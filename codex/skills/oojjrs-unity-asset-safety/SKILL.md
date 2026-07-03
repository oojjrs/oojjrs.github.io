---
name: oojjrs-unity-asset-safety
description: Safely create, update, move, or delete Unity project assets without corrupting Unity metadata. Use for Unity asset work involving Assets, Packages, Sprites, prefabs, animations, materials, audio, images, generated art, or any task where .meta files, GUIDs, import state, Design.html references, or temporary asset candidates matter.
---

# oojjrs Unity Asset Safety

Use this skill for Unity asset work before touching files under `Assets`, `Packages`, or project design-asset folders.

## Hard Rules

1. Do not create or author new `.meta` files. Unity import/meta generation is the user's responsibility unless explicitly requested.
2. Preserve or move existing `.meta` files only when they already exist and are in the requested scope.
3. Put all temporary and intermediate files under a literal `$Trash` folder.
4. Keep generated candidates separate from final project assets until the user accepts them or the task clearly asks to install them.
5. Preserve unrelated dirty Unity files. Do not normalize or rewrite broad asset trees.

## Asset Workflow

1. Read `$oojjrs-guidelines`.
2. Inspect `git status --short --branch` and identify unrelated dirty files.
3. If `Design.html` exists and the asset affects planning state, read it and plan a matching update.
4. Find existing assets, dimensions, naming, and references before creating replacements.
5. For image/art assets, use `$oojjrs-image-first-art-workflow` for the first visual pass and post-process only accepted outputs.
6. When replacing a tracked asset, preserve the original file name only if existing references depend on it; otherwise update references deliberately.
7. Validate local references with exact path/GUID searches where possible.

## Checks

Before finishing, verify:

- No new `.meta` files were authored unless explicitly requested.
- Temporary files are only under `$Trash`.
- Changed files match the requested asset scope.
- `git diff --check` is clean for touched text assets.
