---
name: oojjrs-guideline-maintenance
description: Maintain shared oojjrs workflow guidance and public guideline documents. Use when editing common-work-guidelines.md, guideline-design-generation.review.md, guideline-readme-generation.review.md, unity-csharp-coding-convention.md, or deciding whether a reusable rule belongs in shared guidance, a project Design.html, a skill, or temporary memory.
---

# oojjrs Guideline Maintenance

Use this skill when a durable workflow rule or public guidance document must change.

## Routing

1. Put general repository work rules in `codex/common-work-guidelines.md`.
2. Put `Design.html` planning-document rules in `codex/guideline-design-generation.review.md`.
3. Put GitHub-facing README rules in `codex/guideline-readme-generation.review.md`.
4. Put Unity C# style rules in `codex/unity-csharp-coding-convention.md`.
5. Put executable or repeated task procedure in a skill when it is more than a short rule.
6. Do not preserve reusable workflow policy only in Codex memory. Memory may hold in-progress scratch or checkpoint state only.

## Editing Rules

1. Verify the current authoritative file directly before answering whether a rule exists.
2. Keep edits narrow to the requested rule or wording.
3. Preserve existing encoding and line endings exactly.
4. Do not add repo-local `AGENTS.md`, `HANDOFF.md`, or similar instruction files unless the user explicitly makes that repository an exception.
5. If the rule affects public skills, update the relevant `SKILL.md`, `agents/openai.yaml`, `codex/skills/index.md`, and `install.ps1`.

## Convention Document Sets

1. Treat every agent copy and public language page of a convention as one document set. Do not publish or report a convention change while any representation is missing the rule.
2. For Unity C# convention changes, update all applicable files in the same task:
   - `codex/unity-csharp-coding-convention.md`: concise agent copy containing every rule and decision criterion.
   - `kr/unity/csharp-coding-convention.html`: full Korean public page with the matching rule card and examples.
   - `en/unity/csharp-coding-convention.md`: full English public source with the matching rule and examples.
   - `unity/csharp-coding-convention.html`: redirect only; change it only when the route or default language changes.
3. Keep rule order, numbering, meaning, decision criteria, and correct/incorrect examples aligned across the document set. The agent copy may omit long examples, but it must not omit the rule or weaken its criteria.
4. Before commit or push, compare the rule inventory across every representation and verify that no rule exists in only part of the document set.

## Validation

Use static checks that match the edit:

```powershell
git diff --check -- <changed-files>
git diff -- <changed-files>
```

For a convention document set, also validate encoding and line endings for every changed representation, check HTML structure when applicable, and verify matching rule numbers and content across languages before publishing.

After publishing shared guideline changes, refresh or reinstall the user-global skill/guideline cache when applicable, then report whether GitHub Pages/raw content may lag.
