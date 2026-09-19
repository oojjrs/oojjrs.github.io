---
name: oojjrs-unity-prefab-edit-workflow
description: Create, revise, move, rename, or delete Unity prefabs and change prefab hierarchy, components, serialized fields, overrides, or references through the official Unity CLI. Requires explicit approval of the exact prefab targets and operations before mutation. Do not use for read-only GUID tracing or non-prefab assets.
---

# oojjrs Unity Prefab Edit Workflow

Use this as the only mutation workflow for `.prefab` files. Read-only prefab and serialized-reference tracing remains in `$oojjrs-unity-prefab-guid-usage-lookup`.

## Approval Gate

Before changing anything, present:

- every exact prefab path;
- the hierarchy, component, field, override, reference, move, rename, creation, or deletion operation for each target; and
- the official Unity CLI and Editor API path that will perform it.

Obtain explicit user approval for that scope. A general feature, fix, asset, UI, scene, animation, or validation request does not authorize prefab mutation. Reuse approval only when the targets and operations are unchanged in the current task; obtain new approval when the scope expands.

## Official Editor Path

1. After approval, use `$unity-cli`. Run `unity status`, target the exact project with `--project-path` when necessary, and discover the live command catalog.
2. Pass `--caller plugin --skill oojjrs-unity-prefab-edit-workflow` on every `unity command` invocation.
3. Use Unity Editor APIs such as `PrefabUtility`, `SerializedObject`, and `AssetDatabase` through the official CLI. Use `$ui-ugui` for uGUI-specific design guidance while keeping mutation execution in `$unity-cli`.
4. Never hand-edit prefab YAML or `.meta` text, and never use a different mutation tool as a fallback. Read-only YAML/GUID inspection and Git diff review are allowed.
5. Let Unity create or update `.meta` files through its importer. Use Unity's asset APIs for moves and renames so existing GUIDs remain stable; never fabricate or transplant GUID text.
6. If a compatible Editor cannot be reached, the project is hidden by the sandbox, Safe Mode prevents the Pipeline package from loading, or the required command is unavailable, stop and report the blocker. Do not reinterpret that failure as permission for direct file editing.

## Mutation And Readback

1. Inspect the current prefab hierarchy, components, serialized fields, nested-prefab relationships, and instance overrides through Unity before editing.
2. Apply only the approved operations. Save the prefab and assets through Unity, then reimport when the selected API requires it.
3. Read the prefab back through Unity and confirm the intended hierarchy paths, component types, serialized values, object references, nested-prefab source links, and overrides.
4. Inspect the scoped Git diff after Unity saves. Unexpected broad reserialization, unrelated overrides, missing references, or GUID churn is a failure; do not normalize or repair the YAML by hand.
5. Report the approved targets, actual CLI operation, readback evidence, resulting diff scope, and unresolved runtime validation needs.
