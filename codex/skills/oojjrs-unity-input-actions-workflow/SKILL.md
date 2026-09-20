---
name: oojjrs-unity-input-actions-workflow
description: Create, revise, rename, remove, or diagnose Unity Input System `.inputactions` assets, action maps, actions, bindings, control schemes, and generated C# wrappers through the official Unity CLI. Use for InputActionAsset changes; do not use for hotkey display enums or application behavior alone.
---

# oojjrs Unity Input Actions Workflow

Use this as the primary workflow for Unity Input System asset changes. Apply the canonical Unity work rules first.

## Hard Rules

1. Mutate every `.inputactions` asset only through the official Unity CLI connected to a compatible running Unity Editor. Pass `--caller plugin --skill oojjrs-unity-input-actions-workflow` on every `unity command` call.
2. Never hand-edit `.inputactions` JSON, its `.meta`, or a generated input wrapper. Let the CLI-driven Editor update the asset, import it, and regenerate configured wrapper code.
3. If no typed CLI command covers the change, put a focused C# builder under the project-root literal `$Trash` folder and invoke it with `unity command run_script`. The builder must use Unity Input System and Editor APIs, write only the requested asset, call `AssetDatabase.ImportAsset`, and remain idempotent.
4. Preserve existing action-map, action, binding, and control-scheme IDs. Let Input System APIs create IDs for genuinely new objects; never fabricate or replace IDs in text.
5. Preserve unrelated dirty files and unrelated members of the target asset. If the official CLI, Editor connection, Input System package, or import path is unavailable, stop instead of falling back to direct text edits.

## Scope Boundaries

- This workflow owns the `InputActionAsset`, its importer settings, and generated wrapper verification.
- Hotkey enums, key-label presentation, rebinding UI, and application behavior are separate concerns. Change them only when the request includes them.
- A generated callback interface may require ordinary C# consumers to add a new member. Do not invent callback behavior. When the user explicitly asks for an empty callback, add only the required empty stub; otherwise report or resolve the application-code requirement within the user's stated scope.
- Before editing ordinary Unity C# consumers, load and follow the Unity C# convention. Do not edit the generated wrapper manually.

## Workflow

1. Record the target asset's current Git state. Inspect its maps, actions, bindings, control schemes, `.meta` wrapper-generation settings, generated wrapper path, and implementations of generated callback interfaces.
2. Confirm the Editor is connected with `unity status --project-path <project>` and ready. Discover the installed command surface before assuming a specialized Input System command exists.
3. Build the smallest idempotent mutation:
   - find the map and action by exact name before creating them;
   - compare existing binding paths and binding groups before adding bindings;
   - use canonical control paths such as `<Keyboard>/f9` and `<Gamepad>/buttonWest`;
   - preserve processors, interactions, expected control types, and control-scheme membership unless the request changes them.
4. Compile-check a `run_script` builder with `--dry_run true`, then execute it through the Unity CLI. Import the changed asset through `AssetDatabase` so Unity regenerates its wrapper according to the existing `.meta` settings.
5. Inspect the scoped diff. A normal action addition should change the requested action and bindings plus the corresponding generated wrapper members and callback interface—nothing broader.
6. Reconcile ordinary C# callback consumers only as authorized. Keep a requested placeholder callback empty.

## Validation

Read back the requested action and bindings after import and verify:

- exact map and action names, action type, control paths, interactions, processors, and binding groups;
- wrapper generation occurred at the configured path without direct edits;
- existing IDs stayed stable and only new objects received new IDs;
- `unity command recompile_status` reports completion with `failed: false` when compilation is in scope;
- Unity console ground truth reports no current compilation failure;
- the scoped diff and text-format checks contain only the requested files and necessary generated or consumer changes.

Use a full project build or runtime input test only when requested or when the applicable validation rules identify it as the necessary independent oracle.
