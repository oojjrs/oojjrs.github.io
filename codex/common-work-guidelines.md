# Codex Work Rules

Read this before work. Keep it tiny.

1. Follow the latest user instruction and current scope.
2. Always treat this file as the highest-priority project guidance. Read and apply it before local skills, memory, habits, or tool-specific notes; those sources are supplemental only and lose on any conflict.
3. Do normal requested work immediately; do not ask for extra approval.
4. For review requests, review only: inspect diffs/files and report findings first. Do not run builds/tests or make edits unless the user asks for them.
5. Ask first unless the immediately previous user message explicitly ordered a hard-to-undo or external action: `git push`, deploy, permanent delete, forced rollback, or unrecoverable document rewrite.
6. Preserve user/other-thread changes. Do not revert or clean unrelated files.
7. Existing text files: preserve their current encoding and line endings exactly; do not normalize them just because they were touched. New text files only: UTF-8 No-BOM + CRLF.
8. If `Design.html` exists, read it before every task and update it when the task changes planning state.
9. For `Design.html` work, also read `https://oojjrs.github.io/codex/guideline-design-generation.review.md`.
10. When editing Unity C# code, also read `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md`.
11. After applying this file, use project skills only as supplemental workflow help; if missing, install/update from `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/install.ps1`; index: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/index.md`.
12. If the git repository is linked 1:1 to a GitHub Project, use `$github-project-board` and that Project as the task board: find/create the task card, convert a draft card to an issue when moving it to In Progress, assign issue-backed cards to `oojjrs`, update status/notes while working, use real newlines in card/issue bodies instead of literal `\n`, and report if no board/card update was possible.
13. Stage/commit only the requested scope. Push only when explicitly requested.
14. Write feedback and documents in Korean; include relevant `git log` context when reporting work or choosing the next task.
