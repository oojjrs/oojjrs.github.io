# Source Inputs

Read this reference before using Audio, Voice, recording, uploads, Inspo, or Custom Models.

## Common boundary

1. Identify the exact source and intended Suno operation.
2. Read the file-upload API documentation returned by the current CUA runtime before any upload.
3. A current request that names the exact local file, Suno, and requested generation or derivative action authorizes that required upload; do not ask for the same approval again. Obtain current approval when the source, destination, or purpose is still ambiguous.
4. Verify that the user owns or has permission to use the source. Never dismiss or satisfy a rights attestation on an assumption.
5. Read the live dialog's plan, duration, format, age, region, identity, and usage restrictions. Official Suno pages can conflict; the current account UI wins.
6. Verify upload or selection completion before enabling generation.

## Audio

The current `Audio` control can expose Browse, Upload, and Record.

- **Browse**: Select an existing eligible Library item without revealing unrelated private items.
- **Upload**: Use the exact user-approved local file. Do not search broadly for alternatives. When the explicit request already identifies the file and Suno action, assign it without another confirmation.
- **Record**: Confirm before accepting microphone permission. Let the user take over when they must perform the recording or rights confirmation.

An uploaded clip becomes a remote Library item. Record its resulting stable ID when needed. If Audio Influence appears, set and verify it only after the source is attached.

Attaching Audio to the current Advanced form can default the derivative type to **Cover**. For an Extend request, open the visible `Cover에서 조건 유형 변경` menu, select `연장`, and verify the resulting Extend form before continuing. Preserve the form's existing **Extend from** value unless the user requested another point; the observed source can show `24.0`, which is source-specific rather than a universal default.

An attached source can auto-fill Lyrics and Styles with distorted or irrelevant text. Inspect both fields after attachment. When the user supplied instrumental bracket instructions and a Style, replace the auto-filled values with that exact content and read them back before submission. Do not add guessed BPM, key, instruments, or other musical facts.

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
