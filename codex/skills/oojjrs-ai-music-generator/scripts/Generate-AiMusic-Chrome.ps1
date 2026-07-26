[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string] $Prompt,
    [string] $Title = '',
    [string] $Style = '',
    [string] $Username = 'oojjrs',
    [string] $OutputDirectory = '',
    [ValidateRange(1, 120)]
    [int] $TimeoutMinutes = 30,
    [ValidateRange(5, 300)]
    [int] $PollSeconds = 15,
    [ValidateRange(1024, 65535)]
    [int] $DebugPort = 9222,
    [string] $ChromeProfile = (Join-Path $env:LOCALAPPDATA 'AiMusicAutomation\ChromeProfile'),
    [switch] $ImportCookiesFromClipboard,
    [switch] $PreflightOnly,
    [switch] $AcknowledgeUnresolvedGeneration
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$baseUrl = 'https://ai-music-generator.ai'
$profileUrl = "$baseUrl/ko/@$Username"
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

function Get-ProfileSongIds {
    $snapshotText = Invoke-JavaScript -Expression $script:ProfileSnapshotScript
    $snapshot = $snapshotText | ConvertFrom-Json
    if ($snapshot.httpStatus -ne 200) {
        throw "프로필 조회 실패(HTTP $($snapshot.httpStatus))."
    }
    return @($snapshot.ids)
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
if ([string]::IsNullOrWhiteSpace($Prompt)) {
    throw '노래 설명(-Prompt)을 입력하세요.'
}
if ($Prompt.Length -gt 199) {
    throw "노래 설명은 최대 199자입니다. 현재 $($Prompt.Length)자입니다."
}
if ($Title.Length -gt 80) {
    throw "제목은 최대 80자입니다. 현재 $($Title.Length)자입니다."
}
if ($Style.Length -gt 120) {
    throw "음악 스타일은 최대 120자입니다. 현재 $($Style.Length)자입니다."
}
if (-not [string]::IsNullOrWhiteSpace($Style) -and [string]::IsNullOrWhiteSpace($Title)) {
    throw '사용자 정의 모드(-Style 사용)에서는 -Title도 필요합니다.'
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
            -ArgumentList @(
                "--remote-debugging-port=$DebugPort",
                "--user-data-dir=$ChromeProfile",
                '--no-first-run',
                $profileUrl
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
            -Uri "$debugUrl/json/new?$([Uri]::EscapeDataString($profileUrl))"
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
    $null = Invoke-Cdp -Method 'Page.navigate' -Params @{ url = $profileUrl }
    Start-Sleep -Seconds 4

    $profileText = Invoke-JavaScript -Expression 'document.body.innerText'
    if ($profileText -notmatch [regex]::Escape($Username)) {
        throw "전용 Chrome 창에서 $profileUrl 에 로그인한 뒤 다시 실행하세요."
    }

    $usernameJs = ConvertTo-JavaScriptValue -Value $Username
    $script:ProfileSnapshotScript = @'
(async () => {
  const username = __USERNAME__;
  const response = await fetch(
    '/ko/@' + encodeURIComponent(username) + '?tab=songs&_=' + Date.now(),
    { cache: 'no-store', credentials: 'same-origin' }
  );
  const html = await response.text();
  const documentCopy = new DOMParser().parseFromString(html, 'text/html');
  const ids = [];
  const uuid = '[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}';

  for (const row of documentCopy.querySelectorAll('tr')) {
    const rowIds = new Set();
    for (const link of row.querySelectorAll('a[href]')) {
      const url = new URL(link.getAttribute('href'), location.origin);
      const match = url.pathname.match(
        new RegExp('^/ko/songs/(' + uuid + ')/edit$')
      );
      if (
        match &&
        url.searchParams.get('field') === 'title' &&
        !url.searchParams.has('apply_to_pair')
      ) {
        rowIds.add(match[1]);
      }
    }

    const download = row.querySelector(
      '[data-download-song-url-value^="/ko/song/"]' +
      '[data-download-song-url-value$="/download"]'
    );
    const downloadMatch = download
      ?.getAttribute('data-download-song-url-value')
      ?.match(new RegExp('/ko/song/(' + uuid + ')/download$'));
    if (downloadMatch) {
      rowIds.add(downloadMatch[1]);
    }

    const fallback = row.querySelector('[id^="song-actions-"][id$="-trigger"]');
    const fallbackMatch = fallback
      ?.id
      ?.match(new RegExp('^song-actions-(' + uuid + ')-trigger$'));
    if (fallbackMatch) {
      rowIds.add(fallbackMatch[1]);
    }
    ids.push(...rowIds);
  }

  return JSON.stringify({
    httpStatus: response.status,
    path: new URL(response.url).pathname,
    ids: [...new Set(ids)]
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
  const failed = /생성 실패|Internal Error/i.test(bodyText);
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

    $baselineIds = @(Get-ProfileSongIds)
    $baselineLookup = @{}
    foreach ($id in $baselineIds) {
        $baselineLookup[[string] $id] = $true
    }

    $script:AttemptId = [guid]::NewGuid().ToString()
    $customMode = -not [string]::IsNullOrWhiteSpace($Style)
    $submitConfigData = @{
        attemptId                    = $script:AttemptId
        acknowledgeUnresolved       = [bool] $AcknowledgeUnresolvedGeneration
        baselineIds                 = $baselineIds
        customMode                  = $customMode
        prompt                     = $Prompt
        style                      = $Style
        title                      = $Title
    }
    $submitConfig = ConvertTo-JavaScriptValue -Value $submitConfigData

    $preflightScript = @'
(() => {
  const config = __CONFIG__;
  const key = 'aiMusicAutomationSubmitState';
  let previous = null;
  try {
    previous = JSON.parse(sessionStorage.getItem(key) || 'null');
  } catch {}
  const blockingPhases = new Set([
    'armed',
    'sent',
    'started',
    'generation-active',
    'unresolved'
  ]);
  if (
    previous &&
    blockingPhases.has(previous.phase) &&
    !config.acknowledgeUnresolved
  ) {
    throw new Error(
      'a previous generation is active or unresolved; inspect it before retrying'
    );
  }

  const prefix = config.customMode ? 'custom' : 'auto';
  const form = document.querySelector(
    '#music-generate-modal form' +
    '[data-music-generate-modal-target="' + prefix + 'Form"]' +
    '[action$="/generation_tasks"]'
  );
  if (!form) {
    throw new Error('generation form not found');
  }

  const requiredNames = [
    'generation_task[custom_mode]',
    'generation_task[ai_model_name]',
    'generation_task[instrumental]',
    'generation_task[prompt]'
  ];
  if (config.customMode) {
    requiredNames.push('generation_task[style]', 'generation_task[title]');
  }
  for (const name of requiredNames) {
    if (!form.querySelector('[name="' + CSS.escape(name) + '"]')) {
      throw new Error('missing field: ' + name);
    }
  }
  if (!form.querySelector(
    '[data-music-generate-modal-target="' + prefix + 'Instrumental"]'
  )) {
    throw new Error('instrumental checkbox not found');
  }
  if (!form.querySelector(
    '[data-music-generate-modal-target="' + prefix + 'Submit"]'
  )) {
    throw new Error('submit button not found');
  }
  return JSON.stringify({
    ready: true,
    mode: prefix,
    baselineCount: config.baselineIds.length
  });
})()
'@.Replace('__CONFIG__', $submitConfig)

    $preflight = (Invoke-JavaScript -Expression $preflightScript) | ConvertFrom-Json
    if (-not [bool] $preflight.ready) {
        throw '생성 폼 사전 검증에 실패했습니다.'
    }
    if ($PreflightOnly) {
        [pscustomobject] @{
            Ready         = $true
            Mode          = [string] $preflight.mode
            BaselineCount = [int] $preflight.baselineCount
            PostSent      = $false
        } | ConvertTo-Json
        return
    }

    $submitScript = @'
(() => {
  const config = __CONFIG__;
  const key = 'aiMusicAutomationSubmitState';
  const prefix = config.customMode ? 'custom' : 'auto';
  const form = document.querySelector(
    '#music-generate-modal form' +
    '[data-music-generate-modal-target="' + prefix + 'Form"]' +
    '[action$="/generation_tasks"]'
  );
  const nodes = name => [
    ...form.querySelectorAll('[name="' + CSS.escape(name) + '"]')
  ];
  const setField = (name, value) => {
    const candidates = nodes(name);
    if (!candidates.length) {
      throw new Error('missing field: ' + name);
    }
    const element = candidates.find(item => (
      item.type !== 'checkbox' && item.type !== 'radio'
    )) || candidates[0];
    element.value = value;
    element.dispatchEvent(new Event('input', { bubbles: true }));
    element.dispatchEvent(new Event('change', { bubbles: true }));
  };
  const setState = state => sessionStorage.setItem(
    key,
    JSON.stringify({
      attemptId: config.attemptId,
      baselineIds: config.baselineIds,
      at: Date.now(),
      ...state
    })
  );

  setField('generation_task[custom_mode]', String(config.customMode));
  setField('generation_task[ai_model_name]', 'V5_5');
  const instrumental = form.querySelector(
    '[data-music-generate-modal-target="' + prefix + 'Instrumental"]'
  );
  instrumental.checked = true;
  instrumental.dispatchEvent(new Event('change', { bubbles: true }));
  setField('generation_task[instrumental]', 'true');

  // The instrumental change handler can clear the prompt.
  setField('generation_task[prompt]', config.prompt);
  if (config.customMode) {
    setField('generation_task[style]', config.style);
    setField('generation_task[title]', config.title);
  }
  if (!form.checkValidity()) {
    throw new Error('generation form validation failed');
  }

  const submit = form.querySelector(
    '[data-music-generate-modal-target="' + prefix + 'Submit"]'
  );
  setState({ phase: 'armed' });
  form.addEventListener('turbo:submit-start', () => {
    setState({ phase: 'started' });
  }, { once: true });
  form.addEventListener('turbo:submit-end', event => {
    const success = Boolean(event.detail?.success);
    setState({
      phase: success ? 'generation-active' : 'ended',
      success,
      status: event.detail?.fetchResponse?.statusCode || null
    });
  }, { once: true });

  setState({ phase: 'sent' });
  form.requestSubmit(submit);
  return JSON.stringify({
    submitted: true,
    attemptId: config.attemptId,
    mode: prefix
  });
})()
'@.Replace('__CONFIG__', $submitConfig)

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

    $deadline = [DateTimeOffset]::Now.AddMinutes($TimeoutMinutes)
    $newIds = New-Object Collections.ArrayList
    $readySongs = @{}
    $downloaded = @{}
    $generationFailed = @{}
    $downloadErrors = @{}

    while ([DateTimeOffset]::Now -lt $deadline) {
        Start-Sleep -Seconds $PollSeconds
        $currentIds = @()
        try {
            $currentIds = @(Get-ProfileSongIds)
        }
        catch {
            Write-Warning "프로필 조회 재시도 예정: $($_.Exception.Message)"
            continue
        }

        foreach ($idValue in $currentIds) {
            $id = [string] $idValue
            if (
                -not $baselineLookup.ContainsKey($id) -and
                -not $newIds.Contains($id)
            ) {
                $null = $newIds.Add($id)
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
            '생성 결과: {0}/2, 다운로드: {1}/2' -f
            $generationTerminalCount,
            $downloaded.Count
        )
        if (
            $generationTerminalCount -ge 2 -and
            ($downloaded.Count + $generationFailed.Count) -ge 2
        ) {
            break
        }
    }

    $generationTerminalCount = $readySongs.Count + $generationFailed.Count
    $unresolvedCount = [Math]::Max(0, 2 - $generationTerminalCount)
    $statePhase = if ($unresolvedCount -gt 0) {
        'unresolved'
    } else {
        'complete'
    }
    Set-SubmitState -Phase $statePhase -Extra @{
        discoveredCount = $newIds.Count
        downloadedCount = $downloaded.Count
        failedCount     = $generationFailed.Count
        unresolvedCount = $unresolvedCount
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
        PostSent       = $postAttempted
        ExpectedCount  = 2
        DiscoveredCount = $newIds.Count
        DownloadedCount = $downloaded.Count
        FailedCount    = $generationFailed.Count
        UnresolvedCount = $unresolvedCount
        Results         = $results
    } | ConvertTo-Json -Depth 6

    if ($downloaded.Count -ne 2) {
        throw (
            '일부 생성 또는 다운로드 실패: 다운로드 {0}/2, 생성 실패 {1}, 미확정 {2}' -f
            $downloaded.Count,
            $generationFailed.Count,
            $unresolvedCount
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
