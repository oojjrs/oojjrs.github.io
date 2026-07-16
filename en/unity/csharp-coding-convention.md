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

### 15. Conventional compounds are treated as one word

Correct:

```text
Hotkey
Infobox
Inputbox
Lifetime
Nickname
Filename
```

Incorrect:

```text
HotKey
InfoBox
InputBox
LifeTime
NickName
FileName
```

Follow platform or third-party conventions when they exist, but treat new names as one word.

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

### 19. Use `var` actively

Correct:

```csharp
var items = new Dictionary<string, Item>();
```

Incorrect:

```csharp
Dictionary<string, Item> items =
    new Dictionary<string, Item>();
```

Use `var` when the type is clear from the expression on the right.

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

Alphabetical order applies only inside the same category of the same inheritance group, after section order, inheritance implementation order, and constructor priority. Do not mix parent or interface implementation groups just to satisfy alphabetical order.

### 24. Implement inherited members in parent declaration order

Correct:

```csharp
public sealed class RewardButton : ButtonBase, ClickableInterface, TooltipInterface
{
    private int buttonIndex;
    private int clickableCount;
    private int tooltipCount;
    private int rewardCount;

    public bool IsButtonActive { get; }
    public bool IsClickable { get; }
    public string TooltipText { get; }
    public int RewardCount { get; }

    public RewardButton()
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
    private int tooltipCount;
    private int buttonIndex;

    public int RewardCount { get; }
    public string TooltipText { get; }

    public void GiveReward()
    {
    }

    public void ShowTooltip()
    {
    }

    protected override void RefreshButton()
    {
    }

    public RewardButton()
    {
    }
}
```

Use parent > child order. Among parents, follow the inheritance declaration order. Multiple interfaces and their implementations are ordered alphabetically. Constructors come first among functions.

### 25. Interface implementation is explicit by type

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

Do not expose interface members as public members. Implement them as `InterfaceName.MemberName`.

### 26. Member sections are const, readonly, static, member

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

`const`, `readonly`, `static`, and ordinary members are separate sections. Sort alphabetically inside each section.

### 27. Keep brace usage consistent within a control-flow chain

Correct:

```csharp
if (isReady)
    StartGame();
else if (canRetry)
    RetryGame();
else
    CancelGame();
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
if (isReady)
    StartGame();
else if (canRetry)
{
    ResetGame();
    RetryGame();
}
else
    CancelGame();
```

Prefer omitting braces when every branch is a single statement. If any `if`, `else if`, or `else` branch needs braces, use braces for every branch in that chain.

### 28. Use prefix increment and decrement operators

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

Put increment and decrement operators before the operand. Do not use postfix forms.

### 29. Use logical negation only for Boolean toggle assignments

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

Use the logical negation operator `!` only when toggling a Boolean value and assigning it back to the same value. In every other case, including conditions and return expressions, use an explicit comparison such as `== false`.