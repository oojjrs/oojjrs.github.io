---
name: oojjrs-2d-sprite-animation
description: Create or revise 2D sprite animation by choosing and combining drawn frames, complete layered bone/mesh rigs, and corrective compositing per motion phase. Use for key poses, full frame redraws, cutout rigs, hybrid sequences, repairs, sheets, and previews. Use properly separated part rigs for simple articulation; redraw key poses and rig local intervals for complex motion, or redraw every frame when needed. Iterate pixel-level consistency and actual playback quality; do not force one production method.
---

# oojjrs 2D Sprite Animation

## Core Rule

Follow this sequence: establish the target appearance and motion → divide the action into phases → choose and combine methods per phase and part → construct or redraw the required sources → inspect actual playback → repair until the requested quality is achieved.

Own the production decisions within the authorized scope. Do not ask the user to choose routine technique, part, or phase boundaries. Use `$imagegen` / built-in `image_gen` for new or revised artwork, including complete key poses or every frame when necessary. Reusing original pixels, minimizing redraws, or finishing a rig is not the acceptance criterion; judge the actual appearance and motion. Honor explicit method, budget, and scope constraints.

Choose methods by the actual motion and switch when the result warrants it:

- Simple articulation: build complete separate part layers with meaningful pivots, bone hierarchy, meshes, and weights; use rigid transforms for hard parts and deformation for flexible parts.
- Complex motion: draw the action-defining key poses first, then build suitable part rigs for individual intervals. Combine rendered rig frames, attachment swaps, and newly drawn transitions in one sequence; a single rig need not cover the whole action.
- When rigging or local repair cannot reproduce the intended shape, perspective, overlap, or rhythm, redraw the required phase or the entire frame sequence. Do not force the original texture or topology to survive every pose.
- Use registration, masks, compositing, warping, interpolation, timing edits, and other available production tools where they improve the result. Draw missing surfaces and poses rather than hiding defects with blending; no tool's name establishes quality.

Whole-image wobble, clipped joints, rubbery rigid objects, doubled outlines, ghosting, and arbitrary scale changes are defects unless explicitly part of the intended action. Treat these as result criteria, not blanket bans on transforms, meshes, drawing, interpolation, or compositing.

## Workflow

1. Establish the reference and motion contract.
   - Keep the original approved design as the authority for silhouette, anatomy, palette, lighting, outline, camera, and proportions; identify separately which motion, rhythm, or amplitude is currently approved.
   - Preserve frame size, cell geometry, pivots, timing contracts, document previews, and existing Unity references. Declare intentional growth, squash, root motion, or airborne trajectories.
   - Keep the last valid approved version recoverable. A superseded approval or a version under rework is not a validated success or a new design authority.
   - Preserve the approved design and motion intent, not an obligation to reuse its pixels. Redraw complete assets or all frames when that is needed within the requested revision; keep earlier sources recoverable.
   - Never hand-edit Unity YAML or `.meta` text; use the official Unity CLI and importer for Unity-side changes.

2. Design the phases, key poses, trajectories, and timing.
   - Establish neutral, anticipation, contact or peak, and return or final poses. For complex actions, draw the necessary complete key poses before deciding how their intervening motion will be produced.
   - Check silhouettes, anatomy, proportions, joint angles, part lengths, overlaps, and root or foot landmarks. Design motion arcs, acceleration and deceleration, holds, and delayed follow-through.
   - Choose drawn, rigged, or mixed construction independently for each interval and moving part. Add a new drawing, replacement part set, or local rig whenever the existing source cannot reach the next pose faithfully.
   - For an unfamiliar motion, establish a short representative interval at the intended display size before producing a batch. Keep confirmed artwork and motion properties recoverable; a checked key pose alone is not approval of the complete sequence.

3. When using bone/mesh animation, prepare complete layered parts.
   - Separate all independently articulated or occluding body regions into appropriate source layers and rig attachments, subdividing further wherever the required motion needs separate control. A complete character image on one layer is not a substitute for this part rig.
   - Keep a flexible surface continuous within its own part where a mesh is appropriate. Draw each part's hidden contour, underside, and the surface behind it; redraw the full part set if clean separation of the original is insufficient.
   - Provide overlap at joints, clean alpha edges, and sufficient texture padding. Separate foreground occluders and specify draw order, masks or clipping, pivots, and fixed versus moving regions.
   - Reassemble each rig's reference pose at the required scale and position. Check seams, outlines, shading, anatomy, and landmarks before animating. Texture atlas packing may place multiple parts in one image; their source layers and attachments must remain independently controllable.

