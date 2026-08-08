---
layout: page
title: "Semantic Layer Naming"
lang: en
alternate_url: /kr/csharp/semantic-layer-naming/
category: "NAMING DESIGN"
description: "A naming rule for reading identifier boundaries as ownership, structure, relation, and role layers in game-project and server-application business logic."
permalink: /en/csharp/semantic-layer-naming/
toc_items:
  - id: principle
    label: Core principle
  - id: tokens
    label: Layers, not words
  - id: structure
    label: Mapping structure into names
  - id: matrix
    label: Two-dimensional coordinates
  - id: evidence
    label: Evidence for a boundary
  - id: failures
    label: Invalid boundaries
  - id: checklist
    label: Review sequence
  - id: scope
    label: Scope and history
---

<p class="article-backlink"><a href="{{ "/en/" | relative_url }}">← Document index</a></p>

<p class="article-lead">A boundary inside an identifier is not a visual spelling break. In game-project and server-application business logic, each boundary declares that the structure represented by the name has gained another layer. The surface syntax may vary by language and platform, but this decision remains the same.</p>

<div class="article-principle">
  <p>Each semantic token in a name represents one real semantic layer. Write one layer as one token. Let ownership, structure, relations, and responsibilities in the code—not the dictionary or surface casing—decide the boundary.</p>
</div>

## Core principle {#principle}

`FooBar` and `Foobar` are not two spellings of the same name.

- `FooBar` declares two layers: `Foo -> Bar`.
- `Foobar` declares one atomic layer named `Foobar`.
- Adding a token expands the structure represented by the name by one layer.
- Length is not the problem. A token that has no coordinate in the real structure is the problem.
- A surface token repeated only because of a language or scope naming constraint does not create another semantic layer.

This is not a casing convention. It is a design rule for how much architecture a name exposes.

The examples use PascalCase, but the semantic decision comes first. In camelCase, snake_case, kebab-case, or another required style, preserve the same grouping and render it with the target convention: `FooBar`, `fooBar`, `foo_bar`, and `foo-bar` can all express `Foo -> Bar`, while `Foobar` and `foobar` express one atomic layer.

## Layers, not words {#tokens}

When the system models a concept as one layer, keep it in one token even if natural language can decompose it.

| Name | Decision | Reason |
| --- | --- | --- |
| `Nickname` | One layer | The system has no `Nick -> Name` structure. |
| `Lifetime` | One layer | Lifetime is modeled as one duration concept. |
| `Gameplay` | One layer | `Game` does not own a `Play` layer. |
| `TitleMenuButton` | Three layers | The real structure is `Title -> Menu -> Button`. |

`Nickname` is correct here not because a dictionary calls it a compound, but because the model has no `Nick` layer with a `Name` role beneath it.

The reverse can also be true. Use `UserName` when the model has a real `User -> Name` property or role. Use `Username` when it is one login-identifier concept. Shape alone cannot decide.

## Mapping structure into names {#structure}

Unity UI provides one concrete example: a name can expose prefab and scene ownership paths.

```text
Title
└─ Menu
   └─ Singleplayer Button

TitleMenuSingleplayerButton
```

`Button` is not decorative suffixing; it is the leaf component role. In the same way, `LobbyRoomListEntryHostText` exposes `Lobby -> Room -> List -> Entry -> Host -> Text`.

An ASP.NET server provides another example.

```text
Db -> Character -> Mapper
Db -> Character -> Record

DbCharacterMapper
DbCharacterRecord
```

Names such as `RoomLobbyService` and `RoomPlayerView` are valid when the aggregate and role boundaries actually exist.

The decision method does not depend on a particular language, engine, or server framework's surface syntax. Its scope, however, is the business logic of the game project itself or the server application itself; it is not generalized into engine, library, or low-level layers.

## Two-dimensional coordinates {#matrix}

A consistent name family is arranged as a structural-path row and a terminal-role column.

| Structural row | Role column | Resulting name |
| --- | --- | --- |
| `Title -> Menu` | `SingleplayerButton` | `TitleMenuSingleplayerButton` |
| `Lobby -> Room -> List -> Entry` | `HostText` | `LobbyRoomListEntryHostText` |
| `Lobby -> Room -> List -> Entry` | `JoinButton` | `LobbyRoomListEntryJoinButton` |
| `Db -> Character` | `Mapper` | `DbCharacterMapper` |
| `Db -> Character` | `Record` | `DbCharacterRecord` |

Repeated prefixes expose rows; repeated role suffixes expose columns. This is why the code looks like a two-dimensional matrix rather than a list of phrases.

