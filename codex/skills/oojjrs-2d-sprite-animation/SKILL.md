---
name: oojjrs-2d-sprite-animation
description: Create or revise 2D sprite animations with actually drawn poses and in-betweens. Use for sprite animation artwork, consistent action strips, phase sequences, sprite sheets, and preview GIFs. Ground each revision in approved references, preserve accepted motion and fixed landmarks, and redraw failed poses without transform, interpolation, fade, or procedural-motion substitutes. A generation may contain one frame or a coherent action strip.
---

# oojjrs 2D Sprite Animation

## Core Rule

Use `$imagegen` / built-in `image_gen` to draw every motion pose and in-between as actual source artwork. Each cel must contain its own drawn pose; generating several cels together does not waive this requirement.

Prefer a coherent strip for one short action when each cel has sufficient usable resolution. Split long or complex actions into phases sharing approved boundary poses, and use individual-frame requests for specific pose repairs. There is no mandatory one-call-per-frame rule; keep unrelated actions and states in separate source generations.

Never synthesize poses or motion by transforming existing art or its parts, rigging, warping, mesh or spline deformation, optical flow, tweening, frame interpolation, or crossfades. Parametric SVG/canvas/path animation rasterized into PNG frames is also motion synthesis. This applies before baking and at runtime, including trivial whole-image motion.

## Workflow

1. Inspect the approved artwork, motion reference, and target runtime format.
   - Keep a canonical identity reference and the last accepted sequence; use a known-good motion example when the requested rhythm or amplitude is unclear.
   - Preserve frame size, sheet layout, pivots, timing contracts, document previews, and existing Unity references.
   - Never hand-edit Unity YAML or `.meta` text; use the official Unity CLI and importer for Unity-side changes.

2. Specify what stays fixed and what changes before generating.
   - Lock camera, palette, lighting, outline, proportions, cell geometry, and anatomical attachment points to the approved reference.
   - Describe one concrete action, its phase order, moving forms, allowed amplitude, holds, and return or loop boundary. Slow motion needs closely spaced drawn poses, not merely fewer frames per second.
   - For growth, squash, or a jump, specify the intended size or anchor trajectory; do not mistake deliberate shape change for drift or pin airborne poses to the ground.

3. Draw a reference-grounded coherent sequence.
   - Supply the canonical artwork and accepted neighboring or boundary poses on every revision; do not rely only on the newest generated image.
   - For a strip or phase, state cell count, order, padding, shared scale, root or foot landmarks, and the exact allowed pose changes. Layout guides must not become visible artwork.
   - Draw newly exposed surfaces, undersides, and overlaps completely; preserve continuous anatomy rather than covering gaps with cutout fragments or opacity tricks.
   - Inspect source artwork before extraction. Reject wrong phase order, new anatomy, scale drift, repeated poses where distinct in-betweens are needed, or unintended lighting changes.

4. Repair the identified defect while preserving accepted work.
   - Identify the failing frames or phase and separate source-art defects from extraction, registration, timing, and preview-encoding defects.
   - Keep accepted concept, silhouette, palette, rhythm, amplitude, endpoints, and unaffected frames; change only the failing property or necessary coherent phase.
   - Redraw the defective poses or phase against approved neighbors. Do not silently replace the concept, add motion, or combine unrelated changes in a retry.
   - A truly stationary approved region may be retained byte-identically at its fixed coordinates when its shape and occlusion do not change; never move, deform, or blend it to manufacture a new pose, and redraw a broken attachment boundary.
   - Preserve the accepted version and revision sources until comparison shows improvement. Keep source paths, generation prompts/references, and packaging operations distinguishable; report code-rendered or transformed output honestly.

5. Prepare output files from accepted artwork.
   - Extract without clipping; use one shared action scale, padding, and stable anchors. Do not fit each frame independently to its tight bounds or stretch a body to hide bad drawing.
   - If the source strip is stable but extracted frames pop, correct extraction or shared registration; if the source itself drifts, redraw the failing art.
   - Use local tools for file preparation, alpha cleanup, unchanged fixed-region retention, sheet packing, and preview encoding only; they must not create moving poses.
   - Build sheets, contact sheets, and GIFs only from actual accepted frames. No preview-only imagegen calls; use a stable GIF palette and compare with PNG/WebP if encoding appears to flicker.

## Unity Installation

1. Keep frame construction and sheet packing outside the Unity project until the accepted output is ready to install.
2. Use `$unity-cli` for import, save, reimport, and every Unity-side serialized or importer change. Pass `--caller plugin --skill oojjrs-2d-sprite-animation` on `unity command` calls.
3. Use `$sprite-editor` for sprite rectangles, names, pivots, borders, slicing, and internal IDs. Set an actual sheet to `SpriteImportMode.Multiple`; set a non-sheet sprite to `Single`.
4. When the asset belongs to a SpriteAtlas, use `$manage-sprite-atlas` to inspect and set both source and atlas output settings. Default generated atlas sprites to uncompressed with Crunch disabled unless an existing preset, platform rule, or explicit request requires another setting.
5. Let Unity create or update `.meta` files. Include the Unity-generated in-scope companion, and treat unexpected GUID churn on an existing asset as a failure.
6. Route `.anim`, AnimatorController, override-controller, curve, state, transition, or binding work to `$oojjrs-unity-animation-asset-workflow` as a separate phase. Do not hand-author those YAML files.


## Validation

- Confirm every changing pose and in-between comes from drawn source artwork; filenames, frame counts, and `runtimeTransforms: false` metadata do not prove the creation method.
- Compare the actual encoded loop with the accepted reference at intended size and speed; check phase boundaries, silhouettes, scale, anchors, palette, occlusion, clipping, and attachment continuity.
- Check dimensions, frame count, sheet layout, transparency, and timing against the runtime contract. Check unchanged fixed regions only when such retention was used.
- For Unity installation, read back importer mode, compression, sprite rects/internal IDs, atlas settings, generated `.meta` GUID, and animation references through Unity; stop Git completion if an expected companion is absent.

## Quality Rules

- Judge source drawing, extraction, encoding, and playback separately; a successful file export does not establish animation quality.
- Improve the last accepted sequence with controlled repairs; additional generation calls alone do not establish consistency.
- Preserve actually drawn motion through final playback; do not replace it with transforms, synthetic in-betweens, or fades during repair or installation.
