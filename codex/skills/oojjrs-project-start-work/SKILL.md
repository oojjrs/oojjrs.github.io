---
name: oojjrs-project-start-work
description: Establish scope and routing once before the first authorized local file or Git-index mutation in a repository. Use for repository edits and for staging an existing scoped diff. Do not use for ordinary questions, read-only review, diagnosis, status checks, planning, GitHub Project-only operations, or a push of an already reviewed commit with no new local mutation.
---

# oojjrs Project Start Work

Run this lifecycle gate once, immediately before the first authorized local file, index, or commit mutation. `$oojjrs-guidelines` already owns the shared work rules; do not reload them.

## Start Gate

1. Resolve the repository root, authorized request, and likely target paths.
2. When needed to separate pre-existing work, inspect `git status --short --branch` once.
3. If requested work overlaps existing changes in the same files, or exact staging would be ambiguous, load `$oojjrs-dirty-worktree-scope-split`. Dirty files elsewhere do not trigger it.
4. Select the single most-specific primary domain for the first phase.
5. Begin once the requested mutation can be isolated safely. Stop only for a real overlap or a missing decision that changes the result.

## Conditional Public References

Load an applicable reference once before the relevant edit, then reuse it in downstream domain skills:

- first-party application or business-layer names in a game/server: `https://oojjrs.github.io/codex/semantic-layer-naming-guideline.md`
- Unity C# code: `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md`
- first-party log messages: `https://oojjrs.github.io/codex/logging-guideline.md`

Do not load a reference for skill or documentation text that merely mentions its domain.
