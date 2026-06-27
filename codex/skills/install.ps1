param(
    [string]$Destination,
    [string[]]$Skill
)

$ErrorActionPreference = "Stop"

$BaseUrl = "https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills"
$AllSkills = @(
    "github-project-board",
    "project-start-work",
    "project-finish-work",
    "project-design-document-router"
)

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
    if ($AllSkills -notcontains $name) {
        throw "Unknown skill '$name'. Known skills: $($AllSkills -join ', ')"
    }
}

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
New-Item -ItemType Directory -Force -Path $Destination | Out-Null

foreach ($name in $TargetSkills) {
    $skillDir = Join-Path $Destination $name
    $agentDir = Join-Path $skillDir "agents"
    New-Item -ItemType Directory -Force -Path $skillDir | Out-Null
    New-Item -ItemType Directory -Force -Path $agentDir | Out-Null

    $skillText = (Invoke-WebRequest -UseBasicParsing -Uri "$BaseUrl/$name/SKILL.md").Content
    $skillText = $skillText -replace "`r`n|`n|`r", "`r`n"
    [System.IO.File]::WriteAllText((Join-Path $skillDir "SKILL.md"), $skillText, $Utf8NoBom)

    try {
        $agentText = (Invoke-WebRequest -UseBasicParsing -Uri "$BaseUrl/$name/agents/openai.yaml").Content
        $agentText = $agentText -replace "`r`n|`n|`r", "`r`n"
        [System.IO.File]::WriteAllText((Join-Path $agentDir "openai.yaml"), $agentText, $Utf8NoBom)
    } catch {
        if (Test-Path -LiteralPath $agentDir) {
            $remaining = Get-ChildItem -LiteralPath $agentDir -Force
            if (-not $remaining) {
                Remove-Item -LiteralPath $agentDir -Force
            }
        }
    }

    Write-Host "Installed $name -> $skillDir"
}
