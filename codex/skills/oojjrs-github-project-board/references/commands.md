# GitHub Board Commands

Every GitHub shell request in this reference must use a direct shell-tool call with `sandbox_permissions: require_escalated`, including reads and authentication checks.

## Linked Board Discovery

Pass the query as a single-quoted PowerShell string so GraphQL variables stay literal. Use `-f` for strings and `--paginate --slurp` for complete results:

```powershell
$query = @'
query($owner: String!, $repo: String!, $endCursor: String) {
  repository(owner: $owner, name: $repo) {
    id
    nameWithOwner
    projectsV2(first: 100, after: $endCursor) {
      nodes { id number title closed url owner { ... on User { login } ... on Organization { login } } }
      pageInfo { hasNextPage endCursor }
    }
  }
}
'@
$result = & gh api graphql --paginate --slurp -f owner=OWNER -f repo=REPO -f query=$query
if ($LASTEXITCODE -ne 0) { throw 'Linked board discovery failed.' }
$pages = ($result -join "`n") | ConvertFrom-Json
foreach ($page in $pages) {
    if ($page.errors -or $null -eq $page.data.repository) { throw 'Linked board discovery returned incomplete data.' }
}
```

Use the resolved host for Enterprise repositories. Reuse a completed discovery result in the same chat.

## Items And Fields

```text
gh project item-list PROJECT_NUMBER --owner PROJECT_OWNER --limit 100 --format json
gh project view PROJECT_NUMBER --owner PROJECT_OWNER --format json
gh project field-list PROJECT_NUMBER --owner PROJECT_OWNER --format json
```

For a known task, use `item-list --query` when the installed CLI supports it. If the listing is incomplete, paginate the selected project's `items(first: 100, after: $endCursor)` with GraphQL and `pageInfo`; do not infer absence from a capped list. Retrieve only identity/title/status until bodies are needed.

## Create, Link, Assign, And Update

Run each command separately, check its exit code, and retain returned identities before the next operation:

```text
gh issue create --repo OWNER/REPO --title TITLE --body-file BODY_FILE --assignee oojjrs
gh project item-add PROJECT_NUMBER --owner PROJECT_OWNER --url ISSUE_URL --format json
gh issue edit ISSUE_NUMBER --repo OWNER/REPO --add-assignee oojjrs
gh issue edit ISSUE_NUMBER --repo OWNER/REPO --body-file BODY_FILE
gh issue comment ISSUE_NUMBER --repo OWNER/REPO --body-file COMMENT_FILE
gh project item-edit --id ITEM_ID --project-id PROJECT_ID --field-id STATUS_FIELD_ID --single-select-option-id STATUS_OPTION_ID
```

`BODY_FILE` and `COMMENT_FILE` are exact UTF-8 paths under the project's literal `$Trash`. Quote PowerShell paths containing `$Trash` with single quotes. A successful issue creation followed by a linking failure resumes at `item-add`, not `issue create`.

## Convert An Existing Draft

Use the existing project item ID and resolved repository node ID. Capture the issue returned from the conversion:

```graphql
mutation($itemId: ID!, $repositoryId: ID!) {
  convertProjectV2DraftIssueItemToIssue(
    input: {itemId: $itemId, repositoryId: $repositoryId}
  ) {
    item {
      id
      content { ... on Issue { id number url repository { nameWithOwner } } }
    }
  }
}
```

Pass the single-quoted query with `gh api graphql -f itemId=ITEM_ID -f repositoryId=REPOSITORY_ID -f query=$query`. Check the exit code, GraphQL errors, and returned issue before assignment or status changes.

## Readback And Error Evidence

`gh issue view ISSUE_NUMBER --repo OWNER/REPO --json number,url,assignees,projectItems` reads the targeted issue. For exact new-comment and field readback, query the known issue/item nodes; use the returned comment URL/ID or a unique handoff marker when outcomes are uncertain.

For HTTP diagnosis, `gh api --include` exposes status and response headers. Inspect authentication only after a corresponding failure with `gh auth status`; inspect quotas only when the response indicates a limit. Do not print authentication tokens or use verbose credential dumps.

## Official Contracts

- [GitHub Projects GraphQL](https://docs.github.com/en/graphql/reference/projects)
- [GitHub CLI API and pagination](https://cli.github.com/manual/gh_api)
- [Issue creation and body files](https://cli.github.com/manual/gh_issue_create)
- [Link an issue to a project](https://cli.github.com/manual/gh_project_item-add)
