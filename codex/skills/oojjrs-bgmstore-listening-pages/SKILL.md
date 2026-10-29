---
name: oojjrs-bgmstore-listening-pages
description: Create or update local BgmStore daily and separate-batch listen pages from existing tracks, preserving saved ratings and stable track numbers through the shared player. Use for 청음 페이지, today's listening page, appending generated tracks, or a requested separate listening set. Paid generation and hosted workshop publication remain separate phases.
---

# BgmStore Listening Pages

Read and follow https://oojjrs.github.io/codex/document-writing-guideline.md before any document or HTML output. Document/page creation, code changes, synchronization, translation, and publication do not approve text. Require separate prior approval of exact new or replacement wording and placement, including headings, table columns, examples, translations, and generated output. Assume 99% refusal: ask only when omission makes the requested result impossible; otherwise omit without asking. Present indispensable wording, placement, and reason in chat and wait for explicit approval; never prefill drafts or placeholders. Inspect the builder's emitted wording before execution; do not run a build that writes unapproved titles, prompts, navigation/index labels, Markdown track links, or fallback content. Preserve existing wording in its approved scope.

Own local listening pages after audio exists. Resolve the BgmStore checkout from the project context; its usual Windows path is `H:\BgmStore`.

## Choose the Requested List

- For today's page, use the client date and root `listen-yyMMdd.html`. Read the existing page and its originating batch plan before appending. Keep its `batchId`, rating key, old conditions, song IDs and numbers; add each later request to that day's list.
- When the user requests a separate set, use that batch's `listen.html` and link it from the shared index. Keep it separate from the established Mines or TRPG library unless merging was requested.
- Reuse an existing batch directory and plan when they own the requested list. For a new mixed daily list, `Experiments/batches/AMG_Listening_yyyyMMdd` is suitable. A project-specific set can live in that project's `batches` directory.

## Prepare the Tracks

Read [listening-contract.md](references/listening-contract.md) when creating or extending batch records. Reuse the checkout's `scripts/Build-DailyListening.ps1` and `scripts/ListenerTrackNumbers.ps1`; do not copy their implementations into the skill.

1. Preserve provider IDs, version pairing, actual model, submitted mode, Instrumental flag and exact submitted text. Keep original Prompt and Style distinct from the actual submitted prompt; record what was actually sent, but display it as page text only after separate approval of the exact wording and placement. Record generation counts and credits only from confirmed provider results.
2. Add a new condition with an unused round number. Retain existing conditions and audio. Use only a separately approved exact display title for the condition; do not invent a distinguishing label or add redundant `후보 1` or `후보 2` suffixes; the player already supplies track numbers and A/B sections.
3. Keep listening audio in its batch outside `$Trash`, using the repository's local-audio ignore policy. Download logs, authentication data and task tooling stay in `$Trash`. Do not process or replace audio just to create a page.
4. Measure every new audio file by decoding its audio frames. Sum `nb_samples` and divide by the audio stream's sample rate; store `MeasuredDurationSeconds` and the sample-count provenance. AMG's arranging estimate and ffprobe's container `format.duration` can be inaccurate. Reuse unchanged files' existing decoded measurements.
5. Preserve failures and unresolved versions in the result record. Include only downloaded, playable tracks. Do not mark a partial or unresolved round complete or invent a missing sibling; the current builder skips incomplete rounds. Report that limitation if partial delivery is required.

## Build and Connect

- Run the existing builder with the resolved batch directory, requested date and desired listen path only after every new or replacement document/HTML phrase it will emit is separately approved. It maintains `results.json`, `playlist.m3u8`, `track-links.md`, the page and stable numbers in `data/listener-track-numbers.json`.
- Use shared `player/listen.css` and `player/listen.js`. Preserve their playback controls, seeking, votes, five verdicts and actual listening-time tracking. Playback counts increase after 30 seconds of listening; paused time and seeking do not count. Initial volume is 100%, and one-track repeat starts off where supported.
- Preserve an existing page's approved navigation wording. For a new page, separately approve the exact navigation label before adding the reference link labeled `청음 목록`, pointing to the same `player/index.html` through the correct relative path. Add the new page to that index and its static fallback list only with separately approved exact labels; retain existing links. Required builder output does not waive text approval.
- Root date pages with matching date-suffixed batch IDs are discovered by the existing server. Register a separate nested page in `data/listener-batches.json` so `/api/listener-votes/<batchId>` resolves it. Preserve existing registrations.
- Keep `batchId`, rating key and song IDs stable across rebuilds. Preserve `data/listener-votes/`, `player/mines-statuses.json`, votes, verdicts and play counts; saved user verdicts take precedence over generated defaults.
- Reuse `음악 작업실.bat` and the existing player server. Do not add another launcher or a separate server for a new list. If starting the requested listening service is necessary, use `player/start-player.ps1 -NoOpen` or `player/start-listener.ps1 -NoOpen` and use the origin it returns. Do not assume a port or open a browser or panel without a current request.

## Check and Deliver

Follow the canonical validation scope and budget. Check new track IDs and numbers, local audio references, decoded-duration provenance, index navigation and the registered storage identity. An available server can answer a read-only votes GET without creating test votes. Do not simulate listening or modify user assessments for validation.

Report the listening link, which track numbers were added, measured lengths, and any failures or missing files. Page creation does not authorize paid generation, audio processing, Git completion or hosted publication. Route an explicitly requested generation phase through `$oojjrs-ai-music-generator`, and hosted workshop publication through `$oojjrs-bgmstore-workshop-publishing`.
