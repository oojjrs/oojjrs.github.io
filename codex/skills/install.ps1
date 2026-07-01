param(
    [string]$Destination,
    [string[]]$Skill
)

$ErrorActionPreference = "Stop"

$BaseUrl = "https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills"
$CanonicalSkills = @(
    "oojjrs-guidelines",
    "oojjrs-github-project-board",
    "oojjrs-project-start-work",
    "oojjrs-project-finish-work",
    "oojjrs-project-design-document-router",
    "oojjrs-unity-package-src-migration",
    "oojjrs-2d-sprite-animation",
    "oojjrs-image-first-art-workflow",
    "oojjrs-ai-music-generator"
)
$LegacyAliases = @{
    "github-project-board" = "oojjrs-github-project-board"
    "project-start-work" = "oojjrs-project-start-work"
    "project-finish-work" = "oojjrs-project-finish-work"
    "project-design-document-router" = "oojjrs-project-design-document-router"
    "unity-package-src-migration" = "oojjrs-unity-package-src-migration"
    "2d-sprite-animation" = "oojjrs-2d-sprite-animation"
    "image-first-art-workflow" = "oojjrs-image-first-art-workflow"
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
        "scripts/Read-OojjrsGuidelines.ps1"
    )
    "oojjrs-ai-music-generator" = @(
        "SKILL.md",
        "agents/openai.yaml",
        "scripts/Generate-AiMusic-Chrome.ps1"
    )
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
}
