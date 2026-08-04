# Unity C# Rules for Codex

Read this before editing first-party Unity C# files. This is the agent copy of the convention: keep every rule and decision criterion, but omit long examples and site decoration.

## Purpose, Scope, Priority

1. Purpose: make Unity C# code shape predictable, reduce style-decision time close to zero, and make analysis approach zero cost as domain familiarity increases.
2. Method: prefer IDE and standard-tool defaults, keep manual decisions simple, keep context consistent (`verb` functions, `noun` variables), and apply the same standard to AI output and manual review.
3. Scope: first-party Unity C# only. Auto-generated code is always an exception to this convention. Do not restyle third-party, generated, imported vendor, sample, or `PackageCache` code for style only.
4. Priority: current project/domain/file conventions first, then this file, then Unity C# Style, then Visual Studio Code Style defaults and Microsoft C# coding conventions. Unmentioned conventions follow Unity and Visual Studio defaults.
5. Safety: runtime behavior, prefab links, serialized field compatibility, Unity object names, and asset references outrank naming cleanup. Ask before broad renames, serialized data migration, prefab/object rename work, or changes that could break Unity references.

## Naming

1. Interfaces use the `Interface` suffix. Put the marker only on the type: `FunctionInterface function`, not `IFunction` or `functionInterface`.
2. Static member variables use two underscores: public static is `__PascalCase`, private static is `__camelCase`; do not use plain `Index`, `_index`, or `index`.
3. `const` and `readonly` names use PascalCase, like `MaxCount` and `StartIndex`; they should read like type or property names.
4. Properties are nouns or adjectives. Boolean question properties should collect under searchable prefixes such as `Is` and `Has`; avoid action-like property names such as `Activate`.
5. Distinguish `Can` from `-able`: `CanGather` means the object can perform the action; `Gatherable` means the object has that attribute.
6. Add type postfixes to properties only when searchability improves, such as `String`, `Sprite`, `Prefab`, `Effect`, or `Tooltip`; avoid noisy postfixes when the short name is searchable enough.
7. Functions use verbs or verb phrases, so the action is visible from the function name: `GiveReward()`, not `Reward()`.
8. Enum types use the `Enum` suffix, and variables do not repeat it: `ItemGroupEnum itemGroup`, not `ItemGroup itemGroupEnum`.
9. Coroutine functions use the `Coroutine` suffix to show the different execution model: `FadeCoroutine()`, not `Fade()` for an `IEnumerator`.

## Files and Unity Objects

10. Match the file name and representative definition name so IDE and IntelliSense search line up: `PlayerController.cs` contains `PlayerController`, not a different main type.
11. One file has one representative top-level definition. Split representative classes, structs, and enums by file; nested definitions are the exception.
12. Nested types are ordered `enum`, `struct`, `interface`, `class`. This matters because multiple type declarations usually appear only as nested types.
13. File names and class names are nouns. Put roles in type names and actions in function names: `PlayerMover`, not `MovePlayer`.
14. Match Unity object names and script names so inspector names and code-search names point to the same concept: prefab/script/class should align, like `InventoryPanel`.

## Words

15. A PascalCase boundary declares a semantic layer. Keep one semantic layer in one token, and split only for a real ownership, structure, relation, or role boundary: `Nickname` is one concept, while `TitleMenuButton` represents `Title -> Menu -> Button`. The dictionary does not decide the boundary; the code structure does. Apply the full decision criteria in `semantic-layer-naming-guideline.md`.
16. Avoid names that are substrings of other search keywords. Do not pair names like `MissionState` and `IntermissionState` if searching `Mission` should not catch both.
17. Plural groups currently allow `-s` and `-es`, such as `Items`, `Enemies`, and `Rewards`. Avoid type-noise suffixes such as `List`, `Array`, or `Bucket`; a better alternative is still undecided.

## Syntax and Structure

18. External lifecycle objects are read-only properties: use a get-only property when creation and ownership live outside this object; do not expose it as a mutable public field.
19. Do not repeat a type in object creation. Use `var` when a local variable's right-side expression names the type. When the declaration or assignment target already names the type, especially for class member variables and properties, use target-typed `new(arguments)` or `new()` instead of repeating the type after `new`.
20. Do not use the newer using-declaration form. Keep the existing block form: `using (...) { }`, not `using var`.
21. Put `sealed` before `override`, in access modifier, `sealed`, `override` order: `public sealed override`, not `public override sealed`.
22. Class sections are nested types, variables, properties, events, functions. Nested type order is still `enum`, `struct`, `interface`, `class`.
23. Sort alphabetically only inside the same category of the same inheritance group, after section order and the shared member order. Variables use `const` > `readonly` > `static` > inherited implementation > local instance member, properties use `static` > inherited implementation > local instance member, and functions use constructors and finalizer > `static` > inherited implementation > local instance function. Do not move parent or interface groups just to satisfy abc sorting.
24. Within each category, order variables, properties, and functions as `static` members, inherited-implementation members, then local instance members. Constructors and the finalizer precede those groups among functions; `const` and `readonly` precede them among variables. Variables and properties that support an inherited implementation belong to that parent or interface group. Do not mix static, inherited-implementation, and local groups. In an ordinary non-static object type, avoid static functions unless the behavior clearly belongs to the type itself. In a `MonoBehaviour`, treat Unity message functions as the first inherited group and implement them before explicitly inherited parent and interface members. Sort Unity messages alphabetically by function name, then use parent > child order, parents in inheritance declaration order, and multiple interfaces and implementations alphabetically.
25. Extract a function only for reuse, an independent responsibility or contract, or a clearer context boundary; otherwise keep one-off logic in its caller. Unity messages, overrides, explicit interface implementations, registered callbacks, and framework entry points are exceptions. Use a local function only for caller-local reuse, a dependent coroutine, or a long foldable block.
26. Implement interface members explicitly as `InterfaceName.MemberName`; do not expose them as public members.
27. Order member variables as `const` > `readonly` > `static` > inherited implementation > local instance; alphabetize only within the same inheritance group.
28. Prefer omitting braces from any body C# permits as a single embedded statement; keep them only for a concrete reason. Do not nest brace-free control statements: when a control statement's only body is another control statement, except for an `else if` chain, brace the outer body and omit braces only from the innermost single action. In an `if` chain, if one branch needs braces, use them for every branch.
29. Use prefix increment and decrement: `++index` and `--index`.
30. Use `!` only to toggle and assign the same Boolean; otherwise compare explicitly with `false`.
31. Do not group members by access modifier; follow rules 22-24 and 27.
32. Put each attribute on its own line above its declaration.
33. Parenthesize each comparison or compound condition joined by logical operators, recursively. Do not parenthesize a complete single Boolean term.
34. Put valid, normal, or primary-interest branches before invalid, error, or exceptional branches.
35. Before adding or changing logs, follow `logging-guideline.md`.
36. Keep declaration parameters and call arguments on one line when practical. When wrapping, put multiple items per line; only generic `where` clauses may use one clause per line.
37. Rules 37-39 control blank lines only. Use exactly one empty line at required boundaries and after `using` directives; never use consecutive or whitespace-only blank lines, or blank lines immediately inside braces.
38. At type scope, put one blank line between existing member sections, inheritance groups, nested types, and function implementations. Keep same-group members together and attributes, documentation, and leading comments attached to their declaration.
39. Inside blocks, put one blank line only between complete statement groups with different immediate purposes. Keep produced values with their immediate validation or consumer; do not put a blank line before `else` or a closing brace.
40. Inline a value used once into its call, assignment, return, or expression. Declare a local only when the value is used at least twice or C# syntax or execution semantics require storage.
