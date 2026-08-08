---
name: oojjrs-guideline-maintenance
description: Maintain shared oojjrs workflow guidance and public guideline documents when public guidance itself is the primary deliverable. Use for common-work-guidelines.md, Design.html or README guidance, logging or semantic naming guidance, and rule-placement decisions. If the task primarily changes SKILL.md, agents/openai.yaml, the skill index, or the installer, use $oojjrs-skill-maintenance instead. Unity C# convention sets use $oojjrs-unity-csharp-convention-maintenance.
---

# oojjrs Guideline Maintenance

Use this skill when durable public guidance must change.

## Authority And Publication

- The active common-rules authority is `https://oojjrs.github.io/codex/common-work-guidelines.md`.
- `codex/common-work-guidelines.md` in this repository is its publication source, not a runtime override.
- Before claiming what the active common rules say, read the canonical URL. Before editing, inspect the publication source and its diff.
- Until a change is committed, pushed, and published, report that the canonical URL still serves the previous body.

## Placement

1. Keep only short, stable, cross-domain rules in `codex/common-work-guidelines.md`.
2. Put Design planning-document rules in `codex/guideline-design-generation.review.md`.
3. Put GitHub-facing README rules in `codex/guideline-readme-generation.review.md`.
4. Put semantic naming and logging rules in their focused public documents.
5. Reroute multilingual Unity C# convention-set work to `$oojjrs-unity-csharp-convention-maintenance`; do not load both domains.
6. Put executable or repeated procedure in a narrowly triggered skill. Keep temporary decisions in task state rather than durable guidance.

## Editing And Validation

1. Keep the change narrow and remove superseded or duplicated wording rather than layering another exception on top.
2. Preserve existing encoding and line endings; validate exact touched files with the shared text-format checker and inspect the ordinary diff.
3. When guidance changes public skills, keep the affected `SKILL.md`, `agents/openai.yaml`, routing index, and installer aligned.
4. When adding, moving, or publishing a public document, add a discoverable site-root navigation path and verify it when deployment is in scope.
5. Run targeted structure/link checks and `git diff --check -- <changed-files>`.

After publication, compare the canonical body or page with the intended source and report any GitHub Pages/raw-content delay.
