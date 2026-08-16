# Create Options

This map reflects the signed-in web UI observed on 2026-08-16 and current official Suno documentation. Discover the live controls every time; plan, model, and rollout differences can change what is available.

## Contents

- [Global rules](#global-rules)
- [Choose a mode](#choose-a-mode)
- [Configure Advanced](#configure-advanced)
- [Configure Sounds](#configure-sounds)
- [Select a model](#select-a-model)
- [Validate before submission](#validate-before-submission)
- [Official references](#official-references)

## Global rules

- Preserve unspecified values instead of resetting the whole form.
- Reacquire controls after changing mode, model, source input, or lyrics mode.
- Scope every locator to a visible active form. Suno can keep hidden Simple, Advanced, and Sounds controls in the DOM at the same time.
- Expand collapsed sections before interacting with their children; verify that the child control accepts pointer events and that its state changes.
- Treat current labels, enabled states, tooltip text, and displayed limits as authoritative over old documentation.
- Treat `credits used this session` as historical usage, not necessarily the price of the next action.
- Do not infer current cost from a standard two-result batch. Read any displayed cost or warning immediately before submission.

## Choose a mode

| Mode | Use it for | Current controls |
| --- | --- | --- |
| Simple | A quick song from one natural-language description | Song Description, random prompt, optional own lyrics, Instrumental, dynamic suggestions |
| Advanced | Full song control | Model, Audio, Voice, Inspo, lyrics mode, Styles, exclusions, vocal controls, creative sliders, duration, title, Workspace |
| Sounds | Short samples rather than songs | Sound prompt, One-Shot or Loop, BPM, Key |

Treat the older official name `Custom` as an alias for current `Advanced`, but select the label that exists in the live UI.

### Simple

1. Select the Simple tab and verify it is selected.
2. Fill Song Description with the user's genre, mood, subject, instrumentation, production, and vocal intent.
3. Use `Lyrics` only when the user supplied or requested explicit lyrics.
4. Use the Instrumental control only when the user wants no sung vocals or lyrics; verify its selected state.
5. Add suggestion chips only when they match the request. Suggestions are dynamic and must never silently change user intent.

### Advanced

Use Advanced when the user specifies multiple independent controls or any source input. Configure sections below, then perform the final readback.

## Configure Advanced

### Lyrics mode

- **Write**: Enter user-supplied lyrics in the Lyrics editor. Support structural tags such as `[Verse]`, `[Chorus]`, and `[Bridge]`. Preserve user text. Use Cowriter, Lyricist, or generated revisions only when requested; generated lyrics may replace or add content.
- **Prompt**: Describe what the lyrics should be about. Read the live lyrics-model selector. Current UI can expose `Classic` for closer prompt following and `ReMi` for more creative, potentially offensive output. Do not choose ReMi silently.
- **Instrumental**: Select the radio and verify both its checked state and the visible no-vocals/no-lyrics message.

Prefer an accessible radio name when the live page provides one. If the radio has no accessible name, enumerate visible `button[role="radio"]` controls within the Lyrics mode group, match the exact rendered text, click that button, and verify its `aria-checked="true"` state. Never select a global radio by index while hidden forms are present.

Vocal Gender is meaningful only for a vocal mode. If the control is absent, disabled, or ignored by the current model, report that limitation instead of fabricating a value.

### Styles and exclusions

- Fill Styles with musical attributes rather than artist imitation: genre, era, tempo feel, instruments, vocal type, arrangement, mix, and mood.
- Prefer a compact, internally consistent prompt. Detailed sentences are acceptable on current models.
- Fill Exclude Styles only for concrete negative constraints such as unwanted instruments, vocal styles, or production traits.
- Suggested styles and personalized prompts are account-dependent. Apply them only when they match user intent.
- Read text values back after filling. A section summary is not proof that the underlying textbox holds the requested value.

### Creative controls

- **Weirdness** moves from safer expected output toward more chaotic variation. The UI currently presents 50% as expected results.
- **Style Influence** moves from loose interpretation toward stronger adherence to Styles. The UI currently presents 50% as moderate.
- **Audio Influence** can appear after Audio or Voice input. Set it only when present and requested; higher influence follows the source more closely.

Set a slider from current evidence rather than assuming keyboard semantics:

1. scope to the labeled section and the visible slider;
2. read its current `value`, `min`, `max`, and `step` plus the visible percentage;
3. adjust from the current value with ArrowLeft or ArrowRight when the step count is small;
4. do not assume `Home` means the minimum because the current Suno component may reinterpret it;
5. when semantic input cannot reach an exact value, read the current bounding rectangle and numeric range, click the computed ratio once, then fine-tune with arrow keys;
6. read both the numeric value and visible percentage after the interaction. Stop if they do not prove the requested value.

### Duration

- Preserve Auto when the user did not request a target length.
- Select Custom only when the current model exposes it. Read the actual slider and `m:ss` textbox after selection.
- Duration is documented for web v5.5, but Suno does not publish a stable slider range. Never hardcode minimum or maximum duration.
- If the requested length is outside the live control's accepted range, report the clamped or unavailable value before submission.
- Inspect only visible inputs inside the Duration section. The page can retain hidden inactive-mode inputs with an `Auto` placeholder.
- A current implementation can expose a formatted `m:ss` control together with an underlying numeric input such as a 1-300 range. Infer seconds only when the current raw value and visible formatted value agree; for example, raw 180 paired with `3:00`. Fill or adjust the scoped control, commit with the supported blur or key action, then verify the final formatted time. If the unit or committed value remains ambiguous, leave Duration unresolved and do not submit.

### Metadata and destination

- Fill Song Title only when supplied or when a generated working title is useful and accepted by the user.
- Select an existing Workspace by visible name and verify the selected value.
- Creating a new Workspace changes remote account state. Require explicit current intent and verify the created destination before generation.

## Configure Sounds

1. Select Sounds and verify the explanatory short-sample mode is visible.
2. Fill `Describe the sound you want` with the event, material, space, duration, motion, intensity, and recording perspective.
3. Choose **One-Shot** for a discrete effect or **Loop** for seamless repetition.
4. Set BPM and Key only when the controls are enabled and musically relevant. Preserve Any when the key is unspecified.
5. Treat Sounds as plan-gated when the live account says so. Do not assume the credit cost from ordinary song generation.

## Select a model

- Open the live model selector and read all visible options, plan badges, descriptions, and disabled states.
- Select by exact visible label and verify the button's final text.
- Do not hardcode v5.5 as universally available. Current official pricing gives Free and paid plans different model access.
- Treat Custom Model creation as a separate upload-and-training workflow. It can require owned source songs, credits, preparation time, and plan access; obtain explicit authority and read [source-inputs.md](source-inputs.md).

## Validate before submission

Read back and summarize:

1. selected Simple, Advanced, or Sounds mode;
2. exact model label and any plan badge;
3. Audio, Voice, or Inspo source, without exposing unnecessary private names;
4. lyrics mode and whether lyrics or a lyric prompt is present;
5. Styles and Exclude Styles;
6. vocal selection and every exposed influence value;
7. Weirdness, Style Influence, and Duration;
8. title and Workspace;
9. Create enabled state, visible credit text, and warnings;
10. for a Generate phase only, baseline result IDs and any already active generation. Skip broad Library reading in a prepare-only phase.

Proceed through [recovery-and-validation.md](recovery-and-validation.md) for any credit-consuming action.

## Official references

- Current Simple and Advanced workflow: https://suno.com/hub/how-to-make-a-song
- Simple mode: https://help.suno.com/en/articles/2462273
- Older Custom terminology: https://help.suno.com/en/articles/3726721
- Sounds: https://help.suno.com/en/articles/10625537
- Models and plan access: https://suno.com/pricing
- Creative sliders: https://help.suno.com/en/articles/6141377
- Exclude Styles: https://help.suno.com/en/articles/3161921
- ReMi lyrics model: https://help.suno.com/en/articles/3599681
- Duration: https://suno.com/release-notes/duration-slider-on-web
