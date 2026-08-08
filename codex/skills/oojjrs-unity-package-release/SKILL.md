---
name: oojjrs-unity-package-release
description: Prepare or review an explicit oojjrs Unity package release/version bundle. Use when the user asks to release, ship, bump a package version, synchronize release metadata/docs, or assess release readiness. Do not use for an Assets-to-Packages/src migration or merely because ordinary package files changed; migration owns its incidental version/docs and generic finish owns commit/push gates.
---

# oojjrs Unity Package Release

Use this as the primary domain when a Unity package change is explicitly being prepared or reviewed as a release bundle. Package-root migration is a different primary domain and must not be stacked with this skill.

## Release Scope

1. Confirm the package root, usually `Packages/src`.
2. Identify the version source, usually `Packages/src/package.json`.
3. Check whether root `README.md`, package `README.md`, samples, docs, or changelog-like notes must match the runtime change.
4. Keep release docs/version updates in the same bundle when the requested release scope requires them. Leave staging, commit, and push authorization to the finish lifecycle.

## Metadata Checks

Verify:

- `Packages/manifest.json` references the local package correctly when applicable.
- `Packages/packages-lock.json` matches the local package entry when applicable.
- package name, display name, version, and README install snippets agree.
- Codex created or modified no `.meta` files; every user- or Unity-generated in-scope `.meta` file is included with its asset even when Git reports it as new or untracked, and only unrelated out-of-scope `.meta` files are excluded.

## Validation

Use repo-specific gates. Common gates:

```powershell
dotnet build <repo-project>.csproj -nologo -v minimal
git diff --check
git diff --cached --check
git ls-files --eol -- <touched-files>
```

If a review-only request triggered this skill, inspect only and do not build, edit, stage, or commit.
