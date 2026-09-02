---
name: oojjrs-game-audio-asset-workflow
description: Use as the primary domain for game audio tasks that include explicitly requested free/licensable SFX sourcing, editing or looping, runtime placement, previews, Design.html synchronization, or Unity-safe installation. Requests to make, create, generate, regenerate, redesign, retry, or iterate on an SFX route directly to $oojjrs-elevenlabs-sound-effects; source selection runs only when the user explicitly asks to find or source existing audio. Never alter audio without explicit processing authorization.
---

# oojjrs Game Audio Asset Workflow

Use this as the primary domain for project-integrated game audio work. Treat a request to make, create, generate, regenerate, redesign, retry, or iterate on an SFX as ElevenLabs provider-generation intent, including short follow-up feedback inside an established generation flow. Route prompt preparation and generation directly to `$oojjrs-elevenlabs-sound-effects` without offering sourced candidates or asking the user to choose a route. Use the source-selection pass only when the user explicitly asks to find, search for, source, audition, download, or compare existing, free, licensable, or library audio. Route an explicitly requested paid music track to `$oojjrs-ai-music-generator`; do not preload a generator outside its active generation phase.

## Workflow

1. Read project `Design.html` only when audio affects planning state.
2. When the user explicitly requests existing-audio sourcing, complete the source-selection pass below before project installation or planning-document promotion. A missing approved source or unresolved style does not activate sourcing by itself. Do not edit or synthesize audio during selection.
3. Put candidate downloads, extracted packs, previews, and intermediate audio under `$Trash`.
4. For an externally sourced selection, preserve the official original download and a provenance record with the creator, title or asset ID, landing and download URLs, exact license and license URL, retrieval date, original filename, and original-versus-preview status. For an explicitly requested synthesized or recorded original, record its origin and every input-source license. Only when the user explicitly authorizes a specific processing operation, apply it to a copy.
5. Promote only selected final files into project asset folders.
6. Do not create or modify Unity `.meta` files. Preserve or move an existing companion, include a user- or Unity-generated in-scope companion even when untracked, and stop before commit or push when an expected companion is absent.
7. Update `Design.html` sound/BGM/effect sections only when the asset inventory or review state actually changes.

## Explicit Existing-SFX Source Selection

1. Translate the gameplay or UI context into audible qualities and search the existing project library plus literal and adjacent terms across action, material, mechanism, mood, and UI role. Treat user examples as search clues; do not infer hit count, spacing, duration, or looping from an example unless the user explicitly makes it a structural requirement.
2. Search reputable SFX libraries and official packs. Prefer CC0 or public-domain material; otherwise verify intended commercial use, modification, attribution, and redistribution terms from the source page or bundled license. A `free` label, search snippet, filename, rating, or download count is not license evidence.
3. Audition the actual audio. Names, descriptions, waveforms, and metadata may filter candidates but cannot establish feel. Never claim to have listened when no listening capability was used; instead provide playable previews and let the user select.
4. When style remains unresolved, present a small set of meaningfully different candidates, normally three to five, with source and license labels before any explicitly requested processing or installation. If style is already explicit and actual listening is available, Codex may select a clearly matching source; otherwise user selection is the gate. Do not promote the first plausible result or turn an illustrative example into the final design.
5. Use an official original file or pack as the selected master. A CDN preview or transcoded web preview may support auditioning but must not become the preserved source when the original is obtainable.

## Editing and Synthesis

Treat SFX processing as separately authorized work. Unless the user's current request explicitly asks for a specific SFX editing or processing operation, do not synthesize, procedurally construct, layer, mix, trim, cut, fade, EQ, filter, pitch-shift, time-stretch, resample, transcode, denoise, compress, normalize, change loudness, or otherwise alter audio bytes. A request to find, choose, download, replace, improve, fix, soften, prepare, install, or use an SFX is not processing authorization when it does not name the processing operation. In an SFX-creation context, `make`, `create`, `generate`, `regenerate`, `redesign`, `retry`, and iterative aesthetic feedback select provider generation, not local synthesis or free-library sourcing. If an available file needs processing to be usable, choose another source or ask the user first.

Without explicit processing authorization, preserve audio unchanged. For an explicit existing-audio sourcing request, select and present a suitable free/licensable official original. For an SFX creation or generation request, route directly to the applicable provider workflow and preserve its result unchanged. A generation request authorizes provider generation only; it does not authorize local waveform construction or post-processing.

Only after the user explicitly authorizes processing, prefer the minimum operation that retains the chosen character. Use `ffmpeg` for deterministic trimming, fades, resampling, EQ, pitch or time changes, layering, loudness work, and reviewable variants. Local synthesis or procedural construction also requires its own explicit current request; a failed search, a rejected candidate, aesthetic feedback, or a perceived need for a novel sound never supplies processing authorization.

When the user requests SFX creation or continues an established ElevenLabs iteration, finish this phase and route English prompt preparation plus official-skill generation to `$oojjrs-elevenlabs-sound-effects`, then return here for listening support, provenance, final selection, promotion, and project installation. Do not edit or convert the generated result unless the user separately and explicitly requests that processing.

## Loop and SFX Checks

When a loop seam changed, check it by listening when possible or by inspecting the edited waveform and fade structure when playback is unavailable.

When the user explicitly requests onset or latency correction for an input-coupled UI SFX, treat response timing as part of UX: remove baked leading silence, place the first intentional audible onset at sample zero, and put the primary feedback transient within the first few milliseconds rather than after anticipation or mechanism pre-motion. Measure the decoded PCM onset after every requested trim, tempo change, resample, or format conversion; even a sub-10 ms baked delay is not a substitute for sample-zero alignment.

For SFX, choose duration, envelope, tail, loudness, and texture from the immediate gameplay or UI context; do not assume all UI feedback must be short or tail-less. Technical waveform and loudness checks support delivery but never replace listening or user selection for an aesthetic decision. For repeated impacts from one object or mechanism, prefer one source with subtle variations unless deliberate contrast is requested.

## Reporting

During selection, report playable candidates with their source and license. After completion, report the final files, selected-source provenance, any explicitly requested material edits, and unresolved listening or runtime risk. Mention tooling only when it affected the work; do not enumerate generic validation skips.
