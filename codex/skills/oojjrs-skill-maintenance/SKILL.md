---
name: oojjrs-skill-maintenance
description: Maintain public oojjrs Codex skill sources in codex/skills. Use when SKILL.md, agents/openai.yaml, install.ps1, or codex/skills/index.md is a primary deliverable, including related common-rule routing alignment. Do not also load $oojjrs-guideline-maintenance for that alignment; use guideline maintenance only when no skill source or routing artifact changes.
---

# oojjrs Skill Maintenance

Use this skill for public/shared skill work in `H:\oojjrs.github.io\codex\skills`.

## Workflow

1. Treat repository files as publication sources, not active common-rule overrides.
2. Keep one narrowly triggered responsibility per skill and remove inherited lifecycle or parent-domain repetition.
3. For a new skill, use the system `skill-creator` initializer; prefix its lowercase hyphen-case name with `oojjrs-` and keep it under 64 characters. Do not add auxiliary docs unless requested.
4. When registration or routing changes, align only the affected `SKILL.md`, `agents/openai.yaml`, `codex/skills/index.md`, and installer entries.
5. After the final edit, validate each changed skill directory once and parse only changed YAML or PowerShell files. Generic format and diff checks remain in the common workflow.
6. For authorized publication, push first and install only the changed skills from that immutable commit.

## Skill And Metadata Rules

- `SKILL.md` frontmatter contains only `name` and `description`; the description carries positive and negative triggers because routing precedes body loading.
- Keep bodies procedural and concise. A domain owns its subordinate rules instead of loading overlapping parents.
- In `agents/openai.yaml`, quote every string and keep `display_name`, a 25-64 character `short_description`, and one consistent `default_prompt` sentence that names `$skill-name`.

## Installer Rules

- Register every default skill in `$CanonicalSkills`; add aliases only for known legacy names or an explicit request.
- Use `$SkillFiles` only for files beyond `SKILL.md` and `agents/openai.yaml`.
- Preserve and verify source bytes, resolve one immutable remote commit per run, and report unexpected stale installed files.
- For publication, download the installer from the pushed commit, require its pinned source to match, and use `-SkipToolInstall` unless workstation tools are in scope.

## Scoped Validation And Publication

Use an existing UTF-8 Python runtime with PyYAML. Run only matching checks:

```powershell
python C:\Users\oojjr\.codex\skills\.system\skill-creator\scripts\quick_validate.py <skill-folder>
python -c "import pathlib,sys,yaml; [yaml.safe_load(pathlib.Path(p).read_text(encoding='utf-8-sig')) for p in sys.argv[1:]]" <changed-yaml-files>
```

Parse changed PowerShell files with `System.Management.Automation.Language.Parser.ParseFile`.

After an authorized push, download `codex/skills/install.ps1` from that commit and run it once for the changed skills with `-SkipToolInstall`; confirm the reported pinned source matches.
