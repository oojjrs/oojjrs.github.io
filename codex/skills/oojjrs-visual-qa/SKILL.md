---
name: oojjrs-visual-qa
description: Visually verify websites, HTML planning documents, generated docs, local apps, game UI previews, image-heavy pages, and rendered frontend changes. Use when rendered visual verification is the request or a materially necessary validation gate. Do not load it automatically for every visual-file edit when the primary domain's static checks are sufficient.
---

# oojjrs Visual QA

Use this conditional helper when rendered evidence is required. It is not an automatic second domain after every visual edit.

## Preferred Flow

1. Identify the exact surface: local app URL, `file://` HTML, generated PDF/image, or static source.
2. Start or reuse the project's normal local server only when the surface needs one.
3. Use browser or screenshot verification when available.
4. Check desktop and mobile-sized views for layout, text fit, image loading, and interaction-critical state.
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

Say exactly what was verified and how. Do not claim rendered browser verification when only static checks ran.

For blocked render checks, report the blocker and the fallback evidence used.
