---
name: oojjrs-unity-animation-asset-workflow
description: Create, revise, or repair Unity AnimationClips, AnimatorControllers, AnimatorOverrideControllers, and sprite bindings through the official Unity CLI and Editor APIs. Use for curves, timing, loop settings, states, transitions, parameters, bindings, or broken animation references. Do not use to draw animation frames, implement Animator-related C# code, or mutate prefabs.
---

# oojjrs Unity Animation Asset Workflow

Use this as the primary domain for Unity animation assets. Route frame or sprite-sheet artwork to `$oojjrs-2d-sprite-animation`, Animator-related C# implementation to the applicable code workflow, and every prefab mutation to `$oojjrs-unity-prefab-edit-workflow` as a separate approved phase.

## Official Editor Path

1. Use `$unity-cli` for every mutation. Run `unity status`, target the exact project with `--project-path` when necessary, and discover the connected Editor's commands before choosing an operation.
2. Pass `--caller plugin --skill oojjrs-unity-animation-asset-workflow` on every `unity command` invocation.
3. Create or change `.anim`, `.controller`, `.overrideController`, and related serialized assets only through Unity Editor APIs such as `AnimationUtility`, `AnimatorController`, and `AssetDatabase` executed through the official CLI.
4. Never hand-edit Unity YAML or `.meta` text. Read-only inspection, GUID lookup, and Git diff review are allowed. Let Unity generate or update `.meta` files through import/save operations, and include the resulting in-scope metadata with its asset.
5. If the official CLI cannot reach a compatible Editor or the required command/API is unavailable, stop the mutation phase. Do not fall back to raw YAML, fabricated GUIDs, or another editor automation path.

## Establish The Contract

- Inspect the target clip, controller, animated hierarchy, component type, property path, frame rate, loop behavior, and existing state/transition contract before editing.
- Resolve sprite references from Unity's imported assets. When sprite slicing, pivots, borders, or internal IDs are involved, use `$sprite-editor` through `$unity-cli`; do not infer subasset IDs from filenames or edit importer metadata directly.
- Preserve existing asset GUIDs, controller parameters, state hashes, bindings, and external references unless the request explicitly changes them.
- Treat an animation request as permission for the named animation assets only. Wiring a controller or clip into a prefab requires the prefab workflow's explicit preflight approval.

## Apply And Verify

1. Perform the smallest cohesive Editor-side change and save/import it through Unity.
2. Read the resulting assets back through Unity APIs and verify the changed clip length, frame rate, wrap/loop settings, curve bindings, key times, state motions, transitions, parameters, and referenced sprite subassets as applicable.
3. Check the scoped Git diff after Unity saves. Use the diff as review evidence, not as an invitation to repair YAML by hand.
4. If Unity regenerated a `.meta`, confirm that the generated GUID and expected asset pairing are valid. For an existing asset, an unexpected GUID change is a failure to investigate before commit.
5. Report the CLI operation used, the assets changed, the readback result, and any prefab connection still awaiting approval.
