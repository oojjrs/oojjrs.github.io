---
name: oojjrs-project-start-work
description: Establish scope and routing once before the first authorized local file or Git-index mutation in a repository. Use for repository edits and for staging an existing scoped diff. Do not use for ordinary questions, read-only review, diagnosis, status checks, planning, GitHub Project-only operations, or a push of an already reviewed commit with no new local mutation.
---

# oojjrs Project Start Work

Use this lifecycle skill once immediately before the first intended local file, index, or commit mutation. Assume `$oojjrs-guidelines` already loaded the canonical common rules; do not load them again.

## Start Gate

1. Resolve the repository root and current user-requested scope.
2. Inspect `git status --short --branch` once when it is needed to distinguish pre-existing work from the requested mutation. Do not read recent history unless provenance, regression, recovery, or commit context actually depends on it.
3. Identify only the files or areas likely to change. If requested and existing changes overlap in the same files, or safe staging will be ambiguous, load `$oojjrs-dirty-worktree-scope-split`; mere dirty status is not enough.
4. Preserve each target text file's existing encoding and line endings as a write condition. Do not add a separate pre-edit format audit unless the format is unknown or already suspicious.
5. Select one primary domain at a time when a domain is needed. The most-specific match owns its subordinate safety and artifact rules; do not stack its generic parents.
6. Read `Design.html` only when the task changes planning content or planning-visible state. Probe or load a GitHub Project board only when the user requested board work or the task already uses a confirmed linked board.
7. Begin editing once the scope can be isolated safely. Report only a real overlap or missing decision instead of narrating a routine start gate.

## Conditional Public References

Load these only when the intended edit matches the condition:

- first-party application or business-layer names in a game/server: `https://oojjrs.github.io/codex/semantic-layer-naming-guideline.md`
- Unity C# code: `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md`
- first-party log messages: `https://oojjrs.github.io/codex/logging-guideline.md`

## Start Output

Keep only the scratch state needed to protect the requested scope. Do not emit a routine start report, repeat unchanged Git evidence, or mutate a board or another external service merely to complete this gate.
