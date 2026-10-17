# Practical Work Rules

Canonical URL: `https://oojjrs.github.io/codex/practical-work-guidelines.md`

Use for pre-work planning and step-by-step execution. Follow the [common work rules](https://oojjrs.github.io/codex/common-work-guidelines.md), [document writing rules](https://oojjrs.github.io/codex/document-writing-guideline.md), [validation rules](https://oojjrs.github.io/codex/validation-guideline.md) and applicable domain rules at their stated entry points.

A step-by-step plan, checklist and separate post-plan execution approval are mandatory only for changes to Unity C# source (.cs files in Unity projects or packages). For other work, including non-Unity code changes, plan only when requested or useful; no plan, checklist or separate post-plan execution approval is required. The checklist and resumption rules below apply when a plan is used.

## Planning Decisions

1. At the first request involving Unity C# code changes in each new thread, save and present a step-by-step work plan before changing Unity C# code, even when the request is concrete. Use one step for a small task. Before post-plan execution approval, limit preparation for Unity C# code changes to necessary read-only inspection and preparation of the plan and permitted decision records. Ask only unresolved questions, one key question at a time; keep replies short. Concrete requirements do not remove the Unity C# planning requirement.
2. Resolve choices that could change implementation scope, structure, contracts or work order while preparing the plan. Never start a step that depends on an unresolved choice. If a new choice emerges during work, stop affected steps, revise the plan and obtain confirmation before continuing them. Reuse settled decisions and existing authorization.
3. Read the project's existing planning document first. If absent, create a minimal draft at its established location within the document writing limits; ask if the project or location is unclear. Before the next question, save each confirmed, revised or withdrawn product decision and its remaining uncertainties in that topic. Keep current decisions and proposals distinct; update superseded content without creating duplicate records or conversation logs.

## Reviewable Work Plan

1. Write a numbered checklist with exactly one step per line. Use stable hierarchical IDs when subdividing; retain existing numbers. Show `[ ]` pending, `[>]` current and `[x]` complete.
2. Split steps recursively until each leaf has a coherent diff the user can review at a glance. A change to one file is a size reference, not a file-count limit or a fixed subdivision depth.
3. Keep each leaf independently coherent. Change dependent references, contracts and required generated counterparts together; do not create intermediate steps that leave the build broken. This requirement does not authorize running a build.
4. If the smallest coherent change is still large, present its exact files, estimated change size and reason for grouping; for Unity C# code changes, obtain execution approval before making it.
5. Keep the checklist in the project root's literal `$Trash/<task>-plan.txt`, separate from the product planning document. Update the same file throughout the task. Preserve one step per line rather than merging or omitting steps to satisfy prose limits or adding product-planning pages.

## Execution And Resumption

1. For steps that change Unity C# code, after presenting the plan, obtain explicit authorization for the leaf step or execution range before starting. Agreement with the plan alone is not authorization to execute every Unity C# step; an explicit instruction to execute the whole presented plan authorizes that range. Present subdivision before starting an oversized parent. After completing a Unity C# step, wait for the user's next instruction unless the user explicitly authorized a larger execution range. Other steps, including non-Unity code changes in mixed tasks, may proceed within existing user authorization without a mandatory plan, checklist or separate post-plan execution approval; they do not authorize unapproved Unity C# code changes.
2. After each implementation step, show its full task-scoped diff in the chat, report the evidence obtained and update the checklist. Distinguish implementation, review and commit status where needed; complete a parent only when all required children are complete.
3. Open the checklist only when explicitly requested in the current request, in the right side panel as the file itself (open_in_codex target type "file", placement "right"), never as a diff or review. Keep an already open checklist current by editing the same file.
4. Before resuming, read the saved product decisions, checklist and actual working-tree/index changes against the latest request. Resume the recorded task and step without silently switching to a separate follow-up task.
