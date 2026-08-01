# Semantic Layer Naming Guideline for Codex

Read this before creating or changing names in first-party Unity or ASP.NET C#. This guideline defines what PascalCase boundaries mean; language syntax and ordinary casing rules remain in their respective coding conventions.

## Core Principle

1. Each PascalCase token declares one semantic layer.
2. Keep one semantic layer in one token.
3. Add a token only when the name gains a real ownership, structure, relation, or role layer.
4. Do not split or merge tokens according to dictionary spelling. The code model decides the boundary.
5. `FooBar` and `Foobar` are different concepts. `FooBar` asserts `Foo -> Bar`; `Foobar` names one atomic layer.
6. Long names are acceptable when every token identifies a real coordinate. A token with no structural meaning is the problem, not length itself.
7. A repeated surface token forced by a language or scope naming constraint does not create another semantic layer.

## Atomic Concepts and Real Layers

- Use one token for a concept modeled as one layer, even when natural language can decompose it: `Nickname`, `Lifetime`, `Gameplay`, `Minimap`, `Hotkey`, `Filename`.
- These forms are contextual, not dictionary mandates. If a project truly models `User -> Name`, `UserName` is correct; if it models one username concept, use `Username`.
- Split tokens when the code has the matching structure. `TitleMenuButton` is correct when the prefab or UI path is `Title -> Menu -> Button`.
- A terminal role such as `Button`, `Text`, `Mapper`, `Record`, `Service`, or `View` is a separate token when it is an actual role in the design.

## Read Names as Two-Dimensional Coordinates

Treat a name family as a structural path plus a terminal role.

- UI path row: `Lobby -> Room -> List -> Entry`
- UI role columns: `HostText`, `ModeText`, `TitleText`, `JoinButton`
- Resulting names: `LobbyRoomListEntryHostText`, `LobbyRoomListEntryModeText`, `LobbyRoomListEntryTitleText`, `LobbyRoomListEntryJoinButton`
- Server path row: `Db -> Character`
- Server role columns: `Mapper`, `Record`
- Resulting names: `DbCharacterMapper`, `DbCharacterRecord`

Repeated prefixes expose structural rows; repeated role suffixes expose columns. This is why a consistent codebase looks like a two-dimensional matrix rather than a flat list of phrases.

## Evidence for a Boundary

A token boundary is justified when at least one concrete structure supports it:

1. A Unity prefab, scene, GameObject, component, or serialized ownership path.
2. A namespace, nested type, aggregate, domain, persistence, transport, or application-service boundary.
3. A stable role reused by peer names, such as `Entry`, `Button`, `Text`, `Mapper`, `Record`, or `Handler`.
4. A real relationship represented by an operator token such as `From`, `For`, `Of`, `Via`, or `Without`.
5. A deliberate provenance layer. For example, `My` is valid when it consistently marks a first-party facade or wrapper around platform types.
6. A numeric token that maps to a real scene, prefab, slot, stage, or ordinal variant.

Preserve official platform identifiers such as `GameObject`, `DateTime`, `TimeSpan`, `AudioSource`, and `Texture2D`. Treat their internal spelling as quoted external vocabulary rather than first-party domain boundaries.

## Failure Modes

1. **Invented boundary:** `NickName`, `LifeTime`, or `GamePlay` declares `Nick -> Name`, `Life -> Time`, or `Game -> Play` without such layers.
2. **Hidden boundary:** `TitlehudStartButton` or `Tilelogic` merges a real `Title -> Hud` or `Tile -> Logic` structure.
3. **Lifecycle label as architecture:** `Temp`, `Legacy`, `Old`, or `New` is not a semantic layer merely because an implementation is temporary. Name the durable responsibility, such as `Workaround`, when that is the actual role.
4. **Misread required repetition:** A nested type may need `MyAsker.MyAskerArguments` when a naming conflict prevents the shorter `Arguments`. The second surface `MyAsker` does not add another semantic layer. Read the structure as `MyAsker -> Arguments`, record the language or scope exception, and do not mechanically shorten it to `MyAsker.Arguments`.
5. **Scope mismatch:** A generic name such as `AssetLoader` is misleading if the implementation only instantiates prefabs. An `AgentContainer` is misleading if it primarily stores obstacles.
6. **Boundary drift:** Do not alternate `Nickname` and `NickName`, or `Minimap` and `MiniMap`, for the same concept unless the structures are genuinely different.

## Review Checklist

Before accepting a new or changed name, answer these questions:

1. What does each PascalCase token point to in the actual structure?
2. Can each intermediate token be explained independently or reused as a sibling-family row?
3. Would merging two tokens hide a real layer?
4. Would splitting one token invent a layer that the system does not have?
5. Does the prefab or scene hierarchy, or the server domain and role matrix, support the boundary?
6. Is the token a durable responsibility rather than a temporary implementation state?
7. Which form does the newest first-party code use for the same concept?
8. Is an apparent repetition required by a language or scope naming constraint, such as a nested-type name conflict?
9. Does a rename require a Unity serialization, prefab, scene, route, database, or wire-format migration?

## Scope and Precedence

- Apply this guideline to first-party Unity and ASP.NET C# names, including types, members, Unity objects, prefabs, scenes, DTOs, persistence types, and service roles.
- Exclude generated, vendor, imported sample, `PackageCache`, and framework-owned names from first-party consistency judgments.
- When inferring an established convention, weight recent first-party code more strongly than old code, and separate other authors' team legacy from the user's own naming practice.
- Existing serialized or external contracts outrank cosmetic cleanup. Do not perform broad renames without tracing references and planning the migration.

Public versions: [Korean](https://oojjrs.github.io/kr/csharp/semantic-layer-naming/) · [English](https://oojjrs.github.io/en/csharp/semantic-layer-naming/)
