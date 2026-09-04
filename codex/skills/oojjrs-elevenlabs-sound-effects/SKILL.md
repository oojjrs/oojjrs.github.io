---
name: oojjrs-elevenlabs-sound-effects
description: Generate or iterate on SFX through the official $sound-effects skill, translating user intent into concrete sound sources and English prompts. Do not use for existing-audio sourcing, post-processing, or project installation.
---

# oojjrs ElevenLabs Sound Effects

## Generation Method

- Use the official `$sound-effects` skill for generation, API usage, authentication, and parameters. If unavailable, ask to install it from `elevenlabs/skills`.
- For prompt-only requests, provide the prompt without generating audio.

## Sound Design And Prompts

- Translate feelings, onomatopoeia, and gameplay intent into a concrete sound source or physical event.
- Describe what produces the sound and how it moves and is heard, with one coherent event per prompt.
- Include material, distance, space, intensity, timing, and tail only where relevant.
- Write the provider prompt in English; explain the chosen source and intent in Korean.
- Set duration, looping, and output format through official parameters.

## Calls And Delivery

- An explicit generation request authorizes one call unless a count is specified. Do not ask for duplicate confirmation.
- Additional candidates and regenerations consume usage. Never automatically retry a submission whose generation outcome is uncertain.
- Save original results under `$Trash` in the active workspace.
- Present each candidate with a number, Korean description, and playable absolute-path audio embed.
- Obtain user approval before copying a candidate into a final or project directory.
