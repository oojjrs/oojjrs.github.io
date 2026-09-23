[CmdletBinding()]
param(
    [ValidateRange(1024, 65535)]
    [int] $DebugPort = 9222,
    [string] $ChromeProfile = (Join-Path $env:LOCALAPPDATA 'AiMusicAutomation\ChromeProfile')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$workspaceUrl = 'https://ai-music-generator.ai/ko'
$debugUrl = "http://127.0.0.1:$DebugPort"
$expectedProfile = [IO.Path]::GetFullPath($ChromeProfile).TrimEnd('\')

function Assert-DedicatedChromeListener {
    $listener = Get-NetTCPConnection `
        -LocalAddress '127.0.0.1' `
        -LocalPort $DebugPort `
        -State Listen `
        -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if ($null -eq $listener) {
        throw "전용 Chrome의 로컬 디버깅 포트($DebugPort)를 확인하지 못했습니다."
    }

    $browser = Get-CimInstance Win32_Process -Filter "ProcessId=$($listener.OwningProcess)"
    if ($null -eq $browser) {
        throw "포트 $DebugPort`의 Chrome 프로세스를 확인하지 못했습니다."
    }
    $match = [regex]::Match(
        [string] $browser.CommandLine,
        '(?:^|\s)--user-data-dir=(?:"([^"]+)"|(\S+))'
    )
    $actualProfile = if ($match.Groups[1].Success) {
        $match.Groups[1].Value
    } else {
        $match.Groups[2].Value
    }
    if (
        $browser.Name -ne 'chrome.exe' -or
        -not $match.Success -or
        -not [string]::Equals(
            [IO.Path]::GetFullPath($actualProfile).TrimEnd('\'),
            $expectedProfile,
            [StringComparison]::OrdinalIgnoreCase
        )
    ) {
        throw "포트 $DebugPort`는 지정한 전용 Chrome 프로필이 아닙니다. 다른 브라우저에 연결하지 않습니다."
    }
}

$endpointReady = $false
try {
    $null = Invoke-RestMethod -Uri "$debugUrl/json/version" -TimeoutSec 2
    $endpointReady = $true
}
catch {
    # The dedicated browser may not be running yet.
}

$started = $false
if (-not $endpointReady) {
    $occupiedPort = Get-NetTCPConnection `
        -LocalPort $DebugPort `
        -State Listen `
        -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if ($null -ne $occupiedPort) {
        throw "포트 $DebugPort`가 이미 사용 중이지만 Chrome CDP에 연결할 수 없습니다. 새 브라우저를 열지 않습니다."
    }
    $chrome = @(
        "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "${env:LOCALAPPDATA}\Google\Chrome\Application\chrome.exe"
    ) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
    if ([string]::IsNullOrWhiteSpace($chrome)) {
        throw 'Google Chrome 실행 파일을 찾지 못했습니다.'
    }

    [IO.Directory]::CreateDirectory($expectedProfile) | Out-Null
    Start-Process -FilePath $chrome -WindowStyle Normal -ArgumentList @(
        '--remote-debugging-address=127.0.0.1',
        "--remote-debugging-port=$DebugPort",
        "--user-data-dir=`"$expectedProfile`"",
        '--no-first-run',
        $workspaceUrl
    )
    $started = $true

    $deadline = [DateTimeOffset]::Now.AddSeconds(20)
    while ([DateTimeOffset]::Now -lt $deadline) {
        try {
            $null = Invoke-RestMethod -Uri "$debugUrl/json/version" -TimeoutSec 2
            $endpointReady = $true
            break
        }
        catch {
            Start-Sleep -Milliseconds 500
        }
    }
    if (-not $endpointReady) {
        throw "Chrome 디버깅 포트($DebugPort)에 연결하지 못했습니다."
    }
}

Assert-DedicatedChromeListener
[pscustomobject] @{
    BrowserReady = $true
    Started = $started
    Endpoint = $debugUrl
    ProfilePath = $expectedProfile
    PostSent = $false
} | ConvertTo-Json -Compress
