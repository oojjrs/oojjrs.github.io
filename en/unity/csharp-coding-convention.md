---
layout: page
lang: en
title: "Unity C# Coding Convention"
alternate_url: /kr/unity/csharp-coding-convention.html
category: "CONVENTION"
description: "A practical Unity C# convention for making code shape predictable and code reading fast."
permalink: /en/unity/csharp-coding-convention.html
toc_items:
  - id: naming
    label: "Naming"
  - id: files-unity-objects
    label: "Files and Unity objects"
  - id: words
    label: "Words"
  - id: syntax-structure
    label: "Syntax and structure"
---

[← Unity]({{ "/en/unity/" | relative_url }}) · [한국어]({{ "/kr/unity/csharp-coding-convention.html" | relative_url }})
{: .article-backlink }

This convention exists to make the shape of Unity C# code predictable.
{: .article-lead }

**Purpose**

- Reduce the time spent deciding how code should look as close to zero as possible.
- Make code analysis approach zero cost as domain familiarity increases.

**Method**

- Use IDE and standard-tool defaults as much as possible.
- Keep manual coding decisions simple.
- Keep contextual information consistent, such as verbs for functions and nouns for variables.
- Apply the same standard to AI output so final review and manual coding use one rule set.

Third-party code is not subject to this convention. In an existing domain, the established local rules always take priority.
{: .article-principle }

**Priority**

