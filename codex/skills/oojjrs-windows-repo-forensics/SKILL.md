---
name: oojjrs-windows-repo-forensics
description: Investigate Windows-local repository, filesystem, OneDrive, Visual Studio, TortoiseGit, case-only path, sync queue, and suspicious folder provenance issues from direct local evidence. Use when the user asks what a folder is, why a repo looks dirty, whether OneDrive is really syncing, why two repo-like paths differ, or which files are Git-meaningfully unique.
---

# oojjrs Windows Repo Forensics

Use this skill for local evidence-based diagnostics. Default to read-only investigation.

## Evidence Order

1. Local filesystem metadata and path structure.
2. Git state: `git status`, `git ls-files`, `git diff`, `git config`.
3. App-specific databases or manifests when relevant, such as OneDrive sync databases or Visual Studio `.vs` state.
4. Logs and process state.
5. Web search only after local evidence is insufficient.

## Common Cases

- OneDrive Activity Center history versus real sync backlog
- `SyncEngineDatabase.db` queue tables
- TortoiseGit overlay false-dirty states
- `core.ignorecase` and case-only path drift
- Visual Studio partial workspaces or repo-like snapshots
- Git-tracked unique files versus superficial on-disk differences
- Epic Online Services/game cache folders under user document paths

## Rules

1. Explain from concrete local evidence, not generic guesses.
2. Do not delete, move, or "fix" files unless the user asks.
3. When comparing folders, say whether "unique" means Git-tracked, byte-different, path-only, or generated/temp.
4. Preserve relative paths when extracting or reporting meaningful differences.
