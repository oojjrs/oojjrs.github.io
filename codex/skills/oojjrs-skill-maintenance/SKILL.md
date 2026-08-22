---
name: oojjrs-skill-maintenance
description: Maintain public oojjrs Codex skill sources in codex/skills. Use when SKILL.md, agents/openai.yaml, install.ps1, or codex/skills/index.md changes, including directly related common-rule routing alignment. Do not load $oojjrs-guideline-maintenance for the same alignment phase; an independent public-guidance semantic change may run as a separate phase.
---

# oojjrs Skill Maintenance

Use this skill for public/shared skill work in `H:\oojjrs.github.io\codex\skills`.

## Workflow

1. Assume the router already loaded `$oojjrs-guidelines` from its canonical URL. Treat repository files as publication sources, never as an active common-rules override.
2. Prefer one narrowly triggered skill with one responsibility. Remove duplicated lifecycle or parent-domain instructions from child skills.
3. Prefix public skills with `oojjrs-`, use lowercase hyphen-case, and keep names under 64 characters.
4. Keep each affected skill aligned across `SKILL.md`, `agents/openai.yaml`, `codex/skills/index.md`, and `install.ps1` when registration or routing changes.
5. Use the system `skill-creator` initializer for a new skill. Do not add auxiliary README, changelog, or install notes inside a skill unless requested.
6. Preserve existing source encoding and line endings. New text files use UTF-8 without BOM and CRLF.
7. Leave generic text-format and Git diff checks to the canonical common rules. Do not duplicate or expand those checks in this domain skill.
8. After the final edit, validate each changed skill directory once with `quick_validate.py`, and parse only changed YAML and PowerShell files. Do not rerun a successful check against unchanged input.
9. When public deployment is authorized, push the completed commit first, then install only the changed skills once from that immutable remote commit. Do not install unpublished working-tree bytes.

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
- For public deployment, download the installer from the pushed commit and require its pinned source commit to match that commit. Use `-SkipToolInstall` unless optional workstation tools are explicitly in scope.
- Report unexpected stale installed files instead of silently treating them as current manifest content.

## Scoped Validation And Publication

Use an existing UTF-8 Python runtime with PyYAML. Run only the checks that match changed artifacts:

```powershell
python C:\Users\oojjr\.codex\skills\.system\skill-creator\scripts\quick_validate.py <skill-folder>
python -c "import pathlib,sys,yaml; [yaml.safe_load(pathlib.Path(p).read_text(encoding='utf-8-sig')) for p in sys.argv[1:]]" <changed-yaml-files>
```

Parse changed PowerShell files with `System.Management.Automation.Language.Parser.ParseFile`. Generic format and diff gates remain owned by the common workflow.

For an authorized publication, derive the pushed commit SHA, download `codex/skills/install.ps1` from that commit, and run it once for the changed skills with `-SkipToolInstall`. Confirm the installer's reported pinned source is the same pushed commit.
