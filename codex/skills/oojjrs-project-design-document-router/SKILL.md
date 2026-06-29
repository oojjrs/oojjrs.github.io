---
name: oojjrs-project-design-document-router
description: Route project Design.html planning-document creation, review, cleanup, or update through the user's public work and design rules. Use when Codex needs to create, update, reorganize, validate, or keep Design.html separate from workflow, queue, commit, and GitHub Project board instructions.
---

# oojjrs Project Design Document Router

Use this skill as a thin router for project planning documents. Do not duplicate the full rules here; the current rules live in the public Markdown documents.

## Required References

Before creating, reviewing, restructuring, or editing a project `Design.html`, open and follow both references:

- Codex work rules: `https://oojjrs.github.io/codex/common-work-guidelines.md`
- Design.html rules: `https://oojjrs.github.io/codex/guideline-design-generation.review.md`

## Workflow

1. Read the live project `Design.html` if it exists.
2. Treat `Design.html` as product/game planning: final decisions, implementation criteria, UX rationale, current state, and unresolved items.
3. Keep operational workflow, queue, validation, GitHub Project board, approval, and commit rules out of `Design.html`.
4. Do not add shared guideline links to the `Design.html` header; Codex reads public Markdown rules from user-level work rules.
5. Current code/assets beat stale planning text. Reconcile planning to implementation and user intent.
6. Keep assets in live runtime paths or `DesignAssets/...`; temporary material belongs in `$Trash`.
7. Validate changed HTML for links, anchors, image click-throughs, local assets, encoding, CRLF, obvious tag balance, and diff scope.

## Boundaries

Generic "document" work does not include `Design.html` unless the user says planning/design doc. If a requested planning change lacks a rule/spec, ask before inventing one.
