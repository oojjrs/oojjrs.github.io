---
name: oojjrs-unity-csharp-entity-workflow
description: Add or revise Record-only, Data-and-Record, or Data-only first-party Unity entity families in oojjrs projects. Use for entity-specific Data, Record, Manager, DataBuilder, Hub registration, client Stub or equivalent, persistence, and record transport work. Do not use for Excel or XML content production or unrelated generic C# changes.
---

# oojjrs Unity C# Entity Workflow

Use `X` below as the entity-specific name, such as `Game`, `Item`, or `Region`. Follow the target project's established type kind, namespace, assembly, folders, and APIs; do not introduce literal generic types named `EntityData`, `EntityRecord`, or `EntityManager` unless they already exist.

## 1. Resolve The Shape Before Editing

Load `https://oojjrs.github.io/codex/unity-csharp-coding-convention.md` before editing first-party Unity C#. If it is unavailable, stop instead of inferring the rules from memory or a workspace copy.

Inspect the nearest complete peer in the target project first. Use Mines, NationZ, or Rebellion only when the target project has no complete peer.

Classify the requested entity as exactly one shape:

| Shape | Core types | Required fields | Manager |
| --- | --- | --- | --- |
| Record-only | `X`, `XRecord`, `XManager` | `XRecord`: `long Id` | Required |
| Data and Record | `X`, `XData`, `XRecord`, `XManager` | `XData`: `string Key`; `XRecord`: `long Id`, `string DataKey` | Required |
| Data-only | `XData`; add runtime, cache, or client wrapper types only when an established consumer requires them | `XData`: `string Key` | Do not create |

When any shape contains Data:

1. If the user did not say whether `XData` needs `int ReferenceIndex`, ask before editing. Never infer it from frequency or from a legacy `Index` field.
2. Do not create or edit the workbook or XML data content; the user supplies it separately.
3. If the project has no existing DataBuilder, stop and ask the user for help before creating the first one.

For a record-backed shape, if the project has no established Manager ownership or registration pattern, ask before introducing the first one.

Do not directly edit generated outputs, vendor code, or external package sources. Follow the established source schema or generator path, or ask the user when none is evident.

## 2. Add The Core Types

1. Add only the core types selected by the shape table.
2. `XData` always owns `string Key`; add `int ReferenceIndex` only when the user confirms it.
3. `XRecord` always owns `long Id`; add `string DataKey` only when `XData` and `XRecord` both exist.
4. Record-only `X` owns its `XRecord`. Data-and-Record `X` owns both its resolved `XData` and its `XRecord`. Match peer constructor and mutability patterns.
5. Data-only never gains an `XRecord` or `XManager`. Follow a complete peer when real consumers require runtime `X`, `XMemory`, `XCache`, a Data cache, or a client wrapper.
6. Add relationship fields and lookup APIs only from the requested contract. Do not copy unrelated fields from the reference entity.
7. Follow the target repository's Unity metadata workflow for new scripts or assets. Preserve existing GUIDs and never invent a `.meta` GUID or a serialized asset reference.

## 3. Wire The Data Path

Skip this section for Record-only entities.

1. Trace one peer to identify every established Data destination in each relevant runtime, such as a raw Data cache, server registry, or client wrapper registry. Add the corresponding keyed storage APIs using `Key`.
2. Extend the existing DataBuilder in its established order: serialized input field when applicable, one deserialization/build step, population of every required destination, then dependent initialization. Data must be ready before a Data-and-Record Manager ingests records.
3. When the project uses a DataBuilder prefab or scene component, wire the user-supplied data asset into its serialized field. If the asset is not present yet, leave only that binding pending and report the exact missing link; never fabricate XML content, an asset, or a GUID.
4. When Data exists, explicitly check whether the target client uses an `XStub` or equivalent Data representation. If peers do, include the complete local path by default: wrapper construction, registry insertion, missing-value fallback when present, key lookup, and entity-to-wrapper conversion. Preserve equivalent local forms such as a Bridge/Reference layer or an `ExX` wrapper instead of forcing a `Stub` suffix.
5. If `ReferenceIndex` is present, follow the peer's complete binding through the wrapper, reference table or loader, Hub/asset holder, and serialized asset assignment. Do not invent an unrelated presentation consumer.

For Data-only work, finish the core Data, DataBuilder, registry, and required client wrapper paths here. Do not continue into Manager or record transport work.

## 4. Add And Register The Manager

1. Mirror the nearest complete peer's core Manager surface and null/identity policy, including its primary `Record.Id` lookup, values, clear, insert, select, delete, and single or batch Upsert operations when present.
2. A Record-only Manager constructs `X` directly from `XRecord`. A Data-and-Record Manager resolves `XData` from `Record.DataKey` and constructs `X` from both values; verify the correct raw-Data or wrapper-backed resolver separately for each runtime.
3. Preserve the peer's Upsert and indexed-field invariants. Do not silently add Data rebinding or secondary-index migration that peers do not support. If the requested contract allows `DataKey` or an indexed relation key to change and the intended behavior is not established, ask the user.
4. Register the Manager in `Hub.Ingame.Manager` and its matching `Clear` path when that is the project convention. Apply the equivalent Manager and lifecycle registration in every required server or host runtime. Preserve a different established ownership model, such as static Managers, instead of adding a new Hub solely for uniformity.

## 5. Complete Record Creation And Transport

Record data normally originates on the server or host. Trace one complete peer path and add only the equivalent required links:

1. Record creation or persistence mapping, including the established source or assignment of `Id` and `DataKey = data.Key` for Data-backed records.
2. Server or host Manager ingestion and any ship, response-builder, dirty-buffer, or persistence registration.
3. Response or packet payload and manual serializer fields when the project does not generate them. Keep reader and writer field order identical.
4. Client response handling into `XManager.Upsert`, followed by the project's notifier or update buffer.
5. Global flush, response, notifier enumeration, and lifecycle lists that explicitly enumerate peer entity types.

Do not assume that every record is database-persistent, networked, or represented by a Unity model. Add optional runtime or model bindings only when the requested behavior and a peer entity require them.

## 6. Review Completeness

Before finishing, verify the selected shape and its end-to-end registrations:

- every Data has `Key`, every Record has `Id`, and only Data-backed Records have `DataKey`;
- the user's `ReferenceIndex` decision is reflected consistently;
- Data-only work has no Record or Manager;
- DataBuilder registration completes before dependent initialization or record ingestion;
- every Manager registration has the matching clear/lifecycle entry in each required runtime;
- Manager Upsert and secondary-index behavior preserves the peer's documented invariants;
- every required record creation, transport, receive, and notification hop is connected; and
- every established client Data wrapper, lookup, fallback, and ReferenceIndex binding is complete when applicable.