## Evidence for a boundary {#evidence}

A token boundary must point to at least one concrete structure:

1. A file, module, package, resource, object, component, or serialized ownership path
2. A namespace, nested type, aggregate, domain, schema, persistence, transport, or application-service boundary
3. A stable role reused by sibling names, such as `Entry`, `Button`, `Text`, `Mapper`, `Record`, or `Handler`
4. A real relationship expressed by `From`, `For`, `Of`, `Via`, or `Without`
5. A consistent first-party facade layer such as `My` around platform types
6. A number that corresponds to a real resource, scene, prefab, slot, stage, schema version, or ordinal variant

Do not reject `MyButton` by shape alone. It is valid when `My` consistently marks a first-party facade distinct from Unity's built-in types. `From` in `FinderFromVariable` is valid when it represents the real source relationship.

Preserve official platform spellings such as `GameObject`, `DateTime`, `TimeSpan`, `AudioSource`, and `Texture2D`. Do not reinterpret their internal capitals as first-party domain layers.

## Invalid boundaries {#failures}

### Inventing a layer

`NickName`, `LifeTime`, and `GamePlay` declare `Nick -> Name`, `Life -> Time`, and `Game -> Play` without those structures.

### Hiding a real layer

`TitlehudStartButton` hides `Title -> Hud` when that path exists in the prefab. `Tilelogic` hides a real `Tile -> Logic` domain and role boundary.

### Treating temporary state as architecture

`Temp` in `PlayerInputBugTemp` or `ItemLogicTemp` is not a semantic layer when it only marks temporary lifetime. If a workaround becomes a durable responsibility, name the actual role, such as `Workaround`.

### Misreading required surface repetition

When a nested class cannot use the shorter `Arguments` because of a name conflict, a form such as `MyAsker.MyAskerArguments` may be required. The second surface `MyAsker` does not add another semantic layer. Read the semantic structure as `MyAsker -> Arguments`, record the language or scope exception, and do not mechanically shorten it to `MyAsker.Arguments`.

### Mismatching name scope and implementation scope

`AssetLoader` is too broad if it only instantiates prefabs. `AgentContainer` is misleading if it primarily stores obstacles. The content of each token, not only its boundary, must match the implementation.

## Review sequence {#checklist}

Before accepting a new or changed name, ask:

1. What actual structure, owner, relation, or responsibility does each semantic token in the name identify?
2. Can each intermediate token be explained independently or reused as a common sibling-family row?
3. Would merging two tokens hide a real layer?
4. Would splitting one token invent a layer the system does not have?
5. Does the relevant ownership hierarchy, code or data model, domain, or role matrix support the boundary?
6. Does `Temp`, `Old`, `New`, or `Legacy` describe responsibility, or only implementation age?
7. Which form has the newest first-party code converged on for the same concept?
8. Is an apparent repetition required by a language or scope naming constraint, such as a nested-type name conflict?
9. Does the rename require a serialization, resource, route, database, public API, or wire-format migration?

## Scope and history {#scope}

Apply this rule to first-party names created or changed in the business or product logic of the game project itself or the server application itself. Within that layer, it covers code identifiers and code-owned names such as types, members, modules, packages, files, resources, serialized objects, DTOs, persistence types, and service roles.

Code whose domain rules and content keep expanding during live service accumulates unique dedicated types and files for narrow responsibilities. Once each unit becomes sufficiently focused, it tends to stabilize instead of continually gaining features, while new requirements add sibling units. Exposing semantic layers as structural coordinates makes those growing name families navigable.

Do not apply this rule inside engines, runtimes, frameworks, reusable libraries, infrastructure primitives, or fully low-level code. Reusable API shape, abstraction boundaries, protocols or ABIs, allocation and performance constraints, and established platform vocabulary take precedence there, so those layers follow their own conventions.

First decide the semantic layers, then express them with the syntax, separators, and casing required by the target convention.

Exclude generated code, vendor code, external samples, dependency caches, and framework-owned names from first-party consistency judgments. In team repositories, separate other authors' legacy from the user's own naming practice.

When inferring the established convention, treat recent first-party code as stronger evidence than old code. Legacy can reveal debt, but it does not automatically become precedent for new names.

<div class="article-note">
  <p>Even when the naming principle is clear, a broad rename that affects serialization, resources, public APIs, or an external contract is a separate migration task. Do not perform it as style cleanup without reference tracing and a migration plan.</p>
</div>

For Unity C# work, continue with [Unity C# Convention]({{ "/en/unity/csharp-coding-convention.html" | relative_url }}) for syntax, file organization, and Unity-specific code shape.
