---
name: oojjrs-mines-art-asset-pipeline
description: Use as the single primary domain for H:\Mines art, UI, theme, effect, treasure, profile reward, tile, flag, preview, and planning-surface asset work. It owns the needed image-first, Unity metadata, and Design rules and supersedes generic image, Unity asset, and Design skills. True 2D sprite animation is routed separately.
---

# oojjrs Mines Art Asset Pipeline

Use this skill for `H:\Mines` art and planning-surface asset work.

## Start

1. Use this as the single primary domain; it owns the required Mines image-first, Unity metadata, and Design synchronization rules. Do not stack the generic image, Unity asset, or Design domain skills.
2. Read `Design.html` before changing art direction, asset inventory, or planning-visible state.
3. Inspect current assets, dimensions, naming, and git history before generating replacements.
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
- BGM/SFX preview rows in `Design.html`

## Installation Rules

1. Keep candidates and rejected variants under `$Trash`.
2. Promote only the selected final asset into the formal project folder.
3. Do not create or modify Unity `.meta` files. Preserve or move an existing one with its asset, include a user- or Unity-generated in-scope `.meta` even when untracked, and stop before commit or push if an expected companion is absent.
4. Preserve existing final names when runtime references already depend on them.
5. Update `Design.html` when the planning inventory, previews, naming, or completion state changes.
6. Keep filenames visible under image previews when the planning doc uses image inventories.
7. Compose reveal previews, treasure previews, comparison boards, and planning-document previews from the actual generated candidates or accepted final files. Do not call imagegen only to create a preview, mockup, contact sheet, or display-only visualization.

## Validation

Use targeted checks:

- image dimensions and frame counts for sheets/GIFs
- referenced file existence from `Design.html`
- no Codex-created or modified `.meta` files, and every in-scope asset has its existing or user/Unity-generated companion when expected
- no unrelated dirty files staged
- `git diff --check` on touched text files
