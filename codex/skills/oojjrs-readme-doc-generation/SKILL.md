---
name: oojjrs-readme-doc-generation
description: Create or update GitHub-facing README and entry documentation for oojjrs repositories. Use when writing README.md, install instructions, project overview pages, sample usage, version notes, package entry docs, or public-facing repo documentation that should follow guideline-readme-generation.review.md.
---

# oojjrs README Doc Generation

Use this skill for GitHub-facing README and repository entry docs.

## Source Rules

1. Read `$oojjrs-guidelines`.
2. Read `codex/guideline-readme-generation.review.md` before editing `README.md`.
3. Use live code, package metadata, project files, and existing docs as the source of truth.
4. Do not invent install methods, package names, version numbers, or feature claims.
5. Keep public docs concise and practical; avoid marketing filler unless the user asks.

## Structure

Prefer:

- what the project/package is
- install or open instructions
- minimum usage example
- important constraints or platform notes
- sample/demo location when present
- version or release note only when it is user-facing and current

## Validation

Check links and code blocks where feasible. For package docs, verify `package.json`, manifest snippets, and root README version text agree.

Preserve existing encoding and line endings.
