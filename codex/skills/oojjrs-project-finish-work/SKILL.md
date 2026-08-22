---
name: oojjrs-project-finish-work
description: Complete an explicitly requested stage, commit, push, deploy, release, or other Git completion operation for a scoped diff or commit without inferring file-content edit authority. Use only when Git or publication completion is in scope. Do not use after ordinary edits, for read-only review or diagnosis, or merely to enumerate validation, documentation, board, version, commit, and push decisions.
---

# oojjrs Project Finish Work

Use this lifecycle skill only for requested Git or publication completion. Ordinary edits finish under the canonical one-pass text-format and scoped-diff rule without loading this skill.

## Content Freeze

A stage or commit instruction freezes all non-document tracked and untracked content at the state present when that instruction arrives. Asking to gather related work, stage, commit, push, deploy, release, or publish authorizes only classification, exact staging, and the named state transition; it never authorizes a new edit to frozen content.

After that sign, the only automatic content changes are the minimum documentation synchronization and governed version-metadata update expressly required by an already applicable workflow; keep them narrow and behavior-neutral. Leave all code, prefabs, assets, data, settings, and other frozen content untouched even when it appears related, supporting, generated, defective, incomplete, contains a `TODO` or error, has missing references, or fails validation. Do not fix, complete, format, normalize, move, delete, replace, recreate, or regenerate it. If the same current request separately and explicitly authorized another content change, finish only that scope; otherwise report the defect, risk, or isolation blocker without repairing it.

## One-Pass Completion

1. Reuse any post-last-edit text-format result while the files remain unchanged. If none exists, run that exact check once. For a commit in the same task, defer the single scoped diff to the final staged review instead of reading both ordinary and staged versions; for non-commit completion, reuse or run the ordinary scoped diff once.
2. Do not start a build, test, server, browser, or new test suite merely because code changed. Follow the user's explicit execution request and the independent-oracle rule in the public validation guideline.
3. Evaluate only conditions that actually trigger. Documentation, Design, asset metadata, publication sync, board work, and versioning belong to their owning domain or current request; do not create or report `not applicable` decisions.
4. If a commit is requested, inspect the exact intended paths for governed versioned units. Read and apply only policies that govern units present in that scope; do not report that unrelated or absent units do not exist.
5. Stage the exact requested existing bytes without modifying their contents. Review `git diff --cached --name-status`, the staged diff, and `git diff --cached --check` once after staging is final.
6. If staged content changes, re-review only the final staged content and any policy directly affected by that change.
7. Commit, push, deploy, or publish only to the explicitly authorized target. For an external result, read back the resulting commit or deployment state once.

## Text Format

Run the installed shared checker in check-only mode on exact touched text files only when no unchanged final result is already available:

```powershell
powershell -ExecutionPolicy Bypass -File <oojjrs-guidelines-skill-dir>\scripts\Test-OojjrsTextFormat.ps1 -Path <exact-touched-files>
```

Never use `-Fix` on frozen content. Correct a mismatch only when the same current request explicitly authorized editing that affected content or the file changed under the narrow documentation/version exception; otherwise leave it untouched and report it. The checker's `-Fix` path verifies an authorized write, so do not add an unconditional second run.

## Commit Boundary

Do not stage files merely to prepare a report. Do not use broad staging when exact paths can express the requested scope. The final staged review is evidence, not repair authority; do not repeat unchanged working-tree status, history, or diffs around it.

## Final Report

Report in Korean: the completed Git or publication action, its resulting identifier or target, checks actually run, and any meaningful remaining risk. Omit inactive gates, routine skip reasons, unchanged Git history, and unrelated dirty files unless they affected safe completion.
