param(
    [string]$Destination,
    [string]$SourceCommit
)

$ErrorActionPreference = "Stop"

$RemoteRepository = "oojjrs/oojjrs.github.io"
$RemoteBranch = "master"
$LegacyAliases = @{
    "github-project-board" = "oojjrs-github-project-board"
    "project-start-work" = "oojjrs-project-start-work"
    "project-finish-work" = "oojjrs-project-finish-work"
    "project-design-document-router" = "oojjrs-project-design-document-router"
    "unity-package-src-migration" = "oojjrs-unity-package-src-migration"
    "2d-sprite-animation" = "oojjrs-2d-sprite-animation"
    "image-first-art-workflow" = "oojjrs-image-first-art-workflow"
    "unity-prefab-guid-usage-lookup" = "oojjrs-unity-prefab-guid-usage-lookup"
    "run-dhlottery-buyer" = "oojjrs-run-dhlottery-buyer"
}
$ToolDependencies = @{
    "oojjrs-image-first-art-workflow" = @(
        @{
            Name = "ImageMagick 7"
            Command = "magick.exe"
            WingetId = "ImageMagick.ImageMagick"
        },
        @{
            Name = "oxipng"
            Command = "oxipng.exe"
            WingetId = "shssoichiro.oxipng"
        }
    )
}

function Test-CommandAvailable {
    param([string]$Command)

    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Get-BytesGitBlobSha1 {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [byte[]]$Bytes
    )

    $header = [System.Text.Encoding]::ASCII.GetBytes("blob $($Bytes.LongLength)" + [char]0)
    $payload = New-Object byte[] ($header.Length + $Bytes.Length)
    [System.Buffer]::BlockCopy($header, 0, $payload, 0, $header.Length)
    [System.Buffer]::BlockCopy($Bytes, 0, $payload, $header.Length, $Bytes.Length)

    $sha = [System.Security.Cryptography.SHA1]::Create()
    try {
        $hash = $sha.ComputeHash($payload)
        return (($hash | ForEach-Object { $_.ToString("x2") }) -join "")
    } finally {
        $sha.Dispose()
    }
}

function Get-FileGitBlobSha1 {
    param([string]$Path)

    $bytes = [System.IO.File]::ReadAllBytes($Path)
    return Get-BytesGitBlobSha1 -Bytes $bytes
}

function Invoke-GitHubJson {
    param([string]$Uri)

    $webClient = New-Object System.Net.WebClient
    try {
        $webClient.Headers["User-Agent"] = "oojjrs-skill-installer"
        $webClient.Headers["Accept"] = "application/vnd.github+json"
        return ($webClient.DownloadString($Uri) | ConvertFrom-Json)
    } finally {
        $webClient.Dispose()
    }
}