1. This document
2. [Unity C# Style](https://unity.com/how-to/naming-and-code-style-tips-c-scripting-unity)
3. [Visual Studio Code Style default options](https://learn.microsoft.com/en-us/visualstudio/ide/code-styles-and-code-cleanup?view=vs-2022) and [C# Coding Conventions](https://docs.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)

Conventions not mentioned here follow Unity standards and Visual Studio Code Style defaults.

## Naming {#naming}

### 01. Interfaces use the `Interface` suffix

Correct:

```csharp
public interface FunctionInterface
{
}

private FunctionInterface function;
```

Incorrect:

```csharp
public interface IFunction
{
}

private FunctionInterface functionInterface;
```

Keep the interface marker only in the type name.

### 02. Static member variables use two underscores

Correct:

```csharp
public static int __Index;
private static int __index;
```

Incorrect:

```csharp
public static int Index;
private static int _index;
private static int index;
```

Use `__PascalCase` for public static fields and `__camelCase` for private static fields.

### 03. `const` and `readonly` use PascalCase

Correct:

```csharp
private const int MaxCount = 10;
private readonly int StartIndex;
```

Incorrect:

```csharp
private const int max_count = 10;
private readonly int start_index;
```

Constant-like members should read like type or property names.

### 04. Properties are nouns or adjectives

Correct:

```csharp
public bool IsActive { get; }
public bool HasReward { get; }
public Item AsItem { get; }
```

Incorrect:

```csharp
public bool Active { get; }
public bool Activate { get; }
public bool Reward { get; }
```

Boolean properties that ask a question should collect under prefixes such as `Is` and `Has` in IDE search.

### 05. Distinguish `Can` from `-able`

Correct:

```csharp
public bool CanGather { get; }
public bool Gatherable { get; }
```

Incorrect:

```csharp
public bool CanGathered { get; }
public bool Gather { get; }
```

`CanGather` describes an action the object can perform. `Gatherable` describes an attribute the object has.

### 06. Add type postfixes to properties when searchability matters

Correct:

```csharp
public Sprite IconSprite { get; }
public GameObject HitEffect { get; }
public string DescriptionTooltip { get; }
```

Incorrect:

```csharp
public Sprite Icon { get; }
public GameObject Hit { get; }
public string Description { get; }
```

Use postfixes such as `String`, `Sprite`, `Prefab`, `Effect`, and `Tooltip` only when they improve search filtering.

### 07. Functions use verbs or verb phrases

Correct:

```csharp
public void GiveReward()
{
}
```

Incorrect:

```csharp
public void Reward()
{
}
```

The action should be visible from the function name.

### 08. Enum types use the `Enum` suffix

Correct:

```csharp
public enum ItemGroupEnum
{
}

private ItemGroupEnum itemGroup;
```

Incorrect:

```csharp
public enum ItemGroup
{
}

private ItemGroup itemGroupEnum;
```

Do not repeat `Enum` in the variable name.

### 09. Coroutine functions use the `Coroutine` suffix

Correct:

```csharp
private IEnumerator FadeCoroutine()
{
    yield return null;
}
```

Incorrect:

```csharp
private IEnumerator Fade()
{
    yield return null;
}
```

The name should distinguish functions with a different execution model.

## Files and Unity objects {#files-unity-objects}

### 10. Match the file name and the representative definition name

Correct:

```csharp
// File: PlayerController.cs
public sealed class PlayerController
{
}
```

Incorrect:

```csharp
// File: Player.cs
public sealed class PlayerController
{
}
```

The file and type should be easy to find through IDE and IntelliSense.

### 11. One file has one representative definition

Correct:

```csharp
// File: PlayerController.cs
public sealed class PlayerController
{
    private enum StateEnum
    {
    }
}
```

Incorrect:

```csharp
// File: PlayerController.cs
public sealed class PlayerController
{
}

public struct PlayerState
{
}

public enum PlayerModeEnum
{
}
```

Representative definitions such as class, struct, and enum should be split by file. Nested definitions are the exception.

### 12. Nested types are ordered enum, struct, interface, class

Correct:

```csharp
public sealed class PlayerController
{
    private enum StateEnum
    {
    }

    private struct Entry
    {
    }

    private interface CacheInterface
    {
    }

    private sealed class Cache
    {
    }
}
```

Incorrect:

```csharp
public sealed class PlayerController
{
    private sealed class Cache
    {
    }

    private interface CacheInterface
    {
    }

    private enum StateEnum
    {
    }

    private struct Entry
    {
    }
}
```

Because one file normally has one representative definition, multiple type declarations usually appear only as nested types. Nested type order is `enum > struct > interface > class`.

### 13. File names and class names are nouns

Correct:

```csharp
// File: PlayerMover.cs
public sealed class PlayerMover
{
}
```

Incorrect:

```csharp
// File: MovePlayer.cs
public sealed class MovePlayer
{
}
```

Put roles in type names and actions in function names.

### 14. Match Unity object names and script names

Correct:

```text
Prefab: InventoryPanel
Script: InventoryPanel.cs
Class: InventoryPanel
```

Incorrect:

```text
Prefab: Inventory
Script: BagPanel.cs
Class: BagPanel
```

Inspector names and code-search names should point to the same concept.

## Words {#words}

### 15. PascalCase boundaries represent semantic layers

Correct:

```text
Nickname
TitleMenuButton
LobbyRoomListEntryHostText
```

Incorrect:

```text
NickName
TitlemenuButton
LifeTime
```

Keep one semantic layer in one token. A new uppercase boundary does not merely separate spelling; it declares one more ownership, structure, relation, or role layer. `Nickname` is one concept, while `TitleMenuButton` represents a real `Title -> Menu -> Button` structure. Let the code structure, not the dictionary, decide the boundary. See [Semantic Layer Naming]({{ "/en/csharp/semantic-layer-naming/" | relative_url }}) for the full decision criteria.

### 16. Avoid names that are substrings of other keywords

Correct:

```text
StageState
IntermissionState
```

Incorrect:

```text
MissionState
IntermissionState
```

`Mission` appears inside `Intermission`, so searching for `Mission` catches unintended results.

### 17. Plural groups currently allow `-s` and `-es`

Correct:

```text
Items
Enemies
Rewards
```

Incorrect:

```text
ItemList
EnemyArray
RewardBucket
```

`List` and `Array` can read like Hungarian notation. A better alternative is still undecided.

## Syntax and structure {#syntax-structure}

### 18. External lifecycle objects are read-only properties

Correct:

```csharp
public Player Player { get; }
```

Incorrect:

```csharp
public Player Player;
```

If creation and ownership live outside this object, close the setter.

### 19. Do not repeat types in object creation

Correct:

```csharp
public sealed class Inventory
{
    private Dictionary<string, Item> items =
        new(StringComparer.Ordinal);

    public List<Item> Items { get; } = new();

    private void Refresh()
    {
        var rewards = new List<Reward>();
    }
}
```

Incorrect:

```csharp
public sealed class Inventory
{
    private Dictionary<string, Item> items =
        new Dictionary<string, Item>(StringComparer.Ordinal);

    public List<Item> Items { get; } = new List<Item>();

    private void Refresh()
    {
        List<Reward> rewards = new List<Reward>();
    }
}
```

Use `var` when a local variable's right-side creation expression names the type. When the declaration or assignment target already names the type, especially for class fields and properties, use target-typed `new(arguments)` or `new()`. Do not repeat the same construction type on both sides.

### 20. Do not use the newer using-declaration form

Correct:

```csharp
using (var stream = File.OpenRead(path))
{
}
```

Incorrect:

```csharp
using var stream = File.OpenRead(path);
```

Keep the existing `using` block form.

### 21. Put `sealed` before `override`

Correct:

```csharp
public sealed override void Dispose()
{
}
```

Incorrect:

```csharp
public override sealed void Dispose()
{
}
```

Read the declaration in access modifier, `sealed`, `override` order.

### 22. Class sections are variables, properties, events, functions

Correct:

```csharp
private enum StateEnum { }
private struct Entry { }
private interface CacheInterface { }
private sealed class Cache { }
private const int MaxCount = 10;
public int Count { get; }
public event Action Changed;
public void Refresh() { }
```

Incorrect:

```csharp
public void Refresh() { }
public int Count { get; }
private enum StateEnum { }
```

After inner enum, inner struct, inner interface, and inner class, use variables > properties > events > functions.

### 23. Sort inside each category alphabetically

Correct:

```csharp
private int alphaCount;
private int betaCount;
private int rewardCount;

public bool IsActive { get; }
public int RewardCount { get; }
public string TooltipText { get; }

public event Action Changed;
public event Action Selected;

public void ApplyReward()
{
}

public void RefreshTooltip()
{
}
```

Incorrect:

```csharp
private int rewardCount;
private int alphaCount;
public void ApplyReward()
{
}
public bool IsActive { get; }
public event Action Selected;
public string TooltipText { get; }
public event Action Changed;
public void RefreshTooltip()
{
}
```

Alphabetical order applies only inside the same category of the same inheritance group, after section order and the shared member order. Variables use `const` > `readonly` > `static` > inherited implementation > local instance member, properties use `static` > inherited implementation > local instance member, and functions use constructors and finalizer > `static` > inherited implementation > local instance function. Do not mix parent or interface implementation groups just to satisfy alphabetical order.

### 24. Order variables, properties, and functions as static, inherited, then local

Correct:

```csharp
public sealed class RewardButton : ButtonBase, ClickableInterface, TooltipInterface
{
    private static int __rewardTypeCount;

    private int buttonIndex;
    private int clickableCount;
    private int tooltipCount;
    private int rewardCount;

    public static int RewardTypeCount { get; }

    public bool IsButtonActive { get; }
    public bool IsClickable { get; }
    public string TooltipText { get; }
    public int RewardCount { get; }

    private static void RegisterRewardType()
    {
    }

    private void Awake()
    {
    }

    private void OnDestroy()
    {
    }

    private void OnEnable()
    {
    }

    private void Start()
    {
    }

    protected override void RefreshButton()
    {
    }

    void ClickableInterface.Click()
    {
    }

    void TooltipInterface.ShowTooltip()
    {
    }

    public void GiveReward()
    {
    }
}
```

Incorrect:

```csharp
public sealed class RewardButton : ButtonBase, TooltipInterface, ClickableInterface
{
    private int rewardCount;
    private static int __rewardTypeCount;
    private int tooltipCount;
    private int buttonIndex;

    public int RewardCount { get; }
    public static int RewardTypeCount { get; }
    public string TooltipText { get; }

    public void GiveReward()
    {
    }

    private static void RegisterRewardType()
    {
    }

    public void ShowTooltip()
    {
    }

    private void Awake()
    {
    }

    protected override void RefreshButton()
    {
    }
}
```

Within each category, order variables, properties, and functions as static members, inherited-implementation members, then local instance members. Constructors and the finalizer precede those groups among functions; `const` and `readonly` precede them among variables. Variables and properties that support an inherited implementation belong to that parent or interface group. Do not mix static, inherited-implementation, and local groups. In an ordinary non-static object type, avoid static functions unless the behavior clearly belongs to the type itself. In a `MonoBehaviour`, Unity message functions are treated like the first inherited group. Put them before explicitly inherited parent and interface members, and sort them alphabetically by function name, such as `Awake`, `OnDestroy`, `OnEnable`, and `Start`. Do not order them by the Unity lifecycle. After that, use parent > child order. Among explicit parents, follow the inheritance declaration order. Multiple interfaces and their implementations are ordered alphabetically.

### 25. Do not create unnecessary functions

Correct:

```csharp
private void ApplyReward()
{
    rewardCount += bonusCount;
    RefreshTooltip();
}
```

Incorrect:

```csharp
private void AddBonus()
{
    rewardCount += bonusCount;
}

private void ApplyReward()
{
    AddBonus();
    RefreshTooltip();
}
```

Keep one-off logic in its caller unless extraction creates reuse, an independent responsibility or contract, or a clearer context boundary. Unity messages, overrides, explicit interface implementations, registered callbacks, and framework entry points are exceptions. Use a local function only for caller-local reuse, a dependent coroutine, or a long foldable block.

### 26. Interface implementation is explicit by type

Correct:

```csharp
public sealed class TooltipButton : TooltipInterface
{
    string TooltipInterface.TooltipText => tooltipText;

    void TooltipInterface.ShowTooltip()
    {
    }
}
```

Incorrect:

```csharp
public sealed class TooltipButton : TooltipInterface
{
    public string TooltipText => tooltipText;

    public void ShowTooltip()
    {
    }
}
```

### 27. Member-variable sections are const, readonly, static, member

Correct:

```csharp
private const int MaxCount = 10;

private readonly int StartIndex;

private static int __cacheCount;
private static int __index;

private int count;
private int index;
```

Incorrect:

```csharp
private const int MaxCount = 10;
private int index;
private readonly int StartIndex;
private static int __cacheCount;
private int count;
```

Treat `const`, `readonly`, `static`, and ordinary variables as separate sections. Order ordinary variables by rule 24 and alphabetize only within the same inheritance group.

### 28. Strongly prefer omitting braces from single embedded-statement bodies

Correct:

```csharp
if (isReady)
    StartGame();
else if (canRetry)
    RetryGame();
else
    CancelGame();

foreach (var enemy in enemies)
    enemy.Update();

foreach (var index in Indexes)
{
    if (index.CanAdd(entity, primaryKey) == false)
        return false;
}
```

Also correct when any branch needs multiple statements:

```csharp
if (isReady)
{
    StartGame();
}
else if (canRetry)
{
    ResetGame();
    RetryGame();
}
else
{
    CancelGame();
}
```

Incorrect without a concrete reason:

```csharp
foreach (var enemy in enemies)
{
    enemy.Update();
}

foreach (var index in Indexes)
    if (index.CanAdd(entity, primaryKey) == false)
        return false;
```

Omit braces from any single embedded-statement body unless there is a concrete reason to keep them. Do not nest brace-free control statements: when a control statement's only body is another control statement, except for an `else if` chain, put braces around the outer body and omit braces only from the innermost single action. If one branch in an `if` chain needs braces, use braces for every branch.

### 29. Use prefix increment and decrement operators

Correct:

```csharp
++index;
--index;
```

Incorrect:

```csharp
index++;
index--;
```

### 30. Use logical negation only for Boolean toggle assignments

Correct:

```csharp
isActive = !isActive;

if (isActive == false)
    Activate();
```

Incorrect:

```csharp
if (!isActive)
    Activate();

return !isActive;
```

Use `!` only when assigning a Boolean toggle back to the same value; otherwise compare explicitly with `== false`.

### 31. Do not sort members by access modifier

Correct:

```csharp
public int AlphaCount { get; }
private int BetaCount { get; }
protected int EnemyCount { get; }
private int ItemCount { get; }
public int RewardCount { get; }
protected int StageCount { get; }
```

Incorrect:

```csharp
public int AlphaCount { get; }
public int RewardCount { get; }
protected int EnemyCount { get; }
protected int StageCount { get; }
private int BetaCount { get; }
private int ItemCount { get; }
```

Access modifiers do not affect member order. Follow rules 22-24 and 27.

### 32. Write one attribute per line

Correct:

```csharp
[Header("Settings")]
[SerializeField]
private int count;
```

Incorrect:

```csharp
[Header("Settings"), SerializeField]
private int count;

[SerializeField] private int index;
```

### 33. Wrap comparisons, but not complete single-term conditions

Correct:

```csharp
if (isReady && (item != null))
    Use(item);

if (CanStart() || ((count > 0) && (item != null)))
    Start();
```

Incorrect:

```csharp
if ((isReady) && (item != null))
    Use(item);

if (CanStart() || count > 0 && item != null)
    Start();
```

Parenthesize every comparison or nested compound operand joined by logical operators. Do not wrap standalone Boolean variables, properties, or calls.

### 34. Put the valid and primary-interest branch first

Correct:

```csharp
if (item != null)
    Use(item);
else
    ReportMissingItem();
```

Incorrect:

```csharp
if (item == null)
    ReportMissingItem();
else
    Use(item);
```

### 35. Follow the logging guideline

Before adding or changing logs, follow `logging-guideline.md`.

### 36. Do not put one function parameter or call argument per line

Correct:

```csharp
private void ApplyReward(
    int rewardCount, RewardTypeEnum rewardType,
    bool isBonus, Action onComplete)
{
}

private void Register<TItem, TFactory>(TItem item, TFactory factory)
    where TItem : Item
    where TFactory : ItemFactoryInterface
{
}

private void GrantReward()
{
    ApplyReward(
        item, rewardCount, rewardType,
        isBonus, onComplete);
}
```

Incorrect:

```csharp
private void ApplyReward(
    int rewardCount,
    RewardTypeEnum rewardType,
    bool isBonus,
    Action onComplete)
{
}

private void GrantReward()
{
    ApplyReward(
        item,
        rewardCount,
        rewardType,
        isBonus,
        onComplete);
}
```

Keep declaration parameters and call arguments on one line when practical. When wrapping, keep multiple items per line. Only generic `where` clauses may be placed one per line.

### 37. Use one completely empty blank line

Correct:

```csharp
private void Run()
{
    Prepare();

    Execute();
}
```

Incorrect:

```csharp
private void Run()
{

    Prepare();


    Execute();

}
```

Use exactly one empty line where separation is required. Do not use consecutive or whitespace-only blank lines, or a blank line directly inside braces. Put one blank line after `using` directives.

### 38. Separate type-scope groups with blank lines

Correct:

```csharp
[SerializeField]
private int _count;
private bool _ready;

public int Count => _count;

// Execution entry point.
public void Run()
{
}

public void Stop()
{
}
```

Incorrect:

```csharp
[SerializeField]

private int _count;
private bool _ready;
public int Count => _count;
public void Run()
{
}
```

At type scope, put one blank line between member sections, inheritance groups, nested types, and function implementations. Keep declarations in the same group together, and keep attributes, documentation, and leading comments attached to their declaration.

### 39. Use blank lines only between logical paragraphs inside blocks

Correct:

```csharp
private IEnumerator RunCoroutine()
{
    var item = Select();
    item.Prepare();

    yield return item.RunCoroutine();

    OnCompleted?.Invoke(item);
}
```

Incorrect:

```csharp
private IEnumerator RunCoroutine()
{
    var item = Select();

    item.Prepare();
    yield return item.RunCoroutine();
    OnCompleted?.Invoke(item);
}
```

Inside blocks, use blank lines only between complete statement groups with different purposes. Keep a produced value with its immediate validation or consumer, and do not put a blank line before `else` or a closing brace.

### 40. Inline values that a local variable would use only once

Correct:

```csharp
private int Run(Player player)
{
    Apply(FindItem());

    return CalculateScore(player);
}

private void ApplyAndLog()
{
    var item = FindItem();
    Apply(item);
    Log(item);
}
```

Incorrect:

```csharp
private int Run(Player player)
{
    var item = FindItem();
    Apply(item);

    var score = CalculateScore(player);
    return score;
}
```

Inline a value used only once. Declare a local only when the same value is used at least twice or C# syntax or execution semantics require storage.
