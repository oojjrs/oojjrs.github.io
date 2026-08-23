# Codex Skill Sources And Routing

When a task matches an available skill, use the most-specific matching skill. Keep the active stack as small as the task permits instead of loading every listed skill.

## Host Custom Instruction

```text
$oojjrs-guidelines
```

## Minimal Stack

```text
$oojjrs-guidelines
+ [$oojjrs-project-start-work: local file or Git-state mutation]
+ [primary domain: zero or one most-specific match]
+ [helper: only after its condition is confirmed]
+ [$oojjrs-project-finish-work: local stage/commit or authorized external completion]
```

- Ordinary conversation, factual Q&A, translation, and rewriting: when host instructions name guidelines, apply only their final-answer presentation requirements; use no lifecycle or domain skill.
- Read-only review or diagnosis: guidelines only when shared work rules matter, then the smallest non-overlapping read-only domains sequentially; no start or finish.
- Local repository edits: guidelines once, start immediately before the first mutation, protect pre-existing or concurrent work outside the current task, use one primary domain at a time when needed, then one check-only exact-file format pass and one scoped diff review. Add finish only when actually staging or committing.
- Scoped stage/commit: local staging and commit need no separate permission. Complete requested content work and required documentation or governed version synchronization first, freeze the scoped bytes immediately before staging, and preserve everything outside that scope.
- Push/deploy of an already reviewed commit: guidelines once and finish authorization gate; start is unnecessary when local state will not change first.
- Builds, tests, runtime servers, browsers, and new tests require a request that targets that execution surface and an independent oracle. Rendered layout work targets the rendered surface and may use Visual QA.
- A more-specific domain owns its subordinate safety, docs, and validation rules. Do not load generic parents alongside it.
- Split genuinely independent deliverables into sequential phases instead of preloading several primary domains.

## Routing Matrix

