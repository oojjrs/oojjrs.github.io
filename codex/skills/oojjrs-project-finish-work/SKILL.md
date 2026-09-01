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

## Remote Synchronization

For every requested branch push or branch-backed publication, record the initiating checkout, its local target branch, and that branch's tip before creating or using an isolated or detached worktree. Immediately before the push sequence, fetch the exact target remote and branch and compare the local and fetched tips.

1. If the tips are equal or only the local side has commits, leave the local branch unchanged.
2. If only the fetched target has commits, recoverably preserve the checkout whose branch will move, including its index, unstaged changes, and untracked paths; fast-forward the local target branch; then restore that state.
3. If both sides have commits, preserve the same state, rebase the local commits onto the fetched target unless the user explicitly chose a merge, and restore that state before staging, committing, or pushing.

Keep every preservation reference until restoration is verified. Resolve a rebase or restore conflict only within the frozen task scope; otherwise stop and report it. Dirty state is not a reason to publish from a stale alternate base.

After pushing, read back the exact remote target and verify that it contains the pushed commit. Before reporting completion, reconcile the initiating checkout's local target branch to the verified remote tip and restore its preserved index, unstaged changes, and untracked paths. Fast-forward when the initiating tip is an ancestor. When an isolated-worktree rebase rewrote the recorded initiating tip, keep a recoverable backup of that tip and move the initiating branch only after verifying that it has not advanced independently and that every old local commit is represented in the pushed history. If the initiating branch contains independent commits or restoration conflicts, retain the preservation and report the exact blocker; do not claim completion while that checkout remains behind.

## One-Pass Completion

1. Reuse a post-last-edit text-format or ordinary-diff result only while both its source bytes and accounted path set remain known unchanged. The final staged review replaces a second ordinary-diff review; it never replaces Scope Reconciliation after a path or byte change. For non-commit completion, reuse or run the ordinary scoped diff once.
2. Do not start a build, test, server, browser, or new test suite merely because code changed. Follow the execution-surface and independent-oracle rules in the public validation guideline.
3. Evaluate only conditions that actually trigger. Documentation, Design, asset metadata, publication sync, board work, and versioning belong to their owning domain or current request; do not create or report `not applicable` decisions.
4. If committing, inspect the exact intended paths for governed versioned units. Read and apply only policies that govern units present in that scope; do not report that unrelated or absent units do not exist.
5. Stage the exact reconciled, staging-eligible existing bytes without modifying their contents. Review `git diff --cached --name-status`, the staged diff, and `git diff --cached --check` once after staging is final.
6. If staged content changes, re-review only the final staged content and any policy directly affected by that change.
7. Commit locally only as part of the explicitly authorized Git or publication outcome. Push, deploy, release, publish, or perform destructive Git operations only to the explicitly authorized target. For a branch push or branch-backed publication, follow **Remote Synchronization**; for another external result, read back the resulting state once.

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
