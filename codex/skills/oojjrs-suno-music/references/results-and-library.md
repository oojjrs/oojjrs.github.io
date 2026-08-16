# Results and Library

Use stable song URLs or IDs as result identity. Never treat list position, title, artwork, or a click alone as proof of completion.

## Contents

- [Track a generation](#track-a-generation)
- [Play and compare](#play-and-compare)
- [Download](#download)
- [Remix and edit](#remix-and-edit)
- [Share and publish](#share-and-publish)
- [Organize and delete](#organize-and-delete)
- [Report](#report)

## Track a generation

1. Capture every existing `/song/<id>` URL before submission.
2. After the single final click, watch for placeholders, disabled Play buttons, alerts, and new `/song/<id>` URLs.
3. Compute the new-ID difference instead of assuming the number or order of results.
4. Mark a result ready only when its stable link exists and its Play control is enabled or another authoritative completion signal is visible.
5. Preserve completed variants even if another variant fails or remains unresolved.

Prefer the clip's persistent status and combined UI evidence over one permissive control. A stable ID with `data-clip-status="streaming"`, a spinner, or disabled Remix remains active even when its Play surface exposes `aria-disabled="false"`. Do not resubmit it. If it later completes, report its actual duration even when it differs sharply from the requested target.

If the page is filtered, paginated, or sorted away from new items, use one focused change to expose the newest relevant results, then verify by ID. Do not clear unrelated user filters without a task-specific reason.

## Play and compare

Playback and visible metadata inspection are read-only. Compare variants by:

- duration and readiness;
- adherence to lyrics, style, exclusions, source, and target duration;
- arrangement, hook, transitions, artifacts, and ending quality;
- user-requested musical acceptance criteria.

Do not start unexpected audible playback merely to prove readiness. When auditioning is requested, play one identified result at a time and report which URL is active.

Prompt text, Styles, exclusions, tags, title, and duration prove requested inputs, not audible adherence. Do not evaluate motif retention, transition quality, instrumentation, energy, or aesthetic fit without an authorized audition or independent audio analysis. If the user declines agent playback, provide the stable links and wait for their acceptance before selecting a winner or chaining another derivative.

## Download

1. Open the identified result's current Download menu.
2. Read live format, plan, quota, and warning text.
3. Choose only the requested format. Current documentation generally exposes MP3 broadly and gates WAV or video by plan, but the live menu is authoritative.
4. Use the browser's supported download flow and verify the completed local file by exact path, nonzero size, and expected extension.
5. Do not overwrite an existing file silently. Preserve the original generated download for any later editing workflow.

If the UI presents a consumptive download allowance or purchase, summarize it and obtain current authority before consuming or buying it.

## Remix and edit

The live `...` menu can expose Remix and Edit families. Discover current items rather than assuming a fixed submenu. Official Suno workflows can include:

- Cover;
- Extend and Get Whole Song;
- Reuse Prompt or Use Styles and Lyrics;
- Adjust Speed;
- Crop;
- Replace Section;
- Song Editor and Quick Replace;
- edit displayed lyrics;
- Remaster with available variation strength;
- Sample;
- Mashup;
- Add Vocals or Add Instrumental.

Distinguish metadata-only edits from audio-generating edits. Displayed-lyrics edits do not change sung audio. Most audio variants create remote results and may consume credits.

For any generative derivative:

1. identify the exact source song URL;
2. read remix permission, attribution, plan, commercial-use, Voice, and public-visibility warnings;
3. record the pre-action result baseline;
4. configure and read back every derivative option;
5. obtain authority for that exact action;
6. submit once and track new IDs independently.

Do not treat permission to create an original song as permission to Remix, Extend, Remaster, or add vocals afterward.

### Identity-sensitive Extend

Treat Extend as generative continuation, not deterministic arrangement editing. Bracket tags, high Audio Influence, low Weirdness, exclusions, and short requested duration can guide a batch, but none guarantees preservation of the source motif, timbre, mix, energy, or join.

- State this limitation when exact identity is a primary acceptance criterion.
- For staged expansion, submit one batch for one stage, then stop for audition and explicit source selection before Get Whole Song or the next Extend. A technically complete but rejected stage must not become the next source.
- Change one meaningful control axis between diagnostic batches when possible; do not combine many prompt, slider, source-point, and duration changes and then claim to know which one helped.
- After repeated identity drift or user rejection, stop paid prompt-chasing. Offer Song Editor or Replace Section for a localized repair, or return exact motif preservation, stem rearrangement, looping, and deterministic assembly to `$oojjrs-game-audio-asset-workflow`.

## Share and publish

- **Copy or expose a link**: Verify the result and current visibility. Copying a link does not itself make a song Public, but sending it transmits access to the recipient.
- **Share to a third party**: Confirm at action time with the exact song, recipient or destination, and visibility implication.
- **Publish or set Public**: Confirm at action time. Verify the final Public state from the page; do not infer it from a click or toast alone.
- **Allow Remixes or Voice reuse**: Treat as a separate visibility and reuse decision. Explain that other users may reuse eligible material, including Voice output.

New songs can be Link Only rather than private in the strict access-control sense. Do not promise confidentiality beyond the visibility shown by Suno.

## Organize and delete

Current Library or result menus can expose Edit title/details, Like, Dislike, Add to Queue, Add to Playlist, Song Radio, Workspace move, filters, and Move to Trash.

- Require explicit current intent before any remote mutation.
- Scope edits and moves by stable song ID, not duplicate title.
- Verify the resulting title, destination, membership, or toggle state.
- Confirm immediately before Move to Trash. Never batch-delete from a broad filter or guessed selection.
- Treat recovery from Trash as uncertain unless the live UI proves it is available.

## Report

Return each result independently with title, stable URL, duration when visible, readiness, requested mutation, and verification. Report the displayed credit, quota, or plan effect when material. State clearly when an action was prepared but not submitted, sent once but unresolved, or completed.

## Official references

- Workspaces: https://help.suno.com/en/articles/4326849
- Download: https://help.suno.com/en/articles/2409921
- WAV availability: https://help.suno.com/en/articles/2479873
- Share visibility: https://help.suno.com/en/articles/2565761
- Publish: https://help.suno.com/en/articles/2551361
- Remix menu: https://help.suno.com/en/articles/6050497
- Extend: https://help.suno.com/en/articles/2409601
- Replace Section: https://help.suno.com/en/articles/3271873
- Song Editor: https://help.suno.com/en/articles/6141505
- Remaster: https://help.suno.com/en/articles/8105281
