---
name: oojjrs-project-design-document-router
description: Route focused project Design.html planning-document review, cleanup, or update through the public design rules. Use for ordinary Design.html work that does not require image-heavy creation, recovery, or a substantial rebuild. For those larger tasks use $oojjrs-design-html-builder instead, not both.
---

# oojjrs Project Design Document Router

Use this skill as the primary domain for focused project planning-document work. Do not duplicate the full rules here or stack it with `$oojjrs-design-html-builder`.

## Required Reference

Before any document or HTML edit, read and follow `https://oojjrs.github.io/codex/document-writing-guideline.md`; its text-addition approval rule takes precedence over every writing and synchronization instruction here. Document or page creation and agreement on planning decisions do not authorize text. Every new or replacement heading, navigation item, table label, caption, filename, status label, tooltip, or generated phrase requires separate prior approval of its exact wording and placement. Assume 99% of text requests are refused: ask only when omission makes the requested result impossible; otherwise omit the text without asking. For indispensable text, show its exact wording, placement, and necessity in chat and wait for explicit approval before writing any draft or placeholder. Before reviewing or editing a project `Design.html`, also follow `https://oojjrs.github.io/codex/guideline-design-generation.review.md`. The lifecycle router already loaded the common rules.

## Workflow

1. Read the live project `Design.html` if it exists.
2. Treat `Design.html` as product/game planning: final decisions, implementation criteria, UX rationale, current state, and unresolved items. These categories do not require filling new prose, headings, or unresolved-item labels.
3. Keep operational workflow, queue, validation, GitHub Project board, approval, and commit rules out of `Design.html`.
4. Do not add shared guideline links to the `Design.html` header; Codex reads public Markdown rules from user-level work rules.
5. Use current code and assets to verify planning facts against user intent. Reconciliation does not authorize rewriting document text; make wording changes only within separately approved exact wording and placement.
6. Keep assets in live runtime paths or `DesignAssets/...`; temporary material belongs in `$Trash`.
7. Validate only changed HTML elements: parse their structure, resolve changed links, anchors, image click-throughs, and local asset paths, and compare changed open/collapsed state with the requested design. Use browser checks only when requested or when layout or responsive behavior changed.

## Boundaries

Generic "document" work does not include `Design.html` unless the user says planning/design doc. If a requested planning change lacks a rule/spec, ask before inventing one. Agreement on that product decision does not authorize writing it into the document.
