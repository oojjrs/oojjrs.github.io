# Codex Skill Sources And Routing

Use the smallest stack that can complete the task. A skill URL being listed here does not mean it should be loaded for every thread.

## Host Custom Instruction

```text
코드·문서·자산·Git·검증·배포 등 실제 작업 스레드에서는 $oojjrs-guidelines로 canonical URL을 한 번만 읽어라. 저장소를 실제 변경할 때만 $oojjrs-project-start-work와 가장 구체적인 도메인 스킬 하나를 사용하고, 마지막 편집 뒤에는 $oojjrs-project-finish-work로 마감하라. 명령마다 지침을 재독하거나 모든 스킬을 미리 읽지 말고, 단순 질문에는 이 워크플로를 사용하지 마라.
```

## Minimal Stack

```text
$oojjrs-guidelines
+ [$oojjrs-project-start-work: local file or Git-state mutation]
+ [primary domain: zero or one most-specific match]
+ [helper: only after its condition is confirmed]
+ [$oojjrs-project-finish-work: edits or scoped Git completion]
```

- Ordinary conversation, factual Q&A, translation, and rewriting: no workflow skill.
- Read-only review or diagnosis: guidelines only when shared work rules matter, then the smallest non-overlapping read-only domains sequentially; no start or finish.
- Local repository edits or scoped stage/commit: guidelines once, start immediately before the first mutation, one primary domain at a time when needed, then finish; every authorized commit completes finish's version-policy check before the final staged review.
- Push/deploy of an already reviewed commit: guidelines once and finish authorization gate; start is unnecessary when local state will not change first.
- A more-specific domain owns its subordinate safety, docs, and validation rules. Do not load generic parents alongside it.
- Split genuinely independent deliverables into sequential phases instead of preloading several primary domains.

## Routing Matrix

| Role | Skill | Load when | Exclusions and precedence |
|---|---|---|---|
| Core | `$oojjrs-guidelines` | Actual repository, code, document, asset, Git, validation, maintenance, or deployment work | Fetch canonical URL once; no per-command reload, cache, or workspace substitute |
| Lifecycle | `$oojjrs-project-start-work` | Immediately before the first authorized local file/index/commit mutation | Not for review, diagnosis, planning, board-only, or push-only tasks |
| Lifecycle | `$oojjrs-project-finish-work` | After task edits or for scoped validation/stage/commit/push/deploy of an existing diff/commit | Not for ordinary no-action reporting; before every authorized commit, inspect the exact scope, consult each applicable version policy, and block if a changed versioned unit has no policy; repeat if the audit causes an edit |
| Helper | `$oojjrs-dirty-worktree-scope-split` | Target changes overlap existing hunks or safe stage/commit isolation is ambiguous | Mere dirty status is insufficient; dirty provenance diagnosis uses Windows forensics |
| Helper | `$oojjrs-github-project-board` | User requests board work, or a cheap probe confirms a relevant 1:1 board this task must update | Do not load for every repo; load once, not again at finish |
| Helper | `$oojjrs-visual-qa` | Rendered visual evidence is the request or a materially necessary validation gate | Do not auto-add after every visual-file edit |
| Domain | `$oojjrs-project-design-document-router` | Focused `Design.html` review, cleanup, or update | Large creation/recovery uses Design builder instead |
| Domain | `$oojjrs-design-html-builder` | Image-heavy creation, recovery, conversion, or substantial `Design.html` rebuild | Supersedes Design router |
| Domain | `$oojjrs-readme-doc-generation` | README/public entry docs are the primary deliverable | Package migration/release owns its incidental README synchronization |
| Domain | `$oojjrs-guideline-maintenance` | Public guidance itself is the primary deliverable and no skill artifact changes | Skill/routing artifacts use skill maintenance; Unity C# convention sets use convention maintenance |
| Domain | `$oojjrs-unity-csharp-convention-maintenance` | Unity C# convention rules or translations themselves change | Not for applying the convention during code edits |
| Domain | `$oojjrs-skill-maintenance` | Public skill source, metadata, routing, install, or validation changes | Owns related common-rule routing alignment; do not add guideline maintenance |
| Domain | `$oojjrs-steamworks` | Steamworks integration, SDK, API, SteamPipe, partner, or operations work | Uses Valve official docs; no generic web research substitute |
| Domain | `$oojjrs-unity-package-src-migration` | Moving an Assets-based Unity package into `Packages/src` | Supersedes release, README, and generic asset skills for the migration |
| Domain | `$oojjrs-unity-package-release` | Before committing any UnityO library change, or for its version decision/change or release-readiness review | Not for game versions or package-root migration; generic finish owns commit/push authorization |
| Domain | `$oojjrs-unity-asset-safety` | General Unity asset mutation with no more-specific workflow | Fallback only; do not stack with package, Mines, art, sprite, audio, or prefab domains |
| Domain | `$oojjrs-unity-csharp-entity-workflow` | Unity entity/model/binding/runtime-helper changes | Before committing UnityO package changes, route package version evaluation as a later separate release phase |
| Domain | `$oojjrs-unity-prefab-guid-usage-lookup` | Read-only Unity serialized reference/GUID tracing | No start/finish until the request changes to an edit |
| Domain | `$oojjrs-2d-sprite-animation` | 2D animation frames, sheets, pivots, or preview GIFs | Supersedes image-first art for animation frames |
| Domain | `$oojjrs-image-first-art-workflow` | General new or revised raster art and visual assets | Not for 2D animation or a more-specific Mines pipeline |
| Domain | `$oojjrs-mines-art-asset-pipeline` | `H:\Mines` art, UI asset, effect, theme, inventory, or planning-surface work | Supersedes generic image, Unity asset, and Design domains |
| Domain | `$oojjrs-game-audio-asset-workflow` | Audio editing, looping, SFX, project installation, previews, or Design synchronization | Switch to AI generator only for a sequential explicit generation phase |
| Domain | `$oojjrs-ai-music-generator` | Explicit paid AI instrumental generation/download phase | Do not preload for a larger integrated game-audio task |
| Domain | `$oojjrs-windows-repo-forensics` | Windows path, folder provenance, OneDrive, case, or false-dirty diagnosis | Read-only by default; actual mixed-hunk isolation uses dirty helper |

