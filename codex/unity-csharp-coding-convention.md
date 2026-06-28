# Unity C# Rules for Codex

Read this before editing first-party Unity C# code. Keep the requested behavior first, then apply these rules inside the touched code unless the user asks for a broader cleanup.

## Scope

1. Apply this to first-party Unity C# files.
2. Do not restyle third-party, generated, imported vendor, sample, or `PackageCache` code for style only.
3. Existing file-local and domain-local conventions win when they are clear.
4. Runtime behavior, prefab links, serialized field compatibility, and asset references outrank naming cleanup.
5. If a convention change requires broad renames, serialized data migration, or prefab changes, stop and ask.

## Reference Priority

1. Current local project and domain conventions.
2. This file.
3. Human reference: `https://oojjrs.github.io/kr/unity/csharp-coding-convention.html`.
4. Unity C# Style.
5. Visual Studio Code Style defaults and Microsoft C# coding conventions.

## Naming

1. Interface type names use the `Interface` suffix.
   - Good: `public interface FunctionInterface { }`, `private FunctionInterface function;`
   - Bad: `public interface IFunction { }`, `private FunctionInterface functionInterface;`
2. Static member variables use two underscores.
   - Good: `public static int __Index;`, `private static int __index;`
   - Bad: `public static int Index;`, `private static int _index;`, `private static int index;`
3. `const` and `readonly` names use PascalCase.
   - Good: `private const int MaxCount = 10;`, `private readonly int StartIndex;`
   - Bad: `private const int max_count = 10;`, `private readonly int start_index;`
4. Properties use nouns or adjectives.
   - Good: `IsActive`, `HasReward`, `AsItem`
   - Bad: `Active`, `Activate`, `Reward`
5. `Can` means an action is possible. `-able` means the object has an attribute.
   - Good: `CanGather`, `Gatherable`
   - Bad: `CanGathered`, `Gather`
6. Add type postfixes to properties only when searchability improves.
   - Good: `IconSprite`, `HitEffect`, `DescriptionTooltip`
   - Bad: `Icon`, `Hit`, `Description` when those names become hard to search.
7. Function names use verbs or verb phrases.
   - Good: `GiveReward()`
   - Bad: `Reward()`
8. Enum type names use the `Enum` suffix.
   - Good: `ItemGroupEnum itemGroup;`
   - Bad: `ItemGroup itemGroupEnum;`
9. Coroutine function names use the `Coroutine` suffix.
   - Good: `FadeCoroutine()`
   - Bad: `Fade()` for an `IEnumerator` coroutine.

## Files and Unity Objects

10. Match the file name and the representative definition name.
    - Good: `PlayerController.cs` contains `public sealed class PlayerController`.
    - Bad: `Player.cs` contains `public sealed class PlayerController`.
11. One file has one representative definition.
    - Good: one top-level class with nested helper types.
    - Bad: one file with multiple top-level classes, structs, or enums.
12. Nested types are ordered `enum`, `struct`, `interface`, `class`.
    - Good: `StateEnum`, then `Entry`, then `CacheInterface`, then `Cache`.
    - Bad: nested classes before nested enums or interfaces.
13. File names and class names are nouns.
    - Good: `PlayerMover.cs`, `PlayerMover`
    - Bad: `MovePlayer.cs`, `MovePlayer`
14. Unity object names and script names should point to the same concept.
    - Good: prefab `InventoryPanel`, script `InventoryPanel.cs`, class `InventoryPanel`.
    - Bad: prefab `Inventory`, script `BagPanel.cs`, class `BagPanel`.

## Words

15. Treat conventional compounds as one word.
    - Good: `Hotkey`, `Infobox`, `Inputbox`, `Lifetime`, `Nickname`, `Filename`
    - Bad: `HotKey`, `InfoBox`, `InputBox`, `LifeTime`, `NickName`, `FileName`
16. Avoid names that are substrings of other keywords.
    - Good: `StageState`, `IntermissionState`
    - Bad: `MissionState`, `IntermissionState` when searching `Mission` should not catch both.
17. Plural groups currently allow `-s` and `-es`.
    - Good: `Items`, `Enemies`, `Rewards`
    - Bad: `ItemList`, `EnemyArray`, `RewardBucket` when the suffix is only type noise.

## Syntax and Structure

18. External lifecycle objects are read-only properties.
    - Good: `public Player Player { get; }`
    - Bad: `public Player Player;`
19. Use `var` actively when the right side makes the type clear.
    - Good: `var items = new Dictionary<string, Item>();`
    - Bad: `Dictionary<string, Item> items = new Dictionary<string, Item>();`
20. Do not use the newer using-declaration form.
    - Good: `using (var stream = File.OpenRead(path)) { }`
    - Bad: `using var stream = File.OpenRead(path);`
21. Put `sealed` before `override`.
    - Good: `public sealed override void Dispose()`
    - Bad: `public override sealed void Dispose()`
22. Class sections are variables, properties, events, functions.
    - Good: nested types first, then fields, then properties, then events, then functions.
    - Bad: public functions before fields or nested types.
23. Sort alphabetically only inside the same category of the same inheritance group.
    - Good: fields alphabetized within their own section after inherited/local grouping.
    - Bad: moving parent or interface implementation groups only to satisfy alphabetic order.
24. Implement inherited members in parent declaration order.
    - Good: base class members, then interfaces in declaration order, then local members. Constructors come first among functions.
    - Bad: local public methods before required base or interface implementation members.
25. Interface implementation is explicit by type.
    - Good: `string TooltipInterface.TooltipText => tooltipText;`, `void TooltipInterface.ShowTooltip() { }`
    - Bad: `public string TooltipText => tooltipText;`, `public void ShowTooltip() { }`
26. Member sections are `const`, `readonly`, `static`, ordinary member.
    - Good: constants first, then readonly fields, then static fields, then ordinary fields.
    - Bad: mixing ordinary fields between constants, readonly fields, and static fields.
