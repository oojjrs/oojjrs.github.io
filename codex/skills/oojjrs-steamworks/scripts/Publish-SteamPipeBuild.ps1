[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateRange(1, [int]::MaxValue)]
    [int]$AppId,

    [Parameter(Mandatory = $true)]
    [ValidateRange(1, [int]::MaxValue)]
    [int]$DepotId,

    [Parameter(Mandatory = $true)]
    [string]$ContentRoot,

    [Parameter(Mandatory = $true)]
    [string]$SteamCmdPath,

    [Parameter(Mandatory = $true)]
    [string]$BuildOutput,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[A-Za-z0-9_][A-Za-z0-9_.-]*$')]
    [string]$SteamUser,

    [ValidateSet('Preview', 'Upload')]
    [string]$Mode = 'Preview',

    [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]*$')]
    [string]$Branch,

    [switch]$SetLive,

    [string]$Description,

    [string[]]$RequiredFiles = @(),

    [string[]]$FileExclusion = @('*.pdb', '*.log', 'steam_appid.txt')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-SteamPipeLog
{
    param([Parameter(Mandatory = $true)][string]$Message)

    Write-Host "STEAMPIPE> $Message"
}

function ConvertTo-VdfPath
{
    param([Parameter(Mandatory = $true)][string]$Path)

    return ([IO.Path]::GetFullPath($Path) -replace '\\', '/')
}

function Assert-VdfValue
{
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$Value
    )

    if ($Value -match '["\r\n]')
    {
        throw "STEAMPIPE> INVALID VDF VALUE : $Name"
    }
}

function Write-Utf8NoBomFile
{
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )

    $crlfText = ($Text -replace "`r?`n", "`r`n").TrimEnd("`r", "`n") + "`r`n"
    $encoding = New-Object Text.UTF8Encoding($false)
    [IO.File]::WriteAllText($Path, $crlfText, $encoding)
}

if ($SetLive -and $Mode -ne 'Upload')
{
    throw 'STEAMPIPE> SET LIVE IS AVAILABLE ONLY IN UPLOAD MODE.'
}

if ($SetLive -and [string]::IsNullOrWhiteSpace($Branch))
{
    throw 'STEAMPIPE> BRANCH IS REQUIRED FOR SET LIVE.'
}

if ($SetLive -and $Branch -ieq 'default')
{
    throw 'STEAMPIPE> THE DEFAULT BRANCH MUST BE SET LIVE IN STEAMWORKS PARTNER.'
}

$resolvedSteamCmdPath = [IO.Path]::GetFullPath($SteamCmdPath)
$resolvedContentRoot = [IO.Path]::GetFullPath($ContentRoot)
$resolvedBuildOutput = [IO.Path]::GetFullPath($BuildOutput)

if (-not (Test-Path -LiteralPath $resolvedSteamCmdPath -PathType Leaf))
{
    throw "STEAMPIPE> STEAMCMD NOT FOUND : $resolvedSteamCmdPath"
}

if (-not (Test-Path -LiteralPath $resolvedContentRoot -PathType Container))
{
    throw "STEAMPIPE> CONTENT ROOT NOT FOUND : $resolvedContentRoot"
}

foreach ($requiredFile in $RequiredFiles)
{
    if ([IO.Path]::IsPathRooted($requiredFile) -or $requiredFile -match '(^|[\\/])\.\.([\\/]|$)')
    {
        throw "STEAMPIPE> REQUIRED FILE MUST BE RELATIVE : $requiredFile"
    }

    $requiredPath = Join-Path $resolvedContentRoot $requiredFile
    if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf))
    {
        throw "STEAMPIPE> REQUIRED FILE NOT FOUND : $requiredPath"
    }
}

foreach ($exclusion in $FileExclusion)
{
    Assert-VdfValue -Name 'FileExclusion' -Value $exclusion
}

$contentItems = @(Get-ChildItem -LiteralPath $resolvedContentRoot -Force -Recurse)
$reparsePoint = $contentItems |
    Where-Object { ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0 } |
    Select-Object -First 1
