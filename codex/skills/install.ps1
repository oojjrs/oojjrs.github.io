param(
    [string]$Destination,
    [string]$SourceCommit
)

$ErrorActionPreference = "Stop"

$RemoteRepository = "oojjrs/oojjrs.github.io"
$RemoteBranch = "master"
$ResolvedRemoteBaseUrl = $null
$ResolvedRemoteCommit = $null
$CanonicalSkills = @(
    "oojjrs-guidelines",
    "oojjrs-github-project-board",
    "oojjrs-project-start-work",
    "oojjrs-project-finish-work",
    "oojjrs-project-design-document-router",
    "oojjrs-design-html-builder",
    "oojjrs-guideline-maintenance",
    "oojjrs-unity-csharp-convention-maintenance",
    "oojjrs-skill-maintenance",
    "oojjrs-run-dhlottery-buyer",
    "oojjrs-steamworks",
    "oojjrs-readme-doc-generation",
    "oojjrs-unity-package-src-migration",
    "oojjrs-unity-package-release",
    "oojjrs-unity-asset-safety",
    "oojjrs-unity-csharp-entity-workflow",
    "oojjrs-unity-prefab-guid-usage-lookup",
    "oojjrs-2d-sprite-animation",
    "oojjrs-image-first-art-workflow",
    "oojjrs-mines-art-asset-pipeline",
    "oojjrs-game-audio-asset-workflow",
    "oojjrs-ai-music-generator",
    "oojjrs-visual-qa",
    "oojjrs-dirty-worktree-scope-split",
    "oojjrs-windows-repo-forensics"
)
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
$DefaultFiles = @(
    "SKILL.md",
    "agents/openai.yaml"
)
$SkillFiles = @{
    "oojjrs-guidelines" = @(
        "SKILL.md",
        "agents/openai.yaml",
        "scripts/Read-OojjrsGuidelines.ps1",
        "scripts/Test-OojjrsTextFormat.ps1"
    )
    "oojjrs-steamworks" = @(
        "SKILL.md",
        "agents/openai.yaml",
        "references/official-documentation-map.md",
        "references/capability-matrix.md",
        "references/steamworks-sdk.md",
        "references/web-api.md",
        "references/steamcmd-steampipe.md",
        "references/partner-site.md",
        "scripts/Test-SteamworksEnvironment.ps1"
    )
    "oojjrs-ai-music-generator" = @(
        "SKILL.md",
        "agents/openai.yaml",
        "scripts/Generate-AiMusic-Chrome.ps1"
    )
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

function Get-BytesSha256 {
    param([byte[]]$Bytes)

    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $hash = $sha.ComputeHash($Bytes)
        return (($hash | ForEach-Object { $_.ToString("x2") }) -join "")
    } finally {
        $sha.Dispose()
    }
}

function Get-FileSha256 {
    param([string]$Path)

    return ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant())
}

function Get-PinnedRemoteBaseUrl {
    if ($script:ResolvedRemoteBaseUrl) {
        return $script:ResolvedRemoteBaseUrl
    }

    if ($SourceCommit) {
        $commitSha = $SourceCommit
    } else {
        $webClient = New-Object System.Net.WebClient
        try {
            $webClient.Headers["User-Agent"] = "oojjrs-skill-installer"
            $refJson = $webClient.DownloadString("https://api.github.com/repos/$RemoteRepository/git/ref/heads/$RemoteBranch")
            $ref = $refJson | ConvertFrom-Json
            $commitSha = [string]$ref.object.sha
        } finally {
            $webClient.Dispose()
        }
    }

    if ($commitSha -notmatch "^[0-9a-fA-F]{40}$") {
        throw "Could not resolve an immutable Git commit for '$RemoteRepository/$RemoteBranch'."
    }

    $script:ResolvedRemoteCommit = $commitSha.ToLowerInvariant()
    $script:ResolvedRemoteBaseUrl = "https://raw.githubusercontent.com/$RemoteRepository/$($script:ResolvedRemoteCommit)/codex/skills"
    Write-Host "Pinned remote skill source: $($script:ResolvedRemoteCommit)"
    return $script:ResolvedRemoteBaseUrl
}