| Role | Skill | Load when | Exclusions and precedence |
|---|---|---|---|
| Core | `$oojjrs-guidelines` | Whenever host instructions name it, or when actual work needs the shared rules | Apply answer presentation to every final answer and operational workflow only to actual work; fetch the canonical URL once |
| Lifecycle | `$oojjrs-project-start-work` | Once before the first intended local file or Git-index mutation | Routine status at most once; history only when evidence requires it; not for review, diagnosis, planning, board-only, or push-only tasks |
| Lifecycle | `$oojjrs-project-finish-work` | Actual local stage/commit, or explicitly authorized push, deploy, release, publication, or destructive Git completion | Do not load when edits remain uncommitted; run only triggered checks once and omit inactive gates |
| Helper | `$oojjrs-dirty-worktree-scope-split` | Target changes overlap existing hunks or safe stage/commit isolation is ambiguous | Mere dirty status is insufficient; dirty provenance diagnosis uses Windows forensics |
| Helper | `$oojjrs-github-project-board` | User requests board work, or a cheap probe confirms a relevant 1:1 board this task must update | Do not load for every repo; load once, not again at finish |
| Helper | `$oojjrs-visual-qa` | Rendered visual evidence is the request or a materially necessary validation gate | Do not auto-add after every visual-file edit |
| Domain | `$oojjrs-project-design-document-router` | Focused `Design.html` review, cleanup, or update | Large creation/recovery uses Design builder instead |
| Domain | `$oojjrs-design-html-builder` | Image-heavy creation, recovery, substantial layout conversion, or `Design.html` rebuild, including `H:\Mines` document structure | Supersedes Design router; Mines asset work may precede it as a separate phase |
| Domain | `$oojjrs-readme-doc-generation` | README/public entry docs are the primary deliverable | Another primary domain edits its incidental README directly; this exclusion never forbids the README edit itself |
| Domain | `$oojjrs-guideline-maintenance` | Public guidance itself is the primary deliverable and no skill artifact changes | Skill/routing artifacts use skill maintenance; Unity C# convention sets use convention maintenance |
| Domain | `$oojjrs-unity-csharp-convention-maintenance` | Unity C# convention rules or translations themselves change | Not for applying the convention during code edits |
| Domain | `$oojjrs-skill-maintenance` | Public skill source, metadata, routing, install, or validation changes | Owns related common-rule routing alignment; do not add guideline maintenance |
| Domain | `$oojjrs-run-dhlottery-buyer` | Preparing, dry-running, explicitly executing, publishing, or scheduling the local DHLottery helper | UI-only purchase flow; never collect credentials or bypass the fresh final confirmation |
| Domain | `$oojjrs-steamworks` | Steamworks integration, SDK, API, SteamPipe, partner, or operations work | Uses Valve official docs; no generic web research substitute |
| Domain | `$oojjrs-unity-package-src-migration` | Moving an Assets-based Unity package into `Packages/src` | Directly performs needed version and README edits; do not add release, standalone README, or generic asset skills during migration |
| Domain | `$oojjrs-unity-package-release` | A governed UnityO package is being committed, or its version/release is explicitly requested | Not for game versions or package-root migration; generic finish owns Git completion while push/release still require explicit authorization |
| Domain | `$oojjrs-unity-asset-safety` | General Unity asset mutation with no more-specific workflow | Fallback only; do not stack with package, Mines, art, sprite, audio, or prefab domains |
| Domain | `$oojjrs-unity-csharp-entity-workflow` | Unity Entity/Data/Record/Manager additions and integrations | Classify Record-only, Data-and-Record, or Data-only first; ask about ReferenceIndex whenever Data is requested |
| Domain | `$oojjrs-unity-prefab-guid-usage-lookup` | Read-only Unity serialized reference/GUID tracing | No start/finish until the request changes to an edit |
| Domain | `$oojjrs-2d-sprite-animation` | 2D animation frames, sheets, pivots, or preview GIFs | Supersedes image-first art for animation frames |
| Domain | `$oojjrs-image-first-art-workflow` | General new or revised raster art and visual assets | Not for 2D animation or a more-specific Mines pipeline |
| Domain | `$oojjrs-mines-art-asset-pipeline` | `H:\Mines` art, UI asset, effect, theme, inventory, or Unity asset work | Supersedes generic image and Unity asset domains; only narrow existing Design asset-entry sync, not document structure or audio |
| Domain | `$oojjrs-game-audio-asset-workflow` | Audio editing, looping, SFX, project installation, previews, or Design synchronization | Switch to AI generator only for a sequential explicit generation phase |
| Domain | `$oojjrs-ai-music-generator` | Explicit paid AI instrumental generation/download phase | Do not preload for a larger integrated game-audio task |
| Domain | `$oojjrs-windows-repo-forensics` | Windows path, folder provenance, OneDrive, case, or false-dirty diagnosis | Read-only by default; actual mixed-hunk isolation uses dirty helper |

## Conditional Public References

These are documents, not additional primary skills. Load only when the edit matches:

- validation scope, build/test authority, or success-oracle decisions: `https://oojjrs.github.io/codex/validation-guideline.md`
- application/business-layer first-party naming: `https://oojjrs.github.io/codex/semantic-layer-naming-guideline.md`
- Unity C# code: `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md`
- first-party logs: `https://oojjrs.github.io/codex/logging-guideline.md`
- `Design.html`: `https://oojjrs.github.io/codex/guideline-design-generation.review.md`
- GitHub-facing README: `https://oojjrs.github.io/codex/guideline-readme-generation.review.md`

## Automatic Install

PowerShell:

```powershell
$repository = "oojjrs/oojjrs.github.io"
$ref = Invoke-RestMethod -Uri "https://api.github.com/repos/$repository/git/ref/heads/master"
$commit = [string]$ref.object.sha
$url = "https://raw.githubusercontent.com/$repository/$commit/codex/skills/install.ps1"
$path = Join-Path $env:TEMP "codex-skill-install.ps1"
Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $path
powershell -ExecutionPolicy Bypass -File $path -SourceCommit $commit
```

