---
name: oojjrs-image-first-art-workflow
description: Enforce the user's image-first art workflow for any image, UI art, game asset, visual mockup, static sprite, icon-like raster asset, generated reference, or art-direction task. Use together with `imagegen` whenever Codex might create or alter visual assets, except when making 2D sprite animation. The first image/art-style pass must be imagegen; preview-only imagegen calls are forbidden; previews must come from actual generated/accepted files. ImageMagick/oxipng are the default second-pass raster tools after an acceptable imagegen result exists, while System.Drawing, PIL, canvas, SVG, HTML/CSS, and procedural/code drawing are fallback or native-source tools only.
---

# oojjrs Image-First Art Workflow

## Core Rule

For any new raster image or visual art asset, create the first aesthetic source with imagegen. This is mandatory for UI art as well as non-UI images.

Exception: do not use imagegen when the task is to make a 2D sprite animation. Animated 2D sprites require frame consistency, pivot stability, timing, hitbox/collision readability, and controllable sprite-sheet layout. Build those with sprite/animation tooling, hand-authored frames, engine timelines, pixel-art tools, or deterministic editing pipelines instead. Imagegen may be used only for separate static concept art if the user asks for it, not for generating the animation frames.

Do not use System.Drawing, PIL, canvas, SVG, HTML/CSS, ImageMagick, procedural shapes, or other deterministic drawing code as the first art pass when the user expects visual quality or art direction.

Local/code tools are allowed only after imagegen has established the art style, subject, and overall visual quality. Use those tools only to make the accepted imagegen output production-ready: exact sizing, slicing, padding, alpha cleanup, format conversion, state variants, atlas packing, masks, guides, or other deterministic post-processing.

Preview-only imagegen calls are forbidden. Result previews, contact sheets, Design.html preview images, comparison boards, review sheets, and display-only mockups must be composed from the actual generated/accepted image files with deterministic local tools. Do not call imagegen separately just to visualize, re-preview, or mock up an already generated result; use imagegen only when creating or revising source/candidate artwork.

## Recommended Local Tools

For second-pass raster work, use ImageMagick 7 (`magick.exe`) as the default local editing tool when it is installed. Use it for image inspection, resize/crop/pad/trim, alpha and mask work, compositing, contact sheets, and visual diffs. Use `oxipng.exe` for final PNG optimization after the visual output is approved.

Do not choose System.Drawing for raster editing when `magick.exe` can do the job. Keep System.Drawing only as a last-resort fallback for simple deterministic transforms when ImageMagick is unavailable, or when the project already has a native .NET image-processing path that must be preserved. Treat older skill or guideline wording that recommends System.Drawing for image editing as outdated when it conflicts with this section.

When this skill is installed through the public `codex/skills/install.ps1` script, the installer attempts to install these workstation tools with `winget`:

- `ImageMagick.ImageMagick` for `magick.exe`
- `shssoichiro.oxipng` for `oxipng.exe`

If `winget` is unavailable or installation fails, continue with available local tools and report the missing tool. Do not add ImageMagick or oxipng as project dependencies; they are workstation utilities for Codex image work.

## Temporary File Location

All image workflow temporary and intermediate files must go under a literal `$Trash` folder. This includes raw generated candidates, downloaded imagegen results, contact sheets, masks, alpha-cleanup inputs, resized/cropped variants, rejected experiments, and post-processing scratch files.

When the task has a repo or project root, use that root's `$Trash` folder. If no root is clear, use a `$Trash` folder under the current working directory or the explicitly requested output directory.

Do not create or use ad-hoc `tmp`, `temp`, `scratch`, or similarly named folders for image generation work. If a tool default points to a temp location, override it before writing files. If writing to `$Trash` is blocked, stop and report the blocker instead of silently falling back to another folder.

When writing literal `$Trash` paths in PowerShell, quote them, for example `'.\$Trash'`, so `$Trash` is not treated as a variable.

## Text Metadata Files

When image work touches existing text metadata, manifests, import settings, or project files, preserve each file's current encoding and line endings exactly. Do not normalize to CRLF unless that was the file's original state or the user explicitly asks.

When creating or exporting Unity assets, do not create or author new Unity `.meta` files. Save the asset output only; preserve or move existing `.meta` files only when they were already present and explicitly in scope.

## Required Sequence

