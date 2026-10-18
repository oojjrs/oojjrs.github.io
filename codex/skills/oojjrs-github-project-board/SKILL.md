---
name: oojjrs-github-project-board
description: Manage repository-linked GitHub Projects v2 cards and issues with every GitHub shell request outside the sandbox from its first attempt. Use for explicit board work or a confirmed linked board during implementation, document, asset, maintenance, or Git completion. Routine task-card writes have standing authorization; read-only diagnosis does not authorize card changes.
---

# oojjrs GitHub Project Board

Load once after an explicit board request or confirmation of a relevant repository-linked board. Reuse the resolved targets and results throughout the chat.

## Execution Boundary

1. Run every shell-based GitHub request with `sandbox_permissions: require_escalated` from the first attempt, including authentication checks, board discovery, issue reads, mutations, readback, and GitHub downloads. Do not try the sandbox first, even for read-only requests.
2. Use a direct shell-tool call with the exact command and a scoped justification. Keep `require_escalated` even when an existing command-prefix rule allows execution without a prompt; escalation selects the execution boundary and is not a request for fresh task authorization. Keep each GitHub command separate from local preparation and result parsing so its actual prefix can be evaluated. If a required command lacks a reusable approval, propose the narrow operation prefix through the tool approval flow; do not disable global approvals or use wrappers to bypass review.
3. Use the existing GitHub CLI credentials. Do not extract tokens, copy credentials into environment variables or files, log secrets, reinstall CLI/MCP, log out, or start reauthentication to work around a sandbox failure.
4. Run dependent operations sequentially. Check each native command's exit code and GraphQL `errors` before consuming its result or starting the next mutation; HTTP 200 alone is not success.
5. Reuse a successful authenticated operation in the same context. Run `gh auth status` outside the sandbox only when an actual authentication or scope failure needs diagnosis.
6. An approval denial is a tool blocker. Use the permitted review path with existing authorization evidence; never switch execution surfaces to bypass it.

## Authorization

Common rule 13 authorizes task-scoped issue/card creation or reuse, linking, draft conversion, assignment to `oojjrs`, status/field changes, necessary body updates, and progress comments without a new permission question. This applies before and after a commit and during ordinary content work. Proceed without asking whether to record, post, or update the board, and do not add a confirmation pause before an already-authorized operation. If execution approval is required, use the tool approval flow directly and identify it as execution permission, not missing board authorization.

Resolve the exact repository, board, and item before writing. Respect user opt-outs and narrower current instructions. Read-only review or diagnosis does not authorize board writes unless requested. New boards, unrelated items, board-wide configuration, deletion, and archival need authorization for that scope.

## Resolve And Reuse

1. Resolve the repository and host from the task and `git remote -v`; never infer a board from an unrelated checkout or a similar name.
2. Discover repository-linked Projects v2 once, outside the sandbox. Use the paginated GraphQL query in [commands](references/commands.md); distinguish a successful empty result from a failed or incomplete query.
3. Select the relevant open linked board. If none is linked, report that fact once and continue the authorized repository work. If several remain ambiguous, ask only for the target board.
4. Keep repository ID, project owner/number/ID/URL, item/issue IDs, status field/options, and successful writes in chat context. Refresh only missing or stale values; do not rediscover everything at each turn, commit, or publication.
5. Search existing cards by repository plus issue URL/number, then task meaning. Read bodies only when needed to distinguish scope. Page through candidates before concluding that no match exists; the first 100 items are not proof of absence.
6. Resolve actual field and option IDs once when needed. Never invent a Status option, assume an English name, or overwrite unrelated fields.

## Card Lifecycle

1. Reuse the matching issue-backed card. If a matching repository issue exists without a card, link it to the resolved board.
2. For new active work, create the repository issue directly with assignee `oojjrs`, then add its returned URL to the board. Do not create a disposable draft just to convert it.
3. Preserve an existing draft's identity: convert that card to an issue in the resolved repository, read the returned issue identity, assign `oojjrs`, then set its active status. Create a new draft only when the user asks to retain a draft.
4. Capture each returned issue URL and item ID immediately. If creation succeeds but linking or a later update fails, retain the successful object and resume from the failed operation.
5. Ensure issue-backed cards are assigned to `oojjrs` unless the user names another assignee. Skip assignment and field writes when the desired value already matches.
6. Map status to the verified result: active or partial work stays in progress; required review uses the board's review option; completion requires the card's actual criteria. One completed subtask does not complete an umbrella card.

## Bodies And Work Records

- Issue body: stable summary, scope, acceptance criteria, and references. Edit only when that meaning changes.
- Issue comments: concise decisions, material progress, verification, blockers, and handoff. Group minor iterations into a meaningful work boundary; do not post a duplicate or one comment per tool call.
- Project fields: operational status and other requested metadata.
- Write multiline issue bodies and comments as UTF-8 files under the project's literal `$Trash`, then use `--body-file`. Use real newlines; never inline complex text into a shell command or post full chats, logs, or transient attempts.

## Failure Handling

1. Name the exact failed stage: discovery, issue creation, linking, conversion, assignment, field update, comment, or readback. Preserve completed stages.
2. For 401 or credential errors, confirm the shell call used `require_escalated`. If an earlier attempt ran in the sandbox, repeat only that failed operation outside it. Do not declare the user's login invalid from sandbox output.
3. If authentication still fails outside the sandbox, inspect `gh auth status` there once and report the account/host/scope result without exposing tokens. Do not alter credentials without an instruction covering that action.
4. For 403/429, inspect the response message and available rate-limit or retry headers before classifying it as permission, scope, primary quota, or secondary throttling. Do not assume every 403 is a rate limit or every rate limit requires login.
5. Respect `Retry-After` or the reset time. Retry a safe read once after the indicated delay when practical; if the wait exceeds 60 seconds, report the retry time and continue independent work. Do not poll, loop, or retry unchanged permission/schema errors.
6. A timeout or lost response after a mutation has an unknown outcome. Read the exact target or search for the returned/recent matching issue, card, or comment before retrying. Never blindly replay a create or comment.
7. Treat a GraphQL error, inaccessible repository/board, truncated listing, missing field, and absent linked board as distinct results. Report only the proven limitation; CLI/MCP installation is not a remedy for an execution-context failure.
8. Preserve successful Git or content work when board work fails. Report the remaining board operation separately instead of claiming that the whole publication failed.

## Commit And Publication Handoff

1. Reconcile the delivered scope with the existing card and its acceptance criteria before staging; reuse the cached board and item.
2. After a commit, record its SHA, implemented result, actual verification, and remaining work in one concise comment. For a requested push or deployment, include the verified publication result; combine these into one handoff comment when they belong to the same completion boundary.
3. Finalize status only after every required publication or verification criterion is met. Keep already-correct fields unchanged.
4. Read back the affected issue identity, assignment, changed fields, and new comment once, using targeted queries and mutation-returned data where sufficient. Readback failure means unverified state, not proof that the write failed.
5. Report completed work and any precise remaining blocker in Korean. Include an issue/board link when useful; do not repeat unchanged no-board or access notices at every turn.
