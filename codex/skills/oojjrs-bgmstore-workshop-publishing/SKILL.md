---
name: oojjrs-bgmstore-workshop-publishing
description: Publish existing BgmStore music to the private music workshop Site. Use when the user asks to add tracks to the workshop, update its hosted catalog, upload its audio, or verify a workshop release. Music generation and game asset installation remain separate phases.
---

# BgmStore Music Workshop Publishing

Use this skill for the BgmStore repository's hosted music workshop. A track is published only when its local record, deployed Site code, stored audio, active library, and requested player grouping agree. A successful Site deployment alone does not make a new track playable.

## Resolve the release

1. Identify the exact requested tracks by stable track ID and inspect the BgmStore working tree before writing. Preserve existing and concurrent changes. Read `README.md`, `publication/selection.json`, `publication/deployment.json`, `publication/site/.openai/hosting.json`, and the current Site source rather than assuming an old project ID, track count, token, or URL.
2. Confirm each chosen audio file is complete and nonempty. Record its source, SHA-256, byte size, and decoded duration. Keep original audio unchanged; a format conversion needs its own reason and verification.
3. Promote temporary results to a durable BgmStore location and update only the requested tracks in the repository's catalog, player library, publication selection, batch record, and inventory as applicable. Preserve stable IDs, existing order, and unrelated metadata. Update `Design.html` only when the project's planning record actually changes. Check that each selected ID resolves to exactly one local file.

## Prepare and deploy the Site

1. Read the selected Site's current source and deployment state through the Sites tools. Preserve its owner-only audience. Use `$sites-hosting` for the Site checkout, build, source push, version save, private deployment, and deployment status; do not rebuild that workflow as ad hoc shell commands. Keep the BgmStore repository and the Site source checkout as distinct Git scopes.
2. Extend the Site's full library and media-size manifest for only the requested tracks. Use the SHA-256-based media filename required by the current worker and check it against the actual file. Preserve existing bootstrap entries, player assets, and every other library row. Build against the current source and inspect the generated library and media manifest before saving a version.
3. Keep source-repository credentials and runtime import tokens in tool session memory or hidden stdin. Never put them in tracked files, command arguments, tool output, or chat. Reuse the current import token when available; if a rotation is necessary, verify the new value is active and report that any existing uploader using the old token must be updated.
4. Save and deploy the verified build as a private Site version. Wait for a successful deployment status before importing audio. Do not claim publication from an archive, source commit, or pending deployment alone.

## Import, activate, and verify

1. Inspect the worker's current import contract before calling it. For the present BgmStore worker, `/api/import/status` lists stored media, `PUT /api/import/<hash>.<extension>` checks expected size and SHA-256, and `POST /api/import/activate` activates the full library only when all expected media are present. Upload only missing content-addressed files. After an interrupted request, inspect status before any retry.
2. Verify each upload response against the local filename, byte size, and SHA-256. Activate the library only after every expected media object is present. Read `/api/library` after activation and verify the requested IDs, total count, and audio URLs. Download each newly published file through the Site and compare its SHA-256 with the local upload source; check a playable range response when relevant.
3. Read `/api/preferences` before changing player groups or playlists. Apply only the grouping the user requested or the verified convention for the chosen tracks, keeping all existing rank overrides, group overrides, and custom playlists. Read preferences again and compare both the requested result and the preserved settings. Never replace the entire preference object from a stale local snapshot.
4. Update `publication/deployment.json` only from verified Site version, storage, library, and preference results. Report the Site URL, published track IDs or titles, playable status, and any incomplete step separately. Local BgmStore Git completion follows the current request and `$oojjrs-project-finish-work`; Site publication does not silently include unrelated repository changes.

## Boundaries

- An instruction to publish existing tracks does not authorize another paid generation request. Use `$oojjrs-ai-music-generator` or `$oojjrs-suno-music` only for a separately requested generation phase.
- Do not use CUA, UIA, foreground browser control, or the user's active desktop. If the Site cannot be reached through background tools or APIs, report the blocker.
- Do not repeat a Site save/deploy or media upload after an uncertain response without checking the corresponding version, deployment, or storage state first.
