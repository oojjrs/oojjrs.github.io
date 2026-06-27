# Codex Work Rules

Read this before work. Keep it tiny.

1. Follow the latest user instruction and current scope.
2. Do normal requested work immediately; do not ask for extra approval.
3. Ask first unless the immediately previous user message explicitly ordered a hard-to-undo or external action: `git push`, deploy, permanent delete, forced rollback, or unrecoverable document rewrite.
4. Preserve user/other-thread changes. Do not revert or clean unrelated files.
5. Preserve existing text encoding and line endings. New text: UTF-8 No-BOM + CRLF.
6. If `Design.html` exists, read it before every task and update it when the task changes planning state.
7. For `Design.html` work, also read `https://oojjrs.github.io/codex/guideline-design-generation.review.md`.
8. Use installed project skills when relevant (`$project-start-work`, `$project-finish-work`, `$project-design-document-router`, `$github-project-board`); source index: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/index.md`.
9. If the git repository is linked 1:1 to a GitHub Project, use `$github-project-board` and that Project as the task board: find/create the task card, convert a draft card to an issue when moving it to In Progress, assign issue-backed cards to `oojjrs`, update status/notes while working, use real newlines in card/issue bodies instead of literal `\n`, and report if no board/card update was possible.
10. Stage/commit only the requested scope. Push only when explicitly requested.
11. Write feedback and documents in Korean; include relevant `git log` context when reporting work or choosing the next task.
