# API And Behavioral Impact Checklist

Use only the sections affected by the requested change. Base each decision on repository-local architecture, a nearest complete peer, and actual consumers; do not produce a ceremonial full checklist or infer package-specific policy from another UnityO repository.

## Surface And Consumers

- Identify every changed type, member, overload, event, generic constraint, default value, namespace, assembly, conditional symbol, and observable behavior.
- Trace direct source consumers and any use through reflection, string names, attributes, dependency injection, serialization, samples, tests, or precompiled assemblies.
- Distinguish a public C# surface from a feature that consumers independently attach, instantiate, configure, or call. Record both when they lead to different compatibility or release consequences.
- Check whether Runtime consumers would gain an Editor-only reference or whether an Editor change leaks into a runtime assembly.

## Compatibility Decision

- Compare old and new call shapes, return values, null behavior, event timing, defaults, ordering, and side effects at each real consumer.
- Check serialized field and type identity when relevant, including renamed fields, moved namespaces or assemblies, managed-reference type names, and existing migration attributes.
- Decide explicitly whether to preserve the old surface, provide an evidenced forwarding or obsolete bridge, migrate all in-scope consumers, or accept a deliberate break. Do not silently choose a compatibility strategy that changes the requested contract.
- When old and new behavior cannot coexist, use repository policy and actual consumers to frame the smallest user decision needed before implementation.

## Dependencies And Assembly Boundaries

- Review affected `package.json` dependencies, asmdef references, `includePlatforms`, `excludePlatforms`, `defineConstraints`, `versionDefines`, and Unity version constraints.
- Keep optional integrations optional and prevent a public signature from exposing a type unavailable to one of its consumers.
- Check for new dependency cycles, duplicated transitive dependencies, runtime access to editor APIs, and compile-symbol combinations that remove a required implementation.
- Add or widen a dependency only when the requested behavior and local architecture require it.

## Lifetime And Ownership

- Identify who creates, initializes, enables, disables, disposes, or destroys the changed object and whether ownership transfers.
- Preserve domain reload, play-mode transition, assembly reload, static-state reset, and duplicate-registration behavior where the package supports those lifecycles.
- Pair subscriptions, callbacks, timers, handles, and native or managed resources with their established cleanup path.
- Check reinitialization, repeated enable/disable, partial initialization, and disposal-after-failure only when the changed path can encounter them.

## Failure And Exception Contract

- Preserve the established result for invalid input, missing state, cancellation, timeout, partial success, and dependency failure: exception, result value, callback, log, or no-op.
- If an exception can cross a public boundary, verify its type, timing, wrapping, cleanup, and whether synchronous validation moved into asynchronous execution or vice versa.
- Do not catch and suppress failures merely to preserve a signature. Do not expose new internal exception details without a contract reason.

## Threading And Async Contract

- Identify the required caller thread and the thread or synchronization context used for callbacks, events, continuations, and Unity API access.
- Preserve ordering, single-completion, cancellation, timeout, and disposal races for affected async paths.
- Check whether shared state needs the package's existing synchronization mechanism. Do not introduce a new locking or scheduling model when the local architecture already owns one.
- Ensure Editor callbacks and Runtime callbacks remain in their intended lifecycle and assembly context.

## Final Impact Pass

- Revisit each changed producer and real consumer against the chosen compatibility, dependency, lifetime, failure, and threading decisions.
- Search for obsolete names, signatures, call patterns, serialized identities, and assembly references in the affected scope.
- Synchronize only directly stale API or behavior documentation and an existing CHANGELOG when the repository uses one.
- Hand the observed behavior and consumer impact to `$oojjrs-unity-package-release`; leave version mutation and all Git completion outside this workflow.
