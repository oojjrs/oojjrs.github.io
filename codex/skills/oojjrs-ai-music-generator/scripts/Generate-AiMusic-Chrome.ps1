[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string] $Prompt,
    [ValidateSet('Description', 'InstrumentalSections')]
    [string] $InputMode = 'Description',
    [string] $Title = '',
    [string] $Style = '',
    [string] $Username = 'oojjrs',
    [string] $OutputDirectory = '',
    [string] $DownloadOnlySongIds = '',
    [ValidateRange(1, 120)]
    [int] $TimeoutMinutes = 30,
    [ValidateRange(5, 300)]
    [int] $PollSeconds = 15,
    [ValidateRange(1024, 65535)]
    [int] $DebugPort = 9222,
    [string] $ChromeProfile = (Join-Path $env:LOCALAPPDATA 'AiMusicAutomation\ChromeProfile'),
    [switch] $ShowChrome,
    [switch] $ImportCookiesFromClipboard,
    [switch] $PreflightOnly,
    [switch] $AcknowledgeUnresolvedGeneration
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$baseUrl = 'https://ai-music-generator.ai'
$workspaceUrl = "$baseUrl/ko"
$debugUrl = "http://127.0.0.1:$DebugPort"
$script:Socket = $null
$script:CommandId = 0
$script:AttemptId = ''
$script:GenerationMutex = $null
$script:MutexOwned = $false

function Get-DefaultOutputDirectory {
    $location = Get-Location
    $currentPath = if ($location.Provider.Name -eq 'FileSystem') {
        $location.ProviderPath
    } else {
        $location.Path
    }
    return Join-Path $currentPath '$Trash'
}

function Get-ChromePath {
    $candidates = @(
        "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "${env:LOCALAPPDATA}\Google\Chrome\Application\chrome.exe"
    )
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }
    throw 'Google Chrome 실행 파일을 찾지 못했습니다.'
}

function Wait-DebugEndpoint {
    $deadline = [DateTimeOffset]::Now.AddSeconds(20)
    while ([DateTimeOffset]::Now -lt $deadline) {
        try {
            return Invoke-RestMethod -Uri "$debugUrl/json/version" -TimeoutSec 2
        }
        catch {
            Start-Sleep -Milliseconds 500
        }
    }
    throw "Chrome 디버깅 포트($DebugPort)에 연결하지 못했습니다."
}

function Connect-Cdp {
    param([Parameter(Mandatory)][string] $WebSocketUrl)

    $script:Socket = New-Object Net.WebSockets.ClientWebSocket
    $uri = New-Object Uri($WebSocketUrl)
    $null = $script:Socket.ConnectAsync(
        $uri,
        [Threading.CancellationToken]::None
    ).GetAwaiter().GetResult()
}

function Receive-CdpMessage {
    $buffer = New-Object byte[] 65536
    $stream = New-Object IO.MemoryStream
    try {
        do {
            $segment = New-Object ArraySegment[byte] -ArgumentList @(,$buffer)
            $result = $script:Socket.ReceiveAsync(
                $segment,
                [Threading.CancellationToken]::None
            ).GetAwaiter().GetResult()
            if ($result.MessageType -eq [Net.WebSockets.WebSocketMessageType]::Close) {
                throw 'Chrome 디버깅 연결이 종료되었습니다.'
            }
            $stream.Write($buffer, 0, $result.Count)
        } while (-not $result.EndOfMessage)

        return [Text.Encoding]::UTF8.GetString($stream.ToArray()) | ConvertFrom-Json
    }
    finally {
        $stream.Dispose()
    }
}

function Invoke-Cdp {
    param(
        [Parameter(Mandatory)][string] $Method,
        [hashtable] $Params = @{}
    )

    $script:CommandId++
    $id = $script:CommandId
    $payload = @{
        id     = $id
        method = $Method
        params = $Params
    } | ConvertTo-Json -Depth 20 -Compress
    $bytes = [Text.Encoding]::UTF8.GetBytes($payload)
    $segment = New-Object ArraySegment[byte] -ArgumentList @(,$bytes)
    $null = $script:Socket.SendAsync(
        $segment,
        [Net.WebSockets.WebSocketMessageType]::Text,
        $true,
        [Threading.CancellationToken]::None
    ).GetAwaiter().GetResult()

    while ($true) {
        $message = Receive-CdpMessage
        if ($null -ne $message.PSObject.Properties['id'] -and $message.id -eq $id) {
            if ($null -ne $message.PSObject.Properties['error']) {
                throw "Chrome 명령 실패($Method): $($message.error.message)"
            }
            return $message.result
        }
    }
}

