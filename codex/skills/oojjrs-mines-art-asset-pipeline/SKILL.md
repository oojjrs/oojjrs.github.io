---
name: oojjrs-mines-art-asset-pipeline
description: Use as the primary domain for H:\Mines art, UI, theme, effect, treasure, profile reward, tile, flag, preview, and Unity asset work. It owns image-first creation, Unity metadata safety, and narrow synchronization of changed asset entries in Design.html. Substantive Design.html layout or structure uses the Design HTML Builder in a separate phase; audio and true 2D sprite animation use their own domains.
---

# oojjrs Mines Art Asset Pipeline

Use this skill for `H:\Mines` art and Unity asset work.

## Start

1. Use this as the primary domain for the Mines art and Unity asset phase; it owns the required image-first and Unity metadata rules. Do not stack the generic image or Unity asset domains. Route substantive `Design.html` work and audio work to their own sequential phases.
2. Read `Design.html` before changing art direction, asset inventory, or planning-visible state.
3. Inspect current assets, dimensions, and naming before generating replacements. Inspect history only when the task is to recover or compare earlier work.
4. For new or substantially revised raster art, use imagegen for the first aesthetic pass; build previews only from actual candidates or accepted finals. Route true 2D sprite animation to `$oojjrs-2d-sprite-animation` instead.
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
3. Do not create or modify Unity `.meta` files. Preserve or move an existing one with its asset, include a user- or Unity-generated in-scope `.meta` even when untracked, and stop before commit or push if an expected companion is absent.
4. Preserve existing final names when runtime references already depend on them.
5. When an asset change affects `Design.html`, update only its existing asset row, preview, name, reference, or completion state while preserving the document structure. Use `$oojjrs-design-html-builder` in a separate phase for layout or structural work.
6. Keep filenames visible under image previews when the planning doc uses image inventories.
7. Compose reveal previews, treasure previews, comparison boards, and planning-document previews from the actual generated candidates or accepted final files. Do not call imagegen only to create a preview, mockup, contact sheet, or display-only visualization.

## Validation

Check only changed asset properties:

- image dimensions and frame counts when sheets or GIFs changed
- changed file references from `Design.html`
- no Codex-created or modified `.meta` files, and every in-scope asset has its existing or user/Unity-generated companion when expected
