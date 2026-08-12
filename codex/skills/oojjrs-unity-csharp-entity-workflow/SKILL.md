---
name: oojjrs-unity-csharp-entity-workflow
description: Add or refactor Unity C# entity/model/binding code in oojjrs Unity repos. Use for Game, Item, Action, Relation, Actor, TableT, EntityModelBindingT, null/default expression cleanup, Regex LIKE helpers, generated-code boundaries, package runtime changes, and loading the public Unity C# coding convention before those edits.
---

# oojjrs Unity C# Entity Workflow

Use this skill for Unity C# model/entity/runtime helper work.

## Required Context

1. Reuse the public Unity C# convention loaded by `$oojjrs-project-start-work`. If this skill was invoked directly without it, load `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md` once before editing. Stop if it is unavailable.
2. Inspect nearby existing entity/model patterns before adding a new abstraction.
3. Treat generated code and third-party code as convention exceptions unless the user explicitly asks to regenerate or edit them.

## Implementation Rules

1. Prefer existing repo patterns, namespaces, file layout, and helper APIs.
2. Keep reference-type default expressions explicit as `null` when that is the established convention.
3. Avoid broad naming churn unless the request is specifically a naming cleanup.
4. When adding an entity-like type, update only directly required binders, tables, and documentation.
5. Keep package/runtime documentation and version updates separate. Before an authorized commit containing UnityO package changes, or for an explicit release/version request, finish this code phase and route a later sequential phase to `$oojjrs-unity-package-release`; do not preload both domains.

## Affected Contracts

Inspect only affected binder and table type references, interface signatures, namespaces, and generated-code boundaries. Leave generic execution and evidence rules to the canonical workflow.
