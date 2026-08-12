# Codex Skill Routing

Host instruction: `$oojjrs-guidelines`

Load the core once, add start only before mutation, select one most-specific domain at a time, add helpers only on confirmed triggers, and add finish only for requested Git or publication completion.

## Routing Matrix

| Role | Skill | Trigger and precedence |
|---|---|---|
| Core | `$oojjrs-guidelines` | Actual repository, code, document, asset, Git, validation, maintenance, or deployment work; canonical URL once |
| Lifecycle | `$oojjrs-project-start-work` | Immediately before the first local file or Git-index mutation; not for read-only or push-only work |
| Lifecycle | `$oojjrs-project-finish-work` | Requested stage, commit, push, deploy, release, or scoped Git completion only |
| Helper | `$oojjrs-dirty-worktree-scope-split` | Overlapping hunks or ambiguous stage/commit isolation; not merely a dirty tree |
| Helper | `$oojjrs-github-project-board` | Requested board work or a confirmed relevant 1:1-linked board this task must update |
| Helper | `$oojjrs-visual-qa` | Requested or materially necessary rendered evidence |
| Domain | `$oojjrs-project-design-document-router` | Focused `Design.html` work; large creation/recovery uses Design builder |
| Domain | `$oojjrs-design-html-builder` | Image-heavy creation, recovery, conversion, or substantial `Design.html` rebuild |
| Domain | `$oojjrs-readme-doc-generation` | Standalone README or public entry docs; migration/release owns incidental docs |
| Domain | `$oojjrs-guideline-maintenance` | Public guidance with no skill artifact changes; conventions use convention maintenance |
| Domain | `$oojjrs-unity-csharp-convention-maintenance` | Unity C# convention rules or translations themselves |
| Domain | `$oojjrs-skill-maintenance` | Skill source, metadata, routing, installer, or related common-rule alignment |
| Domain | `$oojjrs-steamworks` | Steamworks integration or operation; use current Valve documentation |
| Domain | `$oojjrs-unity-package-src-migration` | Assets package migration into `Packages/src`; owns incidental release/docs/assets rules |
| Domain | `$oojjrs-unity-package-release` | Governed UnityO package commit or explicit version/release work; not migration |
| Domain | `$oojjrs-unity-asset-safety` | General Unity asset mutation only when no specific asset domain applies |
| Domain | `$oojjrs-unity-csharp-entity-workflow` | Unity entity/model/binding/runtime helpers; package release is a later phase |
| Domain | `$oojjrs-unity-prefab-guid-usage-lookup` | Read-only serialized-reference/GUID tracing |
| Domain | `$oojjrs-2d-sprite-animation` | 2D animation frames, sheets, pivots, or preview GIFs |
| Domain | `$oojjrs-image-first-art-workflow` | General raster art; not 2D animation or the Mines pipeline |
| Domain | `$oojjrs-mines-art-asset-pipeline` | `H:\Mines` art and planning-surface assets; supersedes generic parents |
| Domain | `$oojjrs-game-audio-asset-workflow` | Audio editing, looping, installation, previews, or Design sync |
| Domain | `$oojjrs-ai-music-generator` | Explicit paid instrumental generation/download phase only |
| Domain | `$oojjrs-windows-repo-forensics` | Windows path, repository, OneDrive, case, or false-dirty diagnosis |

## Conditional Public References

Load only when the edit matches:

- validation scope, build/test authority, or success-oracle decisions: `https://oojjrs.github.io/codex/validation-guideline.md`
- application/business-layer first-party naming: `https://oojjrs.github.io/codex/semantic-layer-naming-guideline.md`
- Unity C# code: `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md`
- first-party logs: `https://oojjrs.github.io/codex/logging-guideline.md`
- `Design.html`: `https://oojjrs.github.io/codex/guideline-design-generation.review.md`
- GitHub-facing README: `https://oojjrs.github.io/codex/guideline-readme-generation.review.md`

## Install

```powershell
$url = "https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/install.ps1"
$path = Join-Path $env:TEMP "codex-skill-install.ps1"
Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $path
powershell -ExecutionPolicy Bypass -File $path
```

Use `-Skill @("name", ...)` for selected skills and `-SkipToolInstall` to omit workstation tools. The downloaded installer pins one remote commit, preserves and verifies source bytes, and installs to `$CODEX_HOME/skills` or `~/.codex/skills`.

## Skill URLs

`https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/<skill-name>/SKILL.md`
