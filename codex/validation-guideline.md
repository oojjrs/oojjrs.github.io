# Codex Validation Rules

Use validation to answer a concrete uncertainty about the changed result. Do not turn completion into a general audit.

## Budget

1. Let `E` be task-local implementation or editing time after scope is understood. Routine validation targets `min(E × 25%, 15 seconds)` of agent-controlled wall time.
2. Minimum assurance is an operation, not a time floor: run the exact touched-text format check and the single scoped diff as one terminal batch. Start that batch even when 25% of `E` is smaller, and let the already-started batch finish within the 15-second hard cap.
3. Measure the hard cap from the first routine validation call through its last result, including agent and tool round trips. At 15 seconds, stop an unfinished unrequested check and report the missing evidence; do not extend the budget with retries or substitute checks.
4. Add a domain-specific check only when time remains and an independent oracle answers a concrete uncertainty. User-requested execution and necessary readback of a high-risk external action are outside the routine budget, but still must not duplicate unchanged evidence.
5. If a check exposes a defect, correcting that defect returns the task to implementation. Validate the changed result once; never repeat a successful check against unchanged content.

## Default Finish

1. Preserve the existing encoding and line endings while editing.
2. After the last edit, batch the shared text-format checker on the exact touched text files and the single scoped diff in one terminal call when the available tool supports it.
3. If that check finds a mismatch, correct only the affected files. `-Fix` verifies its own write, so do not add an unconditional second run.
4. Read the scoped diff once. When a commit is part of the same task, let the final staged review serve as that diff instead of reading both ordinary and staged versions of unchanged content. Do not scan the whole repository when the task changed only named paths.
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

Use an initial status only when needed to isolate pre-existing work. When a commit is requested, stage exact paths and review the final staged name/status, diff, and whitespace check once. That staged review replaces an ordinary diff over the same unchanged content. Re-review only if staged content changes. Apply version policy only to governed versioned units in that staged scope. Do not report absent units or inapplicable gates.

## Reporting

Report the changed scope, checks actually performed, their results, and any meaningful residual risk. Do not list every possible check, every skipped check, unchanged Git history, or rows whose conditions did not trigger.
