$ErrorActionPreference = "Stop"
$CanonicalUrl = "https://oojjrs.github.io/codex/common-work-guidelines.md"

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

try {
    $response = Invoke-WebRequest -UseBasicParsing -Uri $CanonicalUrl
} catch {
    throw "Canonical guidelines could not be read from '$CanonicalUrl': $($_.Exception.Message)"
}

if ([int]$response.StatusCode -ne 200) {
    throw "Canonical guidelines returned HTTP $([int]$response.StatusCode), expected 200."
}

$finalUrl = $null
if ($response.BaseResponse -and $response.BaseResponse.ResponseUri) {
    $finalUrl = [string]$response.BaseResponse.ResponseUri.AbsoluteUri
} elseif ($response.BaseResponse -and $response.BaseResponse.RequestMessage -and $response.BaseResponse.RequestMessage.RequestUri) {
    $finalUrl = [string]$response.BaseResponse.RequestMessage.RequestUri.AbsoluteUri
}

if ($finalUrl -cne $CanonicalUrl) {
    throw "Canonical guidelines resolved to unexpected URL '$finalUrl'."
}

$text = [string]$response.Content
if ([string]::IsNullOrWhiteSpace($text)) {
    throw "Canonical guidelines returned an empty body."
}

$activeSha256 = Get-TextSha256 -Text $text
Write-Output "oojjrs-guidelines source: canonical"
Write-Output "source-url: $CanonicalUrl"
Write-Output "active-sha256: $activeSha256"
Write-Output ""
Write-Output $text
