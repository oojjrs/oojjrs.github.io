---
layout: page
title: "Network Object State Synchronization"
lang: en
category: "GAME DEVELOPMENT"
description: "A network synchronization structure that shares compact object state and lets each client rebuild local presentation from it."
permalink: /en/unity/network-action-presentation-sync/
alternate_url: /kr/unity/network-action-presentation-sync/
toc_items:
  - id: diagram
    label: "One-Page Summary"
  - id: problem
    label: "Design Context"
  - id: sync-model
    label: "Synchronization Model"
  - id: structure
    label: "Common Structure"
  - id: decision-owner-placement
    label: "Decision Owner Placement"
  - id: strengths
    label: "Strengths"
  - id: risks
    label: "Risks"
  - id: principles
    label: "Principles"
---

[← Unity]({{ "/en/unity/" | relative_url }})
{: .article-backlink }

In a networked game, it is usually more stable to share the meaning and order of object state changes, then let each client rebuild local presentation from that state, than to keep replicating the final visible result.
{: .article-lead }

> The network aligns the meaning and order of object state. Local code plays or discards presentation based on that state.
{: .article-principle }

## One-Page Summary {#diagram}

<div class="state-sync-diagram" role="img" aria-label="Network object state synchronization from command generation to state change requests, decision owner, shared object state, presentation adapter, and output">
  <div class="state-sync-diagram-head">
    <p class="state-sync-diagram-kicker">Object State Flow</p>
    <h3 class="state-sync-diagram-title">Common Network Object State Flow</h3>
  </div>

  <div class="state-sync-flow">
    <section class="state-sync-node state-sync-node-request">
      <span class="state-sync-eyebrow">Request</span>
      <h3>Command / Intent</h3>
      <ul>
        <li>Client input</li>
        <li>Server, AI, or local decisions</li>
        <li>Create, destroy, start, stop, replace</li>
      </ul>
    </section>

    <section class="state-sync-node state-sync-node-request">
      <span class="state-sync-eyebrow">Request</span>
      <h3>State Change Request</h3>
      <ul>
        <li>Create, destroy, start, stop, replace</li>
        <li>Target, position, direction</li>
        <li>Request time and cause</li>
      </ul>
    </section>

    <section class="state-sync-node state-sync-node-decision">
      <span class="state-sync-eyebrow">Decision</span>
      <h3>Decision Owner</h3>
      <ul>
        <li>Offline: local runtime</li>
        <li>P2P/Host: Peer Master</li>
        <li>Client-server: game server</li>
        <li>Availability and priority</li>
      </ul>
    </section>

    <section class="state-sync-node state-sync-node-state">
      <span class="state-sync-eyebrow">Shared State</span>
      <h3>Shared Object State</h3>
      <ul>
        <li>Current state / version</li>
        <li>Target, position, start time</li>
        <li>Stop or replacement result</li>
      </ul>
    </section>

    <section class="state-sync-node state-sync-node-presentation">
      <span class="state-sync-eyebrow">Presentation</span>
      <h3>Presentation Adapter</h3>
      <ul>
        <li>Observe shared state changes</li>
        <li>Clean up old presentation</li>
        <li>Schedule new presentation</li>
      </ul>
    </section>
  </div>

  <div class="state-sync-definitions">
    <section class="state-sync-definition">
      <span class="state-sync-eyebrow">Rules</span>
      <h3>State Rule Definition</h3>
      <ul>
        <li>Availability, cancellation, timing</li>
        <li>Next-state transition rules</li>
      </ul>
    </section>

    <section class="state-sync-definition">
      <span class="state-sync-eyebrow">Presentation Data</span>
      <h3>Presentation Definition</h3>
      <ul>
        <li>Animation mapping</li>
        <li>Effects, sounds, attach points</li>
      </ul>
    </section>
  </div>

  <p class="state-sync-caption">Core idea: requests and decisions update shared object state. Presentation follows by observing that state.</p>
</div>

In the diagram, the main path is command / intent generation -> state change request -> decision owner -> shared object state -> presentation adapter -> output. State rule definitions and presentation definitions do not replace the main path; they are static definitions consulted by the decision owner and presentation adapter.
{: .article-note }

Start, stop, replace, create, and destroy intents can all appear at the same command generation stage. A state change request can come from a client, server, AI, or local system. A stop or replacement can also be decided by the decision owner after it evaluates priority, hit, death, or other state rules. Either way, the final decision that changes object state is made by the decision owner, recorded in shared object state, and synchronized. The presentation adapter is not called directly by the decision owner; it observes shared object state changes and updates animation, effects, and sound.
{: .article-note }

## Design Context {#problem}

This structure is not mainly about compensating for one output system. The core idea is to separate object state decided by gameplay from the local presentation that turns that state into visuals and sound. Animation, effects, sounds, projectiles, and hitbox displays are all outputs that express object state. They should not become the original truth that the network must replicate.

