[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Test-LiteralFile {
    param(
        [Parameter(Mandatory)]
        [string]$LiteralPath
    )

    return Test-Path -LiteralPath $LiteralPath -PathType Leaf
}

function Test-LiteralDirectory {
    param(
        [Parameter(Mandatory)]
        [string]$LiteralPath
    )

    return Test-Path -LiteralPath $LiteralPath -PathType Container
}

try {
    $resolved = Resolve-Path -LiteralPath $Path -ErrorAction Stop
} catch {
    throw "SteamCMD or ContentBuilder path was not found: $Path"
}

if ($resolved.Provider.Name -ne "FileSystem") {
    throw "Only file system paths are supported."
}

$item = Get-Item -LiteralPath $resolved.Path -Force
$candidates = @()

if (-not $item.PSIsContainer) {
    if ($item.Name -ine "steamcmd.exe") {
        throw "A file path must point to steamcmd.exe."
    }

    $contentBuilderRoot = $null
    if (($null -ne $item.Directory) -and
        ($item.Directory.Name -ieq "builder") -and
        ($null -ne $item.Directory.Parent)) {
        $contentBuilderRoot = $item.Directory.Parent.FullName
    }

    $candidates += [pscustomobject]@{
        Kind               = "SteamCmdExecutable"
        SteamCmdPath       = $item.FullName
        ContentBuilderRoot = $contentBuilderRoot
    }
} else {
    $builderRoot = $null
    if (($item.Name -ieq "builder") -and ($null -ne $item.Parent)) {
        $builderRoot = $item.Parent.FullName
    }

    $candidates += [pscustomobject]@{
        Kind               = "SteamCmdDirectory"
        SteamCmdPath       = Join-Path $item.FullName "steamcmd.exe"
        ContentBuilderRoot = $builderRoot
    }

    $candidates += [pscustomobject]@{
        Kind               = "ContentBuilder"
        SteamCmdPath       = Join-Path $item.FullName "builder\steamcmd.exe"
        ContentBuilderRoot = $item.FullName
    }

    $sdkContentBuilder = Join-Path $item.FullName "tools\ContentBuilder"
    $candidates += [pscustomobject]@{
        Kind               = "SteamworksSdkRoot"
        SteamCmdPath       = Join-Path $sdkContentBuilder "builder\steamcmd.exe"
        ContentBuilderRoot = $sdkContentBuilder
    }

    $archiveContentBuilder = Join-Path $item.FullName "sdk\tools\ContentBuilder"
    $candidates += [pscustomobject]@{
        Kind               = "SteamworksSdkArchiveRoot"
        SteamCmdPath       = Join-Path $archiveContentBuilder "builder\steamcmd.exe"
        ContentBuilderRoot = $archiveContentBuilder
    }
}

$matches = @(
    $candidates |
        Where-Object { Test-LiteralFile -LiteralPath $_.SteamCmdPath }
)

if ($matches.Count -eq 0) {
    throw "steamcmd.exe was not found under the specified path."
}

if ($matches.Count -gt 1) {
    $matchedPaths = ($matches | ForEach-Object { $_.SteamCmdPath }) -join ", "
    throw "Multiple SteamCMD candidates were found: $matchedPaths"
}

$selected = $matches[0]
$steamCmd = Get-Item -LiteralPath $selected.SteamCmdPath -Force

if ($steamCmd.Length -le 0) {
    throw "steamcmd.exe is empty."
}

$warnings = [System.Collections.Generic.List[string]]::new()
$layout = $null
$resultState = "SteamCmdFound"

if ($null -ne $selected.ContentBuilderRoot) {
    $builderPath = Join-Path $selected.ContentBuilderRoot "builder"
    $contentPath = Join-Path $selected.ContentBuilderRoot "content"
    $outputPath = Join-Path $selected.ContentBuilderRoot "output"
    $scriptsPath = Join-Path $selected.ContentBuilderRoot "scripts"

    $hasBuilder = Test-LiteralDirectory -LiteralPath $builderPath
    $hasContent = Test-LiteralDirectory -LiteralPath $contentPath
    $hasOutput = Test-LiteralDirectory -LiteralPath $outputPath
    $hasScripts = Test-LiteralDirectory -LiteralPath $scriptsPath

    $layout = [pscustomobject]@{
        Root     = $selected.ContentBuilderRoot
        Builder  = $hasBuilder
        SteamCmd = $true
        Content  = $hasContent
        Output   = $hasOutput
        Scripts  = $hasScripts
    }

    if ($hasBuilder -and $hasContent -and $hasScripts) {
        $resultState = "ContentBuilderLayoutFound"
    } else {
        $resultState = "PartialContentBuilderLayout"
    }

    if (-not $hasContent) {
        $warnings.Add("The ContentBuilder content directory is missing.")
    }

    if (-not $hasScripts) {
        $warnings.Add("The ContentBuilder scripts directory is missing.")
    }

    if (-not $hasOutput) {
        $warnings.Add(
            "The ContentBuilder output directory is missing. " +
            "Official documentation allows it to be deleted, so this is only a warning."
        )
    }
} else {
    $warnings.Add(
        "Only a standalone steamcmd.exe was found. The ContentBuilder layout was not verified."
    )
}

$warnings.Add(
    "SteamCMD was not executed. Bootstrap, automatic updates, login, permissions, " +
    "and upload readiness remain unverified."
)

[pscustomobject]@{
    SchemaVersion        = "1.0"
    State                = $resultState
    DiscoveryKind        = $selected.Kind
    SteamCmdPath         = $steamCmd.FullName
    ContentBuilderLayout = $layout
    ValidationScope      = "StaticPathAndLayoutOnly"
    Authenticity         = "Unverified"
    Bootstrap            = "Unverified"
    OperationalReadiness = "Unverified"
    Safety               = [pscustomobject]@{
        SteamCmdExecuted      = $false
        SteamBackendContacted = $false
        FilesWritten          = $false
        SecretsRequested      = $false
        LoginConfigRead       = $false
        BuildScriptsRead      = $false
    }
    Warnings             = $warnings.ToArray()
}
