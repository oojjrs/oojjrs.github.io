# Codex Validation Rules

Use validation to answer a concrete uncertainty about the changed result. Do not turn completion into a general audit.

## Priority And Applicability

1. When the common work rules require this document, it is the controlling cross-domain authority for validation scope, execution-surface authority, oracle selection, budget, retries, and reporting.
2. Domain workflows may choose a narrower domain check or impose a stricter safety limit, but they must not replace, skip, weaken, or broaden these rules. If workflow text conflicts with this document, follow this document and report any unresolved conflict before validation.
3. Loading a domain skill does not load this document. Load the canonical URL once, immediately before the first validation step, when a task changes files or external state or requests validation.

## Routine Finish And Budget

1. Let `E` be task-local implementation or editing time after scope is understood. Routine validation targets `min(E × 25%, 15 seconds)` of agent-controlled wall time.
2. After the last edit, batch the shared format checker on the exact touched text files with one scoped diff. This operation is mandatory, not a time floor: start it even if 25% of `E` is smaller and let it finish only within the 15-second hard cap.
3. Measure that cap from the first routine validation call through its last result, including tool round trips. At 15 seconds, stop unfinished unrequested checks and report missing evidence; do not retry or substitute another check.
4. Preserve existing encoding and line endings. Use `-Fix` only for a reported mismatch inside the current task's content scope. Protected pre-existing or concurrent work stays check-only: report its mismatch without writing. `-Fix` verifies its authorized write and replaces another run. Read the scoped diff once, or use the final staged review instead when committing.
5. Add a domain check only with remaining time and an independent oracle for a concrete uncertainty. User-requested execution and necessary high-risk readback are outside the routine budget but must not duplicate evidence.
6. A discovered defect returns the task to implementation only when changing the affected content is inside the current task scope. Otherwise leave the defect untouched and report it. Validate a corrected result once; never rerun a successful check on unchanged input.

## Code And Tests

Static review may check syntax, types, null handling, branches, bounds, data flow, and caller consistency, but cannot establish unstated product intent. Builds, tests, servers, browsers, and new tests are opt-in: use them only on request or when the task targets that execution surface and has an independent oracle. A request to change or verify rendered layout targets the rendered surface, so Visual QA may use the project's normal local server and browser; an unrelated code edit does not.

Valid oracles include:

- explicit user acceptance criteria
- an existing specification, protocol, schema, or established test
- current caller and API contracts
- a reproduced bug with a known expected result
- deterministic artifact invariants such as parseability, dimensions, IDs, references, or hashes

Do not derive both behavior and expected output from the same assumption; a self-authored passing test then proves only internal consistency. Report or resolve semantic ambiguity instead of claiming certainty.

## Domain Checks

- Documents: changed links, anchors, references, code blocks, or structure; render only when requested or source inspection cannot establish layout.
- Code: existing targeted checks under the execution rule; ordinary manual builds remain with the user unless delegated.
- Assets/media: changed outputs and objective contracts such as dimensions, frames, channels, loops, GUID companions, or paths.
- Skills/structured files: fast schema or parser checks on changed artifacts.
- External/high-risk changes: exact target before mutation and one resulting-state readback.


## Reporting

Report changed scope, performed checks/results, and meaningful residual risk; omit possible or skipped checks, unchanged history, and inactive gates.
