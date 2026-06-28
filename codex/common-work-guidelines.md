# Codex Work Rules

Read this before work. Keep it tiny.

1. Follow the latest user instruction and current scope.
2. Do normal requested work immediately; do not ask for extra approval.
3. For review requests, review only: inspect diffs/files and report findings first. Do not run builds/tests or make edits unless the user asks for them.
4. Ask first unless the immediately previous user message explicitly ordered a hard-to-undo or external action: `git push`, deploy, permanent delete, forced rollback, or unrecoverable document rewrite.
5. Preserve user/other-thread changes. Do not revert or clean unrelated files.
6. Preserve existing text encoding and line endings. New text: UTF-8 No-BOM + CRLF.
7. If `Design.html` exists, read it before every task and update it when the task changes planning state.
8. For `Design.html` work, also read `https://oojjrs.github.io/codex/guideline-design-generation.review.md`.
9. When editing Unity C# code, also read `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md`.
10. Use project skills when relevant; if missing, install/update from `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/install.ps1`; index: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/index.md`.
11. If the git repository is linked 1:1 to a GitHub Project, use `$github-project-board` and that Project as the task board: find/create the task card, convert a draft card to an issue when moving it to In Progress, assign issue-backed cards to `oojjrs`, update status/notes while working, use real newlines in card/issue bodies instead of literal `\n`, and report if no board/card update was possible.
12. Stage/commit only the requested scope. Push only when explicitly requested.
13. Write feedback and documents in Korean; include relevant `git log` context when reporting work or choosing the next task.
