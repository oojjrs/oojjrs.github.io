---
name: oojjrs-design-html-builder
description: Build, rebuild, recover, or substantially update project Design.html planning documents for oojjrs projects. Use for image-heavy planning docs, Mines/MunpaWeb/Rebellion style conversions, PDF/git-history recovery, left-nav layouts, lightbox/image inventories, filename labels, visible metadata cleanup, and live asset synchronization.
---

# oojjrs Design.html Builder

Use this skill for substantive `Design.html` creation or rebuild work. It supplements `$oojjrs-project-design-document-router`.

## Required Reads

1. Read `$oojjrs-guidelines`.
2. Read `codex/guideline-design-generation.review.md`.
3. Read the current `Design.html` if it exists.
4. When a referenced model document is named, inspect that live document instead of relying on memory.

## Source Priority

Use this order:

1. live code, assets, prefabs, package metadata, and current project files
2. existing `Design.html`
3. git history for missing or accidentally removed planning content
4. original PDFs or source docs when rebuilding
5. memory only as a clue for where to look

## Document Shape

Favor:

- fixed or persistent left navigation when the existing style uses it
- image-forward sections with inspectable previews
- filename labels directly under image previews when asset identity matters
- collapsible sections for dense inventories
- minimal prose around visual inventories
- no visible file paths, byte counts, validation logs, or implementation audit metadata unless requested

## Validation

Check:

- image references exist
- duplicate IDs and broken anchors
- intended collapsed/open section state
- UTF-8 No-BOM and original line endings
- `git diff --check -- Design.html`

If browser validation is blocked, use static checks and say so.
