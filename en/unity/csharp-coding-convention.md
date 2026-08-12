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

First-party Unity C# only. Local rules take priority; generated, third-party, vendor, sample, and `PackageCache` code are excluded.

{: .article-principle }

## Core rules {#core-rules}

### 01. Do not wrap semicolon-terminated statements, function declarations, or calls

New/edited statements through `;`, declaration headers including parameters/`where`, and call arguments stay on one physical line regardless of length. Preserve user wraps unless asked.

Correct:

```csharp
ApplyReward(item, count);
```

Incorrect:

```csharp
ApplyReward(
    item, count);
```

### 02. Strongly prefer omitting braces from single embedded-statement bodies

Single body: no braces. Nested control-only body: brace outer except `else if`. One braced `if` branch: brace all.

Correct:

```csharp
if (ready)
    Start();
```

Incorrect:

```csharp
if (ready)
{
    Start();
}
```

### 03. Write one attribute per line

One attribute per line directly above its declaration.

### 04. Use one completely empty blank line

One empty line at required boundaries and after `using`; never consecutive, whitespace-only, or directly inside braces.

### 05. Separate type-scope groups with blank lines

Type scope: one line between member sections, inheritance groups, nested types, functions. Keep groups and attached metadata together.

### 06. Use blank lines only between logical paragraphs inside blocks

Blocks: separate only complete purpose groups. Keep values with immediate validation/use; no line before `else` or `}`.

### 07. Do not use null-conditional or null-coalescing operators on Unity objects

`UnityEngine.Object`: never `?.`/`??`/`??=`; use Unity checks and explicit fallbacks. Recover hidden Unity objects first. Managed references, nullable, `?:`, delegates/events exempt.

Correct:

```csharp
if (target != null)
    target.Reset();
```

Incorrect:

```csharp
target?.Reset();
```

## Naming {#naming}

### 08. Interfaces use the `Interface` suffix

Interface: type suffix `Interface`; variable no marker.

### 09. Static-field prefixes depend on the immediate declaring type

Static field except `const`/`readonly`: non-static type public `__PascalCase`/private `__camelCase`; static class public `_PascalCase`/private `_camelCase`. Judge immediate type.

Correct:

```csharp
public static int __Count;
private static int __count;
```

Incorrect:

```csharp
public static int _Count;
private static int _count;
```

### 10. `const` and `readonly` use PascalCase

`const`/`readonly`: unprefixed PascalCase; mutable `static readonly` also follows 31.

### 11. Properties are nouns or adjectives

Property: noun/adjective; Boolean question `Is`/`Has`, not action.

### 12. Distinguish `Can` from `-able`

`CanX`: ability to act; `Xable`: attribute.

### 13. Add type postfixes to properties when searchability matters

Property type postfix only when search improves (`String`, `Sprite`, `Prefab`, `Effect`, `Tooltip`).

### 14. Functions use verbs or verb phrases

### 15. Enum types use the `Enum` suffix

Enum: type suffix `Enum`; variable no repeated suffix.

### 16. Coroutine functions use the `Coroutine` suffix

## Files and Unity objects {#files-unity-objects}

### 17. Match the file name and the representative definition name

### 18. One file has one representative definition

One main top-level class/struct/enum per file; nested types exempt.

### 19. Nested types are ordered enum, struct, interface, class

### 20. File names and class names are nouns

File/class: role noun; function carries action.

### 21. Match Unity object names and script names

## Words {#words}

### 22. PascalCase boundaries represent semantic layers

Business logic: one semantic layer per PascalCase token; split only for ownership/structure/relation/role. Exclude engine/library/low-level; see `semantic-layer-naming-guideline.md`.

### 23. Avoid names that are substrings of other keywords

### 24. Plural groups currently allow `-s` and `-es`

Groups: plural `-s`/`-es`; avoid type-noise `List`/`Array`/`Bucket`.

## Syntax and structure {#syntax-structure}

### 25. External lifecycle objects are read-only properties

### 26. Do not repeat types in object creation

Do not repeat a construction type: initializer names it -> `var`; target names it -> `new(...)`/`new()`.

Correct:

```csharp
Item item = new();
```

Incorrect:

```csharp
Item item = new Item();
```

### 27. Do not use the newer using-declaration form

### 28. Put `sealed` before `override`

### 29. Class sections are variables, properties, events, functions

Sections: nested types > variables > properties > events > functions.

### 30. Sort inside each category alphabetically

After 29/31/34, alphabetize only within one category/inheritance group; never mix groups.

### 31. Order variables, properties, and functions as static, inherited, then local

Groups: static > inherited > local; constructors/finalizer first. Supporting fields/properties stay in inherited group. `MonoBehaviour`: Unity messages alphabetical > parents declaration order > interfaces alphabetical > local. Static only if type-owned; define lifetime/reset/cleanup/concurrency. `Instance`/`Current`/service access = debt.

Correct:

```csharp
private static void ResetAll() { }
protected override void Refresh() { }
private void Run() { }
```

Incorrect:

```csharp
private void Run() { }
protected override void Refresh() { }
private static void ResetAll() { }
```

### 32. Do not create unnecessary functions

Extract only for reuse, independent responsibility/contract, or clearer boundary. Entry points/overrides/explicit interfaces/callbacks exempt. Local function only for caller-local reuse, dependent coroutine, or long foldable block.

### 33. Interface implementation is explicit by type

Interfaces: explicit `InterfaceName.MemberName` implementation.

### 34. Member-variable sections are const, readonly, static, member

Variables: `const` > `readonly` > `static` > inherited > local; alphabetize only within group.

### 35. Use prefix increment and decrement operators

### 36. Use logical negation only for Boolean toggle assignments

`!` only for toggle reassignment; otherwise compare with `false`.

### 37. Do not sort members by access modifier

Never group/order by access; follow 29-31/34.

### 38. Wrap comparisons, but not complete single-term conditions

Logical expression: parenthesize comparisons/nested compound operands, not standalone Boolean terms.

Correct:

```csharp
if ((count > 0) && ready)
```

Incorrect:

```csharp
if (count > 0 && (ready))
```

### 39. Put the valid and primary-interest branch first

### 40. Follow the logging guideline

### 41. Inline values that a local variable would use only once

Inline single-use value; local requires 2+ uses or syntax/execution semantics.
