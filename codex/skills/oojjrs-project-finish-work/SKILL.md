---
name: oojjrs-project-finish-work
description: Complete an explicitly requested stage, commit, push, deploy, release, or other Git completion operation for a scoped diff or commit. Use only when Git or publication completion is in scope. Do not use after ordinary edits, for read-only review or diagnosis, or merely to enumerate validation, documentation, board, version, commit, and push decisions.
---

# oojjrs Project Finish Work

Use this lifecycle skill only for explicitly requested Git or publication completion. Shared format, validation, diff, and reporting rules remain in the canonical workflow.

## Completion Gate

1. Reuse a post-last-edit format result or reviewed diff while its source bytes remain unchanged. For a commit, the final staged review replaces an ordinary working-tree diff.
2. Evaluate only finish conditions that trigger. For a commit, inspect the exact intended paths for governed versioned units and apply only policies governing units present in that scope.
3. Stage exact requested paths. Never stage merely to prepare a report, and do not use broad staging when exact paths can express the scope.
4. After staging is final, review `git diff --cached --name-status`, the staged diff, and `git diff --cached --check` once. Reuse that review while the staged bytes remain unchanged.
5. If staged content changes, review only the new final staged content and any policy directly affected by the change.
6. Commit, push, deploy, release, or publish only to the explicitly authorized target. Read back the resulting commit, remote ref, deployment, or publication state once.