if ($null -ne $reparsePoint)
{
    throw "STEAMPIPE> REPARSE POINT IS NOT ALLOWED IN CONTENT : $($reparsePoint.FullName)"
}

$contentFiles = @($contentItems | Where-Object { -not $_.PSIsContainer })
if ($contentFiles.Count -eq 0)
{
    throw "STEAMPIPE> CONTENT ROOT IS EMPTY : $resolvedContentRoot"
}

$contentBytes = ($contentFiles | Measure-Object -Property Length -Sum).Sum
if ($null -eq $contentBytes)
{
    $contentBytes = 0
}

New-Item -ItemType Directory -Path $resolvedBuildOutput -Force | Out-Null
$runRoot = Join-Path $resolvedBuildOutput 'runs'
New-Item -ItemType Directory -Path $runRoot -Force | Out-Null
$runId = [DateTime]::Now.ToString('yyyyMMdd-HHmmssfff')
$currentRunRoot = Join-Path $runRoot $runId
New-Item -ItemType Directory -Path $currentRunRoot | Out-Null

if ([string]::IsNullOrWhiteSpace($Description))
{
    $Description = "App $AppId $Mode $([DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss K'))"
}
Assert-VdfValue -Name 'Description' -Value $Description

$contentVdfPath = ConvertTo-VdfPath -Path $resolvedContentRoot
$outputVdfPath = ConvertTo-VdfPath -Path $resolvedBuildOutput
$depotVdfName = "depot_build_$DepotId.vdf"
$depotVdfPath = Join-Path $currentRunRoot $depotVdfName
$appVdfPath = Join-Path $currentRunRoot "app_build_$AppId.vdf"

