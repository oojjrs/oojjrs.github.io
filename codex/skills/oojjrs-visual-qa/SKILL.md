---
name: oojjrs-visual-qa
description: Visually verify websites, HTML planning documents, generated docs, local apps, game UI previews, image-heavy pages, and rendered frontend changes. Use when the user requests rendered evidence or when layout or responsive behavior changed and static evidence cannot establish the result. Do not load it for content-only or asset-only edits with sufficient static checks.
---

# oojjrs Visual QA

Use this conditional helper when rendered evidence is requested or a changed layout or responsive rule requires it. It is not an automatic second domain after every visual edit.

## Preferred Flow

1. Identify the exact surface: local app URL, `file://` HTML, generated PDF/image, or static source.
2. Start or reuse the project's normal local server only when the surface needs one.
3. Use browser or screenshot verification when available.
4. Check desktop and mobile-sized views only when responsive or layout behavior changed or the user requested both. Otherwise inspect only the affected viewport and state.
5. If browser automation is blocked, fall back to static DOM/CSS checks, file metadata, image dimensions, and targeted source inspection.
6. For previews, review sheets, and visual QA artifacts, capture or compose from the actual surface, screenshot, generated image, accepted asset, or rendered document under test. Do not call imagegen only to make a QA preview, mockup, comparison board, or display-only visualization.

## What To Inspect

Check for:

- missing or broken images
- text overflow, clipping, or overlap
- tiny thumbnails where inspection matters
- unexpected scroll/header behavior
- hidden language selectors, nav, or controls
- one-note color palettes or accidental theme drift
- blank canvas/3D output
- hover/focus states resizing fixed-format UI

## Reporting

Report the rendered result and any material unresolved risk. Do not claim browser verification when only static evidence was used, and do not enumerate unaffected viewports or inapplicable checks.
