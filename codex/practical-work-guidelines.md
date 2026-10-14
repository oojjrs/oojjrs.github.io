# Practical Work Rules

Canonical URL: `https://oojjrs.github.io/codex/practical-work-guidelines.md`

Use for pre-work planning and step-by-step execution. Follow the [common work rules](https://oojjrs.github.io/codex/common-work-guidelines.md), [document writing rules](https://oojjrs.github.io/codex/document-writing-guideline.md), [validation rules](https://oojjrs.github.io/codex/validation-guideline.md) and applicable domain rules at their stated entry points.

## Planning Decisions

1. Infer planning intent from the request and context, even before a document or task exists. Ask one key question at a time; keep replies short, with one or two sentences per paragraph. Do not begin with a complete long proposal or force discussion onto an already concrete execution request.
2. Resolve choices that could change implementation scope, structure, contracts or work order while preparing the plan. Never start a step that depends on an unresolved choice. If a new choice emerges during work, stop affected steps, revise the plan and obtain confirmation before continuing them. Reuse settled decisions and existing authorization.
3. Read the project's existing planning document first. If absent, create a minimal draft at its established location within the document writing limits; ask if the project or location is unclear. Before the next question, save each confirmed, revised or withdrawn product decision and its remaining uncertainties in that topic. Keep current decisions and proposals distinct; update superseded content without creating duplicate records or conversation logs.

## Reviewable Work Plan

1. Write a numbered checklist with exactly one step per line. Use stable hierarchical IDs when subdividing; retain existing numbers. Show `[ ]` pending, `[>]` current and `[x]` complete.
2. Split steps recursively until each leaf has a coherent diff the user can review at a glance. A change to one file is a size reference, not a file-count limit or a fixed subdivision depth.
3. Keep each leaf independently coherent. Change dependent references, contracts and required generated counterparts together; do not create intermediate steps that leave the build broken. This requirement does not authorize running a build.
4. If the smallest coherent change is still large, present its exact files, estimated change size and reason for grouping, then obtain permission before making it.
5. Keep the checklist in the project root's literal `$Trash/<task>-plan.txt`, separate from the product planning document. Update the same file throughout the task. Preserve one step per line rather than merging or omitting steps to satisfy prose limits or adding product-planning pages.

## Execution And Resumption

1. Execute only the authorized leaf step. Approval of the plan or a parent step is not blanket permission for every child. Present subdivision before starting an oversized parent. After completing a step, wait for the user's next instruction unless the user explicitly authorized a larger execution range.
2. After each implementation step, show its full task-scoped diff in the chat, report the evidence obtained and update the checklist. Distinguish implementation, review and commit status where needed; complete a parent only when all required children are complete.
3. Open the checklist in a Codex side panel only when explicitly requested in the current request; keep an already open checklist current by editing the same file.
4. Before resuming, read the saved product decisions, checklist and actual working-tree/index changes against the latest request. Resume the recorded task and step without silently switching to a separate follow-up task.
