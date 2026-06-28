# Codex Skill Sources

If a listed skill is missing, Codex should install/update it automatically before continuing.

Host custom instruction:

```text
모든 작업에서 $oojjrs-guidelines 를 먼저 사용하라.
```

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

- `oojjrs-guidelines`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-guidelines/SKILL.md`
- `github-project-board`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/github-project-board/SKILL.md`
- `project-start-work`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/project-start-work/SKILL.md`
- `project-finish-work`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/project-finish-work/SKILL.md`
- `project-design-document-router`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/project-design-document-router/SKILL.md`
- `unity-package-src-migration`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/unity-package-src-migration/SKILL.md`
- `2d-sprite-animation`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/2d-sprite-animation/SKILL.md`
- `image-first-art-workflow`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/image-first-art-workflow/SKILL.md`

## Legacy Skill URLs

- `oojjrs-unity-package-src-migration`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-package-src-migration/SKILL.md`
