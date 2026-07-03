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

## Validation

Use static checks that match the edit:

```powershell
git diff --check -- <changed-files>
git diff -- <changed-files>
```

After publishing shared guideline changes, refresh or reinstall the user-global skill/guideline cache when applicable, then report whether GitHub Pages/raw content may lag.
