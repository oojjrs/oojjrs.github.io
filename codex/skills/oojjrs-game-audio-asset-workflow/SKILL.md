---
name: oojjrs-game-audio-asset-workflow
description: Use as the primary domain for game audio tasks that include editing, looping, SFX preparation, runtime placement, preview tables, Design.html synchronization, or Unity-safe installation. Generation/download-only requests use $oojjrs-ai-music-generator. A larger integrated task switches to that generator only during its explicit generation phase, never as a preload.
---

# oojjrs Game Audio Asset Workflow

Use this as the primary domain for project-integrated game audio work. When a new paid track is explicitly required, close the current phase, route the generation phase to `$oojjrs-ai-music-generator`, then return with its downloaded results; do not preload both skills.

## Workflow

1. Read project `Design.html` only when audio affects planning state.
2. Preserve original generated/downloaded audio files.
3. Edit copies for loops, fades, cuts, previews, or runtime-ready variants.
4. For unattended effect-sound creation, prefer `ffmpeg` CLI synthesis and post-processing over GUI-only editors or generators unless the user explicitly asks for a specific tool.
5. Put temporary/intermediate audio files under `$Trash`.
6. Promote only selected final files into project asset folders.
7. Do not create or modify Unity `.meta` files. Preserve or move an existing companion, include a user- or Unity-generated in-scope companion even when untracked, and stop before commit or push when an expected companion is absent.
8. Update `Design.html` sound/BGM/effect sections when the asset inventory or preview state changes.

## Loop and SFX Checks

When a loop seam changed, check it by listening when possible or by inspecting the edited waveform and fade structure when playback is unavailable.

For SFX, choose duration, envelope, tail, loudness, and texture from the immediate gameplay or UI context; do not assume all UI feedback must be short or tail-less. When the user is not directly editing audio, use `ffmpeg` filters such as oscillators, noise sources, fades, EQ, pitch/time changes, delay, and mixing to create reviewable variants.

## Reporting

Report the final files, material result, and any unresolved listening or runtime risk. Mention source preservation or tooling only when it affected the work; do not enumerate generic validation skips.
