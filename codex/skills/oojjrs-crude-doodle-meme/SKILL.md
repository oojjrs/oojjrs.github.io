---
name: oojjrs-crude-doodle-meme
description: Create oojjrs-style Korean reaction memes and gag images when the user asks to make a 짤, reaction image, or crude doodle meme. Use imagegen for the artwork and preserve the intentionally incompetent, mouthless, eyeball-driven visual language; do not use for polished illustration, photorealism, or 2D sprite animation.
---

# Oojjrs Crude Doodle Meme

Create a new image for the requested situation instead of reusing a fixed composition. Use `$imagegen` together with `$oojjrs-image-first-art-workflow`. When useful, provide `assets/eyes-reaction-reference.png` to imagegen strictly as an art-style reference, never as a scene or pose template.

## Visual Language

- Make the result look genuinely rushed by an untrained person who has no interest in improving but draws with unjustified confidence.
- Use sparse black ballpoint-like lines on plain warm-white paper. Keep shaky single-pass strokes, failed joins, inconsistent pressure, bad perspective, unresolved hands, and awkward proportions.
- Avoid polished naive art. The drawing must not look like a skilled artist deliberately producing a charming childlike style.
- Use lopsided potato-, wedge-, or sack-like forms. Avoid clean circles, pleasing silhouettes, professional anatomy, deliberate composition, elaborate texture, shading, and decorative backgrounds.
- Crop close enough for the subject and gag to read immediately. Do not leave large empty areas unless the requested joke specifically depends on distance or isolation.

## Face And Emotion

- Omit the mouth and nose. Never add even a short mouth line unless the user explicitly asks.
- Omit eyebrows by default. Do not translate the current emotion into angry, sad, or surprised eyebrow shapes.
- Let the eyeballs carry any visible reaction through size, pupil position, focus, spacing, and mismatch.
- Use larger eyeballs than ordinary dot eyes. For confusion or embarrassment, enlarge them abruptly and roll small pupils sideways or in slightly different directions. For deadpan confidence, keep them blank, still, or mildly unfocused.
- The face should usually remain emotionally detached from the outrageous action. Prefer a person doing something absurd with calm procedural certainty over a person visibly reacting to the joke.

## Comedy Direction

- Prefer gag images overwhelmingly, especially deadpan absurdity, shameless confidence, misplaced blame, and scolding energy.
- Build the joke from a contradiction between an unreasonable action and the character's matter-of-fact attitude. Do not explain the punchline through expression, props, motion effects, or cinematic staging.
- A scolding meme does not require an angry face. A neutral character silently treating the target as the problem is usually funnier.
- Keep non-graphic slapstick readable but omit injury, gore, impact detail, or realistic suffering unless the user's request independently calls for an allowed treatment.

## Text

- Use no text by default.
- Add text only when the user asks or the gag cannot work without it. Keep it extremely short, colloquial, and raw; terse fragments such as `ㅅ발?` or `이새끼가?` fit better than grammatical explanatory sentences.
- Render optional text as hurried, uneven handwriting. Never invent polished captions, complete textbook-style sentences, motivational copy, or generic AI punchlines.

## Generation Check

After generating, reject or revise a result when it has a mouth, emotion-coded eyebrows, a round symmetrical head, polished linework, excessive empty space, explanatory text, or an obviously professional composition. Prefer one targeted imagegen revision over repairing a stylistically wrong result with local drawing code. Use deterministic tools only for accepted-image cropping or other production cleanup.
