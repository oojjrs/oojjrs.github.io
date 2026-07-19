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

15. Treat conventional compounds as one word: `Hotkey`, `Infobox`, `Inputbox`, `Lifetime`, `Nickname`, `Filename`. Follow platform or third-party conventions when they exist, but treat new names as one word.
16. Avoid names that are substrings of other search keywords. Do not pair names like `MissionState` and `IntermissionState` if searching `Mission` should not catch both.
17. Plural groups currently allow `-s` and `-es`, such as `Items`, `Enemies`, and `Rewards`. Avoid type-noise suffixes such as `List`, `Array`, or `Bucket`; a better alternative is still undecided.

## Syntax and Structure

18. External lifecycle objects are read-only properties: use a get-only property when creation and ownership live outside this object; do not expose it as a mutable public field.
19. Use `var` actively when the right side makes the type clear; do not repeat obvious generic types on both sides.
20. Do not use the newer using-declaration form. Keep the existing block form: `using (...) { }`, not `using var`.
21. Put `sealed` before `override`, in access modifier, `sealed`, `override` order: `public sealed override`, not `public override sealed`.
22. Class sections are nested types, variables, properties, events, functions. Nested type order is still `enum`, `struct`, `interface`, `class`.
23. Sort alphabetically only inside the same category of the same inheritance group, after section order and the function order of constructors and finalizer > static functions > inherited implementations > local instance functions. Do not move parent or interface groups just to satisfy abc sorting.
24. Function order is constructors, finalizer, static functions, inherited implementations, then local instance functions. Do not mix static and instance functions. In an ordinary non-static object type, avoid static functions unless the behavior clearly belongs to the type itself. In a `MonoBehaviour`, treat Unity message functions as the first inherited group and implement them before explicitly inherited parent and interface members. Sort Unity messages alphabetically by function name, then use parent > child order, parents in inheritance declaration order, and multiple interfaces and implementations alphabetically.
25. Do not create unnecessary functions. A single call site alone does not make a function unnecessary. A function called from only one place is unnecessary when extraction creates no reuse, independent responsibility, contract, or clearer context boundary and only scatters related context across the file. Keep that logic in its caller. Unity messages, overrides, explicit interface implementations, registered callbacks, and framework entry points remain member functions regardless of direct call count. `private` limits external access but does not by itself justify class-wide scope; in long components, do not move one-off helper logic away from its caller without a clear benefit. Local functions are also exceptional: use them mainly for a dependent coroutine subflow, a very long block that benefits from folding, or logic called multiple times by one outer function but nowhere else. Use a member function when multiple members share the logic or it owns an independent responsibility.
26. Interface implementation is explicit by type. Do not expose interface members as public members; implement them as `InterfaceName.MemberName`, such as `TooltipInterface.TooltipText`.
27. Member-variable sections are `const`, `readonly`, `static`, ordinary member. Sort alphabetically inside each section and do not mix ordinary fields between those sections. Function ordering follows rule 24.
28. Keep braces consistent across the branches of the same control-flow chain. Prefer omitting braces when every branch is a single statement; if any `if`, `else if`, or `else` branch needs braces, use braces for every branch in that chain.
29. Use increment and decrement operators in prefix form: `++index` and `--index`, not `index++` or `index--`.
30. Use the logical negation operator `!` only to toggle and assign the same Boolean value, such as `isActive = !isActive;`. In every other case, including conditions, use an explicit comparison such as `if (isActive == false)` instead of `if (!isActive)`.
31. Do not sort or group members by access modifier. Access level does not affect member ordering; follow section order, the function order in rule 24, inheritance implementation order, and alphabetical rules without creating `public`, `protected`, or `private` groups.
32. Write each attribute on its own line, and put the attributed declaration on the following line. Do not combine multiple attributes on one line or place an attribute and its declaration on the same line.
33. When two or more individual conditions are joined by logical operators, wrap every individual condition in parentheses regardless of operator precedence: write `if ((count > 0) && (item != null))`, not `if (count > 0 && item != null)`. A nested compound condition counts as one condition at the outer level, so its internal conditions follow the same rule recursively.
34. In an `if` chain, put the valid, normal, or primary-interest case first and move the invalid, error, or exceptional case later. Choose branch order by what a human reader needs to understand first: write `if (item != null)` before its `else`, not `if (item == null)` first when the main behavior uses the item.
35. Before adding or changing logs, read `logging-guideline.md` and classify each message as a required system log, warning, debugging log, or optional UX LOG. The logging guideline controls language, uppercase text, identifier references, stability, and channel-specific behavior.
