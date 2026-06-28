param(
    [string]$Workspace = (Get-Location).Path,
    [string]$SourceUrl = "https://oojjrs.github.io/codex/common-work-guidelines.md",
    [string]$CacheRoot,
    [int]$MaxAgeMinutes = 10,
    [switch]$Force,
    [switch]$ContentOnly
)

$ErrorActionPreference = "Stop"
$Utf8NoBom = New-Object System.Text.UTF8Encoding -ArgumentList $false

function Get-DefaultCacheRoot {
    if ($env:CODEX_HOME) {
        return (Join-Path $env:CODEX_HOME "cache\oojjrs-guidelines")
    }

    return (Join-Path (Join-Path $HOME ".codex") "cache\oojjrs-guidelines")
}

function Read-Meta {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return $null
    }

    $json = [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
    if ([string]::IsNullOrWhiteSpace($json)) {
        return $null
    }

    return ($json | ConvertFrom-Json)
}

function Write-TextFile {
    param(
        [string]$Path,
        [string]$Text
    )

    $parent = Split-Path -Parent $Path
    if ($parent) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }

    [System.IO.File]::WriteAllText($Path, $Text, $Utf8NoBom)
}

function Get-TextSha256 {
    param([string]$Text)

    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
        $hash = $sha.ComputeHash($bytes)
        return (($hash | ForEach-Object { $_.ToString("x2") }) -join "")
    } finally {
        $sha.Dispose()
    }
}

function Write-Meta {
    param(
        [string]$Path,
        [object]$Meta
    )

    $json = $Meta | ConvertTo-Json -Depth 6
    Write-TextFile -Path $Path -Text ($json + "`r`n")
}

function Get-HeaderValue {
    param(
        [object]$Headers,
        [string]$Name
    )

    if (-not $Headers) {
        return $null
    }

    if ($Headers.ContainsKey($Name)) {
        $value = $Headers[$Name]
        if ($value -is [array]) {
            return [string]$value[0]
        }

        return [string]$value
    }

    return $null
}

function Test-CacheFresh {
    param(
        [object]$Meta,
        [int]$Minutes
    )

    if (-not $Meta -or -not $Meta.checkedAt) {
        return $false
    }

    $checkedAt = [DateTimeOffset]::Parse([string]$Meta.checkedAt)
    return ($checkedAt.AddMinutes($Minutes) -gt [DateTimeOffset]::UtcNow)
}

function Write-Result {
    param(
        [string]$Source,
        [string]$Path,
        [string]$Text,
        [string]$Note
    )

    if ($ContentOnly) {
        Write-Output $Text
        return
    }

    Write-Output "oojjrs-guidelines source: $Source"
    Write-Output "path: $Path"
    if ($Note) {
        Write-Output "note: $Note"
    }
    Write-Output ""
    Write-Output $Text
}

$workspaceRules = Join-Path $Workspace "codex\common-work-guidelines.md"
if (Test-Path -LiteralPath $workspaceRules) {
    $text = [System.IO.File]::ReadAllText($workspaceRules, [System.Text.Encoding]::UTF8)
    Write-Result -Source "workspace" -Path $workspaceRules -Text $text
    exit 0
}

if (-not $CacheRoot) {
    $CacheRoot = Get-DefaultCacheRoot
}

New-Item -ItemType Directory -Force -Path $CacheRoot | Out-Null

$cachePath = Join-Path $CacheRoot "common-work-guidelines.md"
$metaPath = Join-Path $CacheRoot "common-work-guidelines.meta.json"
$lockPath = Join-Path $CacheRoot "common-work-guidelines.lock"

$meta = Read-Meta -Path $metaPath
if ((Test-Path -LiteralPath $cachePath) -and -not $Force -and (Test-CacheFresh -Meta $meta -Minutes $MaxAgeMinutes)) {
    $text = [System.IO.File]::ReadAllText($cachePath, [System.Text.Encoding]::UTF8)
    Write-Result -Source "cache" -Path $cachePath -Text $text
    exit 0
}

$lockStream = $null
$deadline = (Get-Date).AddSeconds(10)
while (-not $lockStream -and (Get-Date) -lt $deadline) {
    try {
        $lockStream = [System.IO.File]::Open($lockPath, [System.IO.FileMode]::OpenOrCreate, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
    } catch {
        Start-Sleep -Milliseconds 200
    }
}

if (-not $lockStream) {
    if (Test-Path -LiteralPath $cachePath) {
        $text = [System.IO.File]::ReadAllText($cachePath, [System.Text.Encoding]::UTF8)
        Write-Result -Source "stale-cache" -Path $cachePath -Text $text -Note "refresh lock was busy"
        exit 0
    }

    throw "Could not acquire cache lock and no cached guidelines exist."
}

try {
    $meta = Read-Meta -Path $metaPath
    if ((Test-Path -LiteralPath $cachePath) -and -not $Force -and (Test-CacheFresh -Meta $meta -Minutes $MaxAgeMinutes)) {
        $text = [System.IO.File]::ReadAllText($cachePath, [System.Text.Encoding]::UTF8)
        Write-Result -Source "cache" -Path $cachePath -Text $text
        exit 0
    }

    $headers = @{}
    if ($meta -and $meta.etag) {
        $headers["If-None-Match"] = [string]$meta.etag
    }
    if ($meta -and $meta.lastModified) {
        $headers["If-Modified-Since"] = [string]$meta.lastModified
    }

    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $SourceUrl -Headers $headers
        $text = [string]$response.Content
        $now = [DateTimeOffset]::UtcNow.ToString("o")
        $etag = Get-HeaderValue -Headers $response.Headers -Name "ETag"
        $lastModified = Get-HeaderValue -Headers $response.Headers -Name "Last-Modified"
        $sha256 = Get-TextSha256 -Text $text
        $tempPath = "$cachePath.tmp"

        Write-TextFile -Path $tempPath -Text $text
        Move-Item -LiteralPath $tempPath -Destination $cachePath -Force

        $newMeta = [ordered]@{
            sourceUrl = $SourceUrl
            etag = $etag
            lastModified = $lastModified
            sha256 = $sha256
            fetchedAt = $now
            checkedAt = $now
        }
        Write-Meta -Path $metaPath -Meta $newMeta
        Write-Result -Source "updated" -Path $cachePath -Text $text
        exit 0
    } catch {
        $statusCode = $null
        if ($_.Exception.Response) {
            $statusCode = [int]$_.Exception.Response.StatusCode
        }

        if ($statusCode -eq 304 -and (Test-Path -LiteralPath $cachePath)) {
            $now = [DateTimeOffset]::UtcNow.ToString("o")
            $updatedMeta = [ordered]@{
                sourceUrl = $SourceUrl
                etag = $meta.etag
                lastModified = $meta.lastModified
                sha256 = $meta.sha256
                fetchedAt = $meta.fetchedAt
                checkedAt = $now
            }
            Write-Meta -Path $metaPath -Meta $updatedMeta

            $text = [System.IO.File]::ReadAllText($cachePath, [System.Text.Encoding]::UTF8)
            Write-Result -Source "cache-not-modified" -Path $cachePath -Text $text
            exit 0
        }

        if (Test-Path -LiteralPath $cachePath) {
            $text = [System.IO.File]::ReadAllText($cachePath, [System.Text.Encoding]::UTF8)
            Write-Result -Source "stale-cache" -Path $cachePath -Text $text -Note "refresh failed: $($_.Exception.Message)"
            exit 0
        }

        throw
    }
} finally {
    if ($lockStream) {
        $lockStream.Dispose()
    }
}
