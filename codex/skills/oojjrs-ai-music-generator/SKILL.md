---
name: oojjrs-ai-music-generator
description: Generate and download instrumental music from ai-music-generator.ai through a dedicated Chrome debugging profile and the bundled PowerShell automation. Use when Codex is asked to create AI background music, instrumental tracks, game music, or multiple downloadable MP3 results on the user's oojjrs account, including requests that specify a description, title, style, output folder, or generation timeout.
---

# oojjrs AI Music Generator

Use the bundled `scripts/Generate-AiMusic-Chrome.ps1`. Do not reimplement the private API or send it through plain PowerShell HTTP; Cloudflare blocks non-browser generation requests.

## Workflow

1. Resolve inputs.
   - Require a music description of 1-199 characters.
   - Accept an optional title of up to 80 characters.
   - Accept an optional style of up to 120 characters; when style is present, require a title.
   - Keep instrumental mode enabled. Do not add lyrics or expose an option to disable instrumental mode.
   - Use the requested output directory. Otherwise use `$Trash` in the active workspace.

2. Run the script from PowerShell.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<skill-dir>\scripts\Generate-AiMusic-Chrome.ps1" `
  -Prompt "<description>" `
  -Title "<title>" `
  -OutputDirectory "<absolute-output-directory>"
```

3. Handle the dedicated Chrome profile.
   - The script launches Chrome with a persistent profile under `%LOCALAPPDATA%\AiMusicAutomation\ChromeProfile` and local debugging port `9222`.
   - On the first machine/session, if generation is unauthorized, ask the user to sign in to `https://ai-music-generator.ai/ko/@oojjrs` in normal Chrome, copy the `@oojjrs` Network request as cURL, and tell Codex when it is copied.
   - Never ask the user to paste a Cookie into chat or save it to a repository file.
   - Rerun once with `-ImportCookiesFromClipboard`; omit the switch after the dedicated Chrome profile retains the session.
   - Keep the visible dedicated Chrome window open while generation is running.

4. Wait for both results.
   - The service may temporarily omit one callback ID from the profile response and expose it again later.
   - Do not treat temporary absence as failure and do not stop after the first successful song.
   - Use the default 30-minute timeout unless the user requests another value.
   - Preserve either successful MP3 if the other result ultimately fails, and report each result separately.

5. Report outcome.
   - Link every downloaded MP3 using absolute paths.
   - Report rejected, failed, canceled, unresolved, and download-failed results distinctly.
   - State whether a real generation credit was consumed.

## Safety

- A successful generation POST consumes real account credit. Execute it only when the user explicitly asks to generate music.
- Do not automatically repeat a generation POST after a timeout, lost response, authorization ambiguity, or Cloudflare challenge; verify callback IDs and the profile first to avoid duplicate charges.
- Do not commit MP3 results, Chrome profiles, cookies, job files, or authentication logs unless the user explicitly requests those artifacts.