---
name: oojjrs-ai-music-generator
description: Generate and download instrumental music from ai-music-generator.ai through the dedicated Chrome profile and bundled PowerShell automation. Use when generation/download is the current explicit phase. Do not preload it for a larger game-audio editing, looping, installation, or documentation task; that task uses $oojjrs-game-audio-asset-workflow and routes here only when its paid generation phase begins.
---

# oojjrs AI Music Generator

Use the bundled `scripts/Generate-AiMusic-Chrome.ps1`. The current site uses Rails/Hotwire: submit its signed-in `/ko/generation_tasks` form through the dedicated Chrome tab. Do not call the removed `/api/generate` flow or reconstruct callback IDs.

## Prompt Design and Duration Experiments

Classify the request before changing the prompt:

- **Candidate diversity:** preserve every explicit or already-liked identity anchor, then vary only the dimensions the user wants explored. Conditions may differ in structure, mood, energy curve, harmony, arrangement, or palette, but do not replace a liked style or indispensable instrument set without authorization.
- **Length-only experiment:** freeze the title, core prompt language, style, mood, genre, and instrument identity. Begin with an exact-input baseline, then change only one structural or development cue per condition.
- **Exact musical continuation:** text regeneration cannot reliably preserve a specific melody or recording. When the exact musical material must survive, route to an audio-extension workflow instead of presenting prompt regeneration as continuation.

One POST produces two sibling versions of one condition.

- For four diverse candidates, normally use two intentionally different conditions and one sequential POST for each.
- For a four-song duration test, normally use one exact-input baseline pair and one minimally edited structural-variant pair. If the purpose is to measure generator randomness, repeat the exact baseline instead.
- Record the exact title, prompt, style, condition, and downloaded duration for every pair.

Treat duration as probabilistic:

- Use the user's acceptable duration range; do not hardcode a universal minimum or maximum.
- Full-piece cues such as `full soundtrack track`, development of the opening material, an evolving middle section, thematic return, and a `resolved coda` are hypotheses, not guarantees.
- Musical-form words such as `album track`, `rondo`, `theme-and-variations`, or `suite` may influence duration, but test them with replicated outputs before generalizing.
- Do not invent a new note count, mood, genre, instrument palette, or scene merely to request length.
- Direct minute counts, `long`, bar or cycle counts, and short-cue terms may be tested, but do not maintain a universal blacklist. Preserve required identity words in the baseline and test removal or replacement one variable at a time.
- Generate in English unless the user requests otherwise, measure the downloaded files, and report actual durations. Never attribute an effect to one keyword when several prompt dimensions changed together.

An audio or melody extension can succeed because of the supplied seed even when the text prompt is mediocre. Evaluate seed-based extension quality separately from fresh text-to-music prompt quality.

## Workflow

1. Resolve inputs.
   - Require a music description of 1-199 characters.
   - Accept an optional title of up to 80 characters.
   - Accept an optional style of up to 120 characters; when style is present, require a title.
   - Keep instrumental mode enabled. Do not add lyrics or expose an option to disable instrumental mode.
   - Use the requested output directory. Otherwise use `$Trash` in the active workspace.

2. Run one script invocation at a time from PowerShell.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<skill-dir>\scripts\Generate-AiMusic-Chrome.ps1" `
  -Prompt "<description>" `
  -Title "<title>" `
  -OutputDirectory "<absolute-output-directory>"
```

   - One form POST produces two song versions. "Two results" never means two concurrent generation requests.
   - The script holds a named process lock and calls `requestSubmit()` exactly once outside every polling loop.
   - Use `-PreflightOnly` to validate the signed-in form and selectors without sending a POST or consuming credit.

3. Handle the dedicated Chrome profile.
   - The script launches Chrome with a persistent profile under `%LOCALAPPDATA%\AiMusicAutomation\ChromeProfile` and local debugging port `9222`.
   - On the first machine/session, if generation is unauthorized, ask the user to sign in to `https://ai-music-generator.ai/ko/@oojjrs` in normal Chrome, copy the `@oojjrs` Network request as cURL, and tell Codex when it is copied.
   - Never ask the user to paste a Cookie into chat or save it to a repository file.
   - Rerun once with `-ImportCookiesFromClipboard`; omit the switch after the dedicated Chrome profile retains the session. If that import fails before submission, the existing dedicated profile may still already be authenticated.
   - Keep the visible dedicated Chrome window open while generation is running.

4. Wait for both results.
   - The profile groups both versions into one table row. The representative version has the play/download attributes; the other may appear only as `/ko/songs/<UUID>/edit?field=title`.
   - Discover both version IDs from the grouped row, then GET `/ko/song/<UUID>` for each version's audio URL.
   - Poll with sequential GET requests only. Never put `requestSubmit()` or another generation POST in the polling loop.
   - Download each ready MP3 immediately. Do not wait to preserve the first version until the second finishes.
   - Use the default 30-minute timeout unless the user requests another value.
   - Preserve either successful MP3 if the other result ultimately fails, and report each result separately.
   - If the submission response is lost or a result stays unresolved, do not submit again. Inspect the profile first. Use `-AcknowledgeUnresolvedGeneration` only after that read-only verification and an explicit decision to start a new paid generation.
   - If the two existing version IDs are known and only polling or download failed, recover them without a POST:

     ```powershell
     powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<skill-dir>\scripts\Generate-AiMusic-Chrome.ps1" `
       -DownloadOnlySongIds "<uuid-1>,<uuid-2>" `
       -OutputDirectory "<absolute-output-directory>"
     ```

     `-DownloadOnlySongIds` must bypass the form preflight and `requestSubmit()`, poll only the supplied song IDs, and leave `PostSent` false.

5. Report outcome.
   - Link every downloaded MP3 using absolute paths.
   - Report rejected, failed, canceled, unresolved, and download-failed results distinctly.
   - State whether a real generation credit was consumed.

## Safety

- A successful generation POST consumes real account credit. Execute it only when the user explicitly asks to generate music.
- The site does not reliably handle concurrent generation requests. Never start another invocation while one is generating or unresolved.
- Do not automatically repeat a generation POST after a timeout, lost response, authorization ambiguity, or Cloudflare challenge; verify the grouped version IDs and profile first to avoid duplicate charges.
- Do not commit MP3 results, Chrome profiles, cookies, job files, or authentication logs unless the user explicitly requests those artifacts.
