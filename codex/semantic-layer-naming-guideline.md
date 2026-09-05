# Semantic Layer Naming Guideline for Codex

## Scope

Apply this guideline before creating or changing first-party names in game or server application and business logic. Engines, frameworks, reusable libraries, low-level code, and externally owned names follow their own conventions.

## Core Principles

1. Each token represents one real ownership, structure, relationship, or role layer.
2. Keep one concept in one token. Let the code model, not dictionary spelling, decide boundaries.
3. Add tokens only for real layers. Long names are acceptable when every token has meaning.
4. Decide semantic layers first, then apply the target coding convention's casing and separators.
5. If these rules, the actual structure, and established conventions cannot resolve a name, do not invent one. Explain the ambiguity and available options, ask the user, and wait for their decision before naming it.

## Decision Criteria

- Ground each token in an actual ownership path, code or data model, role, or relationship.
- Do not merge tokens that represent separate layers or split a concept into nonexistent layers.
- For example, use `UserName` for a real `User -> Name` structure and `Username` for one atomic username concept.
- Match the actual responsibility and scope; a temporary implementation state alone does not define a layer.
- Name the same concept consistently. Prefer recent first-party code when establishing conventions.
- Preserve official platform names and repetition required by language or naming conflicts.

## Renaming

- Existing serialization, resource, database, public API, and wire contracts take precedence.
- When a rename affects a contract, trace references and establish the migration approach before proceeding.

Further explanations: [Korean](https://oojjrs.github.io/kr/csharp/semantic-layer-naming/) · [English](https://oojjrs.github.io/en/csharp/semantic-layer-naming/)
