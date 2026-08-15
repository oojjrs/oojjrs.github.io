---
layout: page
lang: en
title: "Unity C# Coding Convention"
alternate_url: /kr/unity/csharp-coding-convention.html
category: "CONVENTION"
description: "A practical Unity C# convention for making code shape predictable and code reading fast."
permalink: /en/unity/csharp-coding-convention.html
toc_items:
  - id: core-rules
    label: "Core rules"
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

## Core rules {#core-rules}

### 01. Do not wrap semicolon-terminated statements, function declarations, or calls

Correct:

```csharp
private Dictionary<string, Item> items = new(StringComparer.Ordinal);

private void ApplyReward(int rewardCount, RewardTypeEnum rewardType, bool isBonus, Action onComplete)
{
}

private void Register<TItem, TFactory>(TItem item, TFactory factory) where TItem : Item where TFactory : ItemFactoryInterface
{
}

private void GrantReward()
{
    ApplyReward(item, rewardCount, rewardType, isBonus, onComplete);
}
```

Incorrect:

```csharp
private Dictionary<string, Item> items =
    new(StringComparer.Ordinal);

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


### 02. Omit braces from one-line simple-statement bodies

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

Incorrect:

```csharp
foreach (var enemy in enemies)
{
    enemy.Update();
}

foreach (var index in Indexes)
    if (index.CanAdd(entity, primaryKey) == false)
        return false;
```


### 03. Write one attribute per line

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

### 04. Use one completely empty blank line

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


### 05. Separate type-scope groups with blank lines

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


### 06. Use blank lines only between logical paragraphs inside blocks

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


### 07. Do not use null-conditional or null-coalescing operators on Unity objects

Correct:

```csharp
private void ResetTarget(Transform target)
{
    if (target != null)
        target.SetPositionAndRotation(Vector3.zero, Quaternion.identity);
}

private Transform SelectTarget(Transform target, Transform fallback)
{
    if (target != null)
        return target;

    return fallback;
}

private void SetTargetFallback(Transform fallback)
{
    if (_target == null)
        _target = fallback;
}
```

Incorrect:

```csharp
private void ResetTarget(Transform target)
{
    target?.SetPositionAndRotation(Vector3.zero, Quaternion.identity);
}

private Transform SelectTarget(Transform target, Transform fallback)
{
    return target ?? fallback;
}

private void SetTargetFallback(Transform fallback)
{
    _target ??= fallback;
}
```


## Naming {#naming}

### 08. Interfaces use the `Interface` suffix

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


### 09. Static-field prefixes depend on the immediate declaring type

Correct naming:

```csharp
public sealed class Cache
{
    public static int __Capacity;
    private static int __index;
}

public static class CacheRegistry
{
    public static int _Capacity;
    private static int _index;
}
```

Incorrect naming:

```csharp
public sealed class Cache
{
    public static int _Capacity;
    private static int _index;
}

public static class CacheRegistry
{
    public static int __Capacity;
    private static int __index;
}
```


### 10. `const` and `readonly` use PascalCase

Correct:

```csharp
private const int MaxCount = 10;
private static readonly int InitialCapacity = 16;
private readonly int StartIndex;
```

Incorrect:

```csharp
private const int max_count = 10;
private readonly int start_index;
private static readonly int __initialCapacity = 16;
private static readonly int _initialCapacity = 16;
```


### 11. Properties are nouns or adjectives

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


### 12. Distinguish `Can` from `-able`

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


### 13. Add type postfixes to properties when searchability matters

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


### 14. Functions use verbs or verb phrases

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


### 15. Enum types use the `Enum` suffix

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


### 16. Coroutine functions use the `Coroutine` suffix

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


## Files and Unity objects {#files-unity-objects}

### 17. Match the file name and the representative definition name

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


### 18. One file has one representative definition

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


### 19. Nested types are ordered enum, struct, interface, class

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


### 20. File names and class names are nouns

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


### 21. Match Unity object names and script names

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


## Words {#words}

### 22. PascalCase boundaries represent semantic layers

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


### 23. Avoid names that are substrings of other keywords

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


### 24. Plural groups currently allow `-s` and `-es`

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


## Syntax and structure {#syntax-structure}

### 25. External lifecycle objects are read-only properties

Correct:

```csharp
public Player Player { get; }
```

Incorrect:

```csharp
public Player Player;
```


### 26. Do not repeat types in object creation

Correct:

```csharp
public sealed class Inventory
{
    private Dictionary<string, Item> items = new(StringComparer.Ordinal);

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
    private Dictionary<string, Item> items = new Dictionary<string, Item>(StringComparer.Ordinal);

    public List<Item> Items { get; } = new List<Item>();

    private void Refresh()
    {
        List<Reward> rewards = new List<Reward>();
    }
}
```


### 27. Use `using (...)`; omit braces for one-line simple bodies and require them otherwise

Use the `using (...)` statement form instead of a using declaration. A one-line, semicolon-terminated simple-statement body omits braces; every other body uses braces. In nested `using` statements, each outer `using` whose body is another `using` uses braces; the innermost `using` omits them when its body meets the one-line rule.

Correct:

```csharp
using (var stream = File.OpenRead(path))
    Process(stream);

using (var input = File.OpenRead(sourcePath))
{
    using (var output = File.Create(destinationPath))
        input.CopyTo(output);
}
```

Incorrect:

```csharp
using var stream = File.OpenRead(path);

using (var input = File.OpenRead(sourcePath))
using (var output = File.Create(destinationPath))
{
    input.CopyTo(output);
}

using (var input = File.OpenRead(sourcePath))
{
    using (var output = File.Create(destinationPath))
    {
        input.CopyTo(output);
    }
}
```


### 28. Put `sealed` before `override`

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


### 29. Class sections are variables, properties, events, functions

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


### 30. Sort inside each category alphabetically

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


### 31. Order variables, properties, and functions as static, inherited, then local

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



### 32. Do not create unnecessary functions

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


### 33. Interface implementation is explicit by type

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

### 34. Member-variable sections are const, readonly, static, member

Correct:

```csharp
public sealed class Cache
{
    private const int MaxCount = 10;

    private readonly int StartIndex;

    private static int __cacheCount;
    private static int __index;

    private int count;
    private int index;
}
```

Incorrect:

```csharp
public sealed class Cache
{
    private const int MaxCount = 10;
    private int index;
    private readonly int StartIndex;
    private static int __cacheCount;
    private int count;
}
```


### 35. Use prefix increment and decrement operators

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

### 36. Use logical negation only for Boolean toggle assignments

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


### 37. Do not sort members by access modifier

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


### 38. Wrap comparisons, but not complete single-term conditions

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


### 39. Put the valid and primary-interest branch first

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
