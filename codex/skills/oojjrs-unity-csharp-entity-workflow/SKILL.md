---
name: oojjrs-unity-csharp-entity-workflow
description: Add or refactor Unity C# entity/model/binding code in oojjrs Unity repos. Use for Game, Item, Action, Relation, Actor, TableT, EntityModelBindingT, null/default expression cleanup, Regex LIKE helpers, generated-code boundaries, package runtime changes, and loading the public Unity C# coding convention before those edits.
---

# oojjrs Unity C# Entity Workflow

Use this skill for Unity C# model/entity/runtime helper work.

## Required Context

1. Read `$oojjrs-guidelines`.
2. Read the Unity C# coding convention before editing code:
   - Prefer `codex/unity-csharp-coding-convention.md` when it exists in the current workspace.
   - Otherwise, on Windows load `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md` with `Invoke-WebRequest -UseBasicParsing`.
   - If that request fails, retry with another available HTTP client or browser before concluding the document is unavailable. A blocked direct-URL web tool or `curl.exe` Schannel error does not prove the site or document is unavailable.
   - If every method fails, report the access failure before editing and do not infer convention rules from memory alone.
3. Inspect existing nearby entity/model patterns before adding a new abstraction.
4. Treat generated code and third-party code as convention exceptions unless the user explicitly asks to regenerate or edit them.

## Implementation Rules

1. Prefer existing repo patterns, namespaces, file layout, and helper APIs.
2. Keep reference-type default expressions explicit as `null` when that is the established convention.
3. Avoid broad naming churn unless the request is specifically a naming cleanup.
4. When adding an entity-like type, update only directly required binders, tables, docs, and tests.
5. Keep package/runtime documentation and version updates separate unless the user asks for a release bundle or `$oojjrs-unity-package-release` applies.

## Validation

Use the repo's established validation. In package repos this is often:

```powershell
dotnet build <repo-project>.csproj -nologo -v minimal
git diff --check
git ls-files --eol -- <touched-files>
```

For review-only requests, do not build or edit unless the user asks.
