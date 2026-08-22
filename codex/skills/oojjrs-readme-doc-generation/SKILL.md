---
name: oojjrs-readme-doc-generation
description: Create or update standalone GitHub-facing README and entry documentation for oojjrs repositories. Use only when README or public entry documentation is the primary deliverable. When another primary domain also requires a README update, that domain edits README directly; do not load this standalone skill in addition.
---

# oojjrs README Doc Generation

Use this skill for GitHub-facing README and repository entry docs.

This boundary prevents duplicate workflow loading, not README edits. Package migration, release, or another primary domain may update README as part of its own scoped work.

## Source Rules

1. Read `https://oojjrs.github.io/codex/guideline-readme-generation.review.md` before editing `README.md`.
2. Use live code, package metadata, project files, and existing docs as the source of truth.
3. Do not invent install methods, package names, version numbers, or feature claims.
4. Keep public docs concise and practical; avoid marketing filler unless the user asks.

## Structure

Prefer:

- what the project/package is
- install or open instructions
- minimum usage example
- important constraints or platform notes
- sample/demo location when present
- version or release note only when it is user-facing and current

## Validation

Validate only changed content against independent project sources:

- resolve changed links and referenced files
- compare changed commands and code blocks with live code or package metadata
- when version text changed, compare it with the applicable `package.json` or manifest

Do not run builds or tests for README-only changes. The canonical single format and scoped-diff pass still applies; do not duplicate it inside this domain.
