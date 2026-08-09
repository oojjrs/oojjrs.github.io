---
name: oojjrs-project-finish-work
description: Close repository work after task-local edits, or complete scoped validation, stage, commit, push, or deploy work for an existing diff or commit. Use to audit validation, text format, the mandatory pre-commit version-policy check, docs, Design, asset metadata, publication/runtime synchronization, board state, commit, and push/deploy decisions. Do not use for ordinary read-only review, diagnosis, planning, or status reporting with no Git completion action.
---

# oojjrs Project Finish Work

Use this lifecycle skill after the last intended edit, or when the task is to finish an already-scoped diff or commit. Assume the canonical common rules were already loaded once; do not reload them. If this audit causes another edit, restart from the final diff after that edit.

## Stable-Diff Loop

1. Inspect `git status --short --branch` and the final ordinary diff for the requested scope.
2. Complete every decision in the impact table. Never silently omit a row.
3. If a commit is authorized, the Version decision always applies. Inspect the exact commit scope and read every applicable published version policy before the final staged review. Route UnityO library changes through `$oojjrs-unity-package-release`; package-root migration keeps its migration-owned decision. If no versioned unit exists, record why. If a versioned unit has no governing policy, stop before commit instead of inventing one.
4. Reuse the current primary domain when a row needs its procedure. If a different primary domain owns an applicable version policy or another required procedure, close the current phase and route a sequential follow-up phase; do not preload both or load a domain merely to declare a row not applicable.
5. If a version, document, Design, metadata, or other required update changes files, return to step 1.
6. Once stable, run the exact-file text-format check below, `git diff --check`, and task-relevant builds/tests or a documented skip. Review the diff again after any automatic fix.

## Required Impact Decisions

| Decision | Apply when | Required result |
|---|---|---|
| Validation | Always evaluate | checks run and result, or precise skip reason |
| Text format | Text files changed | exact touched-file result, or manual-review blocker |
| Version | A versioned unit changed, a commit is authorized, or a version/release decision was requested | exact scope inspected; applicable policy read and bump/no-bump/value reported, no versioned unit with reason, or a missing-policy blocker |
| Docs/README | User behavior, public API, install/use steps, or published claims changed | synchronized files, or not needed with reason |
| Design | Planning state, asset inventory, UX decision, or completion state changed | synchronized `Design.html`, or not needed with reason |
| Asset metadata | Unity or other metadata-bearing assets changed | verified companion metadata, or not applicable |
| Publication/runtime sync | Canonical public guidance, skill source, installer, or deployed runtime content changed | source/published/installed hash parity, pending authorization/publication, or not applicable |
| Task board | The user requested it or this task already uses a confirmed linked board | update result, outside scope, or permission blocker |
| Commit | Always evaluate | commit hash, not authorized/requested, or blocker |
| Push/deploy | Always evaluate | result, not explicitly authorized, or not applicable |

## Text Format Gate

Run the checker from the installed `$oojjrs-guidelines` skill on exact touched text files, first with `-Fix` and then without it:

```powershell
powershell -ExecutionPolicy Bypass -File <oojjrs-guidelines-skill-dir>\scripts\Test-OojjrsTextFormat.ps1 -Path <exact-touched-files> -Fix
powershell -ExecutionPolicy Bypass -File <oojjrs-guidelines-skill-dir>\scripts\Test-OojjrsTextFormat.ps1 -Path <exact-touched-files>
```

If `-Fix` changes a file or reports a mixed-EOL manual review, return to the stable-diff loop before staging or reporting.

## Stage And Commit Gate

Stage only exact requested paths, and only when a commit is authorized. Do not stage files merely to produce a final report. Do not begin the final staged review until the Version decision is complete.

Before committing, review `git diff --cached --name-status`, the staged diff, and `git diff --cached --check` in a completed inspection step. Commit only while that reviewed staged content remains unchanged. If staged paths or content change, repeat the Version decision for the new exact scope and inspect the staged content again. Push or deploy only under explicit current authorization.

## Final Report

Report in Korean: changed files/scope, validation, every impact decision above, commit/push/deploy state, relevant recent Git context, unrelated dirty files left untouched, and remaining risks. A concise table is preferred when several decisions are not applicable.
