---
name: oojjrs-project-start-work
description: Establish scope and routing once before the first intended local file or Git-index mutation in a repository. Use for repository edits and for staging an existing scoped diff. Do not use for ordinary questions, read-only review, diagnosis, status checks, planning, GitHub Project-only operations, or a push of an already reviewed commit with no new local mutation.
---

# oojjrs Project Start Work

Use this lifecycle skill once immediately before the first intended local file, index, or commit mutation. Assume `$oojjrs-guidelines` already loaded the canonical common rules; do not load them again.

## Start Gate

1. Resolve the repository root and current user-requested scope.
2. Inspect `git status --short --branch` once when it is needed to distinguish pre-existing work from the requested mutation. Do not read recent history unless provenance, regression, recovery, or commit context actually depends on it.
3. Treat every pre-existing or concurrently appearing working-tree or index change and untracked item as protected content unless the common rules identify it as task-owned temporary or generated output. Inspection, validation, a `TODO`, a defect, a missing link, staging, or commit never grants authority to edit outside the current task's content scope.
4. Identify only the files or areas likely to change. If requested and existing changes overlap in the same files, or safe staging will be ambiguous, load `$oojjrs-dirty-worktree-scope-split`; mere dirty status is not enough.
5. Preserve each target text file's existing encoding and line endings as a write condition. Do not add a separate pre-edit format audit unless the format is unknown or already suspicious.
6. Select one primary domain at a time when a domain is needed. The most-specific match owns its subordinate safety and artifact rules; do not stack its generic parents.
7. Read `Design.html` only when the task changes planning content or planning-visible state. Probe a repository-linked board once when a 1:1 link can be checked cheaply; load the board helper only when board work is requested or the confirmed board belongs to this task.
8. For code changes, complete the Code Convention Preflight below before the first code edit. For other changes, begin editing once the scope can be isolated safely. Report only a real overlap or missing decision instead of narrating a routine start gate.

## Conditional Public References

Load these only when the intended edit matches the condition:

- first-party application or business-layer names in a game/server: `https://oojjrs.github.io/codex/semantic-layer-naming-guideline.md`
- Unity C# code: `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md`
- first-party log messages: `https://oojjrs.github.io/codex/logging-guideline.md`

## Code Convention Preflight

1. Load only the matching conditional references above before choosing any governed name or declaration placement.
2. Before implementation, fix the exact role and final name of every planned new or renamed first-party identifier against those references. If implementation reveals another identifier, settle it through the same gate before writing it.
3. Before adding or moving a Unity C# declaration, determine its final section and group plus its immediate `abc` predecessor and successor. Apply rule 29 first, then 31/34, then 30; `abc` applies only inside the resulting group and never overrides an earlier grouping rule, and rule 37 forbids access-based grouping.
4. Retain these decisions only in task scratch state through the canonical final scoped diff. Use that existing diff to confirm the implementation matches the decisions; re-derive only an unplanned item or one whose role or structure changed, never perform a second from-scratch convention audit.

## Start Output

Keep only the scratch state needed to protect the requested scope. Do not emit a routine start report, repeat unchanged Git evidence, or mutate a board or another external service merely to complete this gate.
