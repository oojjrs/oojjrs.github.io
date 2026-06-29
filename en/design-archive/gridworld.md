---
layout: page
title: "Gridworld"
lang: en
category: "DESIGN ARCHIVE"
description: "A simulation game design brief about creating worlds, observing them, intervening, and carrying the results into the next world"
permalink: /en/design-archive/gridworld/
alternate_url: /kr/design-archive/gridworld/
toc_items:
  - id: identity
    label: "Project Definition"
  - id: loop
    label: "Core Loop"
  - id: resources
    label: "Core Resources"
  - id: artifacts
    label: "Artifact"
  - id: layers
    label: "World Layers"
  - id: dna
    label: "DNA"
  - id: emotion
    label: "Emotion Loop"
  - id: multiplayer
    label: "Multiverse"
  - id: mvp
    label: "MVP"
  - id: principles
    label: "Technical Principles"
---

[← All documents]({{ "/en/" | relative_url }})
{: .article-backlink }

Gridworld is not a game about playing inside a world. It is a system for creating a world, observing it, intervening in it, and carrying the results into the next world.
{: .article-lead }

The player is not someone who merely finishes one session. The player is a creator, observer, intervener, and record keeper who accumulates conditions across many worlds.

> A world is born, lives, collides, disappears, and continues again.
{: .article-principle }

## Project Definition {#identity}

Gridworld is not a simple simulation game. Its goal is to generate worlds, accumulate them, make them collide, and create emotion through that process.

Instead of directly controlling a world to satisfy a win condition, the player repeats the following actions.

- Create a world.
- Observe the world.
- Intervene in the world through limited means.
- Carry the world's results into the next world.

The important point is that the world is not a board that only executes the player's commands. The world must change on its own over time, and it must produce ecological and civilizational outcomes even without player intervention.

## Core Loop {#loop}

Gridworld's basic flow is this cycle.

```text
Creation -> Observation -> Intervention -> Outcome -> Extraction -> Reintroduction
```

In the creation phase, the player sets initial conditions such as terrain, environment, and the DNA of living beings. In the observation phase, the player watches the world change without intervening. In the intervention phase, the player uses faith, a limited resource, to influence the world.

In the outcome phase, events such as ecosystem change, the formation of civilization, and the collapse of civilization are created. In the extraction phase, meaningful results are stored as Artifacts. In the reintroduction phase, those Artifacts become conditions for the next session or for another world.

## Core Resources {#resources}

Gridworld's core resources are time and faith.

Time is a value that accumulates automatically. The longer the player remains with a world, the more change and history that world gains. Here, time is not a simple waiting cost. It is evidence that the world lived on its own.

Faith is the resource the player spends when intervening in the world. It is powerful, but it must be limited. If the player can always fix the world exactly as desired, the world loses autonomy, and the emotions of observation and loss become weaker.

## Artifact System {#artifacts}

The result of a session is transformed into an Artifact that affects the next world. An Artifact is not simply reward data. It is a condition for the next world.

The main Artifact types are as follows.

- Species: A species that survived or evolved in an unusual way.
- Civilization: A civilization that formed or collapsed.
- Technology: A technology discovered inside a world or inherited from it.
- Event: An event that changed the history of a world.
- Relic: A materialized trace of a specific world.

Artifacts are not a device for closing and ending a session. They are a device for connecting sessions. A failed world can still leave an Artifact, and that failure can become a condition for the next world.

## World Layers {#layers}

A world operates as a structure made of overlapping layers.

1. Environment: terrain, climate, resources.
2. Life: DNA-based entities, reproduction, evolution.
3. Civilization: society, culture, technology.
4. Transcendence: divine intervention, the faith system.
5. Outside influence: other users, alien elements, Artifacts from other worlds.

Each layer must be able to operate independently. The environment should change even without life. The ecosystem should remain alive even without civilization. The world should have its own time even when the player does not intervene.

## DNA Design Principles {#dna}

DNA should create behavior and form, not just numbers.

```text
DNA -> Behavior change -> Form change -> Ecosystem result
```

For example, size, speed, aggression, reproductive power, and perception can each connect to visible changes such as body size, leg length, jaws or attack organs, abdomen shape, and eyes. Numerical changes must become changes the player can read on screen, and those changes must lead to ecological consequences.

The same principle applies to art direction. Art is not decoration. It is an information delivery system. Changes must be noticeable, meaningful, and inherited by the next generation.

## Emotion Loop {#emotion}

The emotional flow Gridworld wants to create is as follows.

```text
Creation -> Attachment -> Expansion -> Threat -> Collapse -> Reflection -> Redesign
```

The core emotions are protection, control, loss, and transcendence. The player should want to protect the world, but should not be able to control it completely. Uncontrollable change creates loss, and loss gives the player a reason to design the next world again.

The relationship between god and world also changes over time. At first, the world depends on the player. Later, it gains autonomy, resists, becomes independent, and may eventually reject the player's intervention.

## Multiplayer And Multiverse {#multiplayer}

The core of multiplayer is asynchronous interaction. Artifacts from other users flow into my world and affect it through breeding, invasion, trade, or similar routes. Synchronous competition can exist as a supporting structure, but the core is the long-term exchange of traces between worlds.

The multiverse is created through choice-based branching and event-based natural branching. Worlds split like branches, and some branches meet again or influence each other.

The important fun comes from the moment something I created appears again, the moment an unexpected combination occurs, the moment failure affects the next world, and the feeling that the history of worlds is accumulating.

## MVP Goal {#mvp}

The MVP goal can be summarized in one sentence.

> A living being I created survives even without my intervention.
{: .article-principle }

The minimum implementation scope is a single species, reproduction and death, environmental influence, and a simple intervention system. At this stage, the important thing is not the amount of content, but verifying the feeling that the world changes even without the player.

## Technical Design Principles {#principles}

Because Gridworld assumes long-term world records and reintroduction across sessions, the following technical principles are important.

- Prioritize data-centered structures.
- Seeds are the basis of deterministic simulation.
- Changes in the world are recorded as an event log.
- Relationships are maintained by IDs rather than direct references.

The final goal is for the player to stop being only an operator outside the world. The player creates, observes, intervenes, and records the world, then eventually becomes part of it.