function Invoke-JavaScript {
    param([Parameter(Mandatory)][string] $Expression)

    $result = Invoke-Cdp -Method 'Runtime.evaluate' -Params @{
        expression    = $Expression
        awaitPromise  = $true
        returnByValue = $true
    }
    if ($null -ne $result.PSObject.Properties['exceptionDetails']) {
        $description = [string] $result.exceptionDetails.text
        $lineNumber = [int] $result.exceptionDetails.lineNumber + 1
        $columnNumber = [int] $result.exceptionDetails.columnNumber + 1
        if (
            $null -ne $result.exceptionDetails.PSObject.Properties['exception'] -and
            $null -ne $result.exceptionDetails.exception.PSObject.Properties['description']
        ) {
            $description = [string] $result.exceptionDetails.exception.description
        }
        throw "브라우저 스크립트 오류($lineNumber`:$columnNumber): $description"
    }
    return $result.result.value
}

function Get-CookiesFromClipboard {
    $clipboard = Get-Clipboard -Raw
    $match = [regex]::Match(
        $clipboard,
        '(?is)(?:-H|--header)\s+([''"])(?:cookie:\s*)(?<value>.*?)\1'
    )
    if (-not $match.Success) {
        $match = [regex]::Match(
            $clipboard,
            '(?is)(?:-b|--cookie)\s+([''"])(?<value>.*?)\1'
        )
    }
    if (-not $match.Success) {
        throw '클립보드의 cURL에서 Cookie를 찾지 못했습니다.'
    }

    $cookies = foreach ($part in ($match.Groups['value'].Value -split ';\s*')) {
        $pair = $part -split '=', 2
        if ($pair.Count -eq 2 -and -not [string]::IsNullOrWhiteSpace($pair[0])) {
            @{
                name   = $pair[0].Trim()
                value  = $pair[1]
                domain = '.ai-music-generator.ai'
                path   = '/'
                secure = $true
            }
        }
    }
    return @($cookies)
}

function ConvertTo-JavaScriptValue {
    param([AllowNull()][object] $Value)
    return ($Value | ConvertTo-Json -Depth 20 -Compress)
}

function Get-WorkspaceSongs {
    $snapshotText = Invoke-JavaScript -Expression $script:WorkspaceSnapshotScript
    $snapshot = $snapshotText | ConvertFrom-Json
    if ($snapshot.httpStatus -ne 200 -or -not $snapshot.authenticated) {
        throw "AI MUSIC> 작업 공간 로그인 조회 실패 : $($snapshot.httpStatus)"
    }
    return @($snapshot.songs)
}

function Get-SongDetail {
    param([Parameter(Mandatory)][string] $Id)

    $config = ConvertTo-JavaScriptValue -Value @{ id = $Id }
    $expression = $script:SongDetailTemplate.Replace('__CONFIG__', $config)
    $detailText = Invoke-JavaScript -Expression $expression
    return ($detailText | ConvertFrom-Json)
}

function Set-SubmitState {
    param(
        [Parameter(Mandatory)][string] $Phase,
        [hashtable] $Extra = @{}
    )

    if ([string]::IsNullOrWhiteSpace($script:AttemptId)) {
        return
    }
    $next = @{
        attemptId = $script:AttemptId
        phase     = $Phase
        at        = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
    }
    foreach ($key in $Extra.Keys) {
        $next[$key] = $Extra[$key]
    }
    $nextJs = ConvertTo-JavaScriptValue -Value $next
    $expression = @'
(() => {
  const key = 'aiMusicAutomationSubmitState';
  const next = __STATE__;
  let previous = {};
  try {
    previous = JSON.parse(sessionStorage.getItem(key) || '{}');
  } catch {}
  if (previous.attemptId !== next.attemptId) return false;
  sessionStorage.setItem(key, JSON.stringify({ ...previous, ...next }));
  return true;
})()
'@.Replace('__STATE__', $nextJs)
    try {
        $null = Invoke-JavaScript -Expression $expression
    }
    catch {
        Write-Warning "생성 상태 기록 실패: $($_.Exception.Message)"
    }
}

function Get-SafeFileName {
    param([Parameter(Mandatory)][string] $Value)

    $invalid = [regex]::Escape((-join [IO.Path]::GetInvalidFileNameChars()))
    $safe = [regex]::Replace($Value, "[$invalid]", '_').Trim()
    if ([string]::IsNullOrWhiteSpace($safe)) {
        return 'ai-music'
    }
    return $safe
}

