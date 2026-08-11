---
name: oojjrs-unity-csharp-entity-workflow
description: Add or refactor Unity C# entity/model/binding code in oojjrs Unity repos. Use for Game, Item, Action, Relation, Actor, TableT, EntityModelBindingT, null/default expression cleanup, Regex LIKE helpers, generated-code boundaries, package runtime changes, and loading the public Unity C# coding convention before those edits.
---

# oojjrs Unity C# Entity Workflow

Use this skill for Unity C# model/entity/runtime helper work.

## Required Context

1. Read `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md` before editing code. If it cannot be reached, report the access failure and do not infer convention rules from memory or a workspace draft.
2. Inspect existing nearby entity/model patterns before adding a new abstraction.
3. Treat generated code and third-party code as convention exceptions unless the user explicitly asks to regenerate or edit them.

## Implementation Rules

1. Prefer existing repo patterns, namespaces, file layout, and helper APIs.
2. Keep reference-type default expressions explicit as `null` when that is the established convention.
3. Avoid broad naming churn unless the request is specifically a naming cleanup.
4. When adding an entity-like type, update only directly required binders, tables, and docs. Update tests only when the user requests them or an existing independently defined contract requires the change.
5. Keep package/runtime documentation and version updates separate. Before an authorized commit containing UnityO package changes, or for an explicit release/version request, finish this code phase and route a later sequential phase to `$oojjrs-unity-package-release`; do not preload both domains.

## Evidence-Based Validation

1. Check only the entity/model contracts affected by the change, such as binder and table type references, interface signatures, namespaces, and generated-code boundaries.
2. Run a build or test only when the user explicitly requests it. Use the smallest established target that answers the request.
3. Before asserting a test result, require an independent oracle: an explicit user requirement, an authoritative contract, previously confirmed behavior, or a reproducible bug with a known correct outcome.
4. Do not invent expected input/output from the same interpretation used to implement the code. When no independent oracle exists, leave semantic behavior for user verification instead of presenting a self-consistent test as proof.

For review-only requests, do not build, test, or edit unless the user asks.
