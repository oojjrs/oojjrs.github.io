---
name: oojjrs-unity-package-docset-maintenance
description: Create, restructure, update, or audit UnityO package Documentation~ guides, API contract docs, or a complete documentation set spanning package and repository entry points. Do not use for incidental code-change docs, root-README-only work, package migration, version or changelog-only updates, or game Design.html.
---

# Oojjrs Unity Package Docset Maintenance

Use this skill when UnityO package documentation is the primary deliverable, whether the request targets focused `Documentation~` or API material or a comprehensive set across documentation layers. It owns the package-documentation rules and any directly required package or repository entry-point synchronization for that phase; do not stack a standalone README workflow.

## Scope Gate

The possible documentation surfaces are:

- repository-root `README.md`
- `Packages/src/README.md`
- `Packages/src/Documentation~/index.md`
- focused API contract documents under `Packages/src/Documentation~`

Use only the surfaces required by the request. For a comprehensive creation or restructuring task, cover every applicable role; for a focused guide or API task, preserve navigation and synchronize only directly stale entry points. Map these roles to an already established equivalent layout when necessary, but do not move the package, rename source paths, or perform an `Assets`-to-`Packages/src` migration as part of documentation work.

Route other work to its owning phase:

- documentation incidental to a code or behavior change stays with that code-change workflow
- a standalone repository README uses the README-specific workflow
- package structure migration and its required docs stay with the migration workflow
- version, release-note, or changelog-only work stays with the package-release workflow
- game planning content in `Design.html` stays with the applicable Design workflow

## Sources Of Truth

1. Read the live `package.json`, asmdefs, public Runtime and Editor code, platform-specific implementations, samples, tests, existing docs, and repository entry points that bear on documented claims.
2. Derive package identifiers, Unity compatibility, dependencies, install paths, namespaces, API signatures, lifecycle, error behavior, and platform support from those sources. Do not invent or preserve a claim merely because an older document states it.
3. Use current official primary documentation for upstream Unity or platform contracts when local evidence is insufficient. Clearly distinguish an upstream guarantee from package behavior inferred from implementation.
4. Preserve the requested or established audience and language. Mark genuinely unresolved behavior instead of presenting it as a contract.
5. Consult Git history only when recovery, provenance, or an explicitly historical explanation requires it.

## Information Architecture

Give each fact one authoritative home and link to it from shallower layers instead of copying long sections.

- **Root README:** repository identity, package purpose and location, concise capabilities, verified entry path, and links into package documentation.
- **Package README:** consumer-facing requirements, verified installation or inclusion method, smallest useful example, important constraints, and links to the full guide and API contracts.
- **Documentation index:** navigable overview of concepts, setup, primary workflows, platform notes, samples, and API documents.
- **API contracts:** current public types and members plus the applicable ownership, lifecycle, inputs and outputs, event or callback ordering, async and thread behavior, cancellation and timeout behavior, failures and exceptions, fallbacks, persistence, and platform differences.

Do not turn API documentation into an inventory of private implementation details. Keep examples minimal, executable in context, and exact about namespaces and signatures.

## Workflow

1. Inventory the current documentation files, audiences, links, duplication, contradictions, and missing layers.
2. Inventory the current public package surface and material behavioral contracts. Trace every changed factual claim to live code, metadata, a sample, a test with independent contract value, or official upstream documentation.
3. Choose a coherent navigation and document split that fits the package rather than forcing every package into identical filenames beyond the four documentation roles above.
4. Create or revise only the documentation required for the requested scope, including directly stale navigation or entry points. Do not change implementation, package structure, metadata, versions, or changelogs to make a document claim true; report those mismatches for a separately authorized phase.
5. Preserve existing documentation `.meta` files. Do not fabricate or hand-edit `.meta` files for Markdown; `Documentation~` intentionally does not require them. If repository policy requires a new package-root Markdown `.meta`, leave Unity generation as an explicit pre-publication requirement.
6. Remove stale duplication only within the requested documentation scope. Preserve useful historical or migration material unless the user requested its reorganization and its new home is clear.

## Verification

Verify the completed documentation scope against independent sources:

- every changed local link and heading target resolves with correct path casing
- package IDs, versions, Unity requirements, dependencies, commands, paths, namespaces, signatures, and examples match live sources
- each documentation layer has its assigned role and navigation reaches the deeper material
- repeated claims do not conflict and unsupported claims are removed or labeled
- API contracts cover only behavior the implementation or an authoritative source establishes

Do not use a package build or broad test suite as a proxy for documentation accuracy. Run code or snippet validation only when the request authorizes it and it materially verifies a changed example. Report any unresolved source-versus-document conflict without silently editing source code.
