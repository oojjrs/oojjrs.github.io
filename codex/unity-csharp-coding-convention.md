# Unity C# Rules for Codex

Read this before editing first-party Unity C# files. This is the agent copy of the convention: keep every rule and decision criterion, but omit long examples and site decoration.

## Purpose, Scope, Priority

1. Purpose: make Unity C# code shape predictable, reduce style-decision time close to zero, and make analysis approach zero cost as domain familiarity increases.
2. Method: prefer IDE and standard-tool defaults, keep manual decisions simple, keep context consistent (`verb` functions, `noun` variables), and apply the same standard to AI output and manual review.
3. Scope: first-party Unity C# only. Auto-generated code is always an exception to this convention. Do not restyle third-party, generated, imported vendor, sample, or `PackageCache` code for style only.
4. Priority: current project/domain/file conventions first, then this file, then Unity C# Style, then Visual Studio Code Style defaults and Microsoft C# coding conventions. Unmentioned conventions follow Unity and Visual Studio defaults.
5. Safety: runtime behavior, prefab links, serialized field compatibility, Unity object names, and asset references outrank naming cleanup. Ask before broad renames, serialized data migration, prefab/object rename work, or changes that could break Unity references.

## Core Rules

1. Keep every semicolon-terminated code statement on one physical line from its first token through its semicolon. Keep function declaration parameter lists, call argument lists, and the full declaration header including generic `where` clauses on one physical line regardless of length. Line length never justifies wrapping. If a line appears to require wrapping, treat the code design as the problem and leave the line unchanged instead of wrapping it or performing an unrequested refactor. Codex and automated formatters must not introduce, remove, or rearrange code line breaks. Only the user may decide a deliberate manual wrap; preserve existing user-authored wraps unless the user explicitly asks to change them.
2. Prefer omitting braces from any body C# permits as a single embedded statement; keep them only for a concrete reason. Do not nest brace-free control statements: when a control statement's only body is another control statement, except for an `else if` chain, brace the outer body and omit braces only from the innermost single action. In an `if` chain, if one branch needs braces, use them for every branch.
3. Put each attribute on its own line above its declaration.
4. Rules 4-6 control blank lines only. Use exactly one empty line at required boundaries and after `using` directives; never use consecutive or whitespace-only blank lines, or blank lines immediately inside braces.
5. At type scope, put one blank line between existing member sections, inheritance groups, nested types, and function implementations. Keep same-group members together and attributes, documentation, and leading comments attached to their declaration.
6. Inside blocks, put one blank line only between complete statement groups with different immediate purposes. Keep produced values with their immediate validation or consumer; do not put a blank line before `else` or a closing brace.
7. Never use the null-conditional (`?.`), null-coalescing (`??`), or null-coalescing assignment (`??=`) operators to access or select a fallback for a `UnityEngine.Object`-derived reference. Unity can retain a managed wrapper after its native object is destroyed, while these operators test only CLR null and bypass Unity's overloaded equality and implicit Boolean. Check `unityObject != null` or `if (unityObject)` immediately before access and use an explicit branch for fallback selection. If an `object`, interface, or generic may contain a Unity object, recover and check it as `UnityEngine.Object` first. Ordinary managed references, delegates or events such as `Changed?.Invoke()`, nullable annotations such as `Type?`, and the ternary operator (`condition ? first : second`) remain allowed.

## Naming

8. Interfaces use the `Interface` suffix. Put the marker only on the type: `FunctionInterface function`, not `IFunction` or `functionInterface`.
9. Except for `const` and `readonly`, static field prefixes follow the immediate declaring type: public and private static fields use `__PascalCase` and `__camelCase` in a non-static type, and `_PascalCase` and `_camelCase` in a `static class`. For a nested type, judge only the type that directly declares the field, not an enclosing type. Apply this naming rule mechanically while the field exists.
10. `const` and `readonly` fields use PascalCase without an underscore prefix regardless of whether they are static or which type declares them, like `MaxCount` and `StartIndex`; they should read like type or property names. A `static readonly` field that references a mutable object still follows rule 31's static-state design criterion.
11. Properties are nouns or adjectives. Boolean question properties should collect under searchable prefixes such as `Is` and `Has`; avoid action-like property names such as `Activate`.
12. Distinguish `Can` from `-able`: `CanGather` means the object can perform the action; `Gatherable` means the object has that attribute.
13. Add type postfixes to properties only when searchability improves, such as `String`, `Sprite`, `Prefab`, `Effect`, or `Tooltip`; avoid noisy postfixes when the short name is searchable enough.
14. Functions use verbs or verb phrases, so the action is visible from the function name: `GiveReward()`, not `Reward()`.
15. Enum types use the `Enum` suffix, and variables do not repeat it: `ItemGroupEnum itemGroup`, not `ItemGroup itemGroupEnum`.
16. Coroutine functions use the `Coroutine` suffix to show the different execution model: `FadeCoroutine()`, not `Fade()` for an `IEnumerator`.

