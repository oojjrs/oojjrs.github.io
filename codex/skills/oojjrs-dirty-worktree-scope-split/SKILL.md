---
name: oojjrs-dirty-worktree-scope-split
description: Work safely in dirty git repositories by preserving unrelated user or parallel-thread changes, splitting mixed work into narrow scopes, staging exact files, creating review worktrees when useful, and preparing clean commits without sweeping in unrelated Unity, document, asset, or generated-file changes.
---

# oojjrs Dirty Worktree Scope Split

Use this skill whenever `git status` shows unrelated or mixed changes and the user asks for a narrow fix, commit, review, or cleanup.

## First Pass

1. Run `git status --short --branch`.
2. Inspect recent context with `git log --oneline --decorate -5`.
3. Classify changes as requested scope, related support files, unrelated existing work, generated/temp files, or unknown.
4. Do not revert or clean unknown changes. Treat them as user or parallel-thread work.

## Narrow Work

1. Read diffs for files you must touch.
2. Edit only the requested scope.
3. Stage exact paths, not broad `git add -A`, unless the whole dirty tree is the requested scope.
4. Use `git diff --cached --name-status` and `git diff --cached --check` before committing.
5. If unrelated changes are interleaved in the same file, avoid staging until you can isolate hunks safely; ask only if isolation is impossible.

## Worktree Split

Use a separate worktree when the user wants independent review slices or the root checkout must return clean.

Before moving files recursively on Windows, resolve absolute paths and confirm they stay inside the intended workspace.

## Reporting

Report what was included, what was deliberately left out, and any remaining dirty files after the requested commit.
