# Instrumental Music Direction and Narrative Experiments

Use this shared brief when preparing music for oojjrs through AI Music Generator or Suno. Keep provider controls, generation authority and result tracking in the corresponding provider skill. An explicit current request takes precedence over this brief. Planning or updating this reference does not submit a paid generation.

## Musical Direction

- Prioritize an easy-to-grasp, memorable main melody and rewarding repetition, with purposeful development and a satisfying ending. Keep the main melody clearly audible as supporting parts become richer; melodic simplicity can still sound mature and substantial.
- A striking opening can use only a few parts. A sparse statement of the hook followed by a sudden full-ensemble entrance is a strongly liked option, alongside other narrative shapes.
- Favor forceful optimism, mature adventure, soaring aspiration, or energetic action and battle music. Treat these as distinct directions; a single track need not contain every category.
- Keep positive music confident and substantial. Avoid depressive or mournful framing and childish novelty. Do not equate optimism with an obligatory major key, maximum tempo, loudness, or cute instrumentation.
- Avoid a foreground guitar lead and piercing, whining guitar tone. A restrained guitar part blended into the accompaniment can be acceptable; do not translate this into an unconditional ban on every guitar.
- Default to instrumental music without intelligible lyrics, especially Korean or English lyrics. Avoid romance, money and everyday personal concerns as lyrical subjects.
- Keep wordless choir pads separate from sung lyrics. A monumental vocal work about humanity, exploration or civilization is a limited alternative direction, not permission to add vocals to every instrumental. Choose its language and subject deliberately when that direction is requested.
- Use reference recordings to identify the desired effect of a passage. A reference with vocals or guitar does not authorize copying every part of its arrangement into a new piece.

## Reference Anchors

The two strongest local reference outcomes are:

| Recording | Role | Provenance limit |
| --- | --- | --- |
| `SeasideSandcastleBgm-1.mp3` | Complete composition and narrative reference; measured 187.760 seconds | The accepted recording came from extending a liked opening in Suno. Embedded section/instrument tags are partial provenance, not a recovered complete generation request. |
| `Treasure PvP Moonlit Ruins-1-dc6b4f9f.mp3` | Complete composition and narrative reference; measured 152.959979 seconds | An exceptional individual output. Its prompt does not establish a repeatable success rate or reveal its exact model settings. |

The original `PVP 보물찾기 BGM 후보` set is also a source of liked openings. Many candidates end before developing those ideas sufficiently. Preserve their individual musical identity when exploring longer or different narratives.

Resolve the recordings through the relevant project's `Design.html`; the Mines copies are `Client/Assets/Sources/Sound/SeasideSandcastleBgm-1.mp3` and `DesignAssets/Sounds/BgmCandidates/PvpMusic/Treasure PvP Moonlit Ruins-1-dc6b4f9f.mp3`. Do not alter or upload either file merely to prepare text prompts.

Commercial references include `Sogno di Volare`, fripSide's `only my railgun`, `Hawaii Five-O` theme, Megumi Hayashibara's `Plenty of Grit`, and Mark Mothersbaugh's `What Heroes Do`. These are references for different possible directions, not one combined instrumentation recipe. Exact recordings and favored passages still matter. `Good Enough` and the filename-like `hans_zimmer_-_moicani` remain unresolved identifiers; obtain an artist, recording or link before attributing specific musical features to them.

