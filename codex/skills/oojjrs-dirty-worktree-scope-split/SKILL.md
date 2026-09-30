---
name: oojjrs-dirty-worktree-scope-split
description: Isolate requested work in a dirty Git repository when target files overlap pre-existing or concurrent changes, hunks are interleaved, or safe staging/commit separation is genuinely ambiguous. Do not use merely because git status is dirty, for read-only dirty-state diagnosis, or for changes that can simply be left untouched.
---

# oojjrs Dirty Worktree Scope Split

Use this helper only after the start gate or finish-phase Scope Reconciliation confirms a real overlap, uncertain classification, or staging-isolation problem. Use `$oojjrs-windows-repo-forensics` instead when the question is why a path or repository appears dirty.

## Scope Evidence

1. Reuse the requested paths and overlap evidence already established for the task. Do not repeat broad Git status or history checks merely because this helper was loaded.
2. Inspect only the files and hunks whose ownership overlaps or remains uncertain.
3. Classify those changes as requested scope, related support files, unrelated existing work, task-owned generated/temp files, or unknown according to their semantic role in the carried task outcome, not their author. Protection and permitted in-scope maintenance-document or governed version edits follow the common rules; classification alone never authorizes changes to existing user code, assets, or unrelated hunks. Requested-scope and related-support bytes are staging-eligible only when the current Git instruction covers that outcome; unrelated and unknown bytes are not.
4. Refresh evidence only for an affected file that changed after review or inspection, for a newly appearing candidate path, or immediately before isolating its hunks for a commit.
5. Do not revert or clean any pre-existing, concurrent, or unknown change. Protection forbids unauthorized content edits; permitted maintenance-document and governed version updates may precede freezing and staging requested-scope or related-support bytes. The common rules' `$Trash` and task-owned-output exception remains disposable.

## Narrow Work

1. Read only the overlapping diffs needed to separate ownership.
2. Edit only the authorized task scope, including necessary maintenance-document and governed version updates before freezing. Commit classification alone does not authorize changes to existing user code, assets, or unrelated hunks.
3. Stage exact requested-scope and related-support paths or isolated hunks when committing the reconciled work; never use broad `git add -A` unless the whole dirty tree is the current task scope.
4. Leave the final staged-content review to the commit workflow instead of duplicating it here.
5. If unrelated changes are interleaved in the same file, avoid staging until you can isolate hunks safely; ask only if isolation is impossible.

## Worktree Split

Use a separate worktree when the user wants independent review slices or the root checkout must return clean.

Before moving files recursively on Windows, resolve absolute paths and confirm they stay inside the intended workspace.

## Reporting

Report the included and excluded overlapping scope, plus any unresolved isolation risk. Do not inventory unrelated dirty files that did not affect the task.