function Get-RemoteSkillManifest {
    if ($SourceCommit) {
        $commitSha = $SourceCommit
    } else {
        $ref = Invoke-GitHubJson -Uri "https://api.github.com/repos/$RemoteRepository/git/ref/heads/$RemoteBranch"
        $commitSha = [string]$ref.object.sha
    }

    if ($commitSha -notmatch "^[0-9a-fA-F]{40}$") {
        throw "Could not resolve an immutable Git commit for '$RemoteRepository/$RemoteBranch'."
    }

    $commitSha = $commitSha.ToLowerInvariant()
    $tree = Invoke-GitHubJson -Uri "https://api.github.com/repos/$RemoteRepository/git/trees/$commitSha`?recursive=1"
    if ($tree.truncated) {
        throw "The GitHub tree response was truncated; no skill files were changed."
    }

    $skillNames = @()
    foreach ($entry in @($tree.tree)) {
        if ($entry.type -ne "tree") {
            continue
        }

        $match = [System.Text.RegularExpressions.Regex]::Match([string]$entry.path, "^codex/skills/([^/]+)$")
        if (-not $match.Success) {
            continue
        }

        $name = $match.Groups[1].Value
        if ($name.StartsWith("oojjrs-", [System.StringComparison]::OrdinalIgnoreCase)) {
            if (-not [System.Text.RegularExpressions.Regex]::IsMatch($name, "^oojjrs-[a-z0-9-]+$")) {
                throw "Invalid managed skill directory name '$name'."
            }
            $skillNames += $name
        }
    }
    $skillNames = @($skillNames | Sort-Object -Unique)
    if ($skillNames.Count -eq 0) {
        throw "No managed oojjrs-* skills were found at commit '$commitSha'."
    }

    $files = @()
    $seenPaths = @{}
    foreach ($entry in @($tree.tree)) {
        if ($entry.type -ne "blob") {
            continue
        }

        $match = [System.Text.RegularExpressions.Regex]::Match([string]$entry.path, "^codex/skills/(oojjrs-[a-z0-9-]+)/(.+)$")
        if (-not $match.Success) {
            continue
        }

        $skillName = $match.Groups[1].Value
        $relativePath = $match.Groups[2].Value
        if ($skillNames -notcontains $skillName) {
            throw "Managed file '$($entry.path)' has no matching skill directory."
        }

        foreach ($segment in $relativePath.Split('/')) {
            if (-not $segment -or $segment -eq "." -or $segment -eq ".." -or
                $segment.EndsWith(".") -or $segment.EndsWith(" ") -or
                $segment.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0 -or
                $segment -match "^(con|prn|aux|nul|com[1-9]|lpt[1-9])($|\.)") {
                throw "Managed file path '$($entry.path)' is not safe on Windows."
            }
        }

        $pathKey = "$skillName/$relativePath"
        if ($seenPaths.ContainsKey($pathKey)) {
            throw "Case-insensitive managed path collision at '$pathKey'."
        }
        $seenPaths[$pathKey] = $true

        $blobSha = ([string]$entry.sha).ToLowerInvariant()
        if ($blobSha -notmatch "^[0-9a-f]{40}$") {
            throw "Invalid Git blob hash for '$($entry.path)'."
        }

        $files += [pscustomobject]@{
            SkillName = $skillName
            RelativePath = $relativePath
            RemotePath = [string]$entry.path
            Sha = $blobSha
            Size = [long]$entry.size
        }
    }
    $files = @($files | Sort-Object RemotePath)

    foreach ($skillName in $skillNames) {
        if (-not ($files | Where-Object { $_.SkillName -eq $skillName -and $_.RelativePath -eq "SKILL.md" })) {
            throw "Managed skill '$skillName' has no SKILL.md at commit '$commitSha'."
        }
    }

    return [pscustomobject]@{
        Commit = $commitSha
        Skills = $skillNames
        Files = $files
        RawBaseUrl = "https://raw.githubusercontent.com/$RemoteRepository/$commitSha/codex/skills"
    }
}

function Get-ContainedPath {
    param(
        [string]$RootPrefix,
        [string]$Candidate,
        [string]$Operation
    )

    $fullPath = [System.IO.Path]::GetFullPath($Candidate)
    if (-not $fullPath.StartsWith($RootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to $Operation outside the skill destination: '$fullPath'."
    }
    return $fullPath
}

function Assert-NoReparsePointInPath {
    param([string]$Path)

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $currentPath = [System.IO.Path]::GetPathRoot($fullPath)
    $relativePath = $fullPath.Substring($currentPath.Length)
    foreach ($segment in @($relativePath -split "[\\/]" | Where-Object { $_ })) {
        $currentPath = Join-Path $currentPath $segment
        $item = Get-Item -LiteralPath $currentPath -Force -ErrorAction SilentlyContinue
        if ($item -and ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
            throw "The skill destination cannot pass through a symbolic link or junction: '$currentPath'."
        }
    }
}

function Assert-NoReparsePointsInTree {
    param([string]$Directory)

    $pendingDirectories = New-Object "System.Collections.Generic.Stack[string]"
    $pendingDirectories.Push($Directory)
    while ($pendingDirectories.Count -gt 0) {
        $currentDirectory = $pendingDirectories.Pop()
        foreach ($item in @(Get-ChildItem -LiteralPath $currentDirectory -Force)) {
            if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
                throw "The skill destination contains a symbolic link or junction: '$($item.FullName)'."
            }
            if ($item.PSIsContainer) {
                $pendingDirectories.Push($item.FullName)
            }
        }
    }
}

