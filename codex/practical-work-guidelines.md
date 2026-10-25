# Practical Work Rules

Canonical URL: `https://oojjrs.github.io/codex/practical-work-guidelines.md`

Use for pre-work planning and step-by-step execution. Follow the [common work rules](https://oojjrs.github.io/codex/common-work-guidelines.md), [document writing rules](https://oojjrs.github.io/codex/document-writing-guideline.md), [validation rules](https://oojjrs.github.io/codex/validation-guideline.md) and applicable domain rules at their stated entry points.

A step-by-step plan, checklist and separate post-plan execution approval apply by default to Unity C# implementation of end-user products and services. Reusable library work and non-Unity work use this workflow only when the user requests it. Other work proceeds within existing authorization; an optional plan alone does not create an approval gate. The checklist and resumption rules below apply when this workflow is active.

## Determine Applicability

1. Infer the requested work's purpose from the request and the smallest useful set of existing evidence, such as a README, planning document, package manifest or deployment structure. Verify whether the requested changes affect Unity C# source; do not infer product/library purpose from project name, language, engine or folder location alone, and do not scan all registered projects.
2. Work on a game, application or service delivered to end users is product/service implementation. Work on a reusable package or library consumed by other projects is library work, even when paid or developed inside a product repository. Classify the requested deliverable; in mixed work, apply the default gate only to Unity C# product/service implementation and keep necessary dependent changes in coherent steps. Standalone web, non-Unity C# and other non-Unity implementation do not activate the gate merely because they deliver a product/service.
3. Make the best-supported judgment without asking the user to label the project in each new thread. If evidence remains ambiguous, use the current request's deliverable as the default and state the assumption briefly; ask only when an unresolved distinction materially changes the implementation scope or approval boundary and cannot be reasonably inferred.
4. Keep the judgment in the current conversation only. Do not create or update project classification lists, memory entries, project instructions or planning-document labels for this purpose. Reassess from existing evidence in new threads; a current user instruction overrides inference.

## Planning Decisions

1. At the first applicable implementation request in each new thread, save and present a step-by-step work plan before implementation, even for a concrete request; a small task may have one step. Before post-plan execution approval, perform only necessary read-only inspection and preparation of the plan and permitted decision records. Reuse current-thread decisions and authorization; ask only about unresolved choices that materially affect the work.
2. Resolve choices that could change implementation scope, structure, contracts or work order while preparing the plan. Never start a step that depends on an unresolved choice. If a new choice emerges during work, stop affected steps, revise the plan and obtain confirmation before continuing them. Reuse settled decisions and existing authorization.
3. Read the project's existing planning document first. If absent, create a minimal draft at its established location within the document writing limits; ask if the project or location is unclear. Before the next question, save each confirmed, revised or withdrawn product decision and its remaining uncertainties in that topic only within the planning document text-addition approval rules in the [Design writing guideline](https://oojjrs.github.io/codex/guideline-design-generation.review.md). Agreement on a product decision does not itself authorize new document wording; keep unapproved wording out of the document. Keep current decisions and proposals distinct; update superseded content without creating duplicate records or conversation logs.

## Reviewable Work Plan

1. Write a numbered checklist with exactly one step per line. Use stable hierarchical IDs when subdividing; retain existing numbers. Show `[ ]` pending, `[>]` current and `[x]` complete.
2. Split steps recursively until each leaf has a coherent diff the user can review at a glance. A change to one file is a size reference, not a file-count limit or a fixed subdivision depth.
3. Keep each leaf independently coherent. Change dependent references, contracts and required generated counterparts together; do not create intermediate steps that leave the build broken. This requirement does not authorize running a build.
4. If the smallest coherent change is still large, present its exact files, estimated change size and reason for grouping; when this workflow is active, obtain execution approval before making it.
5. Keep the checklist in the project root's literal `$Trash/<task>-plan.txt`, separate from the product planning document. Update the same file throughout the task. Preserve one step per line rather than merging or omitting steps to satisfy prose limits or adding product-planning pages.

## Execution And Resumption

1. When this workflow is active, obtain explicit authorization for the leaf step or execution range after presenting the plan. Agreement with the plan alone is not authorization to execute every step; an explicit instruction to execute the whole presented plan authorizes that range. Present subdivision before starting an oversized parent. After completing a step, wait for the next instruction unless a larger execution range is already authorized. In mixed tasks, unrelated work outside this workflow may proceed within existing authorization; it does not authorize gated implementation steps.
2. After each implementation step, show its full task-scoped diff in the chat, report the evidence obtained and update the checklist. Distinguish implementation, review and commit status where needed; complete a parent only when all required children are complete.
3. Open the checklist only when explicitly requested in the current request, in the right side panel as the file itself (open_in_codex target type "file", placement "right"), never as a diff or review. Keep an already open checklist current by editing the same file.
4. Before resuming, read the saved product decisions, checklist and actual working-tree/index changes against the latest request. Resume the recorded task and step without silently switching to a separate follow-up task.
