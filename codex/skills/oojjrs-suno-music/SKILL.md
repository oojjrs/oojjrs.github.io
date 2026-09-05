---
name: oojjrs-suno-music
description: Operate Suno's signed-in browser UI to create songs, instrumentals, and sound samples; configure Simple, Advanced, and Sounds options; use model, Audio, Voice, Inspo, lyrics, styles, exclusions, vocal, duration, and workspace controls; monitor generated variants; and play, compare, download, remix, edit, share, publish, queue, organize, or trash results. Use when Codex must interact with suno.com or manage Suno Library items. Do not use for generic songwriting advice, another music generator, local audio editing or looping, Unity installation, or game-audio asset integration.
---

# Suno Music

Operate Suno through the user's signed-in browser session with `mcp__cua_repl.js`. Keep creation, result tracking, and Suno-side follow-up actions in one workflow so that one tab, one baseline, and one credit-consuming state remain authoritative.

## Route the request

1. Use `mcp__cua_repl.js` for browser actions. On its first call or after a reset, make exactly one initialization call allowed by the tool instructions, then follow the API documentation returned by that call.
2. Read [browser-session.md](references/browser-session.md) before selecting or recovering a Suno tab.
3. Read only the references required for the requested phase:
   - Configure or generate a song or sound: [create-options.md](references/create-options.md)
   - Use Audio, Voice, recording, upload, or Inspo: [source-inputs.md](references/source-inputs.md)
   - Inspect, play, compare, download, remix, edit, publish, share, or organize results: [results-and-library.md](references/results-and-library.md)
   - Submit any generation or recover an uncertain run: [recovery-and-validation.md](references/recovery-and-validation.md)
4. Return local post-processing, looping, mastering, SFX preparation, Unity installation, and game-project integration to `$oojjrs-game-audio-asset-workflow` after the Suno phase.

## Classify the phase

- **Inspect**: Read current options, plan limits, Library state, or result metadata without changing the account.
- **Prepare**: Fill controls and validate the form without clicking a credit-consuming action. Do not scan the full Library or collect a result baseline unless the user is about to submit.
- **Generate**: Create, Remix, Extend, Cover, Remaster, Replace, Mashup, Add Vocals, Add Instrumental, or another action that may consume credits.
- **Manage**: Play, compare, download, rename, move, queue, playlist, share, publish, or trash an existing result.

Do not treat an inspection, preparation request, project goal, or old approval as authority to generate. A current request such as "generate it" or an affirmative reply to a concrete preflight authorizes the described batch once. When the request names the exact local file, Suno, and the requested generation or derivative action, it also authorizes the required upload and one submission; do not ask for the same approval again.

## Maintain one generation state

Use this state model:

`idle -> prepared -> armed -> sent -> active -> complete | unresolved`

1. When submission will occur, record the current result URLs or stable IDs immediately before submission. Skip this in a prepare-only run.
2. Configure requested options and preserve unspecified defaults.
3. Read every material setting back from the visible UI.
4. Summarize the mode, model, source inputs, lyrics mode, styles, duration, title, workspace, displayed cost, and expected output behavior.
5. Enter `armed` only with current authority for the exact credit-consuming action.
6. Click the final action once, outside any polling loop, then enter `sent`.
7. Identify new results by stable URL or ID difference. Never assume exactly two results even when Suno commonly returns two.
8. Track each result independently until playable, failed, or unresolved.

If a click may have reached Suno, never click again automatically. Inspect the Library, active placeholders, alerts, and new IDs. Leave the state `unresolved` when evidence cannot distinguish failure from delayed acceptance.

Technical completion is not musical acceptance. A ready clip, matching metadata, or a prompt echoed in the result proves delivery state only; it does not prove that the arrangement, motif, transition, instrumentation, duration, or subjective quality followed the request.

## Enforce browser and account safety

- Never request, read, copy, store, or expose passwords, default browser credentials, cookies, local storage, tokens, browser profiles, or session files. Prefer an already signed-in UI even if the user offers a cURL handoff; use an explicit handoff only as a necessary fallback allowed by the active tools.
- Use visible labels, ARIA roles, fresh DOM state, and current option values. Treat selectors and labels in references as hints, not immutable contracts.
- Follow the active CUA tool policy for file transmission, sensitive Voice data, public communication, permission prompts, CAPTCHA, and deletion. Do not repeat an approval already supplied for the exact file and action.
- Require explicit current intent for account mutations such as creating or moving a Workspace, liking, queuing, adding to a playlist, or enabling remix permissions.
- Confirm immediately before Publish, sending a share link to a third party, changing public or remix visibility, or moving a result to Trash.
- When the live UI presents a plan gate, credit warning, age or identity verification, rights or legal attestation, microphone prompt, or CAPTCHA, follow the active tool policy and hand control to the user when required.
- Never bypass a safety interstitial, paywall, regional restriction, or rights check.

## Adapt to the live UI

Suno changes labels, models, plan limits, and menu contents frequently. Discover the current mode and exposed controls first. If an option is unavailable, report whether it is hidden, disabled, plan-gated, model-gated, source-dependent, or absent. Do not simulate unsupported controls or guess coordinates when semantic evidence is missing.

After any mode, model, source, or tab change, reacquire locators and re-read dependent controls. Expanding a collapsed section is not the same as selecting an option; verify checked, selected, active, slider, text, and enabled states after each material change.

## Report the outcome

Report only what matters:

- requested settings and the settings actually verified;
- whether a credit-consuming action was prepared, sent once, completed, failed, or remains unresolved;
- every new result URL or stable ID and its independent readiness;
- downloads or account mutations actually completed;
- plan gates, user handoffs, or unverified risks that affect the result.

Do not claim that a song, upload, download, publish, or deletion succeeded from a click alone. Without an authorized audition or independent audio analysis, report configured intent and technical readiness only. Do not call a result good, faithful, seamless, or suitable from prompt text, metadata, or duration.
