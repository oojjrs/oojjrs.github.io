param(
    [string]$Destination,
    [string[]]$Skill,
    [switch]$SkipToolInstall
)

$ErrorActionPreference = "Stop"

$BaseUrl = "https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills"
$CanonicalSkills = @(
    "oojjrs-guidelines",
    "oojjrs-github-project-board",
    "oojjrs-project-start-work",
    "oojjrs-project-finish-work",
    "oojjrs-project-design-document-router",
    "oojjrs-design-html-builder",
    "oojjrs-guideline-maintenance",
    "oojjrs-skill-maintenance",
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
}
$KnownSkills = $CanonicalSkills + $LegacyAliases.Keys
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

if ($Skill -and $Skill.Count -gt 0) {
    $TargetSkills = $Skill
} else {
    $TargetSkills = $CanonicalSkills
}

foreach ($name in $TargetSkills) {
    if ($KnownSkills -notcontains $name) {
        throw "Unknown skill '$name'. Known skills: $($CanonicalSkills -join ', ')"
    }
}

New-Item -ItemType Directory -Force -Path $Destination | Out-Null

foreach ($name in $TargetSkills) {
    if ($LegacyAliases.ContainsKey($name)) {
        $canonicalName = $LegacyAliases[$name]
    } else {
        $canonicalName = $name
    }

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
        $sourcePath = Join-Path $PSScriptRoot (Join-Path $canonicalName ($relativePath -replace "/", [System.IO.Path]::DirectorySeparatorChar))
        $localDir = Split-Path -Parent $localPath
        if ($localDir) {
            New-Item -ItemType Directory -Force -Path $localDir | Out-Null
        }

        # Preserve source bytes exactly. Do not normalize encoding or line endings during install.
        if (Test-Path -LiteralPath $sourcePath) {
            [System.IO.File]::Copy($sourcePath, $localPath, $true)
        } else {
            $webClient = New-Object System.Net.WebClient
            try {
                $bytes = $webClient.DownloadData("$BaseUrl/$canonicalName/$webPath")
                [System.IO.File]::WriteAllBytes($localPath, $bytes)
            } finally {
                $webClient.Dispose()
            }
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

    Write-Host "Installed $canonicalName -> $skillDir"

    if (-not $SkipToolInstall -and $ToolDependencies.ContainsKey($canonicalName)) {
        foreach ($tool in $ToolDependencies[$canonicalName]) {
            Install-ToolDependency $tool
        }
    }
}
