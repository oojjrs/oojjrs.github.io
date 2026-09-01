---
name: oojjrs-elevenlabs-sound-effects
description: Turn Korean, rough, or project-specific SFX requests into concise production-ready English prompts and parameters, then delegate generation to the official $sound-effects skill from ElevenLabs. Use when ElevenLabs sound-effect prompting or generation is the current explicit phase. Do not use for broader sourcing, editing, runtime installation, or documentation; that work belongs to $oojjrs-game-audio-asset-workflow.
---

# oojjrs ElevenLabs Sound Effects

Act as a thin prompt-and-routing adapter for the official ElevenLabs `$sound-effects` skill. Let that skill own current public API, SDK, CLI, parameter, and authentication mechanics; do not use private endpoints or browser scraping.

## Workflow

1. Load and follow `$sound-effects` for current ElevenLabs mechanics. If it is unavailable, stop and ask to install `sound-effects` from the official `elevenlabs/skills` repository.
2. Convert the user's intent into one concise English prompt.
   - Preserve the audible event, source and material, motion, perspective or distance, acoustic space, intensity, timing, envelope or tail, and one-shot or ambience role when they matter.
   - Add useful sound-design language such as `foley`, `dry`, `close-mic`, `distant`, `short transient`, `low mechanical rumble`, or `seamless ambience` only when it expresses the requested result.
   - Prefer one coherent event per prompt. Split unrelated events when separate generations will give better control.
   - Keep directions about duration, looping, prompt influence, and output format in their official parameters instead of bloating the prompt.
   - Submit an English prompt. Do not put Korean in it unless the user explicitly wants Korean speech as audible content.
3. Present the final English prompt and resolved parameters. When the user asks only for prompt help, stop there without consuming usage. A current explicit request to generate authorizes its stated number of calls; do not add a duplicate confirmation gate.
4. Delegate exactly the authorized number of generation calls to `$sound-effects`.
   - The API returns one result per call. Never infer four calls from the website's four-preview behavior.
   - Save the untouched API response under `$Trash` in the active workspace. Receiving and saving that response is part of the generation call, not a separate browser download.
   - Link each preview by absolute path and wait for approval before copying it into a final or project directory.
   - Another variant is another usage-consuming call unless its count was already authorized. Never retry an ambiguous or failed submission automatically.
5. Return approved previews to `$oojjrs-game-audio-asset-workflow` for listening support, editing, conversion, provenance, final naming, and project installation.

## Output Fidelity

- Honor an explicitly requested format and never silently replace WAV or PCM with MP3. If the format is unavailable for the current account, report the entitlement boundary and let the user choose.
- For a lossless game-SFX result when no format was specified, prefer the highest native PCM format allowed by the current account. Preserve the raw PCM response as the generation master.
- When a playable WAV is needed from raw PCM, add only the correct WAV container header, preserve the sample payload bit-for-bit, and verify that identity. Label the WAV as a container copy, not a separately generated file.
- Before the user reviews a generated candidate, do not amplify, normalize, trim, resample, denoise, EQ, or otherwise improve it. Technical measurements may diagnose a bad result but must not be used to pass a processed repair off as generation quality.

## Authentication And Safety

- Use `ELEVENLABS_API_KEY` authentication as described by `$sound-effects`. If it is absent, stop before generation and direct the user to local environment setup. If the user explicitly supplies a key and directs its use on the current machine, accept that authorization and place it in the process or user-scoped environment appropriate to their setup; do not refuse solely because it appeared in chat.
- Never echo a key, put its value in a prompt or command argument, or store it in the skill, repository, generated metadata, or logs.
- Generation consumes real account usage; prompt drafting and local preview promotion do not.
- Do not claim to have auditioned audio unless an actual listening tool was used.
