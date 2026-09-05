# Instrumental Sections for Longer Arrangements

Use this after repeated short Description outputs when the user wants arrangement or Custom Lyrics experiments. Keep the existing Style and musical identity. The site requires Custom Lyrics with Instrumental switched off to submit these directions; the words are arrangement hints, not sung lyrics.

## Reusable Form

Replace the placeholders with the existing lead instrument, rhythmic accompaniment, motif, and scene. Do not introduce an unrelated genre or instrument. Pass the result as `-Prompt` with `-InputMode InstrumentalSections` and the existing `-Style`.

```text
[Instrumental]
[Intro: {rhythm} establishes the pulse; {lead} introduces the main motif]
[Verse 1: instrumental; develop the complete {lead} melody over {rhythm}]
[Pre-Chorus: instrumental; build the existing scene's tension through a rising sequence]
[Chorus: instrumental; full main theme, {rhythm}, and the scene's musical payoff]
[Instrumental Interlude: continue the pulse and develop the opening motif]
[Verse 2: instrumental; a substantial new variation of the {lead} melody over {rhythm}]
[Pre-Chorus: instrumental; gradually build tension and momentum]
[Chorus: instrumental; return to the complete main theme]
[Bridge: extended instrumental development; the main theme moves through contrasting phrases while the rhythm keeps its pulse]
[Instrumental Solo: {lead} develops the main motif through several complete phrases]
[Final Chorus: instrumental; broad full reprise of the main theme]
[Outro: instrumental; resolve the main theme after the final reprise]
[End]
```

## Evidence and Limits

A Golden Chest test on 2026-09-05 kept the original orchestral arcade Style, triumphant brass and racing drums, and used this form in Custom Lyrics. Two sequential requests with identical inputs produced four files measuring 182.520, 154.632, 163.008 and 162.192 seconds. All four exceeded two minutes; ten prior Description-mode candidates ranged from 10.248 to 107.568 seconds. The mode, Instrumental flag and prompt structure changed together, so the result does not isolate a particular tag or prove that the lyrics field alone caused the improvement.

Measure each downloaded file and retain the exact inputs. Repeat a promising condition before trying more keywords. Duration metadata cannot establish absence of vocals or preservation of musical character; assess those separately. Do not claim a universal success rate from this small sample.