Christopher Tin describes `Sogno di Volare` in terms of exploration, propulsion, flight and anthem-like grandeur; its Italian text draws on Leonardo da Vinci's idea of flight. Use those broad aspirations when relevant, without reproducing its lyrics or claiming to have analyzed the supplied recording. [Composer's account](https://christophertin.com/blogs/recordings/sogno-di-volare-civilization-vi)

These reference roles are preference evidence. File metadata measures duration and provenance; it does not establish the audible arrangement. Never infer a taste for guitar leads from Seaside's embedded guitar-related tags. Do not present webpage descriptions or player playback as direct listening when audio was not available to the agent.

## Separate Narrative from Palette

1. Select one liked palette or exact original Style as the common baseline. Preserve its main instrumentation and identity anchors across conditions.
2. Write a short description of the intended emotional journey. Change the sequence, recurrence, phrase length or instrumental roles rather than merely renaming Verse and Chorus tags.
3. Keep a fixed source/no-source choice, model label and exposed settings when comparing narratives. Record any deliberate difference instead of claiming complete parameter equality between services.
4. Avoid an obligatory quiet breakdown in every template. Contrast can come from phrase length, density, call and response, or supporting roles while the pulse continues.
5. Do not demand the same motif and same arrangement in every section so strongly that all development is discouraged. Keep recognizable material while specifying a meaningful change.
6. Judge the opening, identity, development, payoff and ending separately. A coherent two-minute piece can satisfy the brief; a long output with weak development cannot satisfy it merely by being long.

## Sparse Hook and Full Ensemble Entrance

Use this option across chosen styles when the intended payoff is the arrival of the full arrangement around an already familiar melody. Select a coherent instrument palette first. Begin with a small subset, then make a decisive increase in active parts; increasing loudness alone does not create the intended entrance. Carry the opening melody and recognizable lead tone through that transition so the arrival develops the same piece.

Repeat the complete hook enough for recognition. Put much of the subsequent variation into countermelodies, answering phrases, rhythmic accents, fills and accompaniment while keeping the main line easy to follow. New decorations should support its phrasing and leave space around it. This preference does not require identical bars throughout, a fixed note count, a fixed intro duration, or the same structure for every track.

Keep the selected Style and palette, then adapt this instrumental arrangement example. It is a prompt hypothesis, not a guarantee of a catchy melody, exact section timing, or faithful execution:

```text
[Instrumental]
[Intro: introduce a clear, memorable main melody with a small subset of the chosen instruments]
[Verse 1: repeat the complete melody with its recognizable lead tone and only light supporting figures]
[Pre-Chorus: create anticipation around the familiar melody while holding back the full accompaniment]
[Chorus: make a sudden, powerful full-ensemble entrance around the same complete main melody, keeping its lead clearly recognizable]
[Instrumental Interlude: keep the familiar melodic thread moving while adding answering phrases and rhythmic decorations around it]
[Verse 2: repeat the main melody with fresh countermelodies and accompaniment; leave space for the lead]
[Final Chorus: present the complete hook with the richest supporting arrangement and a confident sense of arrival]
[Outro: let the recognizable main melody reach a satisfying, decisive resolution]
[End]
```

## Moonlit Ruins Baseline

The Mines planning record for `Treasure PvP Moonlit Ruins` contains this original Prompt:

```text
Moonlit ruins PvP discovery theme, mystical choir pads, nimble percussion, elegant rivalry under stars, instrumental game BGM.
```

Original Style:

```text
mystical cinematic electronic, ruins adventure battle BGM, no vocals
```

Do not replace this with the separate `Moonlit Ruins Discovery` record. The choir-pad cue is part of the original Prompt. When intentionally carrying that cue into an instrumental condition, express it as wordless background texture and avoid blanket choir/chant exclusions that contradict it. Prefer targeted exclusions for intelligible lyrics, spoken word, rap or foreground guitar when the brief requires them. Apply only exclusions relevant to the chosen condition.

For the narrative conditions below, keep the original Style fixed and use this common Lyrics prefix followed by exactly one condition body:

```text
[Instrumental]
[Palette: mystical wordless choir pads blended into the background, nimble percussion, elegant and spirited ruins adventure; no intelligible lyrics]
```

This is a prepared adaptation of the source Prompt, not a recovered original Lyrics input. The following bodies are arrangement hypotheses rather than validated recipes. They are not instructions to recreate the reference recording's exact melody or to run every condition automatically.

### A. Continuous Ascent

```text
[Opening: establish a striking main theme with immediate rhythmic momentum]
[Development: extend the theme into longer phrases while the nimble percussion keeps moving]
[Build: introduce complementary responses around the theme and steadily broaden the arrangement]
[Climax: deliver the complete theme with its fullest expression and a confident sense of arrival]
[Coda: finish the thematic statement with a clear, affirmative resolution]
[End]
```

### B. Returning Adventure Theme

```text
[Theme A: establish a vivid, memorable theme with nimble rhythmic movement]
[Episode B: explore a contrasting phrase within the same palette and spirited mood]
[Theme A: return clearly to the recognizable opening theme]
[Episode C: develop a different phrase shape and redistribute the instrumental roles]
[Final Theme A: bring the opening theme back with a fuller, conclusive statement]
[Coda: resolve the theme decisively]
[End]
```

### C. Exchanges and Breakthrough

```text
[Opening: state a compact main motif with a forceful rhythmic entrance]
[Exchange: alternate short calls and answers derived from the main motif]
[Escalation: shorten the exchanges and intensify the nimble percussion while keeping the motif recognizable]
[Breakthrough: open the compact motif into a broad, confident melodic statement]
[Victory: reaffirm the expanded theme with sustained forward momentum]
[Coda: close with a decisive final phrase]
[End]
```

### D. Journey and Grand Return

```text
[Opening Theme: establish a complete, memorable theme and a clear pulse]
[Journey: carry fragments of the theme through evolving phrases while maintaining forward motion]
[New Horizon: introduce a complementary melody within the same instrumental palette and positive mood]
[Convergence: combine the opening motif and complementary melody into a rising passage]
[Grand Return: bring back the complete opening theme with a stronger sense of arrival]
[Coda: let the final statement resolve fully into a satisfying ending]
[End]
```

These vary the narrative shape: continuous growth, A-B-A-C-A recurrence, short exchanges opening into a longer statement, and a long departure before one major return. Keep sound palette experiments and any monumental choral branch separate from this comparison.

## Experimental Evidence and Delivery

- Evaluate seed-based extension separately from fresh text generation. One excellent Seaside extension does not make arbitrary continuation reliable; one excellent Moonlit result does not validate all settings or every tag in its prompt.
- Structure tags are probabilistic directions. Compare the bodies as whole narrative conditions first. Isolate a single cue in a later test if the purpose becomes explaining why a condition worked.
- The 2026-09 service comparisons produced usable outputs from both providers, with a subjective preference for AMG overall. A small set does not establish a universal capability ranking or prove hidden prompt rewriting.
- Report the exact input, title, mode, source, model, exposed settings, actual result IDs and each duration. Keep subjective acceptance separate from technical readiness.
- Use the provider's one-submission state tracking. Select the next condition within the currently authorized generation scope, and repeat a promising condition before treating it as reliable know-how.
- Keep generated files under the project's literal `$Trash`. Prefer embedded audio players for listening; use local files with the app's supported Markdown audio embed or a provider's supported native preview. Usable playback links remain a fallback. Do not download remote media solely to work around display restrictions or consume Suno download allowances merely to make the two providers' delivery formats look identical.
