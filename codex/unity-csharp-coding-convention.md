# Unity C# Rules

First-party only. Priority: local > here > Unity > VS/Microsoft. Exclude generated/vendor/sample/third-party/`PackageCache`. Preserve behavior and Unity references; ask before broad renames/migrations.

## Core

1. New/edited statements through `;`, declaration headers including parameters/`where`, and call arguments stay on one physical line regardless of length. Preserve user wraps unless asked.
2. Single body: no braces. Nested control-only body: brace outer except `else if`. One braced `if` branch: brace all.
3. One attribute per line directly above its declaration.
4. One empty line at required boundaries and after `using`; never consecutive, whitespace-only, or directly inside braces.
5. Type scope: one line between member sections, inheritance groups, nested types, functions. Keep groups and attached metadata together.
6. Blocks: separate only complete purpose groups. Keep values with immediate validation/use; no line before `else` or `}`.
7. `UnityEngine.Object`: never `?.`/`??`/`??=`; use Unity checks and explicit fallbacks. Recover hidden Unity objects first. Managed references, nullable, `?:`, delegates/events exempt.

## Naming

8. Interface: type suffix `Interface`; variable no marker.
9. Static field except `const`/`readonly`: non-static type public `__PascalCase`/private `__camelCase`; static class public `_PascalCase`/private `_camelCase`. Judge immediate type.
10. `const`/`readonly`: unprefixed PascalCase; mutable `static readonly` also follows 31.
11. Property: noun/adjective; Boolean question `Is`/`Has`, not action.
12. `CanX`: ability to act; `Xable`: attribute.
13. Property type postfix only when search improves (`String`, `Sprite`, `Prefab`, `Effect`, `Tooltip`).
14. Function: verb/verb phrase.
15. Enum: type suffix `Enum`; variable no repeated suffix.
16. `IEnumerator` function: suffix `Coroutine`.

## Files

17. File name = representative definition.
18. One main top-level class/struct/enum per file; nested types exempt.
19. Nested types: `enum` > `struct` > `interface` > `class`.
20. File/class: role noun; function carries action.
21. Align prefab/object/script/class names.

## Words

22. Business logic: one semantic layer per PascalCase token; split only for ownership/structure/relation/role. Exclude engine/library/low-level; see `semantic-layer-naming-guideline.md`.
23. Avoid keyword-substring names when search must distinguish them.
24. Groups: plural `-s`/`-es`; avoid type-noise `List`/`Array`/`Bucket`.

## Structure

25. Externally created/owned lifecycle object: get-only property, not mutable public field.
26. Do not repeat a construction type: initializer names it -> `var`; target names it -> `new(...)`/`new()`.
27. Use `using (...)` blocks, never `using var`.
28. Modifiers: access > `sealed` > `override`.
29. Sections: nested types > variables > properties > events > functions.
30. After 29/31/34, alphabetize only within one category/inheritance group; never mix groups.
31. Groups: static > inherited > local; constructors/finalizer first. Supporting fields/properties stay in inherited group. `MonoBehaviour`: Unity messages alphabetical > parents declaration order > interfaces alphabetical > local. Static only if type-owned; define lifetime/reset/cleanup/concurrency. `Instance`/`Current`/service access = debt.
32. Extract only for reuse, independent responsibility/contract, or clearer boundary. Entry points/overrides/explicit interfaces/callbacks exempt. Local function only for caller-local reuse, dependent coroutine, or long foldable block.
33. Interfaces: explicit `InterfaceName.MemberName` implementation.
34. Variables: `const` > `readonly` > `static` > inherited > local; alphabetize only within group.
35. Prefix increment/decrement: `++index`, `--index`.
36. `!` only for toggle reassignment; otherwise compare with `false`.
37. Never group/order by access; follow 29-31/34.
38. Logical expression: parenthesize comparisons/nested compound operands, not standalone Boolean terms.
39. Valid/normal/primary branch first.
40. Logs: follow `logging-guideline.md`.
41. Inline single-use value; local requires 2+ uses or syntax/execution semantics.
