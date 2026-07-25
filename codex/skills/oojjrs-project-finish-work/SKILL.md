---
name: oojjrs-project-finish-work
description: Finish repository work with validation, narrow git scope, Design.html synchronization when planning state changed, GitHub Project board updates, and Korean reporting. Use immediately after the last edit when entering validation, stage, commit, push, handoff, or final reporting; a task-start or earlier read does not count, and the skill must be re-read before every commit.
---

# oojjrs Project Finish Work

Use this skill only when entering the finish phase after the last edit, and again before every commit, push, final response, or handoff.

## Activation Timing

1. Do not preload this skill at task start. A task-start or earlier read never satisfies a later finish phase.
2. After the last edit, re-read the shared rules and then read this file in a completed tool call. Wait for and apply the returned instructions before validation, staging, committing, pushing, handing off, or reporting.
3. If any file changes after that read, the finish phase is invalid. Restart it by re-reading the shared rules and this file.
4. Before every `git commit`, complete the checklist and review the cached-diff output in an earlier completed tool call. The later commit command must re-read the shared rules and this file and rerun `git diff --cached --check` before invoking Git.
5. Never combine the first finish-phase read, unseen validation output, and `git commit` in one tool call.

## Finish Checklist

1. Re-check `git status --short --branch`.
2. Review the diff and keep staging narrow to the requested scope.
3. Run the relevant validation: at minimum `git diff --check`; add project build/tests when the task touched executable behavior.
4. Run the shared text-format checker with `-Fix` on every touched text file, rerun it without `-Fix`, and review the ordinary diff. It must compare uniform tracked files across the whole file because `git diff --check` and changed-line-only checks can miss EOL normalization.
5. For Unity asset work, verify the staged diff does not add newly authored `.meta` files unless the user explicitly requested them; moved or preserved existing `.meta` files are acceptable.
6. If `Design.html` exists and the work changed planning state, update it using `$oojjrs-project-design-document-router`.
7. If a repository-linked GitHub Project board exists, use `$oojjrs-github-project-board` to update the task card assignee/status/body/notes with real newlines. Report if no update was possible.
8. Before commit, inspect `git diff --cached --name-status` and `git diff --cached --check` in a completed tool call and review their output before issuing a later commit call.
9. Push only when the immediately previous user message explicitly requested push.
10. Keep feedback in Korean and include relevant `git log` context.

## Commit Shape

Prefer small semantic commits. Do not include `Design.html`, document assets, version bumps, generated files, or unrelated dirty changes unless the task explicitly includes them.

If the user requested "all project planning docs" or similar cross-repo work, commit per repository and verify each branch matches its origin after push.

## Final Report

Report files changed, validation run or skipped reason, commit/push status, GitHub Project board/card status, and remaining dirty files or risks.
