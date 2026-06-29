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
powershell -ExecutionPolicy Bypass -File $path -Skill oojjrs-github-project-board
```

Default destination is `$CODEX_HOME/skills`, or `~/.codex/skills` when `$CODEX_HOME` is unset.

## Skill URLs

- `oojjrs-guidelines`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-guidelines/SKILL.md`
- `oojjrs-github-project-board`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-github-project-board/SKILL.md`
- `oojjrs-project-start-work`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-project-start-work/SKILL.md`
- `oojjrs-project-finish-work`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-project-finish-work/SKILL.md`
- `oojjrs-project-design-document-router`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-project-design-document-router/SKILL.md`
- `oojjrs-unity-package-src-migration`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-package-src-migration/SKILL.md`
- `oojjrs-2d-sprite-animation`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-2d-sprite-animation/SKILL.md`
- `oojjrs-image-first-art-workflow`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-image-first-art-workflow/SKILL.md`
