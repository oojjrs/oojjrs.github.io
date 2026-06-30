---
name: oojjrs-2d-sprite-animation
description: Create or revise 2D game sprite animations, sprite sheets, and preview GIFs from raster assets such as PNG sprites, layered PNG parts, or PSD-derived layers. Use when Codex is asked to animate a 2D sprite, make Unity 2D animation frames, build a sprite sheet, improve sprite animation quality, remove artifacts from generated frames, or turn a flat game asset into reusable animation parts.
---

# oojjrs 2D Sprite Animation

Use a layered-parts workflow. Do not start by slicing, warping, or spline-bending a flattened PNG directly unless the motion is a trivial whole-image transform.

## Workflow

1. Inspect the source sprite and target runtime format first.
   - Identify which pixels must stay fixed, which parts move, and which parts occlude others.
   - Preserve the existing runtime contract: frame size, sheet layout, Unity meta/import settings, animation clip references, and document previews.
   - Do not create or author new Unity `.meta` files for newly generated assets; preserve or move existing `.meta` files only if they are already present and in scope.
   - For existing text metadata or project files, preserve the current encoding and line endings exactly; do not normalize to CRLF unless that was the original state or the user asks.

2. Prefer true source layers.
   - Use PSD-derived layers or separate PNG parts when available.
   - If only a flat PNG exists, create explicit intermediate parts before animation, such as `Base`, `Pole`, `Cloth`, `Shadow`, or `Occluder`.
   - Save or inspect those parts when quality is uncertain; a bad part mask will become a bad animation.

3. Keep fixed pixels fixed.
   - Put ground, bases, shadows, and other non-moving anchors in a fixed base layer.
   - Never move a base layer just to fake secondary motion.
   - If a moving part leaves a hole in the flat source, either redraw/inpaint the hidden area or reduce the motion until no hole is exposed.

4. Animate clean parts, not shredded pixels.
   - Transform whole parts or large coherent parts with rotation, translation, scale, shear, mesh, or spline deformation.
   - Avoid per-column/per-strip slicing unless the source was designed for it or every strip overlaps enough to hide seams.
   - Keep structural pieces such as poles or handles as one part unless a real joint/bend asset exists.

5. Compose every frame from a fresh transparent canvas.
   - Draw each layer once in the intended order.
   - Use occluder layers when a fixed object must appear over a moving part.
   - Add alpha bleed to transparent pixels around moving parts before transforms to avoid dark or colored fringes.
   - Leave enough canvas padding so transformed parts do not clip.

6. Generate outputs.
   - Bake the transparent runtime sprite sheet.
   - Bake a preview GIF or PNG sequence on a non-black background that matches the design surface.
   - Keep generated frame count, columns, duration, and pivot behavior consistent with nearby project assets.

## Validation

Before calling the animation done:

- Visually inspect the sprite sheet and preview GIF.
- Check that fixed layer sample pixels are identical across frames.
- Check dimensions, frame count, and transparent background.
- Check for clipping, seams, ghosting, dark fringes, broken occlusion, and palette artifacts.
- For Unity assets, verify existing `.meta` GUIDs, sprite rects/internal IDs, and animation clip references when they already exist; do not generate missing `.meta` files.
- Run the project-appropriate diff/format checks before reporting completion.

## Quality Rules

- If artifacts appear, fix the source parts first rather than tuning transforms.
- If a flat PNG cannot be separated cleanly, redraw the missing part or simplify the motion.
- Prefer a simpler clean animation over a clever animation with visible seams, ghosts, or broken fixed pixels.
- Treat preview quality as part of the deliverable; do not rely only on file generation success.