## Conditional Public References

These are documents, not additional primary skills. Load only when the edit matches:

- application/business-layer first-party naming: `https://oojjrs.github.io/codex/semantic-layer-naming-guideline.md`
- Unity C# code: `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md`
- first-party logs: `https://oojjrs.github.io/codex/logging-guideline.md`
- `Design.html`: `https://oojjrs.github.io/codex/guideline-design-generation.review.md`
- GitHub-facing README: `https://oojjrs.github.io/codex/guideline-readme-generation.review.md`

## Automatic Install

PowerShell:

```powershell
$url = "https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/install.ps1"
$path = Join-Path $env:TEMP "codex-skill-install.ps1"
Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $path
powershell -ExecutionPolicy Bypass -File $path
```

Install selected skills:

```powershell
& $path -Skill @("oojjrs-guidelines", "oojjrs-project-start-work", "oojjrs-project-finish-work")
```

Default destination is `$CODEX_HOME/skills`, or `~/.codex/skills` when `$CODEX_HOME` is unset. A local installer uses one complete local publication tree; a downloaded installer resolves `master` once and fetches the whole bundle from that immutable Git commit. It preserves source bytes, verifies each destination SHA-256, and reports unexpected stale files instead of treating them as current manifest content. Add `-SkipToolInstall` to skip optional workstation-tool installation.

`oojjrs-guidelines` installs both scripts:

- `Read-OojjrsGuidelines.ps1` directly fetches only the canonical common-rules URL, rejects a different final URL, and reports the fetched body's `active-sha256`. It has no local or cache fallback.
- `Test-OojjrsTextFormat.ps1` checks exact touched files against their tracked encoding/EOL state and never auto-normalizes a mixed-EOL original.

The repository file `codex/common-work-guidelines.md` is the publication source. It does not override the active canonical URL before commit, push, and site publication.

## Skill URLs

- `oojjrs-guidelines`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-guidelines/SKILL.md`
- `oojjrs-project-start-work`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-project-start-work/SKILL.md`
- `oojjrs-project-finish-work`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-project-finish-work/SKILL.md`
- `oojjrs-dirty-worktree-scope-split`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-dirty-worktree-scope-split/SKILL.md`
- `oojjrs-github-project-board`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-github-project-board/SKILL.md`
- `oojjrs-visual-qa`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-visual-qa/SKILL.md`
- `oojjrs-project-design-document-router`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-project-design-document-router/SKILL.md`
- `oojjrs-design-html-builder`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-design-html-builder/SKILL.md`
- `oojjrs-readme-doc-generation`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-readme-doc-generation/SKILL.md`
- `oojjrs-guideline-maintenance`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-guideline-maintenance/SKILL.md`
- `oojjrs-unity-csharp-convention-maintenance`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-csharp-convention-maintenance/SKILL.md`
- `oojjrs-skill-maintenance`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-skill-maintenance/SKILL.md`
- `oojjrs-steamworks`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-steamworks/SKILL.md`
- `oojjrs-unity-package-src-migration`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-package-src-migration/SKILL.md`
- `oojjrs-unity-package-release`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-package-release/SKILL.md`
- `oojjrs-unity-asset-safety`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-asset-safety/SKILL.md`
- `oojjrs-unity-csharp-entity-workflow`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-csharp-entity-workflow/SKILL.md`
- `oojjrs-unity-prefab-guid-usage-lookup`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-prefab-guid-usage-lookup/SKILL.md`
- `oojjrs-2d-sprite-animation`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-2d-sprite-animation/SKILL.md`
- `oojjrs-image-first-art-workflow`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-image-first-art-workflow/SKILL.md`
- `oojjrs-mines-art-asset-pipeline`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-mines-art-asset-pipeline/SKILL.md`
- `oojjrs-game-audio-asset-workflow`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-game-audio-asset-workflow/SKILL.md`
- `oojjrs-ai-music-generator`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-ai-music-generator/SKILL.md`
- `oojjrs-windows-repo-forensics`: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-windows-repo-forensics/SKILL.md`
