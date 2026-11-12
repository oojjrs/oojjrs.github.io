---
name: oojjrs-mines-art-asset-pipeline
description: Use as the primary domain for H:\Mines art, UI, theme, effect, treasure, profile reward, tile, flag, preview, and Unity asset work. It owns image-first creation, Unity metadata safety, and narrow synchronization of changed asset entries in Design.html. Substantive Design.html layout or structure uses the Design HTML Builder in a separate phase; audio and true 2D sprite animation use their own domains.
---

# oojjrs Mines Art Asset Pipeline

Use this skill for `H:\Mines` art and Unity asset work.

## Start

1. Use this as the primary domain for the Mines art and Unity asset phase; it owns the required image-first and Unity metadata rules. Do not stack the generic image or Unity asset domains. Route substantive `Design.html` work and audio work to their own sequential phases.
2. Read `Design.html` before changing art direction, asset inventory, or planning-visible state. Before any document or HTML edit, read and follow `https://oojjrs.github.io/codex/document-writing-guideline.md`; its text-addition approval rule governs every document synchronization instruction below. For Design-specific requirements, also follow `https://oojjrs.github.io/codex/guideline-design-generation.review.md`.
3. Inspect current assets, dimensions, and naming before generating replacements. Inspect history only when the task is to recover or compare earlier work.
4. For new or substantially revised raster art, use imagegen for the first aesthetic pass; build previews only from actual candidates or accepted finals.
5. Check `$Trash` and recent git history when the user asks to find earlier candidates.

## Common Asset Types

Handle these as first-class repeated workflows:

- stage theme tiles: `Closed`, `Opening`, `Opened`, reveal previews, backgrounds
- treasure/chest previews, idle sheets, and small loop effects
- profile reward images and grade frames
- common control art, buttons, toggles, radios, panels, popup art
- flags and sprite sheets
- effect frames such as dust, glow, sparkle, and firefly loops

## Installation Rules

1. Keep candidates and rejected variants under `$Trash`.
2. Promote only the selected final asset into the formal project folder.
3. Use the official Unity CLI for asset import, move, and rename. Let Unity manage the associated .meta files, include in-scope metadata, and stop before commit or push if an expected companion is still missing after import.
4. Preserve existing final names when runtime references already depend on them.
5. When an asset change affects `Design.html`, synchronize only the affected existing previews and references while preserving visible text and document structure. Changing a name, filename label, completion-state text, or any other wording requires the separate exact-text approval above; an asset or page approval is insufficient. Use `$oojjrs-design-html-builder` in a separate phase for layout or structural work.
6. Preserve existing filename labels under image previews when the planning doc uses image inventories. New or replacement filename text requires separate prior approval of its exact wording and placement.
7. Compose reveal previews, treasure previews, comparison boards, and planning-document previews from the actual generated candidates or accepted final files. Do not call imagegen only to create a preview, mockup, contact sheet, or display-only visualization.

## Validation

Check only changed asset properties:

- image dimensions and frame counts when sheets or GIFs changed
- changed file references from `Design.html`
- Unity-generated metadata is present for the changed assets and existing GUIDs are preserved.