1. Use `$imagegen` / built-in `image_gen` for the first generated image, concept, static sprite, illustration, UI art, object cutout, background, icon-like raster asset, mockup, or visual reference. Do not use imagegen for 2D sprite animation frames.
2. Inspect the generated result for style fit, subject clarity, composition, and obvious artifacts.
3. Iterate with imagegen if the art style is wrong. Do not try to rescue a bad first-pass drawing with System.Drawing or simple code effects.
4. After the imagegen result is acceptable, use local tools only for deterministic production steps: resize, crop, pad, trim, alpha cleanup, chroma-key removal, format conversion, sprite-sheet packing, atlas layout, file naming, compression, masks, guide overlays, or exact UI-size variants.
5. Build any result preview from the actual generated/accepted image files. A preview is packaging or presentation, not a reason for another imagegen call.
6. Put the final selected asset in the project or requested output location. Do not leave project-referenced assets only in a generated-images cache.

## UI Work

UI work still follows the image-first rule when visual art is involved. Exact dimensions, nine-slice borders, state slices, or engine import requirements do not justify starting with System.Drawing or another code drawing tool.

- For UI buttons, panels, icons, item art, profile frames, badges, splash screens, backgrounds, empty states, and decorative art, establish the visual style with imagegen first.
- Convert the accepted imagegen output into UI-ready assets afterward with second-pass tools: slicing, padding, size normalization, states, masks, nine-slice guides, or theme variants.
- Do not create crude placeholder art with System.Drawing just because the target is UI.
- Pure layout, typography, code-native controls, and existing SVG/icon-system extensions may be built directly in code only when they are not being used as visual art generation.

## Non-UI Work

For non-UI images, the requirement is stronger: use imagegen for the first image unless the user explicitly asks for deterministic vector/code output or an edit to an existing native source file.

Examples that require imagegen first:

- static game sprites, profile objects, tiles, backgrounds, VFX concept frames
- illustration, character, item, environment, and style exploration
- document/reference images for `Design.html`
- product/marketing/hero images
- visual comparison candidates where the user will judge art direction

## oojjrs 2D Sprite Animation Exception

Do not use imagegen to make 2D sprite animations or animation-frame sheets. This exception overrides the imagegen-first rule.

For 2D sprite animation, use tools and workflows that preserve deterministic motion and frame-to-frame consistency:

- hand-authored or edited sprite frames
- pixel-art or sprite animation tools
- engine animation timelines and flipbooks
- deterministic frame transforms from an accepted static source
- local tooling for sprite-sheet layout, pivot guides, onion-skin references, hitbox guides, and timing previews

If the task needs a static style reference for the animated sprite, imagegen can create that separate reference first. Do not turn imagegen output into the animation frame source unless the user explicitly asks for a non-production visual exploration.

## Local Raster Tools And Code Drawing

ImageMagick 7 (`magick.exe`) is the default second-pass raster editor when it is installed. System.Drawing, PIL, SharpDX, canvas, SVG, HTML/CSS, and procedural scripts are fallback or native-source deterministic tools for geometry and file preparation, not first-pass art direction.

Use them only after imagegen has produced the accepted visual source. They may reinforce, normalize, or package an imagegen result; they must not invent the initial art style, silhouette, material feel, lighting, mood, or visual quality.

Allowed second-pass uses:

- resize/crop/pad to exact dimensions
- generate contact sheets from imagegen outputs
- compose previews, comparison boards, and review sheets from actual generated/accepted image files
- trim transparent borders or add margins
- remove chroma-key backgrounds after imagegen
- pack sprite sheets or atlases
- create disabled/pressed/hover variants from an accepted base asset
- add deterministic masks, outlines, guides, or export variants

Forbidden first-pass uses:

- drawing the initial art asset with simple shapes, gradients, noise, or procedural strokes
- substituting a code-made placeholder for art that the user is meant to evaluate visually
- calling imagegen only to create a separate preview, mockup, contact sheet, comparison board, or display-only visualization
- spending iterations polishing a low-quality procedural image when imagegen should have established the style

## Exceptions

Use direct code/vector/native editing only when the task is not asking for generated visual art:

- extending an existing repo-native SVG/vector icon system
- editing a provided native design/source file where preserving exact geometry matters
- drawing simple diagrams, wireframes, or technical overlays that are not art-direction assets
- implementing UI layout around already accepted art

If there is any doubt, bias toward imagegen for the first visual asset.

## Reporting

When finishing image work, state:

- whether imagegen was used for the first art pass
- where temporary/intermediate files were kept, and confirm whether `$Trash` was used
- what second-pass tools were used, if any
- whether previews were composed from actual generated/accepted image files, if any previews were made
- where the final selected asset was saved
- whether any Unity `.meta` files were preserved or moved, and confirm no new `.meta` files were generated
- whether any placeholder/code-made visuals remain and why
