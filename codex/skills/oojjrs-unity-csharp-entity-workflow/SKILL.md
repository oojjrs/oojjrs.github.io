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
4. When adding an entity-like type, update only directly required binders, tables, docs, and tests.
5. Keep package/runtime documentation and version updates separate. If the user requests a release bundle, finish this code phase and route a later sequential phase to `$oojjrs-unity-package-release`; do not preload both domains.

## Validation

Use the repo's established validation. In package repos this is often:

```powershell
dotnet build <repo-project>.csproj -nologo -v minimal
git diff --check
git ls-files --eol -- <touched-files>
```

For review-only requests, do not build or edit unless the user asks.