Every install or refresh checks the complete official `oojjrs-*` skill set discovered from one pinned GitHub commit. It downloads and writes only missing or changed files, leaves matching files untouched, verifies Git blob hashes, and removes managed stale files and retired `oojjrs-*` skill directories. New or removed skills are discovered automatically rather than maintained in a fixed installer list. Default destination is `$CODEX_HOME/skills`, or `~/.codex/skills` when `$CODEX_HOME` is unset.

`oojjrs-guidelines` installs both scripts:

- `Read-OojjrsGuidelines.ps1` directly fetches only the canonical common-rules URL, rejects a different final URL, and reports the fetched body's `active-sha256`. It has no local or cache fallback.
- `Test-OojjrsTextFormat.ps1` checks exact touched files once against their tracked encoding/EOL state and never auto-normalizes a mixed-EOL original. Use check-only mode by default; `-Fix` already verifies its own write.

The repository file `codex/common-work-guidelines.md` is the publication source. It does not override the active canonical URL before commit, push, and site publication.

## Skill URLs

- `oojjrs-guidelines`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-guidelines/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-guidelines/SKILL.md)
- `oojjrs-project-start-work`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-project-start-work/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-project-start-work/SKILL.md)
- `oojjrs-project-finish-work`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-project-finish-work/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-project-finish-work/SKILL.md)
- `oojjrs-dirty-worktree-scope-split`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-dirty-worktree-scope-split/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-dirty-worktree-scope-split/SKILL.md)
- `oojjrs-github-project-board`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-github-project-board/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-github-project-board/SKILL.md)
- `oojjrs-visual-qa`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-visual-qa/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-visual-qa/SKILL.md)
- `oojjrs-project-design-document-router`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-project-design-document-router/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-project-design-document-router/SKILL.md)
- `oojjrs-design-html-builder`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-design-html-builder/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-design-html-builder/SKILL.md)
- `oojjrs-readme-doc-generation`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-readme-doc-generation/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-readme-doc-generation/SKILL.md)
- `oojjrs-guideline-maintenance`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-guideline-maintenance/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-guideline-maintenance/SKILL.md)
- `oojjrs-unity-csharp-convention-maintenance`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-unity-csharp-convention-maintenance/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-csharp-convention-maintenance/SKILL.md)
- `oojjrs-skill-maintenance`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-skill-maintenance/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-skill-maintenance/SKILL.md)
- `oojjrs-run-dhlottery-buyer`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-run-dhlottery-buyer/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-run-dhlottery-buyer/SKILL.md)
- `oojjrs-steamworks`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-steamworks/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-steamworks/SKILL.md)
- `oojjrs-unity-package-src-migration`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-unity-package-src-migration/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-package-src-migration/SKILL.md)
- `oojjrs-unity-package-release`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-unity-package-release/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-package-release/SKILL.md)
- `oojjrs-unity-asset-safety`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-unity-asset-safety/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-asset-safety/SKILL.md)
- `oojjrs-unity-csharp-entity-workflow`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-unity-csharp-entity-workflow/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-csharp-entity-workflow/SKILL.md)
- `oojjrs-unity-prefab-guid-usage-lookup`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-unity-prefab-guid-usage-lookup/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-unity-prefab-guid-usage-lookup/SKILL.md)
- `oojjrs-2d-sprite-animation`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-2d-sprite-animation/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-2d-sprite-animation/SKILL.md)
- `oojjrs-image-first-art-workflow`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-image-first-art-workflow/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-image-first-art-workflow/SKILL.md)
- `oojjrs-mines-art-asset-pipeline`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-mines-art-asset-pipeline/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-mines-art-asset-pipeline/SKILL.md)
- `oojjrs-game-audio-asset-workflow`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-game-audio-asset-workflow/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-game-audio-asset-workflow/SKILL.md)
- `oojjrs-ai-music-generator`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-ai-music-generator/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-ai-music-generator/SKILL.md)
- `oojjrs-windows-repo-forensics`: [웹 보기](https://oojjrs.github.io/codex/skills/oojjrs-windows-repo-forensics/SKILL/) · [원문](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/oojjrs-windows-repo-forensics/SKILL.md)
