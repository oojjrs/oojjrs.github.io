---
name: oojjrs-game-audio-asset-workflow
description: Create, edit, install, document, and validate game audio assets for oojjrs projects. Use for BGM, loopable music copies, UI hover/click sounds, theme music, effect sounds, audio preview tables, AI-generated instrumental outputs, original-preserving edits, Design.html sound sections, and Unity-safe audio asset placement.
---

# oojjrs Game Audio Asset Workflow

Use this skill for game audio work after or alongside `$oojjrs-ai-music-generator`.

## Workflow

1. Read `$oojjrs-guidelines` and project `Design.html` when audio affects planning state.
2. Preserve original generated/downloaded audio files.
3. Edit copies for loops, fades, cuts, previews, or runtime-ready variants.
4. For unattended effect-sound creation, prefer `ffmpeg` CLI synthesis and post-processing over GUI-only editors or generators unless the user explicitly asks for a specific tool.
5. Put temporary/intermediate audio files under `$Trash`.
6. Promote only selected final files into project asset folders.
7. Do not create Unity `.meta` files.
8. Update `Design.html` sound/BGM/effect sections when the asset inventory or preview state changes.

## Loop and SFX Checks

For loopable music, check the seam by listening when possible or by inspecting waveform/fade structure when playback is unavailable.

For SFX, choose duration, envelope, tail, loudness, and texture from the immediate gameplay or UI context; do not assume all UI feedback must be short or tail-less. When the user is not directly editing audio, use `ffmpeg` filters such as oscillators, noise sources, fades, EQ, pitch/time changes, delay, and mixing to create reviewable variants.

## Reporting

Report source file, final file, whether the original was preserved, and what validation was possible.
