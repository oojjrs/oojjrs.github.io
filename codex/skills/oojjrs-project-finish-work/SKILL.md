---
name: oojjrs-project-finish-work
description: Finish repository work with validation, narrow git scope, Design.html synchronization when planning state changed, GitHub Project board updates, and Korean reporting. Use when Codex is done implementing, preparing a commit, pushing, or summarizing completed repository work.
---

# oojjrs Project Finish Work

Use this skill before final response, commit, push, or handoff.

## Finish Checklist

1. Re-check `git status --short --branch`.
2. Review the diff and keep staging narrow to the requested scope.
3. Run the relevant validation: at minimum `git diff --check`; add project build/tests when the task touched executable behavior.
4. Verify touched existing text files kept their original encoding and line endings; `git diff --check` alone is not sufficient.
5. If `Design.html` exists and the work changed planning state, update it using `$oojjrs-project-design-document-router`.
6. If a repository-linked GitHub Project board exists, use `$oojjrs-github-project-board` to update the task card assignee/status/body/notes with real newlines. Report if no update was possible.
7. Before commit, inspect `git diff --cached --name-status` and `git diff --cached --check`.
8. Push only when the immediately previous user message explicitly requested push.
9. Keep feedback in Korean and include relevant `git log` context.

## Commit Shape

Prefer small semantic commits. Do not include `Design.html`, document assets, version bumps, generated files, or unrelated dirty changes unless the task explicitly includes them.

If the user requested "all project planning docs" or similar cross-repo work, commit per repository and verify each branch matches its origin after push.

## Final Report

Report files changed, validation run or skipped reason, commit/push status, GitHub Project board/card status, and remaining dirty files or risks.
