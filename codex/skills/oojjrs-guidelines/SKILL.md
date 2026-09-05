---
name: oojjrs-guidelines
description: Load the user's canonical shared Codex rules once per task thread whenever host instructions name $oojjrs-guidelines, including ordinary conversation and factual Q&A. Apply its operational workflow only to repository, code, document, asset, Git, validation, maintenance, or deployment work. Also use when inspecting or refreshing the rules. The canonical URL is the sole authority.
---

# oojjrs Guidelines

## Canonical Load

1. Run `scripts/Read-OojjrsGuidelines.ps1` once when this skill triggers in a task thread or subagent. It directly fetches only `https://oojjrs.github.io/codex/common-work-guidelines.md`, verifies the final URL, and reports the fetched body's SHA-256.
2. If the script itself is unavailable, open that exact URL directly. Never substitute a workspace, repository, memory, or cached copy.
3. Reuse the loaded rules in the same thread. Do not reload them before each command, tool call, validation step, or final response.
4. Reload only in a new thread or subagent, after context restoration, or when the user asks to recheck the rules.
5. If the canonical URL cannot be reached, stop rule-dependent work and report the access failure.

## Routing

- Apply the canonical workflow only to repository, code, document, asset, Git, validation, maintenance, or deployment work. Load its task-specific references at their stated entry points.
- Read-only review or diagnosis: use no lifecycle skill. If the scope genuinely spans domains, inspect the smallest non-overlapping set sequentially rather than preloading them.
- Local file, index, or commit mutation: use `$oojjrs-project-start-work` immediately before the first mutation, then one most-specific primary domain at a time.
- Conditional helpers: load board, dirty-worktree, or visual-QA helpers only after their exact trigger is confirmed.
- After ordinary edits: apply the canonical one-pass text-format and scoped-diff finish, then leave the task's changes unstaged and uncommitted for user review. Do not load `$oojjrs-project-finish-work` merely because a local commit would be safe.
- For local staging or commit, push, deploy, release, publication, destructive Git completion, or another external state transition: use `$oojjrs-project-finish-work` only when the current request explicitly authorizes the Git or external outcome. A requested push or publication authorizes its necessary scoped staging and local commit.
- If another primary domain becomes necessary, finish the current domain phase and route the next phase separately instead of preloading both.
- Consult `codex/skills/index.md` only when routing or precedence is unclear; do not preload every listed skill.
