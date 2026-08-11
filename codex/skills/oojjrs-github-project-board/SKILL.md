---
name: oojjrs-github-project-board
description: Manage a repository-linked GitHub Project v2 task board when the user requests board operations or a cheap repository probe has confirmed a relevant 1:1-linked board that this task must update. Do not use for ordinary repository work, read-only review, or status reporting unless the board itself is in scope.
---

# oojjrs GitHub Project Board

Use this operational helper only after its trigger is confirmed. Load it once and reuse the procedure through the task; do not reload it at both start and finish.

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

## Finish Checklist

- Repo-linked project checked.
- Matching card found or created; duplicates avoided.
- Draft card converted before In Progress.
- Issue-backed card assigned to `oojjrs`.
- Status and notes/body updated with real newlines.
- Missing board/card/field/assignee/permission reported.
