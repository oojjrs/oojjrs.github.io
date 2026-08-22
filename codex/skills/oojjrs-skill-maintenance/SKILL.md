---
name: oojjrs-skill-maintenance
description: Maintain and synchronize every user-authored oojjrs-* Codex skill through GitHub. Use whenever one is created, changed, routed, published, installed, refreshed, or synchronized; a refresh always updates the complete set, and every skill must remain automatically discoverable for matching tasks.
---

# oojjrs Skill Maintenance

Maintain the GitHub repository's `codex/skills` tree as the source of truth for the user's shared Codex skills.

## Requirements

1. Prefix every user-authored skill with `oojjrs-` so its ownership is clear from the name.
2. Keep every user-authored skill and every file it needs in the GitHub-backed canonical installer set so a clean Codex machine can reproduce the complete skill environment.
3. Give every skill a precise frontmatter `description`, keep implicit invocation enabled, and use the most-specific available skill whenever a task matches it.
4. Treat every install, update, refresh, or synchronization request as a full-set operation. Synchronize every canonical `oojjrs-*` skill from one immutable GitHub commit with no per-skill or changed-only exceptions, no unpublished workspace substitution, and no managed stale files left behind.
5. When publication is authorized, push the completed sources first and then run the full installer from that pushed commit. Report full synchronization only after the complete managed set is present and verified.
