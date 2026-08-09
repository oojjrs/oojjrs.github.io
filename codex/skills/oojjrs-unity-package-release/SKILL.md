---
name: oojjrs-unity-package-release
description: Decide or apply versions for UnityO-prefixed Unity library packages, or review their release readiness. Use whenever a UnityO package change reaches finish/version evaluation, before every authorized commit containing such a change, and for explicit release/version requests. Do not use for game versioning or Assets-to-Packages/src migration; migration owns its incidental version decision.
---

# oojjrs Unity Package Release

Use this for `UnityO...` libraries only. Each package's `package.json` is its version source; game versions follow a separate release policy.

Before every authorized commit containing a UnityO library change, classify each changed package against the Version Rule even when the user did not explicitly request a version bump. A no-bump result must still be reported.

## Version Rule

| Change | Result |
|---|---|
| Convention, cleanup, docs, tests, samples, metadata, settings, or internal reorganization with no behavior change | No bump |
| Bug fix; behavior change in existing files; new internal implementation file not used independently by consumers | Patch |
| Add, delete, rename, move, split, or merge a feature file used independently by consumers | Minor |
| Replace the package's design, usage philosophy, or core mechanism | Ask the user before a major bump |

Judge consumer use by whether they directly attach, create, reference, or call the feature, not by C# accessibility alone. A breaking public API edit inside an existing file remains patch unless it changes the package's design or mechanism.

Normally include one version change per atomic commit. For ordered commits, apply each bump from the version produced by the preceding commit; the highest change within one commit wins.

## Release Check

Verify the package root, `package.json`, applicable manifest/lock entries, README install version, repo-specific build, and companion `.meta` files. Codex must not create or modify `.meta` files; include only in-scope user- or Unity-generated metadata.

Review-only requests stay read-only. Staging, commit, and push remain finish-work decisions.
