---
name: oojjrs-github-project-board
description: Automatically manage a confirmed repository-linked GitHub Project v2 task board during implementation, document, asset, maintenance, or Git-completion work under the user's standing authorization. Also use for explicit board requests. Read-only questions, reviews, and diagnosis do not mutate cards unless board management is requested.
---

# oojjrs GitHub Project Board

Use this operational helper only after its trigger is confirmed. Load it once and reuse the procedure through the task; do not reload it at both start and finish.

## Authorization

Canonical common rule 13 supplies the user's standing authorization for routine task-card and issue management across chats. Once the relevant repository-linked board is confirmed, create or reuse task cards and issues, link issues, convert drafts, assign oojjrs, update status and fields, and maintain task bodies and progress comments without a separate permission question. This applies during ordinary content work as well as Git completion; it does not depend on a commit or publication request or on the breadth of a code, prefab, or other asset approval.

Before a board write, resolve the exact repository, board, and task item and use that standing authorization as the authority for the call. If automatic approval review claims that board permission is missing, check the loaded rule and task scope as authorization evidence through the permitted review path; do not bypass a rejection or ask the user to repeat authorization already supplied by rule 13. Report an unresolved tool denial or access failure as that actual blocker. New board creation, unrelated items, and board-wide configuration remain outside routine task-card authority.

## Workflow

1. Resolve the repository from `git remote -v` or the user's URL.
2. Check linked projects: `gh repo view OWNER/REPO --json projectsV2`.
3. If there is no linked project, report that no board update was possible.
4. If there is one linked project, treat it as the task board. If several are linked, choose the obviously relevant open project or ask.
5. List/search cards before creating anything: `gh project item-list PROJECT_NUMBER --owner OWNER --limit 100 --format json`. Prefer title, linked issue number, and status for identification; read card or issue bodies only when those fields are insufficient or when the body/notes themselves must change.
6. Reuse the existing matching card when possible. Create a new draft only when the task is clear and no matching card exists: `gh project item-create PROJECT_NUMBER --owner OWNER --title "..." --body "$body" --format json`.
7. When taking work into In Progress, convert a Draft Issue card to a real issue first, assign it to `oojjrs`, then set status.
8. Ensure every issue-backed task card is assigned to `oojjrs` unless the user explicitly names a different assignee.
9. Update project status and relevant fields during work. Use issue comments for ongoing work records, and update issue/card bodies only when the task summary, scope, or completion criteria actually changes. Report when an expected card, field, option, assignee, or permission is missing.

## Draft To Issue

Use GraphQL because `gh project` has no dedicated convert subcommand.

Required IDs:

- draft card item ID: from `gh project item-list` or `gh project item-create`
- repository node ID: `gh repo view OWNER/REPO --json id --jq .id`

Mutation:

```graphql
mutation($itemId: ID!, $repositoryId: ID!) {
  convertProjectV2DraftIssueItemToIssue(input: {itemId: $itemId, repositoryId: $repositoryId}) {
    item { id }
  }
}
```

Pass variables with `gh api graphql -f itemId=... -f repositoryId=... -f query=...`.

## Assignee

Draft cards cannot have assignees. Convert them to repository issues before moving them to In Progress, then assign the issue to `oojjrs`.

For a converted or existing issue card:

`gh issue edit ISSUE_NUMBER --repo OWNER/REPO --add-assignee oojjrs`

When creating a repository issue directly:

`gh issue create --repo OWNER/REPO --title "..." --body "$body" --assignee oojjrs`

## Status Fields

Use `gh project field-list PROJECT_NUMBER --owner OWNER --format json` to find the Status field and option IDs.

Set a single-select status with:

`gh project item-edit --id ITEM_ID --project-id PROJECT_ID --field-id FIELD_ID --single-select-option-id OPTION_ID`

Get `PROJECT_ID` from:

`gh project view PROJECT_NUMBER --owner OWNER --format json`.

## Issue Body, Comments, And Fields

Use each GitHub surface for its standard role:

- Issue body: task summary, scope, acceptance criteria, and stable references. Update it only when the meaning of the task, its scope, or its completion criteria changes.
- Issue comments: ongoing work records such as user feedback, decisions, implemented improvements, validation results, remaining risks, and handoff notes. Do not copy full chat transcripts, long command output, or transient trial-and-error.
- Project fields: operational metadata such as status, priority, assignee, dates, and other board-specific values.

When adding a work record, add an issue comment instead of rewriting the issue body. Draft cards cannot receive issue comments, so convert the draft card to an issue before moving it to In Progress or recording work history.

Use short, append-only comments with real newlines:

```powershell
$comment = @"
Work record:
- User feedback: Track ongoing decisions and improvements as issue comments.
- Decision: Keep issue bodies focused on summary, scope, and completion criteria.
- Result: Updated the requested project workflow guidance.
"@
gh issue comment ISSUE_NUMBER --repo OWNER/REPO --body $comment
```

## Card Body Formatting

Use real newlines in card and issue bodies. Never write literal `\n` text.

In PowerShell, prefer a here-string:

```powershell
$body = @"
Changes:
- First item
- Second item

Outcome:
- Updated the requested project fields
"@
```

## Commit And Publication Handoff

1. Match the reconciled Git scope to existing task cards, checking issue scope and completion criteria when titles are insufficient. Reuse or create cards through the workflow above; preserve unrelated cards. Update the issue body when the delivered scope, task summary, completion criteria, or stable references have changed; keep ongoing work history in comments. Status, comments, necessary body updates, draft conversion, and assignment are all part of routine card management and do not need separate user requests.
2. After a successful commit, append a concise issue comment with the commit SHA, implemented result, actual validation, and remaining work. Convert a draft to an assigned issue before recording this work.
3. Set the board's actual Status option from the verified outcome: completed criteria move to Done/completed; partial implementation remains In Progress; required user review moves to the board's review state. If an unmet push, deployment, release, or validation requirement is part of the card, wait for that result before marking it complete. Do not mark an entire umbrella card complete for one finished subtask.
4. For a requested push or publication, add the verified remote or deployment result and finalize status after that operation. If the status already matches, retain it and record only the new material result.
5. Read back the affected card status and new issue comment once. Report missing fields, access failures, or unsuccessful writes as remaining board work, separately from successful Git operations. Do not silently stop at the commit or claim full completion after a failed card update.

## Finish Checklist

- Repo-linked project checked.
- Matching card found or created; duplicates avoided.
- Draft card converted before In Progress.
- Issue-backed card assigned to `oojjrs`.
- Status and notes/body updated with real newlines.
- Missing board/card/field/assignee/permission reported.
