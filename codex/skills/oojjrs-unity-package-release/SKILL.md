---
name: oojjrs-unity-package-release
description: Finish and ship oojjrs Unity package repository changes after runtime, editor, docs, or package metadata updates. Use for Packages/src package.json version bumps, root README and package README synchronization, manifest/file:src checks, dotnet build validation, eol checks, narrow release commits, pushes, and package-family release bundles.
---

# oojjrs Unity Package Release

Use this skill when a Unity package repo change should be finished as a release bundle. Use `$oojjrs-unity-package-src-migration` for package-root migration itself.

## Release Scope

1. Confirm the package root, usually `Packages/src`.
2. Identify the version source, usually `Packages/src/package.json`.
3. Check whether root `README.md`, package `README.md`, samples, docs, or changelog-like notes must match the runtime change.
4. Keep release docs/version updates in the same bundle only when the user asked to finish/release/commit/push or the repo pattern clearly expects it.

## Metadata Checks

Verify:

- `Packages/manifest.json` references the local package correctly when applicable.
- `Packages/packages-lock.json` matches the local package entry when applicable.
- package name, display name, version, and README install snippets agree.
- no unwanted `.meta` files were created.

## Validation

Use repo-specific gates. Common gates:

```powershell
dotnet build <repo-project>.csproj -nologo -v minimal
git diff --check
git diff --cached --check
git ls-files --eol -- <touched-files>
```

If a review-only request triggered this skill, inspect only and do not build, edit, stage, or commit.
