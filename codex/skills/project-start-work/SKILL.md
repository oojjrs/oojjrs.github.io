---
name: project-start-work
description: Start repository work with the user's shared project rules. Use when Codex begins a coding, document, asset, Design.html, or maintenance task in a git repository and must establish scope, read required guidance, inspect git status/log, check Design.html when present, and update a repository-linked GitHub Project board before editing.
---

# Project Start Work

Use this skill before editing a repository.

## Start Checklist

1. Read `https://oojjrs.github.io/codex/common-work-guidelines.md`.
2. Run `git status --short --branch` and inspect recent context with `git log --oneline --decorate -5`.
3. Preserve unrelated dirty files. If they affect the task, work around them or report the conflict.
4. If `Design.html` exists, read it before task work. For Design.html work, also use `$project-design-document-router`.
5. Resolve the exact requested scope and avoid bundling nearby docs/assets/runtime files unless requested.
6. Check whether the repository is linked 1:1 to a GitHub Project. If linked, use `$github-project-board` to find/create the task card, convert draft to issue when moving to In Progress, and update status/notes with real newlines.
7. If no linked board/card update is possible, say that explicitly before or during the work report.
8. Start implementation only after these checks unless the user is only asking a question or review.

## Scope Rules

Use the newest user message as the task boundary.

- Generic "document" work does not include `Design.html` unless the user says planning/design doc.
- GitHub Project board work is operational and must not be copied into `Design.html`.
- Push, deploy, forced rollback, permanent delete, or unrecoverable rewrite still need explicit immediate instruction.

## Report

In the first substantive update or final report, mention the branch/dirty state and whether a GitHub Project board/card was updated.
