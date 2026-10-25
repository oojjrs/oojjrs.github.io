---
name: oojjrs-2d-sprite-animation
description: Create or revise 2D sprite animation with locked artwork, complete layered parts, bone and mesh rigging, checked key poses and timing, selective redrawing, and actual playback review. Use for cutout rigs, sprite poses, in-betweens, sequence repairs, sheets, and preview GIFs. Default to reusing approved art for motion that preserves its structure; draw new surfaces, expressions, and shape-changing effects as needed. Honor explicit drawn-frame requests and verify Spine compatibility before claiming it.
---

# oojjrs 2D Sprite Animation

## Core Rule

Follow this sequence: lock the original → complete the required layered parts → rig bones and meshes → check key poses and timing → draw what the rig cannot represent → inspect actual playback.

For fixed-view motion that preserves the subject's structure, default to reusing approved artwork through local part articulation and weighted meshes. Use `$imagegen` / built-in `image_gen` for new or revised source artwork, hidden surfaces, replacement attachments, and drawn effects. Reuse existing approved art without regenerating every frame. Honor a user's explicit drawing-only or other method requirement.

Choose methods by the actual motion:

- Rigid parts: preserve their shape with translation and rotation around meaningful pivots.
- Bending ears, leaves, stems, or eyestalks: use suitable bone chains, mesh topology, and weights.
- Blinks, expressions, newly exposed sides, or large perspective changes: add replacement drawings and key their visibility or draw order.
- Flowing water, splitting, opening flowers, or other changes the rig cannot represent: draw the necessary local phase; combine it with the stable rig when useful.

Do not use whole-image wobble, indiscriminate scaling, clipped cutouts, or crossfades to conceal missing articulation or artwork. A bone label, more frames, or baked PNGs does not establish quality or prove how motion was made.

## Workflow

1. Lock the original reference.
   - Keep the original approved design as the authority for silhouette, anatomy, palette, lighting, outline, camera, and proportions; identify separately which motion, rhythm, or amplitude is currently approved.
   - Preserve frame size, cell geometry, pivots, timing contracts, document previews, and existing Unity references. Declare intentional growth, squash, root motion, or airborne trajectories.
   - Keep the last valid approved version recoverable. A superseded approval or a version under rework is not a validated success or a new design authority.
   - Never hand-edit Unity YAML or `.meta` text; use the official Unity CLI and importer for Unity-side changes.

2. Prepare complete parts and their occlusion structure.
   - Split only at independently moving or occluding units; keep a continuous flexible surface together where a mesh is more suitable than many rigid fragments.
   - Retain original pixels where possible. Complete each moving part's hidden contour and paint the surface behind it before animation; a crop of the visible fragment is not a complete part.
   - Provide overlap at joints, clean alpha edges, and sufficient texture padding. Separate foreground occluders and specify draw order, masks or clipping, pivots, and fixed versus moving regions.
   - Reassemble the neutral pose at the original scale and position. Check that seams, outlines, shading, anatomy, and landmarks match the approved design before adding motion.

3. Build a rig that follows the subject's structure.
   - Establish root and parent relationships, joint pivots, bone lengths, local axes, and grounded contacts. Keep hard parts rigid; put bending controls and mesh vertices along the intended curvature.
   - Bind weights to the intended parts and test the required extreme poses. Correct texture stretch, collapsing volume, disconnected joints, unintended influence on fixed areas, and occlusion errors before expanding the animation.
   - A single textured mesh can serve subtle continuous deformation; use separate parts when motion exposes hidden surfaces or changes overlap. Do not describe a whole-image mesh as a completed layered cutout rig.
   - Keep rig controls, textures, weights, and timelines editable. Check available authoring/export tools before choosing Spine or another format; do not assume the editor or runtime is installed.

4. Check key poses, trajectories, and timing on a short representative action.
   - Establish neutral, anticipation, contact or peak, and return or final poses. Check silhouettes, anatomy, joint angles, part lengths, overlaps, and root or foot landmarks.
   - Design motion arcs, acceleration and deceleration, holds, and delayed follow-through. Bone interpolation is allowed; equal frame durations, slow playback, and high frame counts do not themselves create natural motion.
   - Keep the exact approved pose artwork and confirmed motion properties. For an unfamiliar rig or motion, demonstrate one short action at its intended display size before producing a batch; do not call the method proven until its actual result supports that claim.

