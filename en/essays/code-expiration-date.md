---
layout: page
lang: en
title: "The Shelf Life of Code"
description: "How to judge code lifetime, design cost, technical debt, and the timing for rebuilding."
permalink: /en/essays/code-expiration-date/
alternate_url: /kr/essays/code-expiration-date/
toc_items:
  - id: expected-lifetime
    label: "Expected lifetime"
  - id: existing-design
    label: "The remaining life of an existing design"
  - id: implementation-rate
    label: "Design intent and implementation rate"
  - id: depreciation
    label: "Depreciation"
  - id: organization
    label: "Organizational judgment"
---

[← All notes]({{ "/en/" | relative_url }})
{: .article-backlink }

Code has a shelf life from the moment it is written.
{: .article-lead }

By shelf life, I do not mean that code becomes old simply because time passes. I mean how long a piece of code can survive within the current requirements, implementation environment, and surrounding design. Code is not a permanent asset by itself. It is a structure that works on top of specific assumptions. If you do not estimate how long those assumptions will hold, you cannot decide how much design cost the code deserves.

Many developers skip this judgment. They write every piece of code with the same attitude. They do not distinguish between code that should be produced quickly and code that must survive for a long time. They give experimental features and core domain logic the same weight. As a result, short-lived code receives excessive design, while long-lived code accumulates temporary fixes.

When short-lived code is treated like a permanent asset, it becomes overengineering. When long-lived code is treated like temporary code, it becomes a broken window. These look like failures in opposite directions, but their root cause is the same: the developer did not judge how long the code would survive.

## Expected lifetime {#expected-lifetime}

When writing code, you must also estimate how long that code is expected to last.

Is the plan still experimental, or is it already a confirmed core rule? Will this code be used once and thrown away, or will many features keep depending on it? Is it tightly bound to an external API or platform environment, or does it represent a long-term rule inside the domain? The cost you should pay for the code changes depending on these conditions.

Short-lived code can be written quickly. But writing quickly does not mean mixing it into the system anywhere you like. The shorter a piece of code is expected to live, the easier it should be to throw away. Its impact area should be narrow, other code should not depend on it casually, and it should be possible to remove or rewrite it later.

Long-lived code, on the other hand, requires more cost up front. You need to verify the assumptions behind the requirements more persistently, make responsibility boundaries clear, and build a structure that later code can safely depend on. Avoiding that cost may look fast now, but every future change becomes more expensive.

> Good code is not always code that is written with maximum precision. Good code is code that pays the right cost for its expected lifetime.
{: .article-principle }

## The remaining life of an existing design {#existing-design}

The harder problem is judging the shelf life of code that already exists.

Most development today is not about building a completely new system from scratch. More often, it is about adding new requirements onto a system that is already running. In that situation, the developer must read the assumptions behind the existing design. Then they must judge whether the changed requirement can fit naturally inside those assumptions, or whether the design has already reached the end of its life.

The signal that rebuilding is needed is the moment an implementation appears that cannot be explained by the assumptions of the existing design. Those assumptions may have been certain facts, or they may have been estimates made at the time. What matters is whether the new requirement can be explained inside the existing assumptions. If unexplained implementation details are forced into the design, that design is already nearing the end of its life.

Rebuilding is not necessary because code is old. Code written on top of the wrong assumption can reach the end of its life in a single day.

## Design intent and implementation rate {#implementation-rate}

The fact that there was a design intent is not enough.

The original intent may have been good. The developer may have imagined an extensible structure, or tried to preserve a certain responsibility boundary. But if that intent was not actually satisfied in code, the system does not behave according to that intent.

What matters is the implementation rate. You need to know whether 80 percent of the required design was implemented, or whether only 20 percent was implemented while merely making the feature work. If you expand code that only implemented 20 percent of the design as if it were an 80 percent design, that code will collapse quickly.

> Technical debt is not the problem by itself. The problem is treating debt as an asset without recording it as debt.
{: .article-note }

## Depreciation {#depreciation}

All code starts depreciating from the moment it begins to run.

Requirements change, surrounding systems change, the context from the time of writing is forgotten, and the environment the code depended on also moves. Even if the code looks the same on the surface, the assumptions supporting it keep wearing down.

That is why trying to estimate a perfect shelf life from the beginning is also dangerous. Very few organizations have the time and cost required to perfectly predict every plan and every possible change. In reality, code usually starts from incomplete information.

What matters is not avoiding incompleteness. What matters is knowing where the incompleteness is. You need to know which parts are more dangerous, which parts will be consumed faster, and whether what you implemented is 20 percent or 80 percent of the design that was actually needed. Then you need to remember to schedule the task that pays back that debt at the right time.

At first, that task may be a C-priority task. It does not stop the service immediately, and feature development may still be possible. But as the code approaches the end of its life, the priority of that debt rises. C becomes B, then A, and at some point it becomes an S-priority incident response task.

After a certain point, small repairs are no longer enough. Just as an old apartment eventually needs its facilities rebuilt or the whole structure reconstructed, code also reaches a point where the structure itself must be rebuilt.

## Organizational judgment {#organization}

The ability to judge the shelf life of code is not merely an implementation skill.

Inside an organization, it is closer to a judgment that architects, technical directors, and team-level engineering leads must have. They need to judge whether the code can withstand the current requirement, how far the team can continue with temporary responses, and when rebuilding must begin. They also need to persuade higher-level decision makers such as producers and directors.

This persuasion is not simply the complaint that the code has become messy. It is the work of translating technical risk into the language of organizational cost: which assumptions have expired, why the new requirement is no longer explained by the existing design, and what schedule and quality risks will accumulate if temporary responses continue.

Leadership without enough understanding of software structure can easily mistake technical debt for mere internal cleanup. But a decision to keep pushing a design whose shelf life has expired does not merely slow down future development. In some cases, the next release, the next incident, or the next requirement can break the service itself.

That does not mean this judgment is needed only after becoming a senior developer. Authority may come later, but direction must be learned from the junior stage. The habit of continuously distinguishing whether the code being written is long-lived code, soon-to-be-discarded code, temporary debt, or a core design boundary determines the direction of a developer's growth.

A good developer is not someone who simply keeps code alive for a long time. A good developer is someone who can judge how long code can survive, and who can decide to rebuild before that life runs out.
