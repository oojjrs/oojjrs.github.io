---
name: oojjrs-guideline-maintenance
description: Maintain shared oojjrs workflow guidance and public guideline documents when public guidance itself is the primary deliverable. Use for common-work-guidelines.md, Design.html or README guidance, logging or semantic naming guidance, and rule-placement decisions. If the task primarily changes SKILL.md, agents/openai.yaml, the skill index, or the installer, use $oojjrs-skill-maintenance instead. Unity C# convention sets use $oojjrs-unity-csharp-convention-maintenance.
---

# oojjrs Guideline Maintenance

Maintain durable public guidance. Reuse the canonical common rules already loaded for this thread.

## Authority And Publication

- `https://oojjrs.github.io/codex/common-work-guidelines.md` is the active authority; the repository copy is only its publication source. Inspect the exact target before editing.
- Claim an active-page change only after commit, push, and publication. Then compare the changed deployed body with its source and report mismatches or material delay.

## Placement

1. Keep only short, stable, cross-domain rules in `codex/common-work-guidelines.md`.
2. Keep Design, README, semantic naming, and logging rules in their focused public documents.
3. Route Unity C# convention-set work to `$oojjrs-unity-csharp-convention-maintenance` instead of loading both domains.
4. Put repeated procedure in a narrowly triggered skill and temporary decisions in task state.

## Editing And Validation

1. Remove superseded or duplicate wording instead of layering exceptions.
2. If `SKILL.md`, `agents/openai.yaml`, the skill index, or installer must change, finish this phase and switch to `$oojjrs-skill-maintenance`.
3. Give new or moved public documents a discoverable site-root path and verify it when publishing.
4. Validate only changed semantics, affected references, structured content, and links against independent sources; add no second generic finish pass.
