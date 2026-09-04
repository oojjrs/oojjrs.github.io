---
name: oojjrs-elevenlabs-sound-effects
description: Use when the user asks to make, create, generate, regenerate, redesign, retry, or iterate on an SFX. Map Korean, rough, or project-specific intent to the closest concrete sound source or physical event, explain that choice in Korean, write the provider prompt in English, and delegate generation to the official $sound-effects skill. Do not use for existing-audio sourcing, post-processing, runtime installation, or documentation.
---

# oojjrs ElevenLabs Sound Effects

Act as a thin prompt-and-routing adapter for the official ElevenLabs `$sound-effects` skill. Let that skill own current public API, SDK, CLI, parameter, and authentication mechanics; do not use private endpoints or browser scraping.

## Workflow

1. Load and follow `$sound-effects` for current ElevenLabs mechanics, including its parameter and output-format sections. Use targeted official documentation only for an unresolved detail, and reuse verified settings while the endpoint, model, and account remain unchanged in this task. If the skill is unavailable, stop and ask to install `sound-effects` from the official `elevenlabs/skills` repository.
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
3. Present the final English provider prompt, resolved parameters, and a concise Korean explanation that identifies the chosen concrete source analogy and why it matches the user's intent. Never use the English prompt itself as the user-facing explanation. When the user asks only for prompt help, stop there without consuming usage. A current explicit request to make, create, generate, regenerate, redesign, retry, or continue an established SFX-generation iteration authorizes one call when no count is stated, or the stated number of calls; do not add a duplicate confirmation gate.
4. Complete the format and playback decisions in **Output Fidelity**, then delegate exactly the authorized number of generation calls to `$sound-effects`.
   - The API returns one result per call. Never infer four calls from the website's four-preview behavior.
   - Save the untouched API response under `$Trash` in the active workspace. Receiving and saving that response is part of the generation call, not a separate browser download.
   - Present every playable candidate inline with an absolute-path audio embed, its number, and a concise Korean description; a prompt-file link alone is not a preview. Showing the generated result needs no additional confirmation. Wait for approval before copying it into a final or project directory.
   - Another variant is another usage-consuming call unless its count was already authorized. A user-requested retry is a newly authorized call.
   - Never retry an ambiguous response or a failure that could have reached generation automatically.
   - Treat an explicit pre-generation `output_format` validation rejection as not consuming the authorized generation call only when it returned no audio and no usage or cost evidence. In that narrow case, correct the format once within the existing authorization using the active endpoint's already-listed highest-quality lossless value; do not probe another unlisted value.
5. Treat generation authorization as permission only for the provider call and saving or presenting its untouched result. It also includes the header-only, sample-bit-identical PCM-to-WAV packaging required by **Output Fidelity**; treat that as result delivery rather than waveform construction or post-processing. It authorizes no other conversion or audio edit.
6. Return approved previews to `$oojjrs-game-audio-asset-workflow` for listening support, provenance, final naming, and project installation. Editing or transcoding remains blocked unless the user separately and explicitly requests that processing; header-only WAV packaging under **Output Fidelity** is the sole exception.

## Iterative Feedback

- Before revising or regenerating a candidate, maintain an internal `keep / remove / required` ledger from the user's explicit feedback. The latest explicit feedback overrides conflicting earlier feedback; preserve non-conflicting accepted qualities and hard requirements.
- Put rejected descriptors, genres, instruments, gestures, moods, and close acoustic synonyms in `remove`. Omit those concepts entirely from the next submitted prompt, including negative phrases such as `no arcade` or `not childish`; rebuild the prompt from retained and newly desired positive attributes.
- Apply rejection only to the candidate or role the user named. Do not treat silence as approval or turn one complaint into a wholesale redesign.
- Change the smallest causal dimension. For example, `too slow` changes rhythmic pace, not automatically duration; `too heavy` changes density and low-end weight, not automatically overall pitch; `unfinished` changes form, cadence, or tail, not automatically genre.
- Before each paid regeneration, compare the submitted prompt with the ledger. Do not reintroduce a removed concept through a synonym, adjacent style, or inherited phrase such as `matching the same palette` unless the user explicitly reverses that feedback.

