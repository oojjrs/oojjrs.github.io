param(
    [string]$Destination,
    [string[]]$Skill
)

$ErrorActionPreference = "Stop"

$BaseUrl = "https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills"
$AllSkills = @(
    "oojjrs-guidelines",
    "github-project-board",
    "project-start-work",
    "project-finish-work",
    "project-design-document-router",
    "unity-package-src-migration",
    "2d-sprite-animation",
    "image-first-art-workflow"
)
$LegacySkills = @(
    "oojjrs-unity-package-src-migration"
)
$KnownSkills = $AllSkills + $LegacySkills
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
    $TargetSkills = $AllSkills
}

foreach ($name in $TargetSkills) {
    if ($KnownSkills -notcontains $name) {
        throw "Unknown skill '$name'. Known skills: $($KnownSkills -join ', ')"
    }
}

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
New-Item -ItemType Directory -Force -Path $Destination | Out-Null

foreach ($name in $TargetSkills) {
    $skillDir = Join-Path $Destination $name
    New-Item -ItemType Directory -Force -Path $skillDir | Out-Null

    if ($SkillFiles.ContainsKey($name)) {
        $files = $SkillFiles[$name]
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

        $text = (Invoke-WebRequest -UseBasicParsing -Uri "$BaseUrl/$name/$webPath").Content
        $text = $text -replace "`r`n|`n|`r", "`r`n"
        [System.IO.File]::WriteAllText($localPath, $text, $Utf8NoBom)
    }

    Write-Host "Installed $name -> $skillDir"
}
