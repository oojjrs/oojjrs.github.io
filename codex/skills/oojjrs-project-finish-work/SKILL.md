---
name: oojjrs-project-finish-work
description: Complete explicitly authorized local staging, commit, push, deploy, release, publication, or destructive Git operations without inferring unrelated file-content edit authority. Use only when the current request authorizes Git or publication completion, not for ordinary uncommitted edits, read-only review, diagnosis, or merely enumerating completion decisions.
---

# oojjrs Project Finish Work

Use this lifecycle skill only for Git or publication completion explicitly authorized by the current request. A change or fix request alone does not authorize staging or committing; an upfront Git-completion instruction or a requested push or publication authorizes its necessary scoped staging and local commit. Ordinary edits remain unstaged and uncommitted for user review and finish under the canonical one-pass text-format and scoped-diff rule without this skill.

## Scope Reconciliation

When Git completion follows review of an uncommitted result in the same Codex task, carry the most recently reported content scope forward as the candidate Git scope unless the latest request changes it. Immediately before staging, take one fresh status snapshot and inspect only the current working-tree, index, and untracked changes needed to account for every candidate or newly appearing path. Classify them against the carried task outcome as requested scope, related support, unrelated existing work, or unknown; classify by semantic role and conversation context, never by whether Codex or the user authored the bytes.

All non-task-owned existing bytes remain protected from Codex content edits. Requested-scope and related-support bytes are eligible to be staged unchanged when the current Git instruction covers that outcome; unrelated and unknown bytes are not. If ownership overlaps, hunks are interleaved, or classification remains uncertain, load `$oojjrs-dirty-worktree-scope-split`. Freeze the final scope only after this reconciliation.

## Content Freeze

After scope reconciliation, an explicit staging or commit instruction never authorizes content edits. When the task also includes content work, complete every requested content action and required documentation or governed version synchronization first, then freeze the reconciled scope immediately before staging. Leave protected work outside that scope untouched.

An explicitly requested merge, rebase, cherry-pick, or revert may make its normal worktree and index changes and the minimum conflict resolution needed to complete that operation. Re-review the resulting scoped bytes before commit; do not add unrelated repairs.

## One-Pass Completion

1. Reuse a post-last-edit text-format or ordinary-diff result only while both its source bytes and accounted path set remain known unchanged. The final staged review replaces a second ordinary-diff review; it never replaces Scope Reconciliation after a path or byte change. For non-commit completion, reuse or run the ordinary scoped diff once.
2. Do not start a build, test, server, browser, or new test suite merely because code changed. Follow the execution-surface and independent-oracle rules in the public validation guideline.
3. Evaluate only conditions that actually trigger. Documentation, Design, asset metadata, publication sync, board work, and versioning belong to their owning domain or current request; do not create or report `not applicable` decisions.
4. If committing, inspect the exact intended paths for governed versioned units. Read and apply only policies that govern units present in that scope; do not report that unrelated or absent units do not exist.
5. Stage the exact reconciled, staging-eligible existing bytes without modifying their contents. Review `git diff --cached --name-status`, the staged diff, and `git diff --cached --check` once after staging is final.
6. If staged content changes, re-review only the final staged content and any policy directly affected by that change.
7. Commit locally only as part of the explicitly authorized Git or publication outcome. Push, deploy, release, publish, or perform destructive Git operations only to the explicitly authorized target. For an external result, read back the resulting state once.

## Text Format

Run the installed shared checker in check-only mode on exact touched text files only when no unchanged final result is already available:

```powershell
powershell -ExecutionPolicy Bypass -File <oojjrs-guidelines-skill-dir>\scripts\Test-OojjrsTextFormat.ps1 -Path <exact-touched-files>
```

Never use `-Fix` outside the current task's content scope. Correct an in-scope mismatch before freezing the final bytes; otherwise leave it untouched and report it. The checker's `-Fix` path verifies its write, so do not add an unconditional second run.

## Commit Boundary

Do not stage files merely to prepare a report. Do not use broad staging when exact paths can express the requested scope. The required pre-stage reconciliation is not an unchanged repeat. After it is stable, the final staged review is evidence, not repair authority; do not repeat unchanged working-tree status, history, or diffs around it.

## Final Report

Report in Korean: the completed Git or publication action, its resulting identifier or target, checks actually run, and any meaningful remaining risk. Omit inactive gates, routine skip reasons, unchanged Git history, and unrelated dirty files unless they affected safe completion.