The synchronization target should therefore be the object state the game understands, not the internal state of an output device. Examples include "which state did this object enter", "what is the version of this transition", "what target or direction is involved", and "should presentation restart". Animator is just one implementation tool that often appears in this structure. The same principle applies to a custom animation player, effect system, or sound system.

## Synchronization Model {#sync-model}

Unity and Unreal both provide automatic network object synchronization for similar layers of the problem. They create network objects, detect and serialize state changed by the decision owner, such as Transform, replicated properties, playback parameters, or component state, then let other peers or clients follow. Unity's [NetworkTransform](https://docs.unity3d.com/Packages/com.unity.netcode.gameobjects@2.4/manual/components/networktransform.html), for example, replicates Transform values such as position, rotation, and scale. Unreal Actor replication sends server-owned Actor state to relevant clients. This is intuitive and easy to build with, but as the number of replicated results grows, bandwidth and correction cost grow with it.

Unreal's [Replication Graph](https://dev.epicgames.com/documentation/en-us/unreal-engine/replication-graph-in-unreal-engine) is a useful reference for that cost model. It groups large numbers of replicated Actors and connections into nodes by role, location, or other criteria so the server can build replication lists efficiently. Epic's documentation also explains that the default Actor replication path can become a server CPU bottleneck with many Actors and clients. This does not mean engine-level replication is useless. It means result-state replication needs relevance, update frequency, grouping, and culling work as scale grows.

The point, then, is not to reject engine synchronization. The actual transport can still use engine RPCs, network objects, or property replication. The important part is that the layer before transport interprets create, destroy, start, stop, and replace requests; the decision owner decides whether and when a state change is allowed; and the result becomes a compact, explicit shared object state. Engine synchronization can carry that state, but it should not become the central layer that decides the meaning of commands and transitions.

This is close to command/result-based synchronization. It does not try to synchronize every intermediate coordinate or presentation progress value. It shares commands, requests, and the state change results confirmed by the decision owner. Network state is assumed to be imperfect: latency, reordering, and temporary disconnection can happen. So instead of matching continuous presentation every moment, the system synchronizes the meaning and transition points of object state. Animation, effects, and sound are rebuilt locally by each client.

This also differs from deterministic lockstep. Deterministic lockstep requires every client to process the same input on the same tick in the same order and produce the same intermediate simulation state. This structure does not require fully deterministic simulation. It requires every client to share the same decision result and object state transitions, then unpack that state into local presentation.

## Common Structure {#structure}

This structure is better understood as three responsibility layers than as a physical execution stack.

<div class="state-sync-diagram" role="img" aria-label="Three responsibility layers: request generation, decision and synchronization, and local presentation around shared object state">
  <div class="state-sync-diagram-head">
    <p class="state-sync-diagram-kicker">Responsibility Layers</p>
    <h3 class="state-sync-diagram-title">Common Structure By Responsibility</h3>
  </div>

  <div class="state-sync-layers">
    <section class="state-sync-node state-sync-node-request">
      <span class="state-sync-eyebrow">Request</span>
      <h3>Request Generation</h3>
      <ul>
        <li>Client input</li>
        <li>Server scripts</li>
        <li>AI and local systems</li>
      </ul>
    </section>

    <section class="state-sync-node state-sync-node-decision">
      <span class="state-sync-eyebrow">Decision / Sync</span>
      <h3>Decision / Sync</h3>
      <ul>
        <li>Confirm availability, stop, replacement</li>
        <li>Update shared object state</li>
      </ul>
    </section>

    <section class="state-sync-node state-sync-node-presentation">
      <span class="state-sync-eyebrow">Presentation</span>
      <h3>Local Presentation</h3>
      <ul>
        <li>Observe state changes</li>
        <li>Animation, effects, sound</li>
      </ul>
    </section>
  </div>

  <section class="state-sync-shared">
    <h3>Shared Versus Rebuilt Locally</h3>
    <p>The shared data is the request, decision result, and object state transition. Intermediate coordinates, presentation progress, and effect playback are rebuilt by the local presentation layer for its own environment.</p>
  </section>
</div>

- Request generation layer: client input, server scripts, AI, and local systems can produce create, destroy, start, stop, and replace intents at the same stage.
- Decision / synchronization layer: incoming state change requests are validated. Stop and replacement can also be decided from priority, hit, death, and state rules. The final availability, priority, and decision timing are confirmed here and synchronized as shared object state.
- Local presentation layer: this layer is not called directly by the decision owner. It observes shared object state changes and plays or cleans up animation, effects, sounds, projectiles, and hit displays.

The core data must stay small if the line is to remain straight. Object state should contain the current state, sequence or version, target, position, start time, and stop or replacement result. Presentation details should stay in state rule definitions and presentation bundles.

```text
State rule definition
- Animation mapping
- Duration / hit timing / combo timing
- Cancellation policy
- Next-state rules

Presentation bundle
- Attach point
- Delay
- Effect / sound
- Projectile / hit display / marker
```

