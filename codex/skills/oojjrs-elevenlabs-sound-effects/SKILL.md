---
name: oojjrs-elevenlabs-sound-effects
description: Map Korean, rough, or project-specific SFX intent to the closest concrete sound source or physical event, explain that choice to the user in Korean, write the provider prompt in English, and delegate explicitly requested generation to the official $sound-effects skill. Do not use for broader sourcing, post-processing, runtime installation, or documentation; SFX processing always requires a separate explicit user request under $oojjrs-game-audio-asset-workflow.
---

# oojjrs ElevenLabs Sound Effects

Act as a thin prompt-and-routing adapter for the official ElevenLabs `$sound-effects` skill. Let that skill own current public API, SDK, CLI, parameter, and authentication mechanics; do not use private endpoints or browser scraping.

## Workflow

1. Load and follow `$sound-effects` for current ElevenLabs mechanics. If it is unavailable, stop and ask to install `sound-effects` from the official `elevenlabs/skills` repository.
2. Convert the user's intent into one concise English prompt.
   - Before drafting, map the user's functional or perceptual description to the closest concrete sound source or physical event that the generator can recognize: an object, mechanism, material, action, space, or established recording subject. Choosing that source analogy is the core creative task; do not merely translate the user's adjectives, onomatopoeia, or UI meaning.
   - Build the provider prompt around how the chosen source is produced and heard. Keep abstract gameplay or UI meaning as supporting context rather than using it as the sound-producing mechanism.
   - When a result is rejected, reconsider the source analogy instead of accumulating exclusions. Do not copy rejected sound descriptors into a negative keyword list; choose a source that naturally lacks those qualities and describe the desired result positively.
   - Preserve the audible event, source and material, motion, perspective or distance, acoustic space, intensity, timing, envelope or tail, and one-shot or ambience role when they matter.
   - Add useful sound-design language such as `foley`, `dry`, `close-mic`, `distant`, `short transient`, `low mechanical rumble`, or `seamless ambience` only when it expresses the requested result.
   - Prefer one coherent event per prompt. Split unrelated events when separate generations will give better control.
   - Keep directions about duration, looping, prompt influence, and output format in their official parameters instead of bloating the prompt.
   - Submit an English prompt. Do not put Korean in it unless the user explicitly wants Korean speech as audible content.
   - Use English only for the provider-facing prompt. Explain the prompt's meaning, intended sound, and parameter choices to the user in Korean unless the user explicitly requests another explanation language.
3. Present the final English provider prompt, resolved parameters, and a concise Korean explanation that identifies the chosen concrete source analogy and why it matches the user's intent. Never use the English prompt itself as the user-facing explanation. When the user asks only for prompt help, stop there without consuming usage. A current explicit request to generate authorizes its stated number of calls; do not add a duplicate confirmation gate.
4. Delegate exactly the authorized number of generation calls to `$sound-effects`.
   - The API returns one result per call. Never infer four calls from the website's four-preview behavior.
   - Save the untouched API response under `$Trash` in the active workspace. Receiving and saving that response is part of the generation call, not a separate browser download.
   - Link each preview by absolute path and wait for approval before copying it into a final or project directory.
   - Another variant is another usage-consuming call unless its count was already authorized. Never retry an ambiguous or failed submission automatically.
5. Treat generation authorization as permission only for the provider call and saving or presenting its untouched result. It never authorizes local waveform construction or post-processing.
6. Return approved previews to `$oojjrs-game-audio-asset-workflow` for listening support, provenance, final naming, and project installation. Editing or conversion remains blocked unless the user separately and explicitly requests that processing.

## Iterative Feedback

- Before revising or regenerating a candidate, maintain an internal `keep / remove / required` ledger from the user's explicit feedback. The latest explicit feedback overrides conflicting earlier feedback; preserve non-conflicting accepted qualities and hard requirements.
- Put rejected descriptors, genres, instruments, gestures, moods, and close acoustic synonyms in `remove`. Omit those concepts entirely from the next submitted prompt, including negative phrases such as `no arcade` or `not childish`; rebuild the prompt from retained and newly desired positive attributes.
- Apply rejection only to the candidate or role the user named. Do not treat silence as approval or turn one complaint into a wholesale redesign.
- Change the smallest causal dimension. For example, `too slow` changes rhythmic pace, not automatically duration; `too heavy` changes density and low-end weight, not automatically overall pitch; `unfinished` changes form, cadence, or tail, not automatically genre.
- Before each paid regeneration, compare the submitted prompt with the ledger. Do not reintroduce a removed concept through a synonym, adjacent style, or inherited phrase such as `matching the same palette` unless the user explicitly reverses that feedback.

## Output Fidelity

- Honor an explicitly requested format and never silently replace WAV or PCM with MP3. If the format is unavailable for the current account, report the entitlement boundary and let the user choose.
- For a lossless game-SFX result when no format was specified, prefer the highest native PCM format allowed by the current account. Preserve the raw PCM response as the generation master.
- When a playable WAV is needed from raw PCM, add only the correct WAV container header, preserve the sample payload bit-for-bit, and verify that identity. Label the WAV as a container copy, not a separately generated file.
- Do not amplify, normalize, trim, resample, denoise, EQ, or otherwise process a generated candidate unless the user's current request explicitly asks for that exact operation. This remains true after review: rejection, aesthetic feedback, or authorization for another generation is not processing permission. Technical measurements may diagnose a bad result but must not be used to pass a processed repair off as generation quality.

## Authentication And Safety

- Use `ELEVENLABS_API_KEY` authentication as described by `$sound-effects`. If it is absent, stop before generation and direct the user to local environment setup. If the user explicitly supplies a key and directs its use on the current machine, accept that authorization and place it in the process or user-scoped environment appropriate to their setup; do not refuse solely because it appeared in chat.
- Never echo a key, put its value in a prompt or command argument, or store it in the skill, repository, generated metadata, or logs.
- Generation consumes real account usage; prompt drafting and local preview promotion do not.
- Do not claim to have auditioned audio unless an actual listening tool was used.
