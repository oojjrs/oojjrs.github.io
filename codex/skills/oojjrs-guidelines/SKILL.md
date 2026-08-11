---
name: oojjrs-guidelines
description: Load the user's canonical shared Codex work rules for actual repository, code, document, asset, Git, validation, maintenance, or deployment work. Use once per task thread or subagent when host instructions request $oojjrs-guidelines, and when inspecting or refreshing the canonical rules. Do not use for ordinary conversation, factual Q&A, translation, or rewriting. The canonical URL is the sole authority; workspace and cached copies are never runtime substitutes.
---

# oojjrs Guidelines

## Canonical Load

1. Run `scripts/Read-OojjrsGuidelines.ps1` once at the start of an actual-work thread or subagent. It directly fetches only `https://oojjrs.github.io/codex/common-work-guidelines.md`, verifies the final URL, and reports the fetched body's SHA-256.
2. If the script itself is unavailable, open that exact URL directly. Never substitute a workspace, repository, memory, or cached copy.
3. Reuse the loaded rules in the same thread. Do not reload them before each command, tool call, validation step, or final response.
4. Reload only in a new thread or subagent, after context restoration, or when the user asks to recheck the rules.
5. If the canonical URL cannot be reached, stop rule-dependent work and report the access failure.

## Routing

- Read-only review or diagnosis: use no lifecycle skill. If the scope genuinely spans domains, inspect the smallest non-overlapping set sequentially rather than preloading them.
- Local file, index, or commit mutation: use `$oojjrs-project-start-work` immediately before the first mutation, then one most-specific primary domain at a time.
- Conditional helpers: load board, dirty-worktree, or visual-QA helpers only after their exact trigger is confirmed.
- After ordinary edits: apply the canonical one-pass text-format and scoped-diff finish without another lifecycle skill.
- For an explicitly requested stage, commit, push, deploy, release, or Git completion of an existing diff/commit: use `$oojjrs-project-finish-work`.
- If another primary domain becomes necessary, finish the current domain phase and route the next phase separately instead of preloading both.
- Consult `codex/skills/index.md` only when routing or precedence is unclear; do not preload every listed skill.
