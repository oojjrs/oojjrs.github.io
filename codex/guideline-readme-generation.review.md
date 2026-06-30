# GitHub README.md Rules

Read this only for GitHub-facing `README.md` creation, review, cleanup, or update. Keep it tiny.

1. Write a `README.md` only when the repository needs a public-style entry point.
2. Keep it short. No filler, long introductions, marketing copy, or copied chat/planning text.
3. Every project must run with F5 without separate environment setup; do not add long setup sections to explain around that rule.
4. First run or use instructions should be one compact block: open solution/project, press F5, or the shortest package/reference step that applies.
5. For libraries, prefer a compact components table over prose. Suggested columns: Component, Kind, Purpose.
6. Include only what helps a first visitor judge or use the repository: name, one-line purpose, status/scope, components, minimal usage, and links.
7. Keep internal workflow, task queues, GitHub Project notes, agent rules, release chores, and design debates out of README.
8. Link deeper docs such as `Documentation~/`, `CHANGELOG.md`, API docs, or examples instead of duplicating them.
9. Preserve the existing README language, encoding, and line endings unless the user asks to convert them. Verify before and after editing; do not normalize to CRLF unless the file already used CRLF or the user asks.