4. Rig only the intervals and parts it can represent faithfully.
   - Establish root and parent relationships, joint pivots, bone lengths, local axes, and grounded contacts. Keep hard parts rigid; put bending controls and mesh vertices along the intended curvature.
   - Bind weights to the intended parts and test the required extreme poses. Correct texture stretch, collapsing volume, disconnected joints, unintended influence on fixed areas, and occlusion errors before expanding the animation.
   - A single mesh may deform one continuous part; build separate attachments and occlusion structure for independently moving regions. Do not describe a whole-image mesh as a completed layered cutout rig.
   - Keep rig controls, textures, weights, and timelines editable. Check available authoring/export tools before choosing Spine or another format; do not assume the editor or runtime is installed.
   - Sample the local rig into as many frames as the motion requires. A generated key drawing may supply a rigged interval, followed by another drawn pose or interval with different sources; do not require one unchanged rig for the entire animation.

5. Draw and combine as much artwork as the result needs.
   - Use imagegen for complete key poses, replacement parts, expressions, alternate views, newly exposed surfaces, or full drawn sequences. There is no limit to local redrawing when full-frame or whole-sequence reconstruction is needed within the authorized scope.
   - For drawn sequences, supply the locked original and nearest accepted poses on both sides; preserve accepted files and draw the missing local interval. Choose individual frames or small groups for continuity without imposing a strip preference or one-call-per-frame rule.
   - Match the scale, landmarks, contours, palette, shading, camera, and occlusion at every drawn/rigged handoff. Draw bridge poses or rebuild the local rig when a swap pops; do not conceal incompatible poses with a crossfade.
   - Fix design drift in artwork and mechanical defects in rigging or timing. Keep the accepted concept, rhythm, amplitude, and endpoints while replacing whatever source material is necessary to meet them.

6. Inspect actual playback and repair the demonstrated defect.
   - Play the actual rig or exported sequence at intended size and speed, then inspect enlarged joints and phase boundaries. Check loop continuity, scale, anchors, contacts, silhouettes, palette, seams, clipping, and attachment visibility.
   - Separate source-art, part extraction, rig/weight, timing, export, and encoding defects. Repair the responsible layer; a fixed-region pixel check alone does not prove natural movement or correct occlusion.
   - Use common output scaling and fixed canvas/pivot registration. Do not fit each frame to its own tight bounds, stretch rigid parts to hide drift, or pin intentional airborne motion to the ground.
   - Compare source-resolution overlays and landmarks when unintended size, contour, or placement differences remain. Repeat drawing, registration, part/weight correction, and compositing until required pixel-level consistency is achieved; intentional pose, perspective, growth, or squash must remain intact.
   - Stationary reused regions may retain identical pixels; redrawn regions must match the required appearance and registration, not an unrelated byte-identity target. Preserve the last valid version until comparison shows improvement.
   - Do not accept visible defects because a method was followed, a frame count was reached, or more drawing would take effort. Switch or combine methods when the current approach stalls; if an explicit budget or tool limit prevents completion, report the remaining defect instead of calling it complete.

## Spine And Tool Verification

- For Spine meshes, weights, attachments, and export behavior, use the current official [meshes](https://esotericsoftware.com/spine-meshes), [weights](https://esotericsoftware.com/spine-weights), [attachments](https://esotericsoftware.com/spine-attachments), and [export](https://esotericsoftware.com/spine-export) documentation.
- When Spine data is part of the deliverable or Spine compatibility is claimed, keep the authoring source or importable rig, source parts, and timelines; verify loading and playback with the target editor or official runtime and match export/runtime versions.
- Hand-authored Spine-style JSON and a custom renderer are not evidence of Spine import or runtime compatibility. Report each verified surface precisely; do not silently replace unavailable authoring tools with an unverified compatibility claim.

## Output Preparation

- Deliver the source drawings, layered parts, and local rigs actually used, plus the runtime output required by the project. Baking rigged intervals and combining them with drawn frames in a PNG/WebP sequence or sheet is allowed; describe the hybrid construction accurately.
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

- Identify the reference, redrawn poses, layered parts and hidden surfaces, local rigs/weights, and timelines actually used. Check only artifacts required by the chosen methods, including boundaries where methods or sources change; metadata labels do not prove the method.
- Inspect actual playback against the current accepted reference, including motion readability, phase and loop boundaries, contacts, scale, palette, occlusion, clipping, and joint continuity. A static sheet or superseded approval does not establish success.
- Check dimensions, frame count, sheet layout, transparency, and timing against the runtime contract. Verify fixed regions only where declared and editor/runtime compatibility only on the actual target toolchain.
- For Unity installation, read back importer mode, compression, sprite rects/internal IDs, atlas settings, generated `.meta` GUID, and animation references through Unity; stop Git completion if an expected companion is absent.

## Quality Rules

- Choose and combine methods autonomously by visual outcome; simple articulation uses proper part rigs, complex motion can combine newly drawn keys and local rigs, and all frames may be redrawn when necessary.
- Judge appearance consistency and motion quality separately. A stable texture, more bones, more frames, or more generation calls does not establish natural animation.
- Use only currently valid approval evidence for the same version and property; preserve explicitly retained design or rhythm without presenting an unfinished animation as a proven workflow.
