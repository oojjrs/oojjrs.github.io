# Codex Validation Rules

Use validation to answer a concrete uncertainty about the changed result. Do not turn completion into a general audit.

## Routine Finish And Budget

1. Let `E` be task-local implementation or editing time after scope is understood. Routine validation targets `min(E × 25%, 15 seconds)` of agent-controlled wall time.
2. After the last edit, batch the shared format checker on the exact touched text files with one scoped diff. This operation is mandatory, not a time floor: start it even if 25% of `E` is smaller and let it finish only within the 15-second hard cap.
3. Measure that cap from the first routine validation call through its last result, including tool round trips. At 15 seconds, stop unfinished unrequested checks and report missing evidence; do not retry or substitute another check.
4. Preserve existing encoding and line endings. Fix only reported mismatches; `-Fix` verifies its write and replaces another run. Read the scoped diff once, or use the final staged review instead when committing.
5. Add a domain check only with remaining time and an independent oracle for a concrete uncertainty. User-requested execution and necessary high-risk readback are outside the routine budget but must not duplicate evidence.
6. A discovered defect returns the task to implementation. Validate the corrected result once; never rerun a successful check on unchanged input.

## Code And Tests

Static review may check syntax, types, null handling, branches, bounds, data flow, and caller consistency, but cannot establish unstated product intent. Builds, tests, servers, browsers, and new tests are opt-in: use them only on request or when the task explicitly targets that execution surface and has an independent oracle.

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

## Git Completion

Load the Git completion workflow only for requested stage, commit, push, deploy, release, or completion of an existing diff. Use initial status only to isolate prior work. For a commit, stage exact paths and review final staged name/status, diff, and whitespace once; this replaces the ordinary diff. Re-review only changed staged content and apply version policy only to governed units in scope.

## Reporting

Report changed scope, performed checks/results, and meaningful residual risk; omit possible or skipped checks, unchanged history, and inactive gates.