## Output Fidelity

- Honor an explicitly requested format and never silently replace WAV or PCM with MP3. If the format is unavailable for the current account, report the entitlement boundary and let the user choose.
- Resolve format support from the exact `output_format` values exposed for the active text-to-sound-effects endpoint by the official `$sound-effects` mechanics or API schema, not from a general capabilities or marketing page. Never submit an unlisted format merely to probe support.
- Separate listed format support, account entitlement, and playback readiness. Use restrictions explicitly applicable to the active SFX endpoint or read-only account capability data; a plan name or a TTS/general format table alone does not establish an SFX limit. Mark unresolved support as unknown rather than unavailable. Do not spend generation calls on format probes.
- When no format was specified, prefer the highest-quality native WAV only when that exact WAV value is listed for the active endpoint and allowed by the account. For non-looping sound effects, prefer native 48 kHz WAV when available, and preserve the returned WAV bytes unchanged as the generation master.
- If the exact endpoint list exposes no native WAV, prefer the highest native PCM format allowed by the account, using `pcm_48000` when listed and available, and preserve that raw PCM response as the generation master. Do not silently fall back to MP3 while a lossless PCM option is available.
- Compare native sampling resolution before selecting the container: use the highest supported lossless resolution, with WAV preferred over raw PCM at equal resolution. Do not choose 24 kHz merely because it is lossless or infer that it is better than a higher-rate compressed format. Before selecting a lower rate, establish why higher listed rates are unavailable and briefly disclose the actual limitation. Never upsample a lower-rate result and describe it as higher-quality generation.
- Before submitting a paid request, settle the exact output format and the path from its response to a playable preview. For raw PCM, establish all four decoding fields required below from SFX-specific evidence; a documented SFX decoder or self-describing provider response can supply them. Reuse already established evidence instead of researching each candidate again. If decoding remains unresolved, explain the precise missing information and available delivery choice before generation; do not first spend the requested batch on raw files that cannot be played correctly.
- For a raw-PCM fallback, also create and present a playable WAV container copy by default: add only the correct WAV header, preserve the sample payload bit-for-bit, and verify that identity. Derive sample rate, channels, bit depth, and byte order only from the official API contract or authoritative response metadata; never guess missing values. If an already-received PCM result lacks verified decoding values, keep its raw master and report why a valid WAV copy could not be made; this recovery rule does not replace the pre-generation playback decision. Label a completed WAV as a container copy, not a separately generated file or an aesthetically processed result.
- A user's explicit instruction accepting an assumed decoding field applies to that authorized delivery without another confirmation. Label the assumption, preserve the PCM payload, and do not treat that exception as a verified provider contract or a default for future unrelated generations.
- Do not amplify, normalize, trim, resample, denoise, EQ, or otherwise process a generated candidate unless the user's current request explicitly asks for that exact operation. This remains true after review: rejection, aesthetic feedback, or authorization for another generation is not processing permission. Technical measurements may diagnose a bad result but must not be used to pass a processed repair off as generation quality.

## Authentication And Safety

- Use `ELEVENLABS_API_KEY` authentication as described by `$sound-effects`. If it is absent, stop before generation and direct the user to local environment setup. If the user explicitly supplies a key and directs its use on the current machine, accept that authorization and place it in the process or user-scoped environment appropriate to their setup; do not refuse solely because it appeared in chat.
- Never echo a key, put its value in a prompt or command argument, or store it in the skill, repository, generated metadata, or logs.
- Generation consumes real account usage; prompt drafting and local preview promotion do not.
- Do not claim to have auditioned audio unless an actual listening tool was used.