## Files and Unity Objects

17. Match the file name and representative definition name so IDE and IntelliSense search line up: `PlayerController.cs` contains `PlayerController`, not a different main type.
18. One file has one representative top-level definition. Split representative classes, structs, and enums by file; nested definitions are the exception.
19. Nested types are ordered `enum`, `struct`, `interface`, `class`. This matters because multiple type declarations usually appear only as nested types.
20. File names and class names are nouns. Put roles in type names and actions in function names: `PlayerMover`, not `MovePlayer`.
21. Match Unity object names and script names so inspector names and code-search names point to the same concept: prefab/script/class should align, like `InventoryPanel`.

## Words

22. In project-level business logic, a PascalCase boundary declares a semantic layer. Keep one semantic layer in one token, and split only for a real ownership, structure, relation, or role boundary: `Nickname` is one concept, while `TitleMenuButton` represents `Title -> Menu -> Button`. The dictionary does not decide the boundary; the code structure does. This design rule does not govern engine, library, or fully low-level code; apply the full scoped criteria in `semantic-layer-naming-guideline.md`.
23. Avoid names that are substrings of other search keywords. Do not pair names like `MissionState` and `IntermissionState` if searching `Mission` should not catch both.
24. Plural groups currently allow `-s` and `-es`, such as `Items`, `Enemies`, and `Rewards`. Avoid type-noise suffixes such as `List`, `Array`, or `Bucket`; a better alternative is still undecided.

## Syntax and Structure

25. External lifecycle objects are read-only properties: use a get-only property when creation and ownership live outside this object; do not expose it as a mutable public field.
26. Do not repeat a type in object creation. Use `var` when a local variable's right-side expression names the type. When the declaration or assignment target already names the type, especially for class member variables and properties, use target-typed `new(arguments)` or `new()` instead of repeating the type after `new`.
27. Do not use the newer using-declaration form. Keep the existing block form: `using (...) { }`, not `using var`.
28. Put `sealed` before `override`, in access modifier, `sealed`, `override` order: `public sealed override`, not `public override sealed`.
29. Class sections are nested types, variables, properties, events, functions. Nested type order is still `enum`, `struct`, `interface`, `class`.
30. Sort alphabetically only inside the same category of the same inheritance group, after section order and the shared member order. Variables use `const` > `readonly` > `static` > inherited implementation > local instance member, properties use `static` > inherited implementation > local instance member, and functions use constructors and finalizer > `static` > inherited implementation > local instance function. Do not move parent or interface groups just to satisfy abc sorting.
31. Within each category, order variables, properties, and functions as `static` members, inherited-implementation members, then local instance members. Constructors and the finalizer precede those groups among functions; `const` and `readonly` precede them among variables. Variables and properties that support an inherited implementation belong to that parent or interface group. Do not mix static, inherited-implementation, and local groups. In a `MonoBehaviour`, treat Unity message functions as the first inherited group and implement them before explicitly inherited parent and interface members. Sort Unity messages alphabetically by function name, then use parent > child order, parents in inheritance declaration order, and multiple interfaces and implementations alphabetically. Design principle: in an ordinary non-static object type, avoid mutable static state as a rule and treat it as exceptional or temporary. When the state genuinely belongs to the type as a whole, make its lifetime, initialization and reset, cleanup, and concurrency responsibilities explicit; treat convenience `Instance`, `Current`, or service-access fields as temporary design debt. Avoid static functions unless the behavior clearly belongs to the type itself.
32. Extract a function only for reuse, an independent responsibility or contract, or a clearer context boundary; otherwise keep one-off logic in its caller. Unity messages, overrides, explicit interface implementations, registered callbacks, and framework entry points are exceptions. Use a local function only for caller-local reuse, a dependent coroutine, or a long foldable block.
33. Implement interface members explicitly as `InterfaceName.MemberName`; do not expose them as public members.
34. Order member variables as `const` > `readonly` > `static` > inherited implementation > local instance; alphabetize only within the same inheritance group.
35. Use prefix increment and decrement: `++index` and `--index`.
36. Use `!` only to toggle and assign the same Boolean; otherwise compare explicitly with `false`.
37. Do not group members by access modifier; follow rules 29-31 and 34.
38. Parenthesize each comparison or compound condition joined by logical operators, recursively. Do not parenthesize a complete single Boolean term.
39. Put valid, normal, or primary-interest branches before invalid, error, or exceptional branches.
40. Before adding or changing logs, follow `logging-guideline.md`.
41. Inline a value used once into its call, assignment, return, or expression. Declare a local only when the value is used at least twice or C# syntax or execution semantics require storage.
