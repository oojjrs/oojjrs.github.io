# Codex Validation Rules

Use validation to answer a concrete uncertainty about the changed result. Do not turn completion into a general audit.

## Budget

1. Routine validation should normally take no more than one minute and target at most 25% of task-local editing time.
2. Do not start an unrequested check expected to take longer than the implementation. Ask or skip when the cost exceeds the likely value.
3. A longer check is justified only when the user requests it or a high-risk action has a clear, independent success criterion.
4. Never repeat a successful check against unchanged content.

## Default Finish

1. Preserve the existing encoding and line endings while editing.
2. After the last edit, run the shared text-format checker once in check-only mode on the exact touched text files.
3. If that check finds a mismatch, correct only the affected files. `-Fix` verifies its own write, so do not add an unconditional second run.
4. Read the scoped ordinary diff once. Do not scan the whole repository when the task changed only named paths.
5. Do not load the Git completion workflow unless stage, commit, push, deploy, release, or explicit completion of an existing diff is requested.

## Code And Tests

Static review may check syntax, types, null handling, branches, bounds, data flow, and consistency with existing callers. It cannot establish unstated product intent.

Builds, test runs, servers, browsers, and new tests are opt-in. Run or create them only when the user requests them or when the task is explicitly about that execution surface and an independent oracle exists.

Valid oracles include:

- explicit user acceptance criteria
- an existing specification, protocol, schema, or established test
- current caller and API contracts
- a reproduced bug with a known expected result
- deterministic artifact invariants such as parseability, dimensions, IDs, references, or hashes

Do not invent both implementation behavior and its expected test output from the same assumption. A passing self-authored test proves consistency with that assumption, not correctness. If the semantic result is ambiguous, report the assumption or ask instead of manufacturing certainty.

## Domain Checks

- Documents: check only changed links, anchors, references, code blocks, or structure. Render only when visual output is requested or source inspection cannot establish the changed layout.
- Code: use existing targeted checks only under the execution rule above. The user owns ordinary manual builds unless they delegate them.
- Assets and media: inspect only changed outputs and their objective runtime contracts, such as dimensions, frame counts, channels, loops, GUID companions, or referenced paths.
- Skills and structured files: use fast schema or parser checks on changed artifacts only.
- External or high-risk changes: confirm the exact target before mutation and read back the resulting state once.

## Git Completion

Use an initial status only when needed to isolate pre-existing work. When a commit is requested, stage exact paths and review the final staged name/status, diff, and whitespace check once. Re-review only if staged content changes. Apply version policy only to governed versioned units in that staged scope. Do not report absent units or inapplicable gates.

## Reporting

Report the changed scope, checks actually performed, their results, and any meaningful residual risk. Do not list every possible check, every skipped check, unchanged Git history, or rows whose conditions did not trigger.