With this split, the network shares compact state, while each client can use presentation systems and assets that fit its environment.

## Decision Owner Placement {#decision-owner-placement}

Create, destroy, start, stop, and replace intents can all appear at the same request generation stage. A stop or replacement can also be decided after the decision owner compares the current object state with the priority of a new event. The important question is where the final decision owner lives: who decides the object state and makes other layers follow the result?

| Game Form | Actual Decision Owner | Explanation |
| --- | --- | --- |
| No-network game | Local runtime object | A MonoBehaviour, service, or manager in a namespace or scene decides whether a state change is allowed and which transition rule applies. There is no network transport, but the role is structurally the same. |
| Local co-op / single simulation | Representative local simulation | Even with multiple input sources, one local gameplay runtime produces the final object state. |
| P2P / Host model | Host or Peer Master | Communication happens between peers, but one peer acts as the session's state authority. "Host" or "Peer Master" describes this better than "socket server". |
| Client-server model | Game server / dedicated server | Clients send requests. The server confirms state changes and timing, then distributes shared state. |

So this is not a network-only pattern. In an offline game, the same idea is folded into local code. In a networked game, the final decision location moves to a Host or server. What changes is where the decision owner lives, not the principle that request generation, state decision, and local presentation should be separated.

This separation is still useful before a project has multiplayer. While focusing on single-player, inputs, AI, and local systems can still create state change requests; a local decision owner can confirm shared object state; and presentation can read only that state. Later, adding multiplayer often means moving the decision location and transport path instead of rewriting the whole gameplay-presentation relationship. This benefit is not automatic. It depends on keeping the habit of not bypassing shared object state even during single-player development.

## Strengths {#strengths}

The largest strength is that the synchronization unit is explicit. Instead of syncing output-device events or playback state, the system syncs the meaning and order of object state. This makes it less sensitive to presentation environment and frame differences.

Presentation replacement also becomes easier. Different characters can attach different animation, effects, sounds, and hitbox displays to the same object state. Presentation can change without rewriting the decision owner or state rules.

Cancellation and chaining become easier to systematize. Whether to stop the current state immediately, reserve input, or allow the next state only after a collision can be decided in one place.

Debugging also improves. When something breaks, you can ask whether shared object state is wrong, whether the presentation adapter interpreted it incorrectly, or whether the output asset is wired incorrectly.

## Risks {#risks}

The initial structure is heavier than direct event calls. It needs state rule definitions, presentation bundles, cancellation policies, sequence numbers, and cleanup rules. This can be too much for a small offline game.

Timing data is also hard to manage. If gameplay decision time and presentation time drift apart, the screen may look as if a hit landed while the real decision has not happened yet, or damage may already be applied while the effect appears late.

A content pipeline can reduce some of that load. Metadata such as duration, event position, hit frame, cancel window, and effect or sound timing can be extracted from animation clips and used as defaults for state data. But a clip is a source for authoring state rules, not the synchronization source of truth. Final decision rules and exceptions should be explicit in the state system.

Complexity can also gather in one place. The presentation adapter receives animation, effects, sounds, projectiles, and hit displays, so it can become a large mediator unless boundaries are kept clear.

Cancellation policy needs special care. Rules such as immediate cancel, reservation, post-hit cancel, and no-cancel can make the current state difficult for both designers and programmers to predict.

In P2P or Host models, load concentrates on the Host or Peer Master. The Host handles local play while validating other peers' requests, confirming state change results, and distributing shared state. Total traffic may be lower, but the Host's network quality, upload bandwidth, and processing speed directly affect the session.

In PvP games, trust in the decision owner matters even more. If one player is the Host or Peer Master, that peer is also acting as the referee for state changes, hits, cancellation, and timing. This is light, but vulnerable to cheating, manipulation, and host advantage. PvP should prefer a dedicated server or a trusted referee server where possible. A simple relay server only forwards packets and does not verify decisions.

## Principles {#principles}

Good balance comes from these rules.

- Animation, effects, and sound are output devices, not synchronization targets.
- The network shares object state meaning, order, target, start time, and decision result.
- Engine-level object synchronization can be a transport tool, but command interpretation and decisions should end in the object-state layer before it.
- Keep state rule definitions compact and presentation bundles separate.
- Cancellation policy should be explicit rules, not implicit control flow.
- When a new state transition starts, clean up reserved presentation and tracked effects from the previous state.
- Document the relationship between gameplay decision time and presentation time.
- Timing metadata extracted from animation clips should be defaults only. Final rules belong in state rule definitions.
- Even in single-player, input, AI, local decisions, and presentation should not bypass shared object state.
- In PvP, prefer a dedicated server or trusted referee server over a player Host where possible.

The purpose of this structure is not to reject output systems. Let each output device do what it does best: play presentation. Put the truth of a networked game in smaller, clearer object state.
