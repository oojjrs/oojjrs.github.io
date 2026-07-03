---
name: oojjrs-skill-maintenance
description: Maintain public oojjrs Codex skill sources in codex/skills. Use when creating, updating, publishing, installing, validating, or repairing shared oojjrs-* skills, their SKILL.md files, agents/openai.yaml metadata, install.ps1 registration, and codex/skills/index.md entries.
---

# oojjrs Skill Maintenance

Use this skill for public/shared skill work in `H:\oojjrs.github.io\codex\skills`.

## Workflow

1. Load `$oojjrs-guidelines` first and treat `codex/common-work-guidelines.md` as the durable source.
2. Keep public skill names prefixed with `oojjrs-`; use lowercase hyphen-case and keep names under 64 characters.
3. Keep every public skill aligned:
   - `codex/skills/<skill>/SKILL.md`
   - `codex/skills/<skill>/agents/openai.yaml`
   - `codex/skills/index.md`
   - `codex/skills/install.ps1`
4. Preserve source encoding and line endings for existing files. New text files should be UTF-8 No-BOM with CRLF.
5. Do not create auxiliary docs such as README, changelog, or install notes inside a skill folder unless the user explicitly asks.
6. Install/update the skill after source edits so `C:\Users\oojjr\.codex\skills` matches the public source.
7. Validate with the skill-creator `quick_validate.py` script when available, then check `git diff --check`.
8. `quick_validate.py` requires PyYAML (`import yaml`). If it is missing in the Python used for validation, install or repair `PyYAML` once and rerun the validation instead of skipping it.

## SKILL.md Rules

Use only `name` and `description` in frontmatter. Put trigger conditions in `description`, because the body is loaded only after the skill triggers.

Keep the body procedural and concise. Include only information that another Codex instance would not reliably infer from general knowledge.

## agents/openai.yaml Rules

Read the skill and keep `display_name`, `short_description`, and `default_prompt` consistent with it.

The `default_prompt` must mention the skill as `$skill-name`. Quote all strings.

## install.ps1 Rules

Add every default-install public skill to `$CanonicalSkills`. Add a legacy alias only when a known older unprefixed skill name already existed or the user explicitly wants that alias.

Use `$SkillFiles` only for skills with files beyond the default `SKILL.md` and `agents/openai.yaml`.

## Finish Checks

Run these checks before commit:

```powershell
git diff --check
python -c "import yaml"
python C:\Users\oojjr\.codex\skills\.system\skill-creator\scripts\quick_validate.py <skill-folder>
powershell -ExecutionPolicy Bypass -File .\codex\skills\install.ps1 -SkipToolInstall
```
