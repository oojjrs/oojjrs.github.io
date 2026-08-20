# Codex Work Rules

Canonical URL: `https://oojjrs.github.io/codex/common-work-guidelines.md`

The URL above is the sole runtime authority. Load it once per actual-work thread or subagent and reuse it through commands and validation. Reload only in a new thread or subagent, after context restoration, or on an explicit recheck. Never substitute repository, memory, habits, tool-specific notes, or cached copies.

## Scope and Authority

1. Follow system and developer instructions, then the latest user request; within that scope, this document is the highest-priority shared guidance.
2. Preserve 100% of user and parallel work outside the explicitly requested scope. Never clean, revert, overwrite, normalize, move, delete, stage, or bundle unknown changes; if safe isolation is uncertain, stop before mutation.
3. These rules cover repository, code, document, asset, Git, validation, maintenance, and deployment work. Do not convert ordinary conversation, opinions, factual Q&A, translation, or rewriting into repository work, a long-running goal, or an execution task. Answer directly without tools or progress updates unless they are necessary for the requested answer or the conversation concerns these rules.
4. Review, diagnosis, explanation, planning, and status requests are read-only: inspect and report only. A change or fix permits narrow reversible local edits, but not an unrequested build, test, server, browser, staging, commit, deployment, or external mutation.
5. Perform normal reversible work authorized by the request without asking for redundant approval. Stop only for a missing decision that materially changes the result, an unsafe overlap, or an action requiring separate authority below.
6. Execute a push, deploy, permanent deletion, forced rollback, destructive rewrite, paid generation, or external record mutation only when the user's latest message explicitly authorizes that exact action and target. Earlier or standing authority, broad requests to finish or handle everything, and tool or environment permission do not count. Otherwise prepare only reversible work, report the exact target and impact, then stop and ask before execution.
7. Stage and commit only the explicitly requested scope and only when the current request authorizes that operation. Push only under rule 6.

## Stack and Sources

8. Respect the established project stack. For standalone Windows automation or web work without one, prefer PowerShell and .NET, and default new web work to ASP.NET or ASP.NET Core. Do not introduce Unix-, Linux-, macOS-, or POSIX-oriented tooling, a Node/npm/JavaScript build chain, broad open-source dependency stacks, or Python when the project does not already require them unless the user requests it or a task-specific limitation makes the preferred stack unreasonable. Treat legacy exceptions as maintenance constraints, not precedent for expansion.
9. Derive behavior and claims from live code, assets, package metadata, existing specifications or tests, external protocols or schemas, reproduced bugs with known results, and the latest user decision. Do not invent a convention, requirement, install method, version, feature claim, or expected result when those sources do not establish one; ask with a short candidate list when the missing choice changes the result.

## Editing, Temporary Files, and Assets

10. Preserve each existing text file's encoding and line endings exactly unless conversion is requested. Treat a CRLF check as matching the original, not forcing CRLF. New text files use UTF-8 without BOM and CRLF.
11. After the final edit, batch the shared text-format checker on exactly the touched text files with one scoped diff when possible. For a commit, the final staged review replaces the ordinary diff. Use `-Fix` only after a real mismatch; its post-write verification replaces a repeat. Mixed-line-ending originals require manual review and must never be auto-normalized.
12. Keep I/O and context proportional: target searches, batch independent reads, reuse evidence, and avoid broad rescans or needless artifacts. Put every necessary temporary or intermediate file, including generated candidates and post-processing outputs, in a literal `$Trash` directory directly under the project root. Never create or use ad-hoc `tmp`, `temp`, or `scratch` folders or a `$Trash` elsewhere. Resolve the project root first; if it is unclear or blocked, stop instead of falling back to another location.
13. Before creating a Unity UI asset or recommending its size, inspect the target project's actual Canvas size and applicable `Canvas Scaler` reference resolution. Evaluate the intended placement at that scale and base dimensions on those values; if they cannot be verified, ask instead of assuming FHD, QHD, or 4K.

## Planning and Public Documents

14. When adding, moving, or publishing a public site document, provide a discoverable click path from the site's existing root navigation, index, or document list and verify the full rendered or deployed path when publishing; a direct URL or successful destination response alone is insufficient.
15. Write reports, feedback, and user-facing documents in Korean unless the user requests another language or the artifact has an established language that must be preserved.

## Validation

16. Validation must be proportional, non-duplicative, and backed by an independent oracle. Follow `https://oojjrs.github.io/codex/validation-guideline.md`, including its 25% proportional target, 15-second agent-controlled hard cap, and no-repeat rule. Start the required batched format and scoped-diff check even when the target is smaller; within the cap let an already-started check finish, then stop without retries or substitute checks.
17. Do not build, test, start a server or browser, or create tests unless the user requested that activity or it is intrinsic to an explicit build, test, runtime-diagnosis, or rendered-validation task. A test and implementation derived from the same guess cannot prove each other.

## Workflow, Skills, and Git

18. Load the smallest non-overlapping workflow: `$oojjrs-project-start-work` only immediately before the first authorized local file or Git-index mutation, one most-specific primary domain at a time, and helpers only on their exact triggers. Use `$oojjrs-project-finish-work` only for a requested stage, commit, push, deploy, release, or Git completion, not automatically after ordinary edits or as a task-start preload.
19. Use `$oojjrs-github-project-board` only when board work is requested or a cheap probe confirms a relevant 1:1-linked board that this task must update. Use `$oojjrs-dirty-worktree-scope-split` only for overlapping hunks or genuinely ambiguous isolation, not merely because the tree is dirty.
20. Inspect repository status at most once when needed to isolate existing work; do not repeat unchanged status, history, diffs, or staged content. For an authorized commit, stage exact paths, review the final `git diff --cached --name-status`, staged diff, and `git diff --cached --check` once, and reuse that review while staged bytes remain unchanged.

## Specialized Safety and Policy

21. Put reusable policy in this canonical document, a linked public guideline, or one narrowly triggered skill. Treat memory only as active scratch or a clue for where to inspect; never use it as durable authority. If reusable workflow guidance exists only in memory, ignore it as authority and move it to an approved durable source before relying on it.
22. Do not add repository-local `AGENTS.md`, `HANDOFF.md`, or similar instruction files beyond a pointer to `$oojjrs-guidelines` unless the user explicitly grants an exception.
23. Report proportionally: changed scope, checks and results, meaningful unverified risks, and requested commit, push, deploy, or publication results. Include relevant Git history only when it affects the decision or the user requests it. Omit inapplicable gates, routine skips, unchanged history, and unrelated dirt unless they affect the task.
