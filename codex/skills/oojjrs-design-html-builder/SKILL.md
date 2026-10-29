---
name: oojjrs-design-html-builder
description: Build, rebuild, recover, or substantially update project Design.html planning documents for oojjrs projects. Use for image-heavy planning docs, substantial layout or template conversions, PDF/git-history recovery, left-nav layouts, lightbox/image inventories, filename labels, visible metadata cleanup, and live asset synchronization.
---

# oojjrs Design.html Builder

Use this as the primary domain for substantive `Design.html` creation, recovery, or rebuild work. It owns the planning-document rules needed for that work and supersedes `$oojjrs-project-design-document-router`; do not load both.

For `H:\Mines`, this skill owns substantive document layout or structure work. The Mines art pipeline may run in a separate asset phase and may synchronize only the entries directly affected by its asset changes, within the public guideline's document-text approval scope.

## Required Reads

1. Read and follow `https://oojjrs.github.io/codex/document-writing-guideline.md` for every document or HTML edit, and `https://oojjrs.github.io/codex/guideline-design-generation.review.md` for Design-specific requirements. The common document text-addition approval rule governs every instruction below, including recovery, filename labels, prose, and asset-entry synchronization. Creating or recovering a document or page does not authorize text. New or replacement wording, including headings, navigation, filenames, captions, status labels, tooltips, and generated text, requires separate prior approval of its exact wording and placement. Assume 99% of text requests are refused: ask only when omitting the text would make the requested result impossible; otherwise omit it without asking. Present the exact wording, placement, and necessity in chat and wait for explicit approval before writing, including drafts and placeholders.
2. Read the current `Design.html` if it exists.
3. When a referenced model document is named, inspect that live document instead of relying on memory.

## Source Priority

Use this order to establish facts. A source supplies evidence, not permission to copy, restore, or rewrite its text in the planning document; apply the separate text-approval gate before doing so:

1. live code, assets, prefabs, package metadata, and current project files
2. existing `Design.html`
3. git history for missing or accidentally removed planning content
4. original PDFs or source docs when rebuilding
5. memory only as a clue for where to look

## Document Shape

Favor:

- fixed or persistent left navigation when the existing style uses it
- image-forward sections with inspectable previews
- preserve existing filename labels in their current approved scope; new or replacement label text requires separate prior approval of its exact wording and placement
- collapsible sections for dense inventories
- only separately approved text around visual inventories; do not automatically fill headings, captions, status labels, or placeholders
- no visible file paths, byte counts, validation logs, or implementation audit metadata unless requested

## Preview Source Rule

Build image previews, comparison boards, contact sheets, and visual inventories from the actual project assets, generated candidates, accepted images, screenshots, or rendered documents they represent. Do not call imagegen only to make a Design.html preview, mockup, or display-only visualization.

## Validation

Check only changed document behavior:

- changed image references resolve
- changed IDs are unique and changed anchors resolve
- changed collapsed/open section state matches the requested design
- changed HTML structure parses without obvious imbalance

Use browser validation only when the user requests it or when layout or responsive behavior changed. In that case, inspect only the affected desktop and mobile surfaces; static checks are sufficient for content-only edits.
