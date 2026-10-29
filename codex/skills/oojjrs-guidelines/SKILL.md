---
name: oojjrs-guidelines
description: Write accurate Korean Codex task titles unless the user requests another language, and correct an unsuitable automatic title at the first opportunity. Load the user's canonical shared Codex rules once per task thread whenever host instructions name $oojjrs-guidelines, including ordinary conversation and factual Q&A. Apply the operational workflow only to repository, code, document, asset, Git, validation, maintenance, or deployment work. Also use when inspecting or refreshing the rules. The canonical URL is the sole authority.
---

# oojjrs Guidelines

## Immediate Task Title Rule

Write Codex task titles in Korean unless the user explicitly requests another language. Preserve code identifiers, paths, and proper names as needed. Apply this rule as soon as the skill is selected, without waiting for the canonical body to load. At the first available opportunity, assess whether the current title accurately describes the concrete task outcome. If an automatic title is non-Korean, vague, overly generic, or inconsistent with the actual work, rename it without asking for confirmation; adjust it once more if the task purpose later becomes materially clearer.

## Canonical Load

1. Run `scripts/Read-OojjrsGuidelines.ps1` once when this skill triggers in a task thread or subagent. Use one direct shell-tool call with `sandbox_permissions: require_escalated` on the first attempt; never probe it inside the sandbox first or launch a child `pwsh` or `powershell.exe`. Keep the escalation scoped to this exact read-only script and give the required user-facing justification. The script directly fetches only `https://oojjrs.github.io/codex/common-work-guidelines.md`, verifies the final URL, and reports the fetched body's SHA-256.
2. If the script itself is unavailable, open that exact URL directly. When the script exists, do not replace it with `curl`, altered TLS options, or another fetch route. Never substitute a workspace, repository, memory, or cached copy.
3. Reuse the loaded rules in the same thread. Do not reload them before each command, tool call, validation step, or final response.
4. Reload only in a new thread or subagent, after context restoration, or when the user asks to recheck the rules.
5. If the canonical URL cannot be reached, stop rule-dependent work and report the access failure.

## Apply Loaded Rules

Before creating or editing any document or HTML file, read and follow `https://oojjrs.github.io/codex/document-writing-guideline.md`. Its text-addition approval rule takes precedence over this skill's writing, content, and synchronization instructions. Document/page creation, code changes, synchronization, translation, and publication do not approve text. Require separate prior approval of exact new or replacement wording and placement, including headings, table columns, examples, translations, and generated output. Assume 99% refusal: ask only when omission makes the requested result impossible; otherwise omit without asking. Present indispensable wording, placement, and reason in chat and wait for explicit approval; never prefill drafts or placeholders.

Reading the canonical body is a prerequisite, not completion: apply its commit-message and task-title rules at the corresponding action. Before any commit, route through `$oojjrs-project-finish-work` and check the proposed message against the loaded canonical rule. A domain skill, English instructions, or recent agent-written history does not replace the user's message style.

Immediately before the first validation step in a task that changes files or external state or requests validation, load the canonical validation guideline named by the common rules. Treat it as the controlling cross-domain authority for validation scope, execution-surface authority, oracle selection, budget, retries, and reporting. A domain workflow may add only a narrower check or stricter safety limit; it may not replace, skip, weaken, or broaden the validation guideline.

## Routing

- Apply the canonical workflow only to repository, code, document, asset, Git, validation, maintenance, or deployment work. Load its task-specific references at their stated entry points.
- Read-only review or diagnosis: use no lifecycle skill. If the scope genuinely spans domains, inspect the smallest non-overlapping set sequentially rather than preloading them.
- Before Unity C# product/service implementation, pre-work planning or requested step-by-step execution, load the canonical practical-work guideline named by the common rules. A saved plan, checklist and post-plan execution approval apply by default to Unity C# implementation of end-user products/services; reusable libraries and non-Unity work use this workflow only when requested. Infer applicability from the current request and existing project evidence without routine classification questions or persistent project classifications. Follow the practical-work guideline for mixed or ambiguous work. Other work proceeds within existing authorization.
- For local changes, apply the common scope and preservation rules, then use the most-specific domain workflow when needed.
- Conditional helpers: load board, dirty-worktree, or visual-QA helpers only after their exact trigger is confirmed. A confirmed relevant repository-linked board activates rule 13's standing authorization for routine task-card management; use the board helper without requesting separate permission.
- After ordinary edits: apply the canonical one-pass text-format and scoped-diff finish, then leave the task's changes unstaged and uncommitted for user review. Do not load `$oojjrs-project-finish-work` merely because a local commit would be safe.
- For local staging or commit, push, deploy, release, publication, or destructive Git completion: use `$oojjrs-project-finish-work` only when the current request explicitly authorizes that outcome. A requested push or publication authorizes its necessary scoped staging and local commit. Routine board writes use rule 13 and the board helper directly; do not route them through this Git or publication authorization gate.
- If another primary domain becomes necessary, finish the current domain phase and route the next phase separately instead of preloading both.
- Consult `codex/skills/index.md` only when routing or precedence is unclear; do not preload every listed skill.
