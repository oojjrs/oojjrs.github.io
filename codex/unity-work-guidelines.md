# Unity Work Rules

Canonical URL: `https://oojjrs.github.io/codex/unity-work-guidelines.md`

Apply these rules to work in Unity projects and packages. Read them before selecting a Unity workflow skill.

1. Treat every Unity prefab as user-owned and read-only. Never create, modify, rewrite, move, rename, or delete a `.prefab` file, and never use Unity or another tool to change a prefab's hierarchy, components, serialized fields, overrides, or references. A feature, fix, asset, UI, scene, or validation request does not grant prefab mutation authority. If the requested outcome depends on a prefab change, leave the prefab untouched and report the exact manual change the user must make. Only a later user instruction that explicitly revokes or amends this rule may authorize prefab mutation.
2. Before writing or editing Unity C# code, follow `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md`. That document governs code conventions; these rules govern work in the Unity environment.
