---
name: oojjrs-image-first-art-workflow
description: Enforce imagegen-first creation or revision of general raster art, UI art, static sprites, icon-like assets, references, and art-direction visuals. Do not use for 2D sprite animation, H:\Mines work covered by $oojjrs-mines-art-asset-pipeline, pure HTML/CSS layout, code-native controls, or an existing SVG/vector system. Preview-only imagegen calls are forbidden; deterministic tools are second-pass only.
---

# oojjrs Image-First Art Workflow

## Scope And Source

Use `$imagegen` / built-in `image_gen` to create the first aesthetic source for new or revised general raster art, including UI art, static sprites, object cutouts, backgrounds, illustrations, marketing images, `Design.html` references, mockups, and art-direction candidates. This is mandatory whenever the user evaluates style, silhouette, material, lighting, mood, or visual quality.

Do not establish that source with System.Drawing, PIL, SharpDX, canvas, SVG, HTML/CSS, ImageMagick, procedural shapes, gradients, noise, or a code-made placeholder. Exact dimensions, nine-slice borders, state slices, and engine import requirements do not exempt UI art. If the accepted style, subject, composition, or artifacts need artistic revision, iterate with imagegen rather than polishing a weak procedural substitute.

Direct code, vector, or native-source editing is allowed when the task instead extends an existing SVG/vector system, preserves exact geometry in a provided native source, draws a non-art diagram/wireframe/technical overlay, implements layout or typography around accepted art, builds code-native controls, or explicitly requests deterministic vector/code output. `H:\Mines` art routes to `$oojjrs-mines-art-asset-pipeline`. When the distinction is uncertain, use imagegen for the first visual asset.

## 2D Sprite Animation Exception

Never use imagegen to create 2D sprite animation frames or frame sheets. Use hand-authored or edited frames, pixel/sprite tools, engine timelines or flipbooks, deterministic transforms from an accepted static source, and local layout/guide tooling so frame consistency, pivots, timing, hitbox or collision readability, onion-skin references, and sheet layout remain controllable.

Imagegen may create a separate static style reference only when requested; it must not generate or become production animation frames. Any explicitly requested imagegen-based animation exploration remains non-production.

## Production Sequence

1. Generate the first source or candidate with imagegen, then inspect style fit, subject clarity, composition, and visible artifacts.
2. Iterate artistically with imagegen until the source is acceptable.
3. Use deterministic tools only afterward for production work: inspect, resize, crop, pad, trim, slice, normalize, clean alpha or chroma key, convert formats, name or compress files, composite, pack sheets or atlases, add masks/outlines/guides/nine-slice guides, or derive exact-size, theme, disabled, pressed, and hover variants.
4. Put the selected final asset in the project or requested output location; do not leave a project reference pointing only to a generated-image cache.

Preview-only imagegen calls are forbidden. Compose previews, contact sheets, `Design.html` previews, comparison or review boards, visual diffs, and display-only mockups from the actual generated or accepted files with deterministic tools. Imagegen is only for creating or artistically revising source or candidate artwork.

## Local Tools

Use ImageMagick 7 (`magick.exe`) as the default second-pass raster tool when installed, and `oxipng.exe` for final PNG optimization after visual approval. Use System.Drawing only for simple deterministic transforms when ImageMagick is unavailable or when preserving an existing native .NET image path; conflicting older recommendations are outdated. Other code tools remain limited to deterministic preparation or native-source work.

The public installer attempts to install `ImageMagick.ImageMagick` and `shssoichiro.oxipng` with `winget`. If that is unavailable or fails, continue with available tools and report the missing utility. These are workstation utilities, never project dependencies.

## Temporary Files

Put every temporary or intermediate image file under a literal `$Trash` folder directly under the repository or project root, including raw or downloaded candidates, rejected experiments, contact sheets, masks, cleanup inputs, previews, and resized, cropped, or post-processed variants. Resolve the root before creating temporary files; if no root is clear, stop instead of using the current or output directory.

Do not create ad-hoc `tmp`, `temp`, or `scratch` folders. Override a tool's temp default before it writes; if `$Trash` is blocked, stop and report the blocker. Quote literal PowerShell paths such as `'.\$Trash'` so `$Trash` is not expanded as a variable.

## Unity Metadata

When creating or exporting Unity assets, do not create or modify `.meta` files. Preserve or move an existing companion with its asset, include an in-scope companion generated by the user or Unity even when it is new or untracked, and stop before commit or push if an expected companion is absent.

## Reporting

Report the selected output path, the material result, and any unresolved visual or runtime risk. Mention temporary files, second-pass tools, preview construction, Unity metadata, or remaining placeholders only when they were actually involved or affect the result; do not enumerate inapplicable checks.
