---
name: oojjrs-unity-prefab-guid-usage-lookup
description: Trace Unity prefab, component, script, scene, animation, and serialized YAML usage by GUID instead of name-only grep. Use when the user asks where a prefab/component is used, whether a serialized reference is broken, whether Receiver/Handler/input wiring is mixed, or whether a Unity field/type migration affected prefab references.
---

# oojjrs Unity Prefab GUID Usage Lookup

Use this skill when Unity serialized references matter.

## Inputs

1. Confirm the repo and scope path.
2. Identify whether the target is a prefab, script/component, scene object, animation, or serialized field.
3. Find the target `.meta` GUID before searching YAML.
4. Open the current implementation if a field type or generated interface is involved.

## Search Procedure

1. Resolve target GUIDs from `.meta` files.
2. Search in-scope Unity YAML for exact GUIDs:
   - `m_SourcePrefab` for direct prefab usage
   - `m_Script` for component/script attachment
   - serialized field names for migration/type checks
3. Separate direct evidence from breadcrumb noise:
   - direct: `m_SourcePrefab: {fileID: 100100000, guid: ...}`
   - direct: `m_Script: {fileID: 11500000, guid: ...}`
   - uncertain: override `target` records, nested variant traces, stale comments
4. For field-type checks, map referenced `fileID` back to the local component block and verify its `m_Script`.
5. Exclude `Library`, generated caches, and user-excluded assets unless explicitly requested.

## Reporting Order

Report:

1. direct in-scope users
2. nested, transitive, or uncertain traces
3. excluded hits
4. expected type versus actual serialized type when claiming a mismatch

Every "used by" claim should have a concrete YAML location or GUID mapping.
