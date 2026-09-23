---
name: oojjrs-ai-music-generator
description: Generate and download instrumental music from ai-music-generator.ai, including length experiments with description prompts or instrumental section tags in Custom Lyrics, through the dedicated Chrome profile and bundled PowerShell automation. Use when generation/download is the current explicit phase. Do not preload it for a larger game-audio editing, looping, installation, or documentation task; that task uses $oojjrs-game-audio-asset-workflow and routes here only when its paid generation phase begins.
---

# oojjrs AI Music Generator

Use the bundled `scripts/Generate-AiMusic-Chrome.ps1` with PowerShell 7 (`pwsh`). The current workspace at `/ko` uses a Rails/Hotwire `/ko/generation_tasks` form. Submit that signed-in form through the dedicated Chrome tab; do not call the removed `/api/generate` flow or reconstruct callback IDs.

## Prompt Design and Duration Experiments

Before developing or revising music prompts for oojjrs, read [music-direction.md](references/music-direction.md) for the reusable musical brief, reference provenance, and narrative experiments. Preserve an explicitly requested exact input instead of silently applying a different preference preset. This reference guides both AMG and Suno; provider operations remain in their own skills.

Classify the request before changing the prompt:

- **Candidate diversity:** preserve every explicit or already-liked identity anchor, then vary only the dimensions the user wants explored. Conditions may differ in structure, mood, energy curve, harmony, arrangement, or palette, but do not replace a liked style or indispensable instrument set without authorization.
- **Length-only experiment:** freeze the title, core prompt language, style, mood, genre, and instrument identity. Begin with an exact-input baseline, then change only one structural or development cue per condition.
- **Exact musical continuation:** text regeneration cannot reliably preserve a specific melody or recording. When the exact musical material must survive, route to an audio-extension workflow instead of presenting prompt regeneration as continuation.

One POST produces two sibling versions of one condition.

- For four diverse candidates, normally use two intentionally different conditions and one sequential POST for each.
- For a four-song duration test, normally use one exact-input baseline pair and one minimally edited structural-variant pair. If the purpose is to measure generator randomness, repeat the exact baseline instead.
- Record the exact title, prompt, style, input mode, Instrumental flag, condition, and downloaded duration for every pair.

Treat duration as probabilistic:

- Use the user's acceptable duration range; do not hardcode a universal minimum or maximum.
- Full-piece cues such as `full soundtrack track`, development of the opening material, an evolving middle section, thematic return, and a `resolved coda` are hypotheses, not guarantees.
- Musical-form words such as `album track`, `rondo`, `theme-and-variations`, or `suite` may influence duration, but test them with replicated outputs before generalizing.
- Do not invent a new note count, mood, genre, instrument palette, or scene merely to request length.
- Direct minute counts, `long`, bar or cycle counts, and short-cue terms may be tested, but do not maintain a universal blacklist. Preserve required identity words in the baseline and test removal or replacement one variable at a time.
- Generate in English unless the user requests otherwise, measure the downloaded files, and report actual durations. Never attribute an effect to one keyword when several prompt dimensions changed together.

For a requested Custom Lyrics experiment, put arrangement directions in square brackets, for example `[Instrumental]`, `[Verse 1: instrumental brass melody over driving drums]`, `[Chorus: instrumental return of the main theme]`, and `[Bridge: extended instrumental development]`. Each nonempty line must be one bracketed direction. Preserve the liked instrument palette and use successive sections to develop and reprise the material. Tags are model hints, not a duration guarantee; do not infer that a long file is vocal-free or musically faithful from metadata alone. Compare actual outputs before recording a technique as successful. For the reusable form and observed limits, read [references/instrumental-sections.md](references/instrumental-sections.md).

An audio or melody extension can succeed because of the supplied seed even when the text prompt is mediocre. Evaluate seed-based extension quality separately from fresh text-to-music prompt quality.

## Workflow

1. Resolve inputs.
   - Use `-InputMode Description` by default with a music description of 1-3000 characters. Use `-InputMode InstrumentalSections` for a requested Custom Lyrics arrangement experiment, with 1-5000 characters of bracketed section and performance directions.
   - In Custom Lyrics mode, accept an optional title of up to 80 characters and a required style of up to 1000 characters. The current Description form disables Title and Style; leave both empty there rather than claiming they will be submitted.
   - In Description mode, keep the Instrumental checkbox enabled. InstrumentalSections intentionally turns it off because this site hides and disables the lyrics field while Instrumental is enabled. The intended output remains instrumental: require a nonempty Style and bracket-only directions, with no sung lyric lines. Explain the mode change and assess unwanted vocals separately from duration.
   - Description uses `custom_mode=false` and the enabled description textarea. InstrumentalSections uses the Custom Lyrics tab, `custom_mode=true`, and the enabled lyrics textarea. Validate the actual submitted mode, Instrumental flag, and single prompt field; never force a disabled field into the form.
   - Use the requested output directory. Otherwise use `$Trash` in the active workspace.

