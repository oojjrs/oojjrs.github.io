# Codex Skill Sources

If a listed skill is missing, Codex should install/update it automatically before continuing.

## Automatic Install

PowerShell:

```powershell
$url = "https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/install.ps1"
$path = Join-Path $env:TEMP "codex-skill-install.ps1"
Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $path
powershell -ExecutionPolicy Bypass -File $path
```

Install one skill:

```powershell
powershell -ExecutionPolicy Bypass -File $path -Skill github-project-board
```

Default destination is `$CODEX_HOME/skills`, or `~/.codex/skills` when `$CODEX_HOME` is unset.

## Skill URLs

- `github-project-board`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/github-project-board/SKILL.md`
- `project-start-work`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/project-start-work/SKILL.md`
- `project-finish-work`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/project-finish-work/SKILL.md`
- `project-design-document-router`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/project-design-document-router/SKILL.md`
- `unity-package-src-migration`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/unity-package-src-migration/SKILL.md`
