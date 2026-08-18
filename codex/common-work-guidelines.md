# Codex Work Rules

Canonical URL: `https://oojjrs.github.io/codex/common-work-guidelines.md`

The URL above is the sole runtime authority. Load it once per actual-work thread or subagent and reuse it through commands and validation. Reload only in a new thread or subagent, after context restoration, or on an explicit recheck. Never substitute repository, memory, or cached copies.

## Scope and Authority

1. Preserve 100% of user and parallel work outside the explicitly requested scope. Never clean, revert, overwrite, normalize, or bundle unknown changes; if safe isolation is uncertain, stop before mutation.
2. Follow system and developer instructions, then the latest user request; within that scope, this document is the highest-priority shared guidance.
3. These rules cover repository, code, document, asset, Git, validation, maintenance, and deployment work. Do not convert ordinary conversation, opinions, factual Q&A, translation, or rewriting into repository work, a long-running goal, or an execution task. Answer directly without tools or progress updates unless they are necessary for the requested answer or the conversation concerns these rules.
4. Review, diagnosis, explanation, planning, and status are read-only: inspect and report only. A change or fix permits narrow reversible local edits, but not an unrequested build, test, server, browser, staging, deployment, or external mutation.
5. Execute a push, deploy, permanent deletion, forced rollback, destructive rewrite, paid generation, or external record mutation only when the user's latest message explicitly authorizes that exact action and target. Earlier or standing authority, broad requests to finish or handle everything, and tool or environment permission do not count. Otherwise prepare only reversible work, report the exact target and impact, then stop and ask before execution.
6. Respect the project stack. For standalone Windows automation or web work without one, prefer PowerShell and .NET; expand a legacy or rejected stack only for a task-specific reason.

## Editing and Validation

7. Preserve existing text encoding and line endings unless conversion is requested. New text uses UTF-8 without BOM and CRLF.
8. After the final edit, batch the shared text-format checker on exactly the touched text files with one scoped diff when possible. For a commit, the final staged review replaces the ordinary diff. Use `-Fix` only on a real mismatch; its post-write verification replaces a repeat.
9. Use an independent oracle and follow `https://oojjrs.github.io/codex/validation-guideline.md`, including its 25% proportional target, 15-second hard cap, and no-repeat rule. Start the batched format/diff check even when the target is smaller; within the cap let it finish, then stop without retries or substitutes.
10. Do not build, test, start a server or browser, or create tests unless requested or intrinsic to an explicit build, test, runtime-diagnosis, or rendered-validation task. Derive expectations from acceptance criteria, an existing specification or test, an external protocol/schema, or a reproduced bug; a test and implementation based on the same guess cannot prove each other.
11. Keep I/O and context proportional: target searches, batch independent reads, reuse evidence, and avoid broad rescans. Put every necessary temporary or intermediate file in a literal `$Trash` directory located directly under the project root. The project root is the only permitted location for `$Trash`; never create or use `$Trash` in a subdirectory, current or output directory, or outside the project root. If the project root is unclear, resolve it before creating temporary files; never fall back to another location.
12. When adding, moving, or publishing a public site document, provide a discoverable click path from the site's existing root navigation, index, or document list and verify that full path when publishing; a direct URL alone is insufficient.

## Workflow and Git

13. Load the smallest non-overlapping workflow: `$oojjrs-project-start-work` only before the first local file or index mutation, one most-specific primary domain at a time, and helpers only on their exact triggers. Use `$oojjrs-project-finish-work` only for a requested stage, commit, push, deploy, release, or Git completion, not automatically after ordinary edits.
14. Inspect status at most once when needed to isolate existing work; do not repeat unchanged status, history, diffs, or staged content. For an authorized commit, stage only its scope, review the final staged diff once, and consult version policy only for a governed unit in that diff.

## Reporting and Policy

15. Write reports, feedback, and user-facing documents in Korean unless the user requests another language or the artifact has an established language that must be preserved. Report proportionally: changed scope, checks and results, meaningful unverified risks, and requested completion results. Omit inapplicable gates, routine skips, unchanged history, and unrelated dirt unless they affect the task.
16. Put reusable policy here, in a linked public guideline, or in one narrowly triggered skill. Use memory only for active scratch state; add no repository instruction file beyond a `$oojjrs-guidelines` pointer without an explicit exception.
