---
name: oojjrs-2d-sprite-animation
description: Create or revise 2D sprite animation artwork through reference lock, key-pose checks, adjacent-frame drawing that preserves approved poses, and actual playback review. Use for sprite poses, in-betweens, sequence repairs, sheets, and preview GIFs. Transforms are supplementary preparation or registration tools, never the main animation method or a substitute for drawing requested poses. Do not prefer strip generation without evidence for the current task.
---

# oojjrs 2D Sprite Animation

## Core Rule

Follow this sequence: lock the original reference → check key poses → preserve approved poses while drawing adjacent frames → inspect actual playback.

Use `$imagegen` / built-in `image_gen` to draw every requested motion pose and in-between as actual source artwork. Preserve the approved artwork and motion intent throughout the sequence.

Do not prefer strips or require one generation call per frame. Choose individual frames or a limited group only to serve the checked key poses and their continuity; grouped generation is an option, not evidence of better consistency.

Transforms are supplementary tools for preparing completed drawings: crop/padding, a shared output scale, small anchor-registration corrections, or retaining truly stationary pixels unchanged. Never build the main animation from transformed static art or use rigging, warping, mesh/spline deformation, frame interpolation, crossfades, or parametric SVG/canvas paths to replace missing drawn poses. Baking such motion into PNG frames does not make it newly drawn artwork.

## Workflow

1. Lock the original reference.
   - Keep the original approved design as the authority for silhouette, anatomy, palette, lighting, outline, camera, and proportions; identify separately which motion, rhythm, or amplitude is currently approved.
   - Preserve frame size, cell geometry, pivots, timing contracts, document previews, and existing Unity references. Specify intentional growth, squash, or airborne trajectories instead of treating them as accidental drift.
   - Keep the last valid approved version recoverable. A superseded approval or a version under rework is not a validated success or a new design authority.
   - Never hand-edit Unity YAML or `.meta` text; use the official Unity CLI and importer for Unity-side changes.

2. Draw and check the key poses before expanding the sequence.
   - Establish the action-defining poses, such as neutral, anticipation, contact or peak, and return or final state, against the locked original.
   - Check complete silhouettes, proportions, root or foot landmarks, anatomy, overlaps, and newly exposed surfaces in the source drawings. Correct a failed key pose by drawing it again before adding its neighboring frames.
   - Preserve the exact pose artwork the user approves. Treat approval as applying only to the confirmed version and property; partial praise or an in-progress sequence does not establish final animation acceptance.

3. Preserve approved poses while drawing adjacent frames.
   - Supply the locked original and nearest approved poses on each revision; draw immediately preceding or following poses and expand the sequence gradually.
   - Keep approved pose files intact. If a group or phase is drawn together, carry its accepted boundary poses forward without replacing them, and check that the new drawings join them naturally.
   - Draw continuous attachments, undersides, and occlusion changes completely. Closely spaced drawn poses provide slow smooth motion; fewer playback frames, opacity tricks, and deformed cutouts do not replace them.
   - Keep accepted concept, palette, rhythm, amplitude, endpoints, and unaffected frames. Repair the failing pose or necessary local phase without silently redesigning the action.

4. Inspect actual playback and repair the demonstrated defect.
   - Assemble previews from the actual drawings and play the sequence at its intended size and speed. Check key-pose transitions, loop boundaries, anchors, scale, silhouettes, palette, clipping, and attachment continuity.
   - Separate source-art defects from extraction, registration, timing, and encoding defects. If stable source drawings pop only after extraction, correct extraction; if the drawings themselves drift, redraw them.
   - Use supplementary preparation only on completed artwork: common scaling, padding, small anchor registration, and unchanged fixed-region retention. Do not fit each frame to its own tight bounds, stretch its proportions, pin intended airborne motion to the ground, or invent a pose through correction.
   - A retained stationary region must stay byte-identical at fixed coordinates with unchanged shape and occlusion; redraw a broken attachment boundary instead of patching moving surfaces.
   - Keep the last valid approved result until comparison shows improvement. Identify the actual drawing and supplementary operations honestly, and do not call a sequence complete while the latest playback still needs rework.

## Output Preparation

- Use local tools to prepare accepted frame files, clean alpha, retain unchanged stationary regions, pack sheets, and encode previews; they must not become the primary motion-creation method.
- Build contact sheets, sheets, and GIFs only from actual accepted drawings. No preview-only imagegen calls; use a stable GIF palette and compare with PNG/WebP if encoding appears to flicker.

## Unity Installation

1. Keep frame construction and sheet packing outside the Unity project until the accepted output is ready to install.
2. Use `$unity-cli` for import, save, reimport, and every Unity-side serialized or importer change. Pass `--caller plugin --skill oojjrs-2d-sprite-animation` on `unity command` calls.
3. Use `$sprite-editor` for sprite rectangles, names, pivots, borders, slicing, and internal IDs. Set an actual sheet to `SpriteImportMode.Multiple`; set a non-sheet sprite to `Single`.
4. When the asset belongs to a SpriteAtlas, use `$manage-sprite-atlas` to inspect and set both source and atlas output settings. Default generated atlas sprites to uncompressed with Crunch disabled unless an existing preset, platform rule, or explicit request requires another setting.
5. Let Unity create or update `.meta` files. Include the Unity-generated in-scope companion, and treat unexpected GUID churn on an existing asset as a failure.
6. Route `.anim`, AnimatorController, override-controller, curve, state, transition, or binding work to `$oojjrs-unity-animation-asset-workflow` as a separate phase. Do not hand-author those YAML files.

## Validation

- Confirm the original, checked key poses, preserved approved poses, and adjacent drawings are identifiable; filenames, frame counts, and `runtimeTransforms: false` metadata do not prove the creation method.
- Inspect actual encoded playback against the current accepted reference, including phase boundaries, scale, anchors, palette, occlusion, clipping, and attachment continuity; do not infer success from a superseded approval.
- Check dimensions, frame count, sheet layout, transparency, and timing against the runtime contract. Check unchanged fixed regions only when such retention was used.
- For Unity installation, read back importer mode, compression, sprite rects/internal IDs, atlas settings, generated `.meta` GUID, and animation references through Unity; stop Git completion if an expected companion is absent.

## Quality Rules

- Draw the poses first; transforms support preparation and registration only and must not take over the requested animation work.
- Judge source drawing, extraction, encoding, and playback separately. More generation calls or a different grouping alone do not establish quality.
- Use only currently valid approval evidence for the same version and property; preserve explicitly retained design or rhythm without presenting an unfinished animation as a proven workflow.