function Save-SongAudio {
    param(
        [Parameter(Mandatory)][object] $Song,
        [Parameter(Mandatory)][int] $VersionIndex
    )

    $id = [string] $Song.id
    $sourceTitle = if (-not [string]::IsNullOrWhiteSpace([string] $Song.title)) {
        [string] $Song.title
    } elseif (-not [string]::IsNullOrWhiteSpace($Title)) {
        $Title
    } else {
        'ai-music'
    }
    $safeTitle = Get-SafeFileName -Value $sourceTitle
    $path = Join-Path $OutputDirectory (
        '{0}-{1}-{2}.mp3' -f $safeTitle, $VersionIndex, $id.Substring(0, 8)
    )
    if (Test-Path -LiteralPath $path) {
        $existing = Get-Item -LiteralPath $path
        if ($existing.Length -ge 1024) {
            return $path
        }
        throw "기존 결과 파일이 비정상적으로 작습니다: $path"
    }

    $partialPath = "$path.$([guid]::NewGuid().ToString('N')).partial"
    try {
        Invoke-WebRequest `
            -UseBasicParsing `
            -Uri ([string] $Song.audioUrl) `
            -OutFile $partialPath
        $partial = Get-Item -LiteralPath $partialPath
        if ($partial.Length -lt 1024) {
            throw "다운로드 결과가 비정상적으로 작습니다: $($partial.Length) bytes"
        }
        Move-Item -LiteralPath $partialPath -Destination $path
        return $path
    }
    catch {
        if (Test-Path -LiteralPath $partialPath) {
            Remove-Item -LiteralPath $partialPath -Force
        }
        throw
    }
}

if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Get-DefaultOutputDirectory
}
$downloadOnlyIds = @()
if (-not [string]::IsNullOrWhiteSpace($DownloadOnlySongIds)) {
    foreach ($candidate in $DownloadOnlySongIds.Split(',')) {
        $id = $candidate.Trim()
        if (
            $id -notmatch
            '^[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}$'
        ) {
            throw "다운로드 전용 노래 ID가 UUID 형식이 아닙니다: $id"
        }
        if ($downloadOnlyIds -notcontains $id) {
            $downloadOnlyIds += $id
        }
    }
}
$downloadOnlyMode = $downloadOnlyIds.Count -gt 0
if (-not $downloadOnlyMode) {
    $Prompt = $Prompt.Replace("`r`n", "`n").Replace("`r", "`n")
}
if (-not $downloadOnlyMode -and [string]::IsNullOrWhiteSpace($Prompt)) {
    throw '노래 설명(-Prompt)을 입력하세요.'
}
$promptLimit = if ($InputMode -eq 'InstrumentalSections') { 5000 } else { 3000 }
if ($Prompt.Length -gt $promptLimit) {
    throw "AI MUSIC> $InputMode 입력은 최대 $promptLimit`자입니다 : $($Prompt.Length)"
}
if ($Title.Length -gt 80) {
    throw "제목은 최대 80자입니다. 현재 $($Title.Length)자입니다."
}
if ($Style.Length -gt 1000) {
    throw "AI MUSIC> 음악 스타일은 최대 1000자입니다 : $($Style.Length)"
}
if (
    -not $downloadOnlyMode -and
    $InputMode -eq 'InstrumentalSections' -and
    [string]::IsNullOrWhiteSpace($Style)
) {
    throw 'AI MUSIC> InstrumentalSections 모드에서는 음악 스타일(-Style)이 필요합니다.'
}
if (-not $downloadOnlyMode -and $InputMode -eq 'InstrumentalSections') {
    foreach ($line in $Prompt.Split("`n")) {
        if (
            -not [string]::IsNullOrWhiteSpace($line) -and
            $line -notmatch '^\[[^\[\]\r\n]+\]$'
        ) {
            throw "AI MUSIC> InstrumentalSections의 비어 있지 않은 각 줄은 [ ... ] 형식이어야 합니다 : $line"
        }
    }
}
if ($downloadOnlyMode -and $PreflightOnly) {
    throw '-DownloadOnlySongIds와 -PreflightOnly는 함께 사용할 수 없습니다.'
}

[IO.Directory]::CreateDirectory($ChromeProfile) | Out-Null
[IO.Directory]::CreateDirectory($OutputDirectory) | Out-Null

$postAttempted = $false
$stateFinalized = $false
try {
    $script:GenerationMutex = New-Object Threading.Mutex(
        $false,
        'Local\oojjrs-ai-music-generator'
    )
    try {
        $script:MutexOwned = $script:GenerationMutex.WaitOne(0)
    }
    catch [Threading.AbandonedMutexException] {
        $script:MutexOwned = $true
    }
    if (-not $script:MutexOwned) {
        throw '다른 AI Music Generator 작업이 실행 중입니다. 완료될 때까지 새 요청을 보내지 않습니다.'
    }

    try {
        $null = Invoke-RestMethod -Uri "$debugUrl/json/version" -TimeoutSec 2
    }
    catch {
        $chrome = Get-ChromePath
        Start-Process `
            -FilePath $chrome `
            -WindowStyle $(if ($ShowChrome) { 'Normal' } else { 'Hidden' }) `
            -ArgumentList @(
                "--remote-debugging-port=$DebugPort",
                "--user-data-dir=$ChromeProfile",
                '--no-first-run',
                $workspaceUrl
            )
        $null = Wait-DebugEndpoint
    }

    $targets = @(Invoke-RestMethod -Uri "$debugUrl/json")
    $target = $targets |
        Where-Object { $_.type -eq 'page' -and $_.url -like "$baseUrl/*" } |
        Select-Object -First 1
    if ($null -eq $target) {
        $newTarget = Invoke-RestMethod `
            -Method Put `
            -Uri "$debugUrl/json/new?$([Uri]::EscapeDataString($workspaceUrl))"
        $target = $newTarget
    }

    $webSocketUrl = [string] @($target.webSocketDebuggerUrl)[0]
    if ([string]::IsNullOrWhiteSpace($webSocketUrl)) {
        throw 'Chrome 대상 탭의 WebSocket 주소를 찾지 못했습니다.'
    }
    Connect-Cdp -WebSocketUrl $webSocketUrl
    $null = Invoke-Cdp -Method 'Runtime.enable'
    $null = Invoke-Cdp -Method 'Page.enable'
    $null = Invoke-Cdp -Method 'Network.enable'

    if ($ImportCookiesFromClipboard) {
        $cookies = Get-CookiesFromClipboard
        $null = Invoke-Cdp -Method 'Network.setCookies' -Params @{ cookies = $cookies }
    }
    $null = Invoke-Cdp -Method 'Page.navigate' -Params @{ url = $workspaceUrl }
    Start-Sleep -Seconds 4

    $authenticated = Invoke-JavaScript -Expression @'
Boolean(document.querySelector('form[action="/ko/users/sign_out"]'))
'@
    if (-not $authenticated) {
        throw "AI MUSIC> 전용 Chrome에서 로그인한 뒤 다시 실행하세요 : $workspaceUrl"
    }

    $usernameJs = ConvertTo-JavaScriptValue -Value $Username
    $script:WorkspaceSnapshotScript = @'
(async () => {
  const username = __USERNAME__;
  const response = await fetch(
    '/ko?_=' + Date.now(),
    { cache: 'no-store', credentials: 'same-origin' }
  );
  const html = await response.text();
  const documentCopy = new DOMParser().parseFromString(html, 'text/html');
  const authenticated = Boolean(documentCopy.querySelector(
    'form[action="/ko/users/sign_out"]'
  ));
  if (!authenticated || !documentCopy.querySelector(
    'form[action="/ko/generation_tasks"]'
  )) {
    throw new Error('AI MUSIC> AUTHENTICATED WORKSPACE NOT FOUND.');
  }
  const songs = new Map();
  const uuid = /^[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}$/i;
  for (const row of documentCopy.querySelectorAll('[data-song-id][data-song-prompt]')) {
    const data = row.dataset;
    if (data.songOwner !== 'true') continue;
    if (data.songAuthor !== username) {
      throw new Error('AI MUSIC> SIGNED-IN SONG OWNER DOES NOT MATCH USERNAME.');
    }
    if (!uuid.test(data.songId) || data.songTitle === undefined) {
      throw new Error('AI MUSIC> WORKSPACE SONG METADATA IS INVALID.');
    }
    const song = {
      id: data.songId,
      title: data.songTitle,
      prompt: data.songPrompt,
      owner: data.songOwner,
      author: data.songAuthor,
      status: data.songStatus || ''
    };
    if (songs.has(song.id) && JSON.stringify(songs.get(song.id)) !== JSON.stringify(song)) {
      throw new Error('AI MUSIC> CONFLICTING WORKSPACE SONG METADATA.');
    }
    songs.set(song.id, song);
  }

  return JSON.stringify({
    httpStatus: response.status,
    path: new URL(response.url).pathname,
    authenticated,
    songs: [...songs.values()]
  });
})()
'@.Replace('__USERNAME__', $usernameJs)

    $script:SongDetailTemplate = @'
(async () => {
  const config = __CONFIG__;
  const response = await fetch(
    '/ko/song/' + encodeURIComponent(config.id) + '?_=' + Date.now(),
    { cache: 'no-store', credentials: 'same-origin' }
  );
  const html = await response.text();
  const documentCopy = new DOMParser().parseFromString(html, 'text/html');
  const player = documentCopy.querySelector(
    '[data-controller~="song-play"][data-song-play-audio-url-value]'
  );
  const download = documentCopy.querySelector(
    '[data-controller~="download-song"]' +
    '[data-download-song-url-value="/ko/song/' + config.id + '/download"]'
  );
  const audioUrl = player
    ?.getAttribute('data-song-play-audio-url-value') || '';
  const bodyText = documentCopy.body?.innerText || '';
  const failed = /\uC0DD\uC131 \uC2E4\uD328|Internal Error/i.test(bodyText);
  const downloadPath = download
    ?.getAttribute('data-download-song-url-value') || '';

  return JSON.stringify({
    id: config.id,
    httpStatus: response.status,
    path: new URL(response.url).pathname,
    status: audioUrl ? 'succeeded' : (failed ? 'failed' : 'pending'),
    title: player?.getAttribute('data-song-play-title-value') || '',
    duration: player?.getAttribute('data-song-play-duration-value') || '',
    audioUrl,
    downloadUrl: downloadPath
      ? new URL(downloadPath, location.origin).href
      : ''
  });
})()
'@

    $baselineIds = @()
    $baselineLookup = @{}
    $script:AttemptId = [guid]::NewGuid().ToString()
    $expectedCount = if ($downloadOnlyMode) {
        $downloadOnlyIds.Count
    } else {
        2
    }

    if (-not $downloadOnlyMode) {
        $baselineSongs = @(Get-WorkspaceSongs)
        $baselineIds = @($baselineSongs | ForEach-Object { [string] $_.id })
        foreach ($id in $baselineIds) {
            $baselineLookup[[string] $id] = $true
        }

        $submitConfigData = @{
            attemptId              = $script:AttemptId
            acknowledgeUnresolved  = [bool] $AcknowledgeUnresolvedGeneration
            baselineIds            = $baselineIds
            inputMode              = $InputMode
            preflightOnly          = $true
            username               = $Username
            prompt                 = $Prompt
            style                  = $Style
            title                  = $Title
        }
        $submitConfig = ConvertTo-JavaScriptValue -Value $submitConfigData

        $submissionTemplate = @'
(() => {
  const config = __CONFIG__;
  const key = 'aiMusicAutomationSubmitState';
  let previous = null;
  try {
    previous = JSON.parse(sessionStorage.getItem(key) || 'null');
  } catch {
    throw new Error('AI MUSIC> SUBMISSION STATE IS UNREADABLE; INSPECT BEFORE RETRYING.');
  }
  const blockingPhases = new Set([
    'armed',
    'sent',
    'started',
    'generation-active',
    'unresolved',
    'ended'
  ]);
  if (
    previous &&
    (blockingPhases.has(previous.phase) || !['complete', 'completed'].includes(previous.phase)) &&
    !config.acknowledgeUnresolved
  ) {
    throw new Error(
      'AI MUSIC> PREVIOUS GENERATION IS ACTIVE OR UNRESOLVED; INSPECT BEFORE RETRYING.'
    );
  }
  if (!document.querySelector('form[action="/ko/users/sign_out"]')) {
    throw new Error('AI MUSIC> SIGN-IN REQUIRED.');
  }
  const forms = document.querySelectorAll('form[action="/ko/generation_tasks"]');
  if (forms.length !== 1) {
    throw new Error('AI MUSIC> EXPECTED ONE WORKSPACE GENERATION FORM.');
  }
  const form = forms[0];
  const singleValue = (data, name) => {
    const values = data.getAll('generation_task[' + name + ']');
    if (values.length !== 1 || typeof values[0] !== 'string') {
      throw new Error(`AI MUSIC> EXPECTED ONE SUBMITTED FIELD : ${name}`);
    }
    return values[0];
  };
  const model = singleValue(new FormData(form), 'ai_model_name');
  if (!model) throw new Error('AI MUSIC> CURRENT MODEL IS MISSING.');
  const mode = {
    Description: {
      tabId: 'generation-description-tab',
      promptId: 'generation-task-description',
      customMode: 'false',
      instrumental: true
    },
    InstrumentalSections: {
      tabId: 'generation-custom-lyrics-tab',
      promptId: 'generation-task-lyrics',
      customMode: 'true',
      instrumental: false
    }
  }[config.inputMode];
  if (!mode) throw new Error('AI MUSIC> INPUT MODE IS INVALID.');
  const modeTab = document.getElementById(mode.tabId);
  if (!modeTab) throw new Error('AI MUSIC> INPUT MODE TAB IS MISSING.');
  modeTab.click();
  const instrumental = form.querySelector(
    'input[type="checkbox"][name="generation_task[instrumental]"]' +
    '[data-workspace-form-target="instrumental"]'
  );
  if (!instrumental || instrumental.disabled) {
    throw new Error('AI MUSIC> INSTRUMENTAL CHECKBOX IS UNAVAILABLE.');
  }
  if (instrumental.checked !== mode.instrumental) instrumental.click();

  // Use the UI first: changing mode or instrumental can clear the active prompt.
  for (const name of ['prompt', 'style', 'title']) {
    const fields = [...form.querySelectorAll(
      '[name="generation_task[' + name + ']"]'
    )].filter(field => !field.disabled && !field.closest('[hidden]'));
    if (fields.length !== 1 || (name === 'prompt' && fields[0].id !== mode.promptId)) {
      throw new Error(`AI MUSIC> EXPECTED ONE ACTIVE INPUT FIELD : ${name}`);
    }
    const field = fields[0];
    if (field.maxLength >= 0 && config[name].length > field.maxLength) {
      throw new Error(`AI MUSIC> FIELD EXCEEDS CURRENT LIMIT : ${name}`);
    }
    field.value = config[name];
    field.dispatchEvent(new Event('input', { bubbles: true }));
    field.dispatchEvent(new Event('change', { bubbles: true }));
  }
  const data = new FormData(form);
  for (const name of ['prompt', 'style', 'title']) {
    if (singleValue(data, name) !== config[name]) {
      throw new Error(`AI MUSIC> SUBMISSION FIELD MISMATCH : ${name}`);
    }
  }
  const instrumentalValues = data.getAll('generation_task[instrumental]');
  const instrumentalIsValid = mode.instrumental
    ? (
      instrumental.checked &&
      ['true', '1'].includes(instrumental.value) &&
      instrumentalValues.length === 2 &&
      ['false', '0'].includes(instrumentalValues[0]) &&
      instrumentalValues[1] === instrumental.value
    )
    : (
      !instrumental.checked &&
      instrumentalValues.length === 1 &&
      ['false', '0'].includes(instrumentalValues[0])
    );
  if (
    !instrumentalIsValid ||
    singleValue(data, 'custom_mode') !== mode.customMode ||
    singleValue(data, 'ai_model_name') !== model ||
    !form.checkValidity()
  ) {
    throw new Error('AI MUSIC> INPUT MODE FORM VALIDATION FAILED.');
  }
  const submits = form.querySelectorAll('button[type="submit"]');
  if (submits.length !== 1 || submits[0].disabled) {
    throw new Error('AI MUSIC> GENERATION SUBMIT BUTTON IS UNAVAILABLE.');
  }
  if (config.preflightOnly) {
    return JSON.stringify({
      ready: true,
      mode: config.inputMode,
      inputMode: config.inputMode,
      instrumental: mode.instrumental,
      model,
      baselineCount: config.baselineIds.length,
      postSent: false
    });
  }
  const setState = state => {
    const current = JSON.parse(sessionStorage.getItem(key) || 'null');
    if (current && current.attemptId !== config.attemptId && state.phase !== 'armed') return;
    sessionStorage.setItem(key, JSON.stringify({
      ...(current?.attemptId === config.attemptId ? current : {}),
      attemptId: config.attemptId,
      baselineIds: config.baselineIds,
      inputMode: config.inputMode,
      instrumental: mode.instrumental,
      prompt: config.prompt,
      title: config.title,
      username: config.username,
      at: Date.now(),
      ...state
    }));
  };
  setState({ phase: 'armed' });
  form.addEventListener('turbo:submit-start', () => {
    setState({ phase: 'started' });
  }, { once: true });
  form.addEventListener('turbo:submit-end', event => {
    const success = Boolean(event.detail?.success);
    setState({
      phase: success ? 'generation-active' : 'unresolved',
      success,
      status: event.detail?.fetchResponse?.statusCode || null
    });
  }, { once: true });

  setState({ phase: 'sent' });
  form.requestSubmit(submits[0]);
  return JSON.stringify({
    submitted: true,
    attemptId: config.attemptId,
    mode: config.inputMode,
    inputMode: config.inputMode,
    instrumental: mode.instrumental
  });
})()
'@

        $preflightScript = $submissionTemplate.Replace('__CONFIG__', $submitConfig)
        $preflight = (Invoke-JavaScript -Expression $preflightScript) | ConvertFrom-Json
        if (-not [bool] $preflight.ready) {
            throw 'AI MUSIC> 생성 폼 사전 검증에 실패했습니다.'
        }
        if ($PreflightOnly) {
            [pscustomobject] @{
                Ready         = $true
                Mode          = [string] $preflight.mode
                InputMode     = [string] $preflight.inputMode
                Instrumental  = [bool] $preflight.instrumental
                Model         = [string] $preflight.model
                BaselineCount = [int] $preflight.baselineCount
                PostSent      = $false
            } | ConvertTo-Json
            return
        }
        $submitConfigData.preflightOnly = $false
        $submitConfig = ConvertTo-JavaScriptValue -Value $submitConfigData
        $submitScript = $submissionTemplate.Replace('__CONFIG__', $submitConfig)

        Write-Host 'AI Music Generator 생성 요청을 한 번만 제출합니다.'
        $postAttempted = $true
        try {
            $submitResult = (Invoke-JavaScript -Expression $submitScript) | ConvertFrom-Json
            if (-not [bool] $submitResult.submitted) {
                Write-Warning '제출 결과를 확인하지 못했습니다. 중복 방지를 위해 재제출하지 않습니다.'
            }
        }
        catch {
            Write-Warning (
                '제출 응답이 불명확합니다. 중복 과금을 막기 위해 재제출하지 않고 ' +
                "프로필만 조회합니다: $($_.Exception.Message)"
            )
        }
    }
    else {
        Write-Host (
            (
                '기존 AI Music Generator 결과 {0}개만 조회하고 다운로드합니다. ' +
                '새 생성 요청은 보내지 않습니다.'
            ) -f $expectedCount
        )
    }

    $deadline = [DateTimeOffset]::Now.AddMinutes($TimeoutMinutes)
    $newIds = New-Object Collections.ArrayList
    $candidateIds = New-Object Collections.ArrayList
    foreach ($id in $downloadOnlyIds) {
        $null = $newIds.Add($id)
    }
    $readySongs = @{}
    $downloaded = @{}
    $generationFailed = @{}
    $downloadErrors = @{}

    while ([DateTimeOffset]::Now -lt $deadline) {
        Start-Sleep -Seconds $PollSeconds
        if (-not $downloadOnlyMode -and $newIds.Count -eq 0) {
            $currentSongs = @()
            try {
                $currentSongs = @(Get-WorkspaceSongs)
            }
            catch {
                Write-Warning "AI MUSIC> 작업 공간 조회 재시도 예정 : $($_.Exception.Message)"
                continue
            }

            foreach ($song in $currentSongs) {
                $id = [string] $song.id
                if (
                    -not $baselineLookup.ContainsKey($id) -and
                    [string] $song.prompt -ceq $Prompt -and
                    ([string]::IsNullOrWhiteSpace($Title) -or [string] $song.title -ceq $Title) -and
                    [string] $song.owner -ceq 'true' -and
                    [string] $song.author -ceq $Username -and
                    -not $candidateIds.Contains($id)
                ) {
                    $null = $candidateIds.Add($id)
                }
            }
            Set-SubmitState -Phase 'generation-active' -Extra @{
                candidateIds = @($candidateIds.ToArray())
            }
            if ($candidateIds.Count -gt $expectedCount) {
                throw "AI MUSIC> 동일 입력의 신규 결과가 두 개를 초과하여 혼입을 막기 위해 중단합니다 : $($candidateIds.Count)"
            }
            if ($candidateIds.Count -eq $expectedCount) {
                foreach ($id in $candidateIds) {
                    $null = $newIds.Add($id)
                }
                Set-SubmitState -Phase 'generation-active' -Extra @{
                    resultIds = @($newIds.ToArray())
                }
            }
        }

        foreach ($idValue in @($newIds)) {
            $id = [string] $idValue
            if ($generationFailed.ContainsKey($id)) {
                continue
            }
            if (-not $readySongs.ContainsKey($id)) {
                try {
                    $detail = Get-SongDetail -Id $id
                }
                catch {
                    Write-Warning "$id 상세 조회 재시도 예정: $($_.Exception.Message)"
                    continue
                }
                if ($detail.status -eq 'failed') {
                    $generationFailed[$id] = 'failed'
                    continue
                }
                if (
                    $detail.status -eq 'succeeded' -and
                    -not [string]::IsNullOrWhiteSpace([string] $detail.audioUrl)
                ) {
                    $readySongs[$id] = $detail
                }
            }

            if (
                $readySongs.ContainsKey($id) -and
                -not $downloaded.ContainsKey($id)
            ) {
                $versionIndex = $newIds.IndexOf($id) + 1
                try {
                    $path = Save-SongAudio `
                        -Song $readySongs[$id] `
                        -VersionIndex $versionIndex
                    $downloaded[$id] = $path
                    $null = $downloadErrors.Remove($id)
                }
                catch {
                    $downloadErrors[$id] = $_.Exception.Message
                    Write-Warning "$id 다운로드 재시도 예정: $($_.Exception.Message)"
                }
            }
        }

        $generationTerminalCount = $readySongs.Count + $generationFailed.Count
        Write-Host (
            '생성 결과: {0}/{2}, 다운로드: {1}/{2}' -f
            $generationTerminalCount,
            $downloaded.Count,
            $expectedCount
        )
        if (
            $generationTerminalCount -ge $expectedCount -and
            ($downloaded.Count + $generationFailed.Count) -ge $expectedCount
        ) {
            break
        }
    }

    $generationTerminalCount = $readySongs.Count + $generationFailed.Count
    $unresolvedCount = [Math]::Max(0, $expectedCount - $generationTerminalCount)
    $statePhase = if ($unresolvedCount -gt 0) {
        'unresolved'
    } else {
        'complete'
    }
    if (-not $downloadOnlyMode) {
        Set-SubmitState -Phase $statePhase -Extra @{
            discoveredCount = $newIds.Count
            downloadedCount = $downloaded.Count
            failedCount     = $generationFailed.Count
            unresolvedCount = $unresolvedCount
        }
    }
    $stateFinalized = $true

    $results = @()
    foreach ($idValue in @($newIds)) {
        $id = [string] $idValue
        $versionIndex = $newIds.IndexOf($id) + 1
        if ($downloaded.ContainsKey($id)) {
            $song = $readySongs[$id]
            $results += [pscustomobject] @{
                Id       = $id
                Version  = $versionIndex
                Status   = 'downloaded'
                Title    = [string] $song.title
                Duration = [string] $song.duration
                Path     = [string] $downloaded[$id]
            }
        }
        elseif ($generationFailed.ContainsKey($id)) {
            $results += [pscustomobject] @{
                Id      = $id
                Version = $versionIndex
                Status  = 'generation-failed'
            }
        }
        elseif ($downloadErrors.ContainsKey($id)) {
            $results += [pscustomobject] @{
                Id      = $id
                Version = $versionIndex
                Status  = 'download-failed'
                Error   = [string] $downloadErrors[$id]
            }
        }
        else {
            $results += [pscustomobject] @{
                Id      = $id
                Version = $versionIndex
                Status  = 'unresolved'
            }
        }
    }

    [pscustomobject] @{
        AttemptId      = $script:AttemptId
        InputMode      = $(if ($downloadOnlyMode) { $null } else { $InputMode })
        Instrumental   = $(if ($downloadOnlyMode) { $null } else { $InputMode -eq 'Description' })
        PostSent       = $postAttempted
        ExpectedCount  = $expectedCount
        DiscoveredCount = $newIds.Count
        DownloadedCount = $downloaded.Count
        FailedCount    = $generationFailed.Count
        UnresolvedCount = $unresolvedCount
        Results         = $results
    } | ConvertTo-Json -Depth 6

    if ($downloaded.Count -ne $expectedCount) {
        throw (
            '일부 생성 또는 다운로드 실패: 다운로드 {0}/{3}, 생성 실패 {1}, 미확정 {2}' -f
            $downloaded.Count,
            $generationFailed.Count,
            $unresolvedCount,
            $expectedCount
        )
    }
}
catch {
    if ($postAttempted -and -not $stateFinalized) {
        Set-SubmitState -Phase 'unresolved' -Extra @{
            error = $_.Exception.Message
        }
    }
    throw
}
finally {
    if ($null -ne $script:Socket) {
        $script:Socket.Dispose()
    }
    if ($null -ne $script:GenerationMutex) {
        if ($script:MutexOwned) {
            $script:GenerationMutex.ReleaseMutex()
        }
        $script:GenerationMutex.Dispose()
    }
}
