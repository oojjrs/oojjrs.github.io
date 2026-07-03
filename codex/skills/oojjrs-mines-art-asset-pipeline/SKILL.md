---
name: oojjrs-mines-art-asset-pipeline
description: Produce and install Mines game art, UI, theme, effect, treasure, profile reward, tile state, flag, sound-preview, and planning-document assets. Use for H:\Mines work that moves from generated or recovered candidates through post-processing, Unity-safe final placement, Design.html synchronization, validation, and narrow commit preparation.
---

# oojjrs Mines Art Asset Pipeline

Use this skill for `H:\Mines` art and planning-surface asset work.

## Start

1. Use `$oojjrs-guidelines`, `$oojjrs-project-start-work`, `$oojjrs-unity-asset-safety`, and for raster art `$oojjrs-image-first-art-workflow`.
2. Read `Design.html` before changing art direction, asset inventory, or planning-visible state.
3. Inspect current assets, dimensions, naming, and git history before generating replacements.
4. Check `$Trash` and recent git history when the user asks to find earlier candidates.

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
3. Do not create new Unity `.meta` files.
4. Preserve existing final names when runtime references already depend on them.
5. Update `Design.html` when the planning inventory, previews, naming, or completion state changes.
6. Keep filenames visible under image previews when the planning doc uses image inventories.

## Validation

Use targeted checks:

- image dimensions and frame counts for sheets/GIFs
- referenced file existence from `Design.html`
- no new `.meta` files
- no unrelated dirty files staged
- `git diff --check` on touched text files
