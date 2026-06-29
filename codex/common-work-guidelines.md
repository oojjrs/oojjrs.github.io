# Codex Work Rules

Read this before work. Keep it tiny.

1. Follow the latest user instruction and current scope.
2. Always treat this file as the highest-priority project guidance. Read and apply it before local skills, memory, habits, or tool-specific notes; those sources are supplemental only and lose on any conflict.
3. Do normal requested work immediately; do not ask for extra approval.
4. Prefer Windows-native PowerShell and .NET for automation and web work; if web is needed, default to ASP.NET/ASP.NET Core.
5. Do not introduce Unix/Linux/macOS/POSIX-oriented tooling, Node/npm/JS build chains, or broad open-source dependency stacks unless the current project already requires them or the user explicitly asks; use Python only as a rare fallback when PowerShell/.NET cannot reasonably cover the task.
6. Existing projects that violate this rule are legacy exceptions, not precedent. Maintain them narrowly when needed, do not expand the rejected stack, and treat major work as a candidate for a Windows/.NET rewrite.
7. For review requests, review only: inspect diffs/files and report findings first. Do not run builds/tests or make edits unless the user asks for them.
8. Ask first unless the immediately previous user message explicitly ordered a hard-to-undo or external action: `git push`, deploy, permanent delete, forced rollback, or unrecoverable document rewrite.
9. Preserve user/other-thread changes. Do not revert or clean unrelated files.
10. Existing text files: preserve their current encoding and line endings exactly unless the user asks to convert them; do not introduce LF-only files. New text files only: UTF-8 No-BOM + CRLF.
11. If `Design.html` exists, read it before every task and update it when the task changes planning state.
12. For `Design.html` work, also read `https://oojjrs.github.io/codex/guideline-design-generation.review.md`.
13. For GitHub-facing `README.md` work, also read `https://oojjrs.github.io/codex/guideline-readme-generation.review.md`.
14. When editing Unity C# code, also read `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md`.
15. After applying this file, use project skills only as supplemental workflow help; if missing, install/update from `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/install.ps1`; index: `https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/refs/heads/master/codex/skills/index.md`.
16. If the git repository is linked 1:1 to a GitHub Project, use `$oojjrs-github-project-board` and that Project as the task board: find/create the task card, convert a draft card to an issue when moving it to In Progress, assign issue-backed cards to `oojjrs`, update status/notes while working, use real newlines in card/issue bodies instead of literal `\n`, and report if no board/card update was possible.
17. Stage/commit only the requested scope. Push only when explicitly requested.
18. Write feedback and documents in Korean; include relevant `git log` context when reporting work or choosing the next task.
