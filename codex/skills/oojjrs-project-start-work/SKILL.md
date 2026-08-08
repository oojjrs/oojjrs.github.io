---
name: oojjrs-project-start-work
description: Establish scope and routing immediately before the first authorized local file, Git index, or commit mutation in a repository. Use for repository edits and for staging or committing an existing scoped diff. Do not use for ordinary questions, read-only review, diagnosis, status checks, planning, GitHub Project-only operations, or a push of an already reviewed commit with no new local mutation.
---

# oojjrs Project Start Work

Use this lifecycle skill once immediately before the first intended local file, index, or commit mutation. Assume `$oojjrs-guidelines` already loaded the canonical common rules; do not load them again.

## Start Gate

1. Resolve the repository root and current user-requested scope.
2. Inspect `git status --short --branch` and relevant recent history, normally `git log --oneline --decorate -5`.
3. List the files or areas likely to change and separate them from existing user or parallel-task changes.
4. If requested and existing changes overlap in the same files, or safe staging will be ambiguous, load `$oojjrs-dirty-worktree-scope-split`. Mere dirty status is not enough.
5. Note the original encoding and line-ending state of existing text files that will be edited. For Git-only completion work, verify the existing diff instead.
6. Select one primary domain at a time when a domain is needed. The most-specific match wins and owns its subordinate safety, documentation, and validation rules; do not stack its generic parents.
7. Read `Design.html` only when the task changes planning content or planning-visible state. Probe or load a GitHub Project board only when the user requested board work or the task is already known to use a confirmed 1:1-linked board.
8. Begin editing only after the scope can be isolated safely. Report a real overlap or missing decision instead of guessing.

## Conditional Public References

Load these only when the intended edit matches the condition:

- first-party application or business-layer names in a game/server: `https://oojjrs.github.io/codex/semantic-layer-naming-guideline.md`
- Unity C# code: `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md`
- first-party log messages: `https://oojjrs.github.io/codex/logging-guideline.md`

## Start Output

Keep a compact scope note containing branch, requested files/areas, unrelated dirty work, selected primary domain, conditional helpers/references, and any blocker. Do not mutate a board or another external service merely to complete this start gate.
