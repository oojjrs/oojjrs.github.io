---
name: oojjrs-project-finish-work
description: Complete explicitly authorized local staging, commit, push, deploy, release, publication, or destructive Git operations without inferring unrelated file-content edit authority. Use only when the current request authorizes Git or publication completion, not for ordinary uncommitted edits, read-only review, diagnosis, or merely enumerating completion decisions.
---

# oojjrs Project Finish Work

Use this lifecycle skill only for Git or publication completion explicitly authorized by the current request. Follow the [common work rules](https://oojjrs.github.io/codex/common-work-guidelines.md) for Git authorization, scope, synchronization, and commit messages.

## Scope Reconciliation

Immediately before staging, take one fresh status snapshot and inspect only the current working-tree, index, and untracked changes needed to account for every candidate or newly appearing path. Classify them against the carried task outcome as requested scope, related support, unrelated existing work, or unknown; classify by semantic role and conversation context, never by whether Codex or the user authored the bytes.

If ownership overlaps, hunks are interleaved, or classification remains uncertain, load `$oojjrs-dirty-worktree-scope-split`. Freeze the final scope only after this reconciliation.

## Project Card Reconciliation

For every commit request, apply the canonical repository-linked board rule even when earlier work omitted it. Reuse the task's resolved board; otherwise check the resolved repository remote now. When a relevant board exists, use `$oojjrs-github-project-board` and reconcile matching cards with the actual commit scope before staging. Read completion criteria when needed; do not infer completion from a filename or commit message.

After the commit succeeds, finish the board helper's **Commit And Publication Handoff** before reporting completion.

## Content Freeze

메모리의 초기화·기록·정리·재개는 [문서 작성 지침 4·5번](https://oojjrs.github.io/codex/document-writing-guideline.md)을 따른다.

An authorized Git-completion instruction includes the maintenance-document and governed version updates needed by the reconciled task scope without a separate content-change instruction, within the text-addition approval scope of `https://oojjrs.github.io/codex/document-writing-guideline.md`. Read and follow that rule before any document or HTML edit; it takes precedence over this skill's maintenance-document instructions. Git-completion authorization alone does not approve new document wording. Apply those updates through their owning domain, complete any other requested content work, then freeze the final scope immediately before staging. After freezing, stage the final bytes without further content edits.

## Remote Synchronization

For every requested branch push or branch-backed publication, record the initiating checkout, its local target branch, and that branch's tip before creating or using an isolated or detached worktree.

Keep every preservation reference until restoration is verified. Resolve a rebase or restore conflict only within the frozen task scope; otherwise stop and report it. Dirty state is not a reason to publish from a stale alternate base.

Fast-forward when the initiating tip is an ancestor. When an isolated-worktree rebase rewrote the recorded initiating tip, keep a recoverable backup of that tip and move the initiating branch only after verifying that it has not advanced independently and that every old local commit is represented in the pushed history. If the initiating branch contains independent commits or restoration conflicts, retain the preservation and report the exact blocker; do not claim completion while that checkout remains behind.

## One-Pass Completion

1. Reuse a post-last-edit text-format or ordinary-diff result only while both its source bytes and accounted path set remain known unchanged. The final staged review replaces a second ordinary-diff review; it never replaces Scope Reconciliation after a path or byte change. For non-commit completion, reuse or run the ordinary scoped diff once.
2. Do not start a build, test, server, browser, or new test suite merely because code changed. Follow the execution-surface and independent-oracle rules in the public validation guideline.
3. Evaluate only conditions that actually trigger. Documentation, Design, asset metadata, publication sync, board work, and versioning belong to their owning domain or current request; do not create or report `not applicable` decisions.
4. If committing, inspect the exact intended paths for governed versioned units. Read and apply only policies that govern units present in that scope; do not report that unrelated or absent units do not exist.
5. Stage the exact reconciled, staging-eligible bytes after permitted maintenance-document and governed version updates are complete; do not modify their contents after freezing. Review `git diff --cached --name-status`, the staged diff, and `git diff --cached --check` once after staging is final.
6. If staged content changes, re-review only the final staged content and any policy directly affected by that change.
7. For a branch push or branch-backed publication, follow **Remote Synchronization**; for another external result, read back the resulting state once.

8. Reconcile project card status and work records with the verified result through **Project Card Reconciliation**. Do not prewrite push, publication, installation or other success from a plan or an agent report. An explicitly requested standalone memory task may have its own commit. Report any failed board update as unfinished work even when Git succeeded.

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
