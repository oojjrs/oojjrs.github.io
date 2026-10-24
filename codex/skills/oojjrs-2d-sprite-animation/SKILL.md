---
name: oojjrs-2d-sprite-animation
description: Create or revise 2D game sprite animations by drawing every frame individually. Use for animating a 2D sprite, making Unity 2D animation frames, building sprite sheets and preview GIFs, or improving animation artwork and consistency. Each imagegen call draws one complete frame; sheets and previews are assembled only from accepted individual frames.
---

# oojjrs 2D Sprite Animation

## Core Rule

Draw every 2D sprite animation frame individually as a complete image with `$imagegen` / built-in `image_gen`. Each generation call draws exactly one animation frame.

Never create animation motion by transforming an existing image or its parts: rotation, translation, scaling, shear, mesh or spline deformation, warping, rigging, tweening, optical flow, and interpolated in-betweens are prohibited, including trivial whole-image motion.

Do not generate a full strip, sprite sheet, or multi-frame image in one call. Draw every in-between frame individually too; assemble outputs only after the individual frames are accepted.

## Workflow

1. Inspect the source sprite and target runtime format first.
   - Establish the character or object identity, silhouette, palette, lighting, motion, and fixed anchor positions.
   - Preserve the existing runtime contract: frame size, sheet layout, Unity meta/import settings, animation clip references, and document previews.
   - Never hand-edit Unity YAML or `.meta` text. Preserve the runtime contract through the official Unity CLI and let Unity generate or update metadata through its importer.

2. Plan every frame before drawing.
   - Define each pose, action phase, frame count, timing, canvas size, pivot, and loop transition.
   - Use the approved source and accepted frames as visual references for identity, proportions, palette, lighting, and alignment.

3. Draw the complete frames one at a time.
   - Request a single transparent-background frame per imagegen call, with its planned pose and the approved visual references.
   - Draw the silhouette, moving forms, newly exposed surfaces, and occlusion for that frame; do not animate extracted parts or reuse their geometry as substitute poses.
   - If a frame has an incorrect pose, anatomy, silhouette, or anchor, redraw that individual frame against the accepted reference.

4. Package the accepted individual frames.
   - Use local tools only for file preparation such as canvas padding, alpha cleanup, sheet packing, and preview assembly; they must not synthesize animation poses or motion.
   - Bake the transparent runtime sprite sheet and a preview GIF or PNG sequence on a non-black background that matches the design surface.
   - Build previews only from the actual accepted animation frames or sheet. Do not call imagegen to create, refresh, or beautify a preview-only GIF, sequence, contact sheet, or mockup.
   - Keep frame count, columns, duration, and pivot behavior consistent with the target runtime contract.

## Unity Installation

1. Keep frame construction and sheet packing outside the Unity project until the accepted output is ready to install.
2. Use `$unity-cli` for import, save, reimport, and every Unity-side serialized or importer change. Pass `--caller plugin --skill oojjrs-2d-sprite-animation` on `unity command` calls.
3. Use `$sprite-editor` for sprite rectangles, names, pivots, borders, slicing, and internal IDs. Set an actual sheet to `SpriteImportMode.Multiple`; set a non-sheet sprite to `Single`.
4. When the asset belongs to a SpriteAtlas, use `$manage-sprite-atlas` to inspect and set both source and atlas output settings. Default generated atlas sprites to uncompressed with Crunch disabled unless an existing preset, platform rule, or explicit request requires another setting.
5. Let Unity create or update `.meta` files. Include the Unity-generated in-scope companion, and treat unexpected GUID churn on an existing asset as a failure.
6. Route `.anim`, AnimatorController, override-controller, curve, state, transition, or binding work to `$oojjrs-unity-animation-asset-workflow` as a separate phase. Do not hand-author those YAML files.

## Validation

Before calling the animation done:

- Visually inspect the sprite sheet and preview GIF.
- Verify that every animation frame has its own individually drawn source image.
- Check identity, proportions, palette, lighting, fixed anchors, and pivot stability across the individual frames.
- Check the changed dimensions, frame count, and transparent background against the target runtime format.
- Check for clipping, seams, ghosting, dark fringes, broken occlusion, and palette artifacts.
- For Unity assets, read back the importer mode, compression, sprite rects/internal IDs, atlas settings, generated `.meta` GUID, and animation references through Unity; do not commit or push while an expected companion is absent.

## Quality Rules

- Correct artwork defects by redrawing the affected individual frame with the accepted visual reference.
- Keep every planned frame individually drawn, including in-betweens and loop transitions.
- Treat preview quality as part of the deliverable; do not rely only on file generation success.
