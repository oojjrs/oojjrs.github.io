---
name: oojjrs-skill-maintenance
description: Maintain public oojjrs Codex skill sources in codex/skills. Use when SKILL.md, agents/openai.yaml, install.ps1, or codex/skills/index.md is a primary deliverable, including related common-rule routing alignment. Do not also load $oojjrs-guideline-maintenance for that alignment; use guideline maintenance only when no skill source or routing artifact changes.
---

# oojjrs Skill Maintenance

Use this skill for public/shared skill work in `H:\oojjrs.github.io\codex\skills`.

## Workflow

1. Assume the router already loaded `$oojjrs-guidelines` from its canonical URL. Treat repository files as publication sources, never as an active common-rules override.
2. Prefer one narrowly triggered skill with one responsibility. Remove duplicated lifecycle or parent-domain instructions from child skills.
3. Prefix public skills with `oojjrs-`, use lowercase hyphen-case, and keep names under 64 characters.
4. Keep each affected skill aligned across `SKILL.md`, `agents/openai.yaml`, `codex/skills/index.md`, and `install.ps1` when registration or routing changes.
5. Use the system `skill-creator` initializer for a new skill. Do not add auxiliary README, changelog, or install notes inside a skill unless requested.
6. Preserve existing source encoding and line endings. New text files use UTF-8 without BOM and CRLF. Run the shared exact-file text-format checker before finishing.
7. Install only the changed skills after source validation so `C:\Users\oojjr\.codex\skills` matches the publication source byte-for-byte.
8. Validate every changed skill with `quick_validate.py`, parse PowerShell/YAML where applicable, and run `git diff --check`.

## Skill And Metadata Rules

Use only `name` and `description` in `SKILL.md` frontmatter. Put positive and negative trigger conditions in `description`, because the body is loaded only after triggering.

Keep bodies procedural and concise. A domain skill must own the subordinate rules it needs instead of instructing the router to load several overlapping domain skills.

In `agents/openai.yaml`, quote all strings and keep `display_name`, a 25-64 character `short_description`, and a one-sentence `default_prompt` consistent with the skill. The prompt must mention `$skill-name`.

## Installer Rules

- Add every default public skill to `$CanonicalSkills`.
- Add legacy aliases only for known old names or an explicit request.
- Use `$SkillFiles` only when a skill has files beyond `SKILL.md` and `agents/openai.yaml`.
- Preserve source bytes and verify the destination SHA-256 after every copy or download.
- Resolve one immutable remote Git commit per installer run; never mix files fetched from a moving branch.
- Report unexpected stale installed files instead of silently treating them as current manifest content.

## Finish Checks

Use a UTF-8 Python runtime with PyYAML; prefer an already working runtime rather than installing another copy solely for validation:

```powershell
python -c "import yaml"
python C:\Users\oojjr\.codex\skills\.system\skill-creator\scripts\quick_validate.py <skill-folder>
powershell -ExecutionPolicy Bypass -File .\codex\skills\install.ps1 -Skill <changed-skills> -SkipToolInstall
git diff --check -- <changed-files>
```