2. Connect the dedicated Chrome profile.
   - The browser uses `%LOCALAPPDATA%\AiMusicAutomation\ChromeProfile` and local CDP port `9222`. It has its own persistent cookies; do not assume the user's ordinary Chrome session is shared.
   - When sign-in is needed and the user wants a visible browser, run the bundled opener once. It opens the AMG workspace in the dedicated profile only if that browser is not already running; it does not submit a generation request. Let the user sign in there, then run the generation script's `-PreflightOnly` check to confirm the workspace account.

     ```powershell
     pwsh -NoProfile -ExecutionPolicy Bypass -File "<skill-dir>\scripts\Open-AiMusic-Chrome.ps1"
     ```

   - Reuse the running dedicated browser for later work. The opener and generator verify that port `9222` belongs to the configured profile before using it; if another process owns that port, stop instead of attaching to it.
   - If a dedicated browser is already running but its window is hidden, the opener only reports its status. Let the user reveal that browser for sign-in rather than changing desktop focus on their behalf.
   - If no dedicated browser is running, the generator can start it hidden with the saved profile. Use the visible opener for sign-in; do not try to control a hidden window with desktop input.
   - Routine generation runs through background CDP in that dedicated profile. Do not send system mouse or keyboard input, activate windows, or switch the user's ordinary Chrome tabs. Do not use CUA or Windows UI Automation for this workflow unless the user explicitly chooses foreground control.
   - If the user instead explicitly hands off a signed-in Network request from ordinary Chrome as cURL through the clipboard, `-ImportCookiesFromClipboard` is available once. Never ask the user to paste a Cookie into chat or save it to a repository file.
   - Keep the dedicated Chrome process running until both results are resolved.

3. Run a preflight, then one paid script invocation at a time from PowerShell.

   - First run the same command with `-PreflightOnly`. It fills and validates the signed-in form without sending a POST or consuming credit. Check `Ready: true`, `PostSent: false`, input mode, Instrumental flag, and active fields. The script preserves the model selected by the site.

   ```powershell
   pwsh -NoProfile -ExecutionPolicy Bypass -File "<skill-dir>\scripts\Generate-AiMusic-Chrome.ps1" `
     -Prompt "<description>" `
     -OutputDirectory "<absolute-output-directory>" `
     -PreflightOnly
   ```

   - After a successful preflight, run that command once without `-PreflightOnly` for the requested generation. If the user left the style open, choose one coherent direction from [music-direction.md](references/music-direction.md) and make one prompt; do not spend another credit merely to explore styles.
   - One form POST produces two song versions. "Two results" never means two concurrent generation requests.
   - The script holds a named process lock and calls `requestSubmit()` exactly once outside every polling loop.

4. Wait for both results.
   - The workspace lists each version separately and exposes song IDs even while queued. Capture a baseline before submitting; identify new owned songs whose exact prompt and supplied title match this request, then freeze the two result IDs. Stop on an ambiguous set instead of mixing in other songs.
   - Read `/ko/song/<UUID>` for each fixed result's audio URL. A duration displayed while arranging does not mean the downloadable file is ready.
   - Poll with sequential GET requests only. Never put `requestSubmit()` or another generation POST in the polling loop.
   - Download each ready MP3 immediately. Do not wait to preserve the first version until the second finishes.
   - Use the default 30-minute timeout unless the user requests another value.
   - Preserve either successful MP3 if the other result ultimately fails, and report each result separately.
   - If the submission response is lost or a result stays unresolved, do not submit again. Inspect the workspace and existing request state first. Use `-AcknowledgeUnresolvedGeneration` only after that read-only verification and an explicit decision to start a new paid generation.
   - If the two existing version IDs are known and only polling or download failed, recover them without a POST:

     ```powershell
     pwsh -NoProfile -ExecutionPolicy Bypass -File "<skill-dir>\scripts\Generate-AiMusic-Chrome.ps1" `
       -DownloadOnlySongIds "<uuid-1>,<uuid-2>" `
       -OutputDirectory "<absolute-output-directory>"
     ```

     `-DownloadOnlySongIds` must bypass the form preflight and `requestSubmit()`, poll only the supplied song IDs, and leave `PostSent` false.

5. Report outcome.
   - Link every downloaded MP3 using absolute paths.
   - Measure each downloaded MP3 with `ffprobe` (or equivalent) and report actual duration, not the arranging page's estimate.
   - Report rejected, failed, canceled, unresolved, and download-failed results distinctly.
   - State whether a real generation credit was consumed.

## Safety

- A successful generation POST consumes real account credit. Execute it only when the user explicitly asks to generate music.
- The site does not reliably handle concurrent generation requests. Never start another invocation while one is generating or unresolved.
- Do not automatically repeat a generation POST after a timeout, lost response, authorization ambiguity, or Cloudflare challenge; verify the fixed result IDs and workspace first to avoid duplicate charges.
- Do not commit MP3 results, Chrome profiles, cookies, job files, or authentication logs unless the user explicitly requests those artifacts.