function Install-ToolDependency {
    param([hashtable]$Tool)

    if (Test-CommandAvailable $Tool.Command) {
        Write-Host "$($Tool.Name) already available ($($Tool.Command))"
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

    if (Test-CommandAvailable $Tool.Command) {
        Write-Host "Installed $($Tool.Name) ($($Tool.Command))"
    } else {
        Write-Warning "$($Tool.Name) installed, but $($Tool.Command) is not available on PATH yet. Restart the terminal or refresh PATH."
    }
}

if (-not $Destination) {
    if ($env:CODEX_HOME) {
        $Destination = Join-Path $env:CODEX_HOME "skills"
    } else {
        $Destination = Join-Path (Join-Path $HOME ".codex") "skills"
    }
}

New-Item -ItemType Directory -Force -Path $Destination | Out-Null
$remoteBaseUrl = Get-PinnedRemoteBaseUrl

foreach ($canonicalName in $CanonicalSkills) {
    $skillDir = Join-Path $Destination $canonicalName
    New-Item -ItemType Directory -Force -Path $skillDir | Out-Null

    if ($SkillFiles.ContainsKey($canonicalName)) {
        $files = $SkillFiles[$canonicalName]
    } else {
        $files = $DefaultFiles
    }

    foreach ($relativePath in $files) {
        $webPath = $relativePath -replace "\\", "/"
        $localPath = Join-Path $skillDir ($relativePath -replace "/", [System.IO.Path]::DirectorySeparatorChar)
        $localDir = Split-Path -Parent $localPath
        if ($localDir) {
            New-Item -ItemType Directory -Force -Path $localDir | Out-Null
        }

        # Preserve GitHub source bytes exactly. Do not normalize encoding or line endings during install.
        $webClient = New-Object System.Net.WebClient
        try {
            $bytes = $webClient.DownloadData("$remoteBaseUrl/$canonicalName/$webPath")
            $expectedSha256 = Get-BytesSha256 -Bytes $bytes
            [System.IO.File]::WriteAllBytes($localPath, $bytes)
        } finally {
            $webClient.Dispose()
        }

        $actualSha256 = Get-FileSha256 -Path $localPath
        if ($actualSha256 -ne $expectedSha256) {
            throw "SHA-256 mismatch after installing '$canonicalName/$relativePath'."
        }
    }

    $skillRoot = [System.IO.Path]::GetFullPath($skillDir).TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
    $expectedRelativePaths = @($files | ForEach-Object { $_ -replace "/", [System.IO.Path]::DirectorySeparatorChar })
    $unexpectedFiles = @(
        Get-ChildItem -LiteralPath $skillDir -File -Recurse | ForEach-Object {
            $relativeInstalledPath = $_.FullName.Substring($skillRoot.Length)
            if ($expectedRelativePaths -notcontains $relativeInstalledPath) {
                $relativeInstalledPath
            }
        }
    )
    foreach ($unexpectedFile in $unexpectedFiles) {
        $unexpectedPath = [System.IO.Path]::GetFullPath((Join-Path $skillDir $unexpectedFile))
        if (-not $unexpectedPath.StartsWith($skillRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to remove stale file outside '$skillDir': '$unexpectedPath'."
        }
        Remove-Item -LiteralPath $unexpectedPath -Force
    }
    $installedDirectories = @(
        Get-ChildItem -LiteralPath $skillDir -Directory -Recurse |
            Sort-Object FullName -Descending
    )
    foreach ($installedDirectory in $installedDirectories) {
        if (-not (Get-ChildItem -LiteralPath $installedDirectory.FullName -Force)) {
            Remove-Item -LiteralPath $installedDirectory.FullName -Force
        }
    }

    foreach ($legacyName in $LegacyAliases.Keys) {
        if ($LegacyAliases[$legacyName] -ne $canonicalName) {
            continue
        }

        $legacyDir = Join-Path $Destination $legacyName
        if (Test-Path -LiteralPath $legacyDir) {
            Remove-Item -LiteralPath $legacyDir -Recurse -Force
        }
    }

    Write-Host "Synchronized $canonicalName -> $skillDir ($($files.Count) files SHA-256 verified; $($unexpectedFiles.Count) stale files removed)"

    if ($ToolDependencies.ContainsKey($canonicalName)) {
        foreach ($tool in $ToolDependencies[$canonicalName]) {
            Install-ToolDependency $tool
        }
    }
}

$destinationRoot = [System.IO.Path]::GetFullPath($Destination).TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
$staleSkillDirectories = @(
    Get-ChildItem -LiteralPath $Destination -Directory |
        Where-Object { $_.Name -like "oojjrs-*" -and $CanonicalSkills -notcontains $_.Name }
)
foreach ($staleSkillDirectory in $staleSkillDirectories) {
    $stalePath = [System.IO.Path]::GetFullPath($staleSkillDirectory.FullName)
    if (-not $stalePath.StartsWith($destinationRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to remove stale skill outside '$Destination': '$stalePath'."
    }
    Remove-Item -LiteralPath $stalePath -Recurse -Force
    Write-Host "Removed stale managed skill -> $stalePath"
}

Write-Host "Synchronized $($CanonicalSkills.Count) canonical oojjrs skills from GitHub commit $ResolvedRemoteCommit"
