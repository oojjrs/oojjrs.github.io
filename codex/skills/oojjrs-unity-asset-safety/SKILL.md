---
name: oojjrs-unity-asset-safety
description: Safely create, import, update, move, or delete general Unity project assets through the official Unity CLI without hand-editing serialized YAML or metadata. Use only when no more-specific art, sprite, audio, animation, localization, package, or prefab workflow applies.
---

# oojjrs Unity Asset Safety

Use this skill for general Unity asset work under `Assets`, `Packages`, or project design-asset folders when no more-specific primary domain applies.

## Hard Rules

1. Use `$unity-cli` for every Unity-side asset creation, installation, import setting, serialized change, move, rename, deletion, import, or reimport. Pass `--caller plugin --skill oojjrs-unity-asset-safety` on `unity command` calls.
2. Never hand-edit Unity YAML or `.meta` text. Let the CLI-driven Editor generate or update `.meta` files through `AssetDatabase` and importer operations. Include the resulting in-scope `.meta` with its asset, and preserve existing GUIDs through Unity asset APIs.
3. If the official CLI cannot reach a compatible Editor or an expected `.meta` is still absent after import/save, stop the mutation or Git-completion phase. Do not fabricate a GUID or fall back to direct file editing.
4. Put all temporary and intermediate files under a literal `$Trash` folder.
5. Keep generated candidates separate from final project assets until the user accepts them or the task clearly asks to install them.
6. Preserve unrelated dirty Unity files. Do not normalize or rewrite broad asset trees.

## Asset Workflow

1. If a planning document such as `Design.html` exists and the asset affects planning state, read it before choosing dimensions or import behavior.
2. Find existing assets, dimensions, naming, references, import presets, atlas membership, and platform settings before creating replacements.
3. For UI images, use the planning document's declared FHD, QHD, or 4K reference resolution. When it is not declared, use FHD (1920x1080) as the default design baseline. Also read the actual Canvas and `Canvas Scaler` through Unity when available; report a mismatch instead of silently changing the baseline.
4. For a generated raster sprite, use the CLI-driven `TextureImporter`. Default a non-sheet image to `SpriteImportMode.Single`; use `Multiple` only for an actual sheet and route its slicing, pivots, borders, and internal IDs through `$sprite-editor`.
5. When the sprite belongs to a SpriteAtlas, use `$manage-sprite-atlas` and `$unity-cli` to inspect both the source importer and atlas platform settings. Default generated atlas sprites to uncompressed source and atlas output with Crunch disabled unless an existing import preset, platform rule, or explicit request requires another setting. Read the applied values back after save/reimport.
6. If the task becomes generated raster art, route to `$oojjrs-image-first-art-workflow` as the primary domain instead of stacking both skills.
7. When replacing a tracked asset, preserve the original file name only if existing references depend on it; otherwise update references deliberately through Unity.
8. When asset references change, validate only those references with Unity readback and exact path or GUID searches.

## Checks

Before finishing, check only the applicable changed asset properties:

- Every Unity serialization or importer mutation was performed through the official CLI, with no hand-edited Unity YAML or `.meta` text.
- Every in-scope Unity-generated `.meta` accompanies its asset, and existing asset GUIDs did not change unexpectedly.
- UI dimensions use the planning document's declared baseline or the FHD default, with any Canvas/Canvas Scaler mismatch reported.
- Non-sheet sprites read back as `Single`; actual sheets read back as `Multiple` with the intended rects and internal IDs.
- Atlas members read back with the intended source and atlas output compression settings.
- New temporary files are only under `$Trash`.
- Changed files match the requested asset scope.
