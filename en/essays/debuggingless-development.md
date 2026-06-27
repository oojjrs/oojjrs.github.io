---
layout: page
lang: en
title: "Debuggingless Development"
description: "A development method for reducing reactive debugging by removing logical failure paths while writing code."
permalink: /en/essays/debuggingless-development/
alternate_url: /kr/essays/debuggingless-development/
toc_items:
  - id: reactive-debugging
    label: "Reactive debugging"
  - id: deductive-design
    label: "Moving deduction into design"
  - id: architecture
    label: "Architecture"
  - id: deterministic-execution
    label: "Deterministic execution"
  - id: structural-logging
    label: "Structural logging"
  - id: observation-limits
    label: "Where observation gets harder"
  - id: limits
    label: "Where it is hard to apply"
  - id: conclusion
    label: "Conclusion"
---

[← All notes]({{ "/en/" | relative_url }})
{: .article-backlink }

Debuggingless Development is a development method for minimizing debugging.
{: .article-lead }

It is a way of working that I use in practice. I do not know whether there is already an established term that precisely matches this idea, so I call it Debuggingless Development for convenience.

Responding to a bug starts with observing the value or state currently in front of you, inferring backward through the flow that produced it, and then fixing the logic deductively. The observed value is only the starting point. A real fix must be able to explain the structure and conditions that made that value possible.

The problem is that debugging can easily push people toward removing only the visible error. If a bad value appears, we exclude that value from the flow. If a specific state causes a problem, we block only that state. If one reproduced condition fails, we handle it with an `if`.

This can make the immediate bug disappear. But it does not explain why the overall logic should behave that way. In the end, this leads to inductive maintenance: observe possible cases one by one, collect them, test them, and respond with more conditions.

> Removing the value currently in front of you is not the same as fixing the logical structure that made that value possible.
{: .article-principle }

## Reactive debugging {#reactive-debugging}

Debugging-centered responses create pressure to fix the code where the problem is found. The function where the error appears, the line where the bad value is found, or the place where an exception is thrown starts to look like the right place to solve the problem.

But the place where a bug appears and the place where it was created can be different. A bad value may have been produced much earlier, and the current location may only be where that value can no longer stay hidden. If you add a condition at that point, the symptom disappears while the cause remains.

For example, when a value is `null`, the easiest response is to add a condition that returns if it is `null`. But if you do not ask whether that value is actually allowed to be `null`, what `null` means in that state, and where the responsibility lies for moving it into a non-`null` state, the same kind of condition keeps multiplying.

What matters in Debuggingless Development is not the `null` check itself. It is whether that `null` state is a legitimate state of the system.

## Moving deductive reasoning into design {#deductive-design}

Experienced developers eventually reconstruct causes deductively when fixing bugs. They look at the current state, assume possible previous states, eliminate impossible paths, and find the remaining path that best explains the result.

Becoming experienced means moving this reasoning from an unconscious habit to something you can handle consciously. Debuggingless Development takes that thinking process out of after-the-fact debugging and brings it into the act of writing code.

Instead of waiting until a bug appears and then asking, "why was this state possible?", you ask while writing the code: "is this state possible?", "if it is possible, through which paths only?", and "if it should not be possible, how do I make it unrepresentable in the code?"

That is why this method is not mainly about writing more tests or adding more logs. Tests and logs observe a system that has already been written. Before that, you need a structure that makes incorrect flows difficult to write naturally.

## Architecture {#architecture}

Architecture is not about making code look neatly divided. It is about limiting the range of possible states. The structure must make it clear which object owns which data, which system is responsible for which changes, and which state transitions are legitimate.

In a good structure, there is less code for handling invalid states because invalid states are harder to create in the first place. When the structure is weak, defensive code grows at every point. Defensive code can look like a safety device, but it can also make it less clear which states the system actually allows.

