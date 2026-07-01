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
    [switch] $ImportCookiesFromClipboard
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Get-DefaultOutputDirectory {
    $location = Get-Location
    $currentPath = if ($location.Provider.Name -eq 'FileSystem') {
        $location.ProviderPath
    } else {
        $location.Path
    }
    return Join-Path $currentPath '$Trash'
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

$baseUrl = 'https://ai-music-generator.ai'
$profileUrl = "$baseUrl/ko/@$Username"
$debugUrl = "http://127.0.0.1:$DebugPort"
$script:Socket = $null
$script:CommandId = 0

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
    $null = $script:Socket.ConnectAsync($uri, [Threading.CancellationToken]::None).GetAwaiter().GetResult()
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
        throw "브라우저 스크립트 오류: $($result.exceptionDetails.text)"
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

function ConvertFrom-ProfileSongs {
    param([Parameter(Mandatory)][string] $Html)

    $songs = foreach ($match in [regex]::Matches(
        $Html,
        '\{\\"id\\":\\"[0-9a-fA-F-]{36}\\".*?\}'
    )) {
        try {
            $item = $match.Value.Replace('\"', '"') | ConvertFrom-Json
            if ($null -ne $item.status -and $null -ne $item.id) {
                $item
            }
        }
        catch {}
    }
    return @($songs | Sort-Object id -Unique)
}

function ConvertTo-JavaScriptString {
    param([AllowEmptyString()][string] $Value)
    return ($Value | ConvertTo-Json -Compress)
}

[IO.Directory]::CreateDirectory($ChromeProfile) | Out-Null
[IO.Directory]::CreateDirectory($OutputDirectory) | Out-Null

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
    $newTarget = Invoke-RestMethod -Method Put -Uri "$debugUrl/json/new?$([Uri]::EscapeDataString($profileUrl))"
    $target = $newTarget
}

$webSocketUrl = [string] @($target.webSocketDebuggerUrl)[0]
if ([string]::IsNullOrWhiteSpace($webSocketUrl)) {
    throw 'Chrome 대상 탭의 WebSocket 주소를 찾지 못했습니다.'
}
Connect-Cdp -WebSocketUrl $webSocketUrl
$null = Invoke-Cdp -Method 'Runtime.enable'
$null = Invoke-Cdp -Method 'Page.enable'

if ($ImportCookiesFromClipboard) {
    $cookies = Get-CookiesFromClipboard
    $null = Invoke-Cdp -Method 'Network.enable'
    $null = Invoke-Cdp -Method 'Network.setCookies' -Params @{ cookies = $cookies }
    $null = Invoke-Cdp -Method 'Page.navigate' -Params @{ url = $profileUrl }
    Start-Sleep -Seconds 4
}

$profileText = Invoke-JavaScript -Expression 'document.body.innerText'
if ($profileText -notmatch [regex]::Escape($Username)) {
    throw "전용 Chrome 창에서 $profileUrl 에 로그인한 뒤 다시 실행하세요."
}

$songId1 = [guid]::NewGuid().ToString()
$songId2 = [guid]::NewGuid().ToString()
$promptJs = ConvertTo-JavaScriptString $Prompt
$titleJs = ConvertTo-JavaScriptString $Title
$styleJs = ConvertTo-JavaScriptString $Style
$usernameJs = ConvertTo-JavaScriptString $Username
$customMode = -not [string]::IsNullOrWhiteSpace($Style)
$customModeJs = if ($customMode) { 'true' } else { 'false' }

$generateScript = @"
(async () => {
  const html = await fetch('/ko/@' + $usernameJs, { cache: 'no-store' }).then(r => r.text());
  const match = html.match(/user_id\\":\\"([0-9a-fA-F-]{36})\\"/);
  if (!match) throw new Error('user id not found');
  const body = {
    style: $styleJs,
    prompt: $promptJs,
    title: $titleJs,
    model: 'V5_5',
    customMode: $customModeJs,
    instrumental: true,
    callBackUrl: 'userId=' + match[1] + '&songId1=$songId1&songId2=$songId2'
  };
  const response = await fetch('/api/generate', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body)
  });
  return JSON.stringify({
    httpStatus: response.status,
    response: await response.text(),
    songIds: ['$songId1', '$songId2']
  });
})()
"@

Write-Host "Chrome 탭에서 악기음악 생성을 요청합니다: $songId1, $songId2"
$generateResult = (Invoke-JavaScript -Expression $generateScript) | ConvertFrom-Json
if ($generateResult.httpStatus -ne 200) {
    throw "생성 요청 실패(HTTP $($generateResult.httpStatus)): $($generateResult.response)"
}
$responseBody = $generateResult.response | ConvertFrom-Json
if ($responseBody.code -ne 200) {
    throw "사이트가 생성 요청을 거부했습니다: $($responseBody.msg)"
}

$deadline = [DateTimeOffset]::Now.AddMinutes($TimeoutMinutes)
$completed = @{}
$failed = @{}
$ids = @($songId1, $songId2)

while (
    [DateTimeOffset]::Now -lt $deadline -and
    ($completed.Count + $failed.Count) -lt $ids.Count
) {
    Start-Sleep -Seconds $PollSeconds
    $html = Invoke-JavaScript -Expression @"
(async () => await fetch(
  '/ko/@' + $usernameJs + '?_=' + Date.now(),
  { cache: 'no-store' }
).then(r => r.text()))()
"@
    $songs = ConvertFrom-ProfileSongs -Html $html
    foreach ($id in $ids) {
        if ($completed.ContainsKey($id) -or $failed.ContainsKey($id)) {
            continue
        }
        $song = $songs | Where-Object id -EQ $id | Select-Object -First 1
        if ($null -eq $song) {
            Write-Host "$id 등록 대기 중..."
            continue
        }
        Write-Host "$id 상태: $($song.status)"
        if ($song.status -in @('failed', 'canceled', 'error')) {
            $failed[$id] = $song.status
        }
        elseif (
            $song.status -eq 'succeeded' -and
            -not [string]::IsNullOrWhiteSpace($song.audio_url)
        ) {
            $completed[$id] = $song

        }
    }

}

$downloaded = @()
$index = 0
foreach ($id in $ids) {
    $index++
    if (-not $completed.ContainsKey($id)) {
        continue
    }
    $song = $completed[$id]
    $safeTitle = if ($song.title) { $song.title } elseif ($Title) { $Title } else { 'ai-music' }
    $invalid = [regex]::Escape((-join [IO.Path]::GetInvalidFileNameChars()))
    $safeTitle = [regex]::Replace($safeTitle, "[$invalid]", '_')
    $path = Join-Path $OutputDirectory (
        '{0}-{1}-{2}.mp3' -f $safeTitle, $index, $id.Substring(0, 8)
    )
    Invoke-WebRequest -UseBasicParsing -Uri $song.audio_url -OutFile $path
    $downloaded += $path
}

if ($downloaded.Count -ne $ids.Count) {
    throw "일부 생성 또는 다운로드 실패: 성공 $($downloaded.Count)/$($ids.Count)"
}
Write-Host "완료: $($downloaded -join ', ')"

if ($null -ne $script:Socket) {
    $script:Socket.Dispose()
}
