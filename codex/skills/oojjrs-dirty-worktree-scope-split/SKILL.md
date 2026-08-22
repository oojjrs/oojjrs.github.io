---
name: oojjrs-dirty-worktree-scope-split
description: Isolate requested work in a dirty Git repository when target files overlap pre-existing or concurrent changes, hunks are interleaved, or safe staging/commit separation is genuinely ambiguous. Do not use merely because git status is dirty, for read-only dirty-state diagnosis, or for changes that can simply be left untouched.
---

# oojjrs Dirty Worktree Scope Split

Use this helper only after the start gate confirms a real overlap or staging-isolation problem. Use `$oojjrs-windows-repo-forensics` instead when the question is why a path or repository appears dirty.

## Scope Evidence

1. Reuse the requested paths and overlap evidence already established for the task. Do not repeat broad Git status or history checks merely because this helper was loaded.
2. Inspect only the files and hunks whose ownership overlaps or remains uncertain.
3. Classify those changes as requested scope, related support files, unrelated existing work, generated/temp files, or unknown. Classification controls isolation and staging eligibility only; it never grants authority to edit content.
4. Refresh evidence only for an affected file that changed after inspection or immediately before isolating its hunks for an authorized commit.
5. Do not revert or clean any pre-existing, concurrent, or unknown change. Treat all of it as protected user or parallel-thread work regardless of relatedness.

## Narrow Work

1. Read only the overlapping diffs needed to separate ownership.
2. Edit only content whose change the current request explicitly authorizes or that falls under the common rules' narrow post-sign documentation/version exception. Never edit protected work merely because it was classified as requested or related for a commit.
3. Stage exact paths or isolated hunks only when a commit is authorized; never use broad `git add -A` unless the whole dirty tree is the requested scope.
4. Leave the final staged-content review to the commit workflow instead of duplicating it here.
5. If unrelated changes are interleaved in the same file, avoid staging until you can isolate hunks safely; ask only if isolation is impossible.

## Worktree Split

Use a separate worktree when the user wants independent review slices or the root checkout must return clean.

Before moving files recursively on Windows, resolve absolute paths and confirm they stay inside the intended workspace.

## Reporting

Report the included and excluded overlapping scope, plus any unresolved isolation risk. Do not inventory unrelated dirty files that did not affect the task.
