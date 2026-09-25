---
name: oojjrs-skill-maintenance
description: Maintain and synchronize user-authored oojjrs-* Codex skills through GitHub, including active installation sources and intentionally disabled preserved sources. Use whenever one is created, changed, enabled, disabled, routed, published, installed, refreshed, or synchronized; every refresh checks the complete active set but transfers only changed or missing files.
---

# oojjrs Skill Maintenance

Maintain the GitHub repository's `codex/skills` tree as the source of truth for the user's shared Codex skills.

For authorized commits and publication, use `$oojjrs-project-finish-work`, including its pre-commit check against the canonical commit-message rule. Skill maintenance does not define a separate message language or template.

## Requirements

1. Prefix every user-authored skill with `oojjrs-` so its ownership is clear from the name.
2. Keep every active user-authored skill and every file it needs under `codex/skills` so a clean Codex machine can reproduce the complete active skill environment.
3. Keep an intentionally disabled skill intact under `codex/skills-disabled`. Exclude it from active routing, installation, and automatic discovery; retain its complete files so it can be explicitly reactivated later.
4. Give every active skill a precise frontmatter `description`, keep implicit invocation enabled, and use the most-specific available skill whenever a task matches it.
5. On every install, update, refresh, or synchronization, check every active official `oojjrs-*` skill and all of its files from one immutable GitHub commit. Transfer and write only missing or changed files, leave byte-identical files untouched, remove installed skills disabled or deleted upstream, and never substitute a partial selection or unpublished workspace copy for the complete-set check.
6. When disabling or reactivating a skill, move its entire directory between `codex/skills` and `codex/skills-disabled`, update routing and catalogs in the same change, and never keep duplicate active and disabled copies.
7. When publication is authorized, push the completed sources first and then run the full installer from that pushed commit. Report full synchronization only after the complete active managed set is present and verified.
