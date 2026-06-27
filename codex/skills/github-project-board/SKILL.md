---
name: github-project-board
description: Manage a repository-linked GitHub Project v2 task board. Use when Codex must find or create task cards, convert Draft Issue cards to real repository issues before moving work to In Progress, update project status/notes during work, or fix/report GitHub Project card metadata and body formatting.
---

# GitHub Project Board

Use this skill for GitHub Project v2 boards that are linked 1:1 to the current repository.

## Workflow

1. Resolve the repository from `git remote -v` or the user's URL.
2. Check linked projects: `gh repo view OWNER/REPO --json projectsV2`.
3. If there is no linked project, report that no board update was possible.
4. If there is one linked project, treat it as the task board. If several are linked, choose the obviously relevant open project or ask.
5. List/search cards before creating anything: `gh project item-list PROJECT_NUMBER --owner OWNER --limit 100 --format json`.
6. Reuse the existing matching card when possible. Create a new draft only when the task is clear and no matching card exists: `gh project item-create PROJECT_NUMBER --owner OWNER --title "..." --body "$body" --format json`.
7. When taking work into In Progress, convert a Draft Issue card to a real issue first, then set status.
8. Update status, notes/body, and relevant fields during work. Report when an expected card, field, option, or permission is missing.

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

## Status Fields

Use `gh project field-list PROJECT_NUMBER --owner OWNER --format json` to find the Status field and option IDs.

Set a single-select status with:

`gh project item-edit --id ITEM_ID --project-id PROJECT_ID --field-id FIELD_ID --single-select-option-id OPTION_ID`

Get `PROJECT_ID` from:

`gh project view PROJECT_NUMBER --owner OWNER --format json`.

## Card Body Formatting

Use real newlines in card and issue bodies. Never write literal `\n` text.

In PowerShell, prefer a here-string:

```powershell
$body = @"
Changes:
- First item
- Second item

Checks:
- git diff --check passed
"@
```

## Finish Checklist

- Repo-linked project checked.
- Matching card found or created; duplicates avoided.
- Draft card converted before In Progress.
- Status and notes/body updated with real newlines.
- Missing board/card/field/permission reported.
