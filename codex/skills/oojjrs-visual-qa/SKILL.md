---
name: oojjrs-visual-qa
description: Visually verify websites, HTML planning documents, generated docs, local apps, game UI previews, image-heavy pages, and rendered frontend changes. Use when Codex must check screenshots, browser rendering, responsive layout, image loading, text overlap, canvas/3D nonblank output, color balance, or fallback static validation when browser automation is blocked.
---

# oojjrs Visual QA

Use this skill after creating or changing visual surfaces.

## Preferred Flow

1. Identify the exact surface: local app URL, `file://` HTML, generated PDF/image, or static source.
2. Start or reuse the project's normal local server only when the surface needs one.
3. Use browser or screenshot verification when available.
4. Check desktop and mobile-sized views for layout, text fit, image loading, and interaction-critical state.
5. If browser automation is blocked, fall back to static DOM/CSS checks, file metadata, image dimensions, and targeted source inspection.

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
