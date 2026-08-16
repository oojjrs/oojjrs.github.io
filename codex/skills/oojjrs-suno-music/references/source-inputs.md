# Source Inputs

Read this reference before using Audio, Voice, recording, uploads, Inspo, or Custom Models.

## Common boundary

1. Identify the exact source and intended Suno operation.
2. Read the Chrome skill's file-upload documentation before any upload.
3. Confirm at action time before transmitting a local file, recording, Voice profile, or other sensitive source to Suno. State the exact data, destination, and purpose.
4. Verify that the user owns or has permission to use the source. Never dismiss or satisfy a rights attestation on an assumption.
5. Read the live dialog's plan, duration, format, age, region, identity, and usage restrictions. Official Suno pages can conflict; the current account UI wins.
6. Verify upload or selection completion before enabling generation.

## Audio

The current `Audio` control can expose Browse, Upload, and Record.

- **Browse**: Select an existing eligible Library item without revealing unrelated private items.
- **Upload**: Use the exact user-approved local file. Do not search broadly for alternatives. Confirm before assigning it to the file chooser because that transmits it to Suno.
- **Record**: Confirm before accepting microphone permission. Let the user take over when they must perform the recording or rights confirmation.

An uploaded clip becomes a remote Library item. Record its resulting stable ID when needed. If Audio Influence appears, set and verify it only after the source is attached.

Do not encode fixed upload-duration limits. The current pricing page and older help pages disagree; read the active upload dialog.

## Voice

The current Voice surface may use the older `Personas` dialog title while explaining that Personas are now Voices. It can expose My Voices, Favorites, Search, recording, and upload.

- Treat a Voice profile and source recording as sensitive personal data.
- Confirm immediately before selecting or transmitting a specific Voice for a generation. Name the Voice only as much as needed for disambiguation.
- Hand control to the user for live voice capture, phrase reading, age or identity verification, rights attestation, or microphone interaction.
- Verify v5.5, regional, plan, duration, and eligibility requirements from the live UI.
- Warn before public or link sharing with remix permission: another user may be able to reuse the generated voice in a Remix or Cover.
- Never infer consent to create a reusable Voice profile from consent to generate one song.

## Inspo

Inspo selects one of the user's own playlists to influence mood, tempo, and instrumentation.

1. Open the playlist dialog and inspect only enough private metadata to identify the requested playlist.
2. Require a playlist with eligible user-owned songs; current official guidance recommends a small coherent set.
3. Select the exact playlist and verify the attached Inspo state.
4. Keep current Lyrics and Styles as separate controls; Inspo does not grant permission to overwrite them.

## Custom Model

Treat `Create Custom Model` as a separate, explicit workflow. Current UI can display an upload-song requirement and a credit cost.

- Confirm the source songs, ownership, displayed cost, plan access, and training action immediately before submission.
- Do not assume a fixed song count, cost, preparation time, or model limit; read the live dialog.
- Keep the trained model private unless the user explicitly requests and confirms a visibility change.

## Official references

- Audio upload: https://help.suno.com/en/articles/6141569
- Current plan limits: https://suno.com/pricing
- Voices: https://help.suno.com/en/articles/11362369
- Voices FAQ: https://help.suno.com/en/articles/11362433
- Inspo: https://help.suno.com/en/articles/6882753
