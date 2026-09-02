---
name: oojjrs-game-audio-asset-workflow
description: Use as the primary domain for game audio tasks that include sourcing or auditioning licensable SFX, editing, looping, SFX creation or preparation, runtime placement, previews, Design.html synchronization, or Unity-safe installation. ElevenLabs prompt preparation and generation use $oojjrs-elevenlabs-sound-effects; generation/download-only instrumental music uses $oojjrs-ai-music-generator. A larger integrated task switches to the matching generator only during its explicit phase, never as a preload.
---

# oojjrs Game Audio Asset Workflow

Use this as the primary domain for project-integrated game audio work. When paid ElevenLabs SFX or a paid music track is explicitly required, close the current phase, route prompt preparation and generation to `$oojjrs-elevenlabs-sound-effects` or `$oojjrs-ai-music-generator`, then return with the approved result; do not preload a generator.

## Workflow

1. Read project `Design.html` only when audio affects planning state.
2. When an SFX has no approved source or style and the user has not explicitly requested original construction, complete the source-selection pass below before editing, synthesis, project installation, or planning-document promotion.
3. Put candidate downloads, extracted packs, previews, and intermediate audio under `$Trash`.
4. For an externally sourced selection, preserve the official original download and a provenance record with the creator, title or asset ID, landing and download URLs, exact license and license URL, retrieval date, original filename, and original-versus-preview status. For a synthesized or recorded original, record its origin and every input-source license. Edit a copy for loops, fades, cuts, previews, mixes, or runtime-ready variants.
5. Promote only selected final files into project asset folders.
6. Do not create or modify Unity `.meta` files. Preserve or move an existing companion, include a user- or Unity-generated in-scope companion even when untracked, and stop before commit or push when an expected companion is absent.
7. Update `Design.html` sound/BGM/effect sections only when the asset inventory or review state actually changes.

## Source-First SFX Selection

1. Translate the gameplay or UI context into audible qualities and search the existing project library plus literal and adjacent terms across action, material, mechanism, mood, and UI role. Treat user examples as search clues; do not infer hit count, spacing, duration, or looping from an example unless the user explicitly makes it a structural requirement.
2. Search reputable SFX libraries and official packs. Prefer CC0 or public-domain material; otherwise verify intended commercial use, modification, attribution, and redistribution terms from the source page or bundled license. A `free` label, search snippet, filename, rating, or download count is not license evidence.
3. Audition the actual audio. Names, descriptions, waveforms, and metadata may filter candidates but cannot establish feel. Never claim to have listened when no listening capability was used; instead provide playable previews and let the user select.
4. When style remains unresolved, present a small set of meaningfully different candidates, normally three to five, with source and license labels before editing or installing one. If style is already explicit and actual listening is available, Codex may select a clearly matching source; otherwise user selection is the gate. Do not promote the first plausible result or turn an illustrative example into the final design.
5. Use an official original file or pack as the selected master. A CDN preview or transcoded web preview may support auditioning but must not become the preserved source when the original is obtainable.

## Editing and Synthesis

After the source or style is selected, prefer the minimum processing that retains the chosen character. Use `ffmpeg` for deterministic trimming, fades, resampling, EQ, pitch or time changes, layering, loudness work, and reviewable variants.

Use synthesis or generation when the user explicitly requests original construction, a targeted search finds no suitable licensable source, or the effect genuinely needs a novel or internally consistent layered design. A request to `make` or `create` an SFX does not by itself authorize paid generation or require from-scratch synthesis. When the user explicitly chooses paid ElevenLabs generation, finish this phase and route English prompt preparation plus official-skill generation to `$oojjrs-elevenlabs-sound-effects`, then return here for editing, provenance, final selection, promotion, and project installation. Ground synthesized work in auditioned references when available; unattended work is not by itself a reason to skip sourcing.

## Loop and SFX Checks

When a loop seam changed, check it by listening when possible or by inspecting the edited waveform and fade structure when playback is unavailable.

For input-coupled UI SFX, treat response timing as part of UX: remove baked leading silence, place the first intentional audible onset at sample zero, and put the primary feedback transient within the first few milliseconds rather than after anticipation or mechanism pre-motion. Measure the decoded PCM onset after every trim, tempo change, resample, or format conversion; even a sub-10 ms baked delay is not a substitute for sample-zero alignment.

For SFX, choose duration, envelope, tail, loudness, and texture from the immediate gameplay or UI context; do not assume all UI feedback must be short or tail-less. Technical waveform and loudness checks support delivery but never replace listening or user selection for an aesthetic decision. For repeated impacts from one object or mechanism, prefer one source with subtle variations unless deliberate contrast is requested.

## Reporting

During selection, report playable candidates with their source and license. After completion, report the final files, selected-source provenance, material edits, and any unresolved listening or runtime risk. Mention tooling only when it affected the work; do not enumerate generic validation skips.
