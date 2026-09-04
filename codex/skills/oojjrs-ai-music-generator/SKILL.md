---
name: oojjrs-ai-music-generator
description: Generate and download instrumental music from ai-music-generator.ai through the dedicated Chrome profile and bundled PowerShell automation. Use when generation/download is the current explicit phase. Do not preload it for a larger game-audio editing, looping, installation, or documentation task; that task uses $oojjrs-game-audio-asset-workflow and routes here only when its paid generation phase begins.
---

# oojjrs AI Music Generator

Use the bundled `scripts/Generate-AiMusic-Chrome.ps1` with PowerShell 7 (`pwsh`). The current workspace at `/ko` uses a Rails/Hotwire `/ko/generation_tasks` form. Submit that signed-in form through the dedicated Chrome tab; do not call the removed `/api/generate` flow or reconstruct callback IDs.

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
   - Require a music description of 1-3000 characters.
   - Accept an optional title of up to 80 characters.
   - Accept an optional style of up to 1000 characters.
   - Keep instrumental mode enabled. Do not add lyrics or expose an option to disable instrumental mode.
   - Use the Description tab. Turning on Instrumental reveals Style and Title while `custom_mode` remains false; Custom Lyrics is a different mode. Only the enabled description textarea may supply the prompt.
   - Use the requested output directory. Otherwise use `$Trash` in the active workspace.

2. Run one script invocation at a time from PowerShell.

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File "<skill-dir>\scripts\Generate-AiMusic-Chrome.ps1" `
  -Prompt "<description>" `
  -Title "<title>" `
  -OutputDirectory "<absolute-output-directory>"
```

   - One form POST produces two song versions. "Two results" never means two concurrent generation requests.
   - The script holds a named process lock and calls `requestSubmit()` exactly once outside every polling loop.
   - Use `-PreflightOnly` to fill and validate the signed-in form without sending a POST or consuming credit. It checks the actual submitted Prompt, Style, Title, and instrumental values, and preserves the model selected by the site.

3. Handle the dedicated Chrome profile.
   - The script uses a persistent profile under `%LOCALAPPDATA%\AiMusicAutomation\ChromeProfile` and local debugging port `9222`. Reuse a running dedicated browser; launch it hidden by default. Pass `-ShowChrome` only when the user asks for a visible browser, such as for signing in.
   - Confirm the signed-in workspace account, not merely a username displayed on a public profile. If sign-in is needed, let the user sign in directly in the dedicated profile and then recheck it.
   - If the user instead signs in through normal Chrome, they can copy the signed-in site's Network request as cURL and tell Codex when it is copied. Use the clipboard import only for that explicit handoff.
   - Never ask the user to paste a Cookie into chat or save it to a repository file.
   - Rerun once with `-ImportCookiesFromClipboard`; omit the switch after the dedicated Chrome profile retains the session. If that import fails before submission, the existing dedicated profile may still already be authenticated.
   - Keep the dedicated Chrome process running until both results are resolved.

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
   - Report rejected, failed, canceled, unresolved, and download-failed results distinctly.
   - State whether a real generation credit was consumed.

## Safety

- A successful generation POST consumes real account credit. Execute it only when the user explicitly asks to generate music.
- The site does not reliably handle concurrent generation requests. Never start another invocation while one is generating or unresolved.
- Do not automatically repeat a generation POST after a timeout, lost response, authorization ambiguity, or Cloudflare challenge; verify the fixed result IDs and workspace first to avoid duplicate charges.
- Do not commit MP3 results, Chrome profiles, cookies, job files, or authentication logs unless the user explicitly requests those artifacts.