function Install-ToolDependency {
    param([hashtable]$Tool)

    if (Test-CommandAvailable $Tool.Command) {
        return
    }

    if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
        Write-Warning "Cannot install $($Tool.Name): winget.exe is not available. Install '$($Tool.WingetId)' manually."
        return
    }

    Write-Host "Installing $($Tool.Name) with winget..."
    & winget.exe install --id $Tool.WingetId --exact --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "winget failed to install $($Tool.Name) ($($Tool.WingetId))."
        return
    }

    if (-not (Test-CommandAvailable $Tool.Command)) {
        Write-Warning "$($Tool.Name) installed, but $($Tool.Command) is not available on PATH yet. Restart the terminal or refresh PATH."
    }
}

if (-not $Destination) {
    if ($env:CODEX_HOME) {
        $Destination = Join-Path $env:CODEX_HOME "skills"
    } else {
        $userProfile = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
        $Destination = Join-Path (Join-Path $userProfile ".codex") "skills"
    }
}

$separators = [char[]]@([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
$Destination = [System.IO.Path]::GetFullPath($Destination).TrimEnd($separators)
$destinationDriveRoot = [System.IO.Path]::GetPathRoot($Destination).TrimEnd($separators)
if (-not $Destination -or $Destination -eq $destinationDriveRoot) {
    throw "The skill destination cannot be a drive root."
}

Assert-NoReparsePointInPath -Path $Destination
New-Item -ItemType Directory -Force -Path $Destination | Out-Null
Assert-NoReparsePointsInTree -Directory $Destination
$destinationRoot = $Destination + [System.IO.Path]::DirectorySeparatorChar
$manifest = Get-RemoteSkillManifest
$managedSkills = @{}
$filesBySkill = @{}
foreach ($skillName in $manifest.Skills) {
    $managedSkills[$skillName] = $true
    $filesBySkill[$skillName] = @()
}
foreach ($remoteFile in $manifest.Files) {
    $filesBySkill[$remoteFile.SkillName] += $remoteFile
}

$unchangedCount = 0
$pendingUpdates = @()
$downloadClient = New-Object System.Net.WebClient
try {
    $downloadClient.Headers["User-Agent"] = "oojjrs-skill-installer"
    foreach ($remoteFile in $manifest.Files) {
        $skillDir = Get-ContainedPath -RootPrefix $destinationRoot -Candidate (Join-Path $Destination $remoteFile.SkillName) -Operation "manage a skill"
        $relativeLocalPath = $remoteFile.RelativePath -replace "/", [System.IO.Path]::DirectorySeparatorChar
        $localPath = Get-ContainedPath -RootPrefix $destinationRoot -Candidate (Join-Path $skillDir $relativeLocalPath) -Operation "manage a skill file"
        $localItem = Get-Item -LiteralPath $localPath -Force -ErrorAction SilentlyContinue

        if ($localItem -and -not $localItem.PSIsContainer -and
            $localItem.Length -eq $remoteFile.Size -and
            (Get-FileGitBlobSha1 -Path $localPath) -eq $remoteFile.Sha) {
            $unchangedCount++
            continue
        }

        $encodedPath = (($remoteFile.RelativePath.Split('/') | ForEach-Object { [System.Uri]::EscapeDataString($_) }) -join "/")
        $bytes = $downloadClient.DownloadData("$($manifest.RawBaseUrl)/$($remoteFile.SkillName)/$encodedPath")
        if ($bytes.LongLength -ne $remoteFile.Size -or (Get-BytesGitBlobSha1 -Bytes $bytes) -ne $remoteFile.Sha) {
            throw "Git blob verification failed for '$($remoteFile.RemotePath)'; no skill files were changed."
        }

        $pendingUpdates += [pscustomobject]@{
            LocalPath = $localPath
            Bytes = $bytes
            Sha = $remoteFile.Sha
        }
    }
} finally {
    $downloadClient.Dispose()
}

foreach ($update in $pendingUpdates) {
    $existingItem = Get-Item -LiteralPath $update.LocalPath -Force -ErrorAction SilentlyContinue
    if ($existingItem -and $existingItem.PSIsContainer) {
        Remove-Item -LiteralPath $update.LocalPath -Recurse -Force
    }

    $localDir = Split-Path -Parent $update.LocalPath
    New-Item -ItemType Directory -Force -Path $localDir | Out-Null
    [System.IO.File]::WriteAllBytes($update.LocalPath, $update.Bytes)
    if ((Get-FileGitBlobSha1 -Path $update.LocalPath) -ne $update.Sha) {
        throw "Git blob verification failed after writing '$($update.LocalPath)'."
    }
}

$staleFileCount = 0
foreach ($skillName in $manifest.Skills) {
    $skillDir = Get-ContainedPath -RootPrefix $destinationRoot -Candidate (Join-Path $Destination $skillName) -Operation "clean a skill"
    $skillRoot = $skillDir.TrimEnd($separators) + [System.IO.Path]::DirectorySeparatorChar
    $expectedPaths = @{}
    foreach ($remoteFile in $filesBySkill[$skillName]) {
        $expectedPaths[$remoteFile.RelativePath -replace "/", [System.IO.Path]::DirectorySeparatorChar] = $true
    }

    foreach ($installedFile in @(Get-ChildItem -LiteralPath $skillDir -File -Recurse -Force)) {
        $relativeInstalledPath = $installedFile.FullName.Substring($skillRoot.Length)
        if ($expectedPaths.ContainsKey($relativeInstalledPath)) {
            continue
        }

        $unexpectedPath = Get-ContainedPath -RootPrefix $skillRoot -Candidate $installedFile.FullName -Operation "remove a stale skill file"
        Remove-Item -LiteralPath $unexpectedPath -Force
        $staleFileCount++
    }

    foreach ($installedDirectory in @(Get-ChildItem -LiteralPath $skillDir -Directory -Recurse -Force | Sort-Object FullName -Descending)) {
        if (@(Get-ChildItem -LiteralPath $installedDirectory.FullName -Force).Count -eq 0) {
            Remove-Item -LiteralPath $installedDirectory.FullName -Force
        }
    }
}

$staleSkillCount = 0
foreach ($legacyName in $LegacyAliases.Keys) {
    $legacyDir = Get-ContainedPath -RootPrefix $destinationRoot -Candidate (Join-Path $Destination $legacyName) -Operation "remove a retired skill alias"
    if (Test-Path -LiteralPath $legacyDir) {
        Remove-Item -LiteralPath $legacyDir -Recurse -Force
        $staleSkillCount++
    }
}

foreach ($staleSkillDirectory in @(
    Get-ChildItem -LiteralPath $Destination -Directory -Force |
        Where-Object { $_.Name -like "oojjrs-*" -and -not $managedSkills.ContainsKey($_.Name) }
)) {
    $stalePath = Get-ContainedPath -RootPrefix $destinationRoot -Candidate $staleSkillDirectory.FullName -Operation "remove a retired skill"
    Remove-Item -LiteralPath $stalePath -Recurse -Force
    $staleSkillCount++
}

foreach ($skillName in $ToolDependencies.Keys) {
    if (-not $managedSkills.ContainsKey($skillName)) {
        continue
    }
    foreach ($tool in $ToolDependencies[$skillName]) {
        Install-ToolDependency $tool
    }
}

Write-Host "Skill sync at $($manifest.Commit): $($manifest.Skills.Count) skills and $($manifest.Files.Count) files checked; $($pendingUpdates.Count) downloaded, $unchangedCount unchanged; $staleFileCount stale files and $staleSkillCount stale skill folders removed."
