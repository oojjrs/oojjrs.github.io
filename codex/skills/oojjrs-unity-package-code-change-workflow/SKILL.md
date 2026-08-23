---
name: oojjrs-unity-package-code-change-workflow
description: Implement C# Runtime or Editor features, bug fixes, behavior changes, and public API changes in UnityO-prefixed Unity library packages when no more-specific workflow applies. Do not use for documentation-primary work, version/release-only work, Assets-to-Packages/src migration, entity families, Steamworks-specific integration, asset/prefab-only changes, game-project code, or Git completion.
---

# oojjrs Unity Package Code Change Workflow

Use this as the fallback implementation domain for first-party C# under a `UnityO...` library package's `Runtime` or `Editor` surface. Assume the common lifecycle and project-start gate already own authorization, protected work, and the Unity C# convention preflight; do not duplicate them here.

## Scope Boundary

Keep the following work in its more-specific domain instead:

- documentation as the primary deliverable: `$oojjrs-unity-package-docset-maintenance`;
- version decisions, release readiness, or release-only changes: `$oojjrs-unity-package-release`;
- an actual `Assets` to `Packages/src` structural migration: `$oojjrs-unity-package-src-migration`;
- first-party Data, Record, Manager, DataBuilder, Hub, or transport entity families: `$oojjrs-unity-csharp-entity-workflow`;
- Steamworks-specific implementation or operation: `$oojjrs-steamworks`;
- asset- or prefab-only work, including serialized wiring with no package code change;
- game-project application or business-layer code outside the UnityO library; and
- staging, commit, push, deployment, or other Git completion: `$oojjrs-project-finish-work`.

When an excluded domain becomes necessary, finish the current package-code phase and route the next phase separately. Do not use this fallback to override a more-specific workflow.

## Establish The Local Contract

1. Resolve the package root from its `package.json`, confirm that the target is a UnityO-prefixed library, and identify the affected Runtime or Editor assembly.
2. Read the repository-local architecture material that governs the target. Search the package's `Documentation~`, root and package README files, assembly definitions, and nearby implementation before inferring a design. Treat UnityOui, UnityOdb, UnityOplat, and other packages as distinct systems; never encode one package's rules as a cross-package default.
3. Inspect the nearest complete peer in the same package and assembly, then trace actual consumers of the changed type, member, namespace, event, or behavior. Include relevant package samples, tests, dependent assemblies, reflection or string-based lookups, and serialized references when they are real consumers.
4. Separate the requested contract from the current implementation and from incidental peer behavior. Prefer direct consumer evidence over copying a superficially similar type.

Before editing an observable API, behavior, dependency, lifetime, failure, or threading contract, read [the API impact checklist](references/api-impact-checklist.md) and resolve only its affected sections. Ask the user only when a missing choice would materially change the public contract or compatibility result.

## Implement The Smallest Cohesive Change

1. Change only the files and call sites needed to satisfy the resolved contract. Preserve the package's namespace, assembly boundary, Runtime/Editor separation, dependency direction, and established extension shape.
2. Preserve existing consumers when that is compatible with the request and local policy. Do not add speculative adapters, overloads, abstractions, or compatibility shims without an evidenced consumer or contract need.
3. Keep initialization, disposal, event subscription, cancellation, exception, and thread-affinity behavior consistent across every touched producer and consumer. A locally compiling signature change is incomplete when one of those contracts no longer holds.
4. Do not directly edit generated or vendored code. Follow its source or generator path when established; otherwise stop and identify the missing authoritative path.
5. Preserve an existing script `.meta` file and GUID when moving or renaming code. When a new script is added in a tree that tracks companion metadata, create its `.meta` from the nearest established script pattern with a fresh unique 32-hex GUID, verify that GUID does not already occur in the repository, and keep the pair in the same scope. Follow an evidenced package policy that intentionally omits script metadata; do not leave the ownership of a required companion file unresolved.

## Synchronize Directly Affected Surfaces

- Update only documentation statements and existing CHANGELOG entries that the code change makes stale or incomplete. Match the repository's current location and style; do not create a documentation hierarchy or a CHANGELOG solely for this task.
- Recheck the affected consumers and search for obsolete public names, signatures, assembly references, or call patterns after the final edit.
- Do not decide or apply the package version in this phase. Record the observable behavior and consumer impact needed by `$oojjrs-unity-package-release`, then hand off to it before any commit containing the package change.
- Leave staging, commit, push, deployment, and publication to `$oojjrs-project-finish-work` after the release decision.

The handoff should identify the changed package and contract, affected consumers, compatibility decision, direct documentation or CHANGELOG synchronization, and any unresolved compile, runtime, dependency, serialization, or `.meta` risk.
