---
name: oojjrs-multi-repo-integration-workflow
description: Coordinate one requested outcome across two or more repositories when dependency order, shared contracts, versions, or release handoffs interact. Use for cross-repository integration planning or implementation; do not use for a single-repository change, lookup-only cross-repository research, or unrelated parallel deliverables.
---

# oojjrs Multi-Repo Integration Workflow

Use this helper only when one outcome genuinely depends on coordinated work across multiple repositories. It owns the cross-repository dependency map, repository boundaries, and handoffs. Each repository's content remains owned by its most-specific domain workflow, applied sequentially rather than preloaded together.

## Fix The Integration Boundary

1. Identify every repository that the requested outcome actually includes, its resolved local root, and whether the requested work there is read-only or mutating. Mentioning or consuming another repository never authorizes editing it.
2. Record the dependency direction between providers and consumers, the shared API, schema, protocol, package, artifact, or configuration contract, and any version or commit reference that carries it.
3. Separate repositories required for the integrated result from merely related repositories. Keep unrelated deliverables and opportunistic repairs outside this workflow.
4. For planning, review, or diagnosis, remain read-only and distinguish verified cross-repository facts from inference and unresolved contract choices. Enter a mutation phase only when the request authorizes changes.

## Protect Each Repository Independently

1. Treat every repository as a separate worktree, index, branch, remote, and authorization boundary. Apply `$oojjrs-project-start-work` in each repository immediately before its first intended local mutation, and protect its pre-existing or concurrent changes independently.
2. Never combine dirty state, staging, commits, version decisions, or validation claims across repositories. If safe scope isolation fails in one repository, stop that repository's mutation without broadening authority in another.
3. Use the most-specific content domain for one repository phase at a time. This helper does not replace package, entity, Steamworks, asset, documentation, or other domain rules.

## Work In Dependency Order

1. Settle the provider contract before changing consumers. When compatibility or migration matters, define the supported old and new states, transition order, and rollback boundary before implementation.
2. Complete the lowest required provider phase first, including its directly affected documentation and governed version decision. Freeze an exact handoff using the provider's committed revision, version, artifact identity, or another deterministic local reference.
3. Update each downstream repository against that exact handoff in dependency order. Do not declare a consumer integrated against an unpublished or moving provider state unless the requested workflow explicitly uses a local or path-based dependency.
4. Validate each repository's own changed contract separately under the public validation rules. Run an end-to-end integration check only when the request targets that execution surface and an independent oracle exists.
5. If a downstream repository exposes a new contract to another consumer, treat it as the next provider and repeat the same handoff rather than editing every repository as one undifferentiated batch.

## Complete Local And Remote Handoffs

1. Use `$oojjrs-project-finish-work` separately for each explicitly authorized scoped commit. A local commit in one repository does not authorize a commit, push, deployment, or release in another.
2. Before any remote operation, confirm that every repository required for the requested integrated result has a complete compatible handoff. If not, report the incomplete repository and stop the remote chain.
3. Push or release only when the current request explicitly authorizes each target, follow the resolved compatibility-safe rollout order, and read back each resulting remote state once before continuing. Do not assume dependency order is deployment order: when old and new contracts cannot coexist, define an explicit expand, consumer-transition, and contract sequence before the first remote change.
4. Report the dependency order and, for each repository, its resolved target, contract or reference handed off, commit or version result, validation evidence, and any remaining external configuration or compatibility risk.