The form I often use from this perspective is [layered architecture](https://en.wikipedia.org/wiki/Multitier_architecture).

Layered architecture itself is not new. It has long been used in operating systems, network stacks, and application architecture. It is often explained in terms of relatively large layers such as UI, domain, and infrastructure.

However, the layered structure I care about in Debuggingless Development is more fine-grained. I try to separate not only large system boundaries, but also the layers inside a single feature: where values are created, where state transitions happen, where policies are decided, and where external effects occur.

The point is not to divide code into more pieces for its own sake. When each layer is limited in what it can know and decide, bad values and bad states are less likely to be created anywhere at random. Instead of adding a condition after a bug appears, the goal is to make certain kinds of decisions happen only in certain places.

What matters is not the number of layers. What matters is whether the direction of responsibility and dependency stays logical. What a layer cannot know should remain hidden from that layer. What a layer must not decide should not be decidable there.

> In an ideal layered structure, leaf-level business logic contains very little conditional judgment. Not only checks such as `if`, but the branching logic itself is handled by higher layers, while leaf components simply execute behavior that has already been selected. When branching conditions are gathered in higher layers, verified decisions can be reused by many leaf-level routines, avoiding repeated condition checks and raising the stability of the system as a whole.
{: .article-note }

When layers collapse, developers tend to solve problems by directly referencing deeper objects to get the value they need, or by letting low-level code know high-level policy. As these shortcuts accumulate, the system becomes increasingly dependent on inductive condition handling.

## Deterministic execution {#deterministic-execution}

Logic should run in an order that is as predictable as possible. Given the same input and the same initial state, the same result should follow, and the order of state changes should be explainable in the code and design.

Determinism matters not only because it makes reproduction easier. More importantly, it reduces the range of possible causes. When execution order is unstable, even after seeing a result, it is hard to be sure which path actually ran. When execution order is clear, you can quickly eliminate possible cause paths after finding a problem.

This is especially important in game development. Many systems interact every frame, so when execution order becomes unclear, bugs stop being simple code mistakes and become problems of system interaction. Debuggingless Development keeps those interactions inside explicit order and explicit boundaries as much as possible.

## Structural logging {#structural-logging}

Logs should not be temporary output added after a bug appears. They should be execution evidence that records important state transitions and system boundaries. Consistent logs should remain at points that explain the logical flow of the system: initialization, lifecycle changes, input handling, event occurrence, and state transitions.

The purpose of logs here is not to collect as many values as possible. What you need is evidence that can be used for deductive reasoning. You should be able to confirm which flow actually ran, which state transition happened, and when a responsibility boundary was crossed.

Structural logging is therefore less a replacement for debugging and more a way to confirm that the designed logical flow is still preserved during execution. Good logs are not useful only when fixing a bug. They show that the system continues to move along the intended paths.

> When structural logs become complete enough, you can extract logs before and after a risky change and compare the execution flow. If the log order changes, an intermediate call disappears, or an unexpected path appears, you can check whether the current call state and conditions are still the same as before. It is similar to comparing call stacks in a memory viewer: by comparing log flows, you can distinguish normal calls from abnormal ones.
{: .article-note }

## Where observation gets harder {#observation-limits}

This method did not arise because of multithreading or real-time systems. The problem is that debugging itself can easily push people toward reactive responses to the currently observed error.

However, this problem becomes more extreme in multithreaded, asynchronous, and real-time systems. In these environments, observing the current value is difficult by itself, and the observed value does not necessarily explain the cause. Setting a breakpoint changes timing. Adding a log can make a race condition disappear or create a new one.

In other words, debugging in these areas is not merely inconvenient. Sometimes the observation itself is hard to trust. That makes it even more dangerous to add conditions based only on the state currently observed. A response fitted to the cases you happened to observe can easily break under another timing, another order, or another combination of states.

What you need here is not more observation, but stronger logical structure. The code structure must explain which thread owns which state, in what order state changes can happen, which values can be accessed concurrently, which values cannot, and at what point a callback or event can run.

Then, even when a bug appears, the response moves toward "why was this case possible?" rather than "let us block this case too." If the path should not be possible, it should not merely be blocked by a condition. It should become unrepresentable.

## Where it is hard to apply {#limits}

Of course, Debuggingless Development cannot be applied to every kind of code with the same intensity.

Legacy code is a representative example. In a system where responsibility boundaries are already blurred, the meaning of state transitions is scattered across many places, and shortcuts have accumulated, it is difficult to demand a deductively designed structure from the start. In that case, the realistic approach is to apply it gradually to newly written boundaries or features that can be isolated.

This method is especially effective in areas where abstract and logical relationships matter, such as business logic, game rules, state machines, and UI flows. When the meaning of values, the legitimacy of states, transition conditions, and responsibility boundaries determine system quality, upfront logical design makes a large difference compared to reactive condition handling.

On the other hand, there is less room to apply it in code close to networking, embedded systems, drivers, or hardware, where call cost, memory constraints, timing, protocols, and device state dominate. In such code, satisfying hardware constraints and low-level execution conditions can be more important than dividing logic into fine-grained layers.

There are also areas that cannot be controlled through my code structure, such as closed hardware behavior or responses from external systems. In those areas, debugging, instrumentation, experiments, and reproducible environments remain important.

Therefore, Debuggingless Development is not a claim that every bug can be eliminated at design time. It is closer to a stance: in the logical areas I can control, I do not want debugging to be the default response.

## Conclusion {#conclusion}

The goal of Debuggingless Development is not to avoid debuggers. It is to move the cause inference that usually happens during debugging into the act of writing code.

Instead of adding a condition to block the current value after a bug appears, I first ask why that value was possible. If a state should not be possible, I do not want to keep adding code that handles it. I want to reduce the logical path that creates it.

A good fix does not end by making one current bug disappear. It should also reduce the paths through which the same kind of bug can appear again.

Ultimately, I do not want code that merely makes frequent debugging easier. I want code that does not need to rely on debugging so often.
