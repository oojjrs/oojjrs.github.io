---
name: oojjrs-guideline-maintenance
description: Maintain shared oojjrs workflow guidance and public guideline documents when the current phase changes no SKILL.md, agents/openai.yaml, skill index, or installer artifact. Use for common-work-guidelines.md, Design.html or README guidance, logging or semantic naming guidance, and rule-placement decisions. If the same alignment also changes a skill artifact, $oojjrs-skill-maintenance owns that phase. Unity C# convention sets use $oojjrs-unity-csharp-convention-maintenance.
---

# oojjrs Guideline Maintenance

Before creating or editing any document or HTML file, read and follow `https://oojjrs.github.io/codex/document-writing-guideline.md`. Its text-addition approval rule takes precedence over this skill's writing, content, and synchronization instructions. Document/page creation, code changes, synchronization, translation, and publication do not approve text. Require separate prior approval of exact new or replacement wording and placement, including headings, table columns, examples, translations, and generated output. Assume 99% refusal: ask only when omission makes the requested result impossible; otherwise omit without asking. Present indispensable wording, placement, and reason in chat and wait for explicit approval; never prefill drafts or placeholders.

Use this skill when durable public guidance must change.

## Authority And Publication

- The active common-rules authority is `https://oojjrs.github.io/codex/common-work-guidelines.md`.
- `codex/common-work-guidelines.md` in this repository is its publication source, not a runtime override.
- Before claiming what the active common rules say, read the canonical URL. Before editing, inspect the exact publication source and any existing changes to that target.
- When publication is requested, do not claim the active page changed until the source is committed, pushed, and published.

## Placement

1. Keep only short, stable, cross-domain rules in `codex/common-work-guidelines.md`.
2. Put Design planning-document rules in `codex/guideline-design-generation.review.md`.
3. Put GitHub-facing README rules in `codex/guideline-readme-generation.review.md`.
4. Put semantic naming and logging rules in their focused public documents.
5. Reroute multilingual Unity C# convention-set work to `$oojjrs-unity-csharp-convention-maintenance`; do not load both domains.
6. Put executable or repeated procedure in a narrowly triggered skill. Keep temporary decisions in task state rather than durable guidance.

## Editing And Validation

1. Keep the change narrow and remove superseded or duplicated wording rather than layering another exception on top.
2. Validate only changed guidance semantics and affected references against independent source material.
3. If guidance alignment requires a public skill artifact change, finish the independent guidance phase and route the aligned skill phase to `$oojjrs-skill-maintenance`; do not load both for the same phase.
4. When adding, moving, or publishing a public document, preserve or update its site-root navigation only within separately approved exact link labels and placement, and verify changed navigation when deployment is in scope. Discoverability does not authorize a new heading, description, or link label.
5. Parse only changed structured content and resolve only changed links. Do not add a second generic format, diff, build, or test pass in this domain.

After a requested publication, compare only the changed canonical body or page with the intended source and report a mismatch or material GitHub Pages/raw-content delay.