5. Add only the artwork the motion requires.
   - Draw complete exposed surfaces, changed expressions, alternate views, or effect phases the rig cannot represent. Use attachment swaps, draw-order changes, or a locally drawn sequence as appropriate.
   - For drawn sequences, supply the locked original and nearest accepted poses on both sides; preserve accepted files and draw the missing local interval. Choose individual frames or small groups for continuity without imposing a strip preference or one-call-per-frame rule.
   - Fix design drift in source artwork and mechanical defects in the rig or timing. Preserve accepted concept, palette, rhythm, amplitude, endpoints, and unaffected phases instead of regenerating the whole subject.

6. Inspect actual playback and repair the demonstrated defect.
   - Play the actual rig or exported sequence at intended size and speed, then inspect enlarged joints and phase boundaries. Check loop continuity, scale, anchors, contacts, silhouettes, palette, seams, clipping, and attachment visibility.
   - Separate source-art, part extraction, rig/weight, timing, export, and encoding defects. Repair the responsible layer; a fixed-region pixel check alone does not prove natural movement or correct occlusion.
   - Use common output scaling and fixed canvas/pivot registration. Do not fit each frame to its own tight bounds, stretch rigid parts to hide drift, or pin intentional airborne motion to the ground.
   - Regions declared stationary must retain the same source pixels and placement except for intentional occlusion. Preserve the last valid version until comparison shows improvement; do not call a sequence complete while its latest playback needs rework.

## Spine And Tool Verification

- For Spine meshes, weights, attachments, and export behavior, use the current official [meshes](https://esotericsoftware.com/spine-meshes), [weights](https://esotericsoftware.com/spine-weights), [attachments](https://esotericsoftware.com/spine-attachments), and [export](https://esotericsoftware.com/spine-export) documentation.
- Keep the authoring source or importable rig, source parts, and timelines. Verify the actual target editor or official runtime can load and play the data, and match export/runtime versions when using Spine data.
- Hand-authored Spine-style JSON and a custom renderer are not evidence of Spine import or runtime compatibility. Report each verified surface precisely; do not silently replace unavailable authoring tools with an unverified compatibility claim.

## Output Preparation

- Deliver the editable rig and parts or the accepted drawings, plus the runtime output required by the existing project. Baking a rig to a PNG/WebP sequence or sheet is allowed; describe it as rendered rig animation.
- Build contact sheets and previews from the actual source drawings or rendered rig frames. No preview-only imagegen calls; use a stable GIF palette and compare with PNG/WebP if encoding appears to flicker.
- Preserve the runtime contract for canvas, pivots, timing, transparency, and sheet geometry. Verify exported output as well as the authoring preview when export can change the result.

## Unity Installation

1. Keep frame construction and sheet packing outside the Unity project until the accepted output is ready to install.
2. Use `$unity-cli` for import, save, reimport, and every Unity-side serialized or importer change. Pass `--caller plugin --skill oojjrs-2d-sprite-animation` on `unity command` calls.
3. Use `$sprite-editor` for sprite rectangles, names, pivots, borders, slicing, and internal IDs. Set an actual sheet to `SpriteImportMode.Multiple`; set a non-sheet sprite to `Single`.
4. When the asset belongs to a SpriteAtlas, use `$manage-sprite-atlas` to inspect and set both source and atlas output settings. Default generated atlas sprites to uncompressed with Crunch disabled unless an existing preset, platform rule, or explicit request requires another setting.
5. Let Unity create or update `.meta` files. Include the Unity-generated in-scope companion, and treat unexpected GUID churn on an existing asset as a failure.
6. Route `.anim`, AnimatorController, override-controller, curve, state, transition, or binding work to `$oojjrs-unity-animation-asset-workflow` as a separate phase. Do not hand-author those YAML files.

## Validation

- Identify the original, source parts and hidden-surface drawings, rig/weights, key poses, timelines, and any drawn phases actually used. Check only the artifacts required by the chosen method; metadata labels do not prove the method.
- Inspect actual playback against the current accepted reference, including motion readability, phase and loop boundaries, contacts, scale, palette, occlusion, clipping, and joint continuity. A static sheet or superseded approval does not establish success.
- Check dimensions, frame count, sheet layout, transparency, and timing against the runtime contract. Verify fixed regions only where declared and editor/runtime compatibility only on the actual target toolchain.
- For Unity installation, read back importer mode, compression, sprite rects/internal IDs, atlas settings, generated `.meta` GUID, and animation references through Unity; stop Git completion if an expected companion is absent.

## Quality Rules

- Reuse approved artwork where the motion permits it; complete parts before rigging and draw what cannot be represented faithfully by the rig.
- Judge appearance consistency and motion quality separately. A stable texture, more bones, more frames, or more generation calls does not establish natural animation.
- Use only currently valid approval evidence for the same version and property; preserve explicitly retained design or rhythm without presenting an unfinished animation as a proven workflow.
