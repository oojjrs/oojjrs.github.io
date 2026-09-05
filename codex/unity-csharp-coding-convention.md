# Unity C# Rules

First-party only. Priority: local > here > Unity > VS/Microsoft. Exclude generated/vendor/sample/third-party/`PackageCache`. Preserve behavior and Unity references; ask before broad renames/migrations.

## Core

1. New/edited statements through `;`, declaration headers including parameters/`where`, and call arguments stay on one physical line regardless of length. Preserve user wraps unless asked.
2. One-line simple-statement body: no braces. When the body is another control statement, brace the outer statement except `else if`; nested `using` follows 27. One braced `if` branch: brace all.
3. One attribute per line directly above its declaration.
4. One empty line at required boundaries and after `using`; never consecutive, whitespace-only, or directly inside braces.
5. Type scope: one line between member sections, inheritance groups, nested types, functions. Keep groups and attached metadata together.
6. Blocks: separate only complete purpose groups. Keep values with immediate validation/use; no line before `else` or `}`.
7. `UnityEngine.Object`: never `?.`/`??`/`??=`; use Unity checks and explicit fallbacks. Recover hidden Unity objects first. Managed references, nullable, `?:`, delegates/events exempt.

## Naming

8. Inherited-role naming: append the direct base type to the derived role: `FooSome : Some`; drop only `Interface` from an interface role: `FooSome : SomeInterface`; preserve the full direct base-class name in deeper chains: `SomeFooBar : FooBar`, `FooBar : Bar`. Rule 21 Unity object/script name identity takes priority: `IngameMenu : Page`, not `IngameMenuPage`. Interface types use suffix `Interface`; variables do not.
9. First inspect the field itself: if its declaration does not contain `static`, this rule does not apply; `const` is governed by 10. Except constant-like `static readonly` under 10, a static field declared in a non-static type uses public `__PascalCase`/private `__camelCase`; one declared in a `static class` uses public `_PascalCase`/private `_camelCase`. Judge the field's immediate declaring type. A private instance field uses `_camelCase`, never `__camelCase` (for example, `private int _index` versus `private static int __index`).
10. `const` and constant-like `static readonly`: unprefixed PascalCase. A `static readonly` qualifies only when it denotes a program/API definition, not captured/owned runtime state; its semantic value and contributing reachable observable state cannot change after initialization; identity/lifetime/synchronization/lazy/service/cache state is irrelevant. Time/random/environment/configuration/I/O/Unity-derived values and merely unmodified mutable objects do not qualify. Every other `readonly` follows normal instance/static field naming; uncertainty defaults to field naming. Naming does not change order under 34; mutable static state also follows 31.
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
27. Use `using (...)` statements, never `using var`. A one-line, semicolon-terminated simple-statement body omits braces; every other body uses braces. In nested `using`, each outer `using` whose body is another `using` uses braces; the innermost omits them when its body meets the one-line rule.
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
40. Inline single-use value; local requires 2+ uses or syntax/execution semantics.
41. Do not use `internal` unless the user explicitly designates that specific declaration or scope as internal. This includes explicit `internal`, compound access containing it such as `protected internal`, and omitted access on top-level types (implicit internal). Never infer it from assembly/package/test boundaries or nearby code; otherwise state the intended non-internal access explicitly.
42. A property that can be represented by one expression uses an expression body (`=>`) whenever possible. Function declarations never use expression bodies: methods, constructors, finalizers, operators, and local functions use brace-delimited block bodies. Rule 2's brace omission applies only to statement bodies; lambda syntax is unaffected.
43. Equality/inequality, including reference comparisons: use `==`/`!=` by default. Use `ReferenceEquals` only when CLR reference identity is required and direct operator comparison cannot provide it, such as when overloaded equality must be bypassed or an equality operator would call itself recursively. Confirm the operand static types and the operators selected for the expression before applying an exception. Explicit reference intent or hypothetical future overloads are not exceptions. Preserve comparison semantics and rule 7's Unity validity checks.