$exclusionLines = @($FileExclusion | ForEach-Object { "    `"FileExclusion`" `"$_`"" })
$depotVdf = @"
"DepotBuildConfig"
{
    "DepotID" "$DepotId"
    "ContentRoot" "$contentVdfPath"
    "FileMapping"
    {
        "LocalPath" "*"
        "DepotPath" "."
        "Recursive" "1"
    }
$($exclusionLines -join "`r`n")
}
"@

$optionalLines = @()
if ($Mode -eq 'Preview')
{
    $optionalLines += '    "Preview" "1"'
}
if ($SetLive)
{
    $optionalLines += "    `"SetLive`" `"$Branch`""
}
$optionalBlock = ''
if ($optionalLines.Count -gt 0)
{
    $optionalBlock = ($optionalLines -join "`r`n") + "`r`n"
}

$appVdf = @"
"AppBuild"
{
    "AppID" "$AppId"
    "Desc" "$Description"
$optionalBlock    "ContentRoot" "$contentVdfPath"
    "BuildOutput" "$outputVdfPath"
    "Depots"
    {
        "$DepotId" "$depotVdfName"
    }
}
"@

Write-Utf8NoBomFile -Path $depotVdfPath -Text $depotVdf
Write-Utf8NoBomFile -Path $appVdfPath -Text $appVdf

$appLogPath = Join-Path $resolvedBuildOutput "app_build_$AppId.log"
$depotLogPath = Join-Path $resolvedBuildOutput "depot_build_$DepotId.log"
$previewManifestPath = Join-Path $resolvedBuildOutput "${DepotId}_preview.manifest.txt"
foreach ($transientPath in @($appLogPath, $depotLogPath, $previewManifestPath))
{
    if (Test-Path -LiteralPath $transientPath -PathType Leaf)
    {
        Remove-Item -LiteralPath $transientPath -Force
    }
}

Write-SteamPipeLog "MODE : $Mode"
Write-SteamPipeLog "APP ID : $AppId"
Write-SteamPipeLog "DEPOT ID : $DepotId"
Write-SteamPipeLog "BRANCH : $Branch"
Write-SteamPipeLog "SET LIVE : $SetLive"
Write-SteamPipeLog "STEAM USER : $SteamUser"
Write-SteamPipeLog "CONTENT : $resolvedContentRoot ($($contentFiles.Count) FILES, $contentBytes BYTES)"
Write-SteamPipeLog "RUN : $currentRunRoot"

$runStartedUtc = [DateTime]::UtcNow
$steamArguments = @('+login', $SteamUser, '+run_app_build', $appVdfPath, '+quit')
& $resolvedSteamCmdPath @steamArguments
$steamExitCode = $LASTEXITCODE
if ($steamExitCode -ne 0)
{
    throw "STEAMPIPE> STEAMCMD FAILED : EXIT CODE $steamExitCode"
}

$freshnessFloorUtc = $runStartedUtc.AddSeconds(-2)
$result = [ordered]@{
    Mode = $Mode
    AppID = $AppId
    DepotID = $DepotId
    Branch = $Branch
    SetLive = [bool]$SetLive
    SteamUser = $SteamUser
    ContentRoot = $resolvedContentRoot
    FileCount = $contentFiles.Count
    ContentBytes = [Int64]$contentBytes
    BuildID = $null
    ManifestID = $null
    RunDirectory = $currentRunRoot
    OutputDirectory = $resolvedBuildOutput
}

if ($Mode -eq 'Preview')
{
    if (-not (Test-Path -LiteralPath $previewManifestPath -PathType Leaf))
    {
        throw "STEAMPIPE> PREVIEW MANIFEST NOT FOUND : $previewManifestPath"
    }

    $previewManifestInfo = Get-Item -LiteralPath $previewManifestPath
    if ($previewManifestInfo.Length -eq 0 -or $previewManifestInfo.LastWriteTimeUtc -lt $freshnessFloorUtc)
    {
        throw "STEAMPIPE> PREVIEW MANIFEST IS NOT FRESH : $previewManifestPath"
    }

    $previewManifest = [IO.File]::ReadAllText($previewManifestPath).Replace('/', '\')
    foreach ($requiredFile in $RequiredFiles)
    {
        if ($previewManifest.IndexOf($requiredFile, [StringComparison]::OrdinalIgnoreCase) -lt 0)
        {
            throw "STEAMPIPE> PREVIEW FILE MISSING : $requiredFile"
        }
    }
    Write-SteamPipeLog "PREVIEW VERIFIED : $previewManifestPath"
}
else
{
    if (-not (Test-Path -LiteralPath $appLogPath -PathType Leaf) -or
        -not (Test-Path -LiteralPath $depotLogPath -PathType Leaf))
    {
        throw "STEAMPIPE> BUILD LOG NOT FOUND : $resolvedBuildOutput"
    }

    $appLogInfo = Get-Item -LiteralPath $appLogPath
    $depotLogInfo = Get-Item -LiteralPath $depotLogPath
    if ($appLogInfo.LastWriteTimeUtc -lt $freshnessFloorUtc -or
        $depotLogInfo.LastWriteTimeUtc -lt $freshnessFloorUtc)
    {
        throw "STEAMPIPE> BUILD LOG IS NOT FRESH : $resolvedBuildOutput"
    }

    $appLog = [IO.File]::ReadAllText($appLogPath)
    $depotLog = [IO.File]::ReadAllText($depotLogPath)
    if ($appLog -match '(?im)\b(ERROR!|FAILED)\b' -or $depotLog -match '(?im)\b(ERROR!|FAILED)\b')
    {
        throw "STEAMPIPE> BUILD LOG CONTAINS AN ERROR : $resolvedBuildOutput"
    }

    $buildMatch = [regex]::Match($appLog, "Successfully finished AppID $AppId build \(BuildID (\d+)\)", 'IgnoreCase')
    $manifestMatch = [regex]::Match($depotLog, 'Success! New manifestID (\d+) created', 'IgnoreCase')
    if (-not $buildMatch.Success -or -not $manifestMatch.Success)
    {
        throw "STEAMPIPE> BUILD RESULT NOT FOUND : $resolvedBuildOutput"
    }

    $result.BuildID = $buildMatch.Groups[1].Value
    $result.ManifestID = $manifestMatch.Groups[1].Value
    Write-SteamPipeLog "UPLOAD VERIFIED : BUILD $($result.BuildID), MANIFEST $($result.ManifestID)"
}

[PSCustomObject]$result
