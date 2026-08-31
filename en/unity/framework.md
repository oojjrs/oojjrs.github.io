---
layout: page
title: "Framework"
lang: en
category: "GAME DEVELOPMENT"
description: "Explains how recurring business logic flows and design decisions become focused frameworks."
permalink: /en/unity/framework/
alternate_url: /kr/unity/framework/
toc_items:
  - id: example
    label: "Code Examples"
  - id: business-framework
    label: "Business Logic Frameworks"
  - id: flow
    label: "How Much Flow Should It Own?"
  - id: quality
    label: "A Good Framework"
  - id: conclusion
    label: "Conclusion"
---

[← Unity]({{ "/en/unity/" | relative_url }})
{: .article-backlink }

A framework defines recurring execution order and participation rules up front, then calls application code within that flow. Framework users do not rebuild the full sequence; they provide feature-specific logic at defined points.
{: .article-lead }

## Code Examples {#example}

<details class="framework-example">
  <summary><span>Small scale</span> Item use</summary>
  <div markdown="1">

```csharp
// Consumable.cs
public abstract class Consumable
{
    protected abstract void ApplyEffect(Character target);

    protected virtual bool CanUse(Character target)
    {
        return true;
    }

    protected virtual void OnUseCompleted(Character target)
    {
    }

    protected virtual void OnUseStarted(Character target)
    {
    }

    // The framework owns validation → start → effect → consume → finish.
    public bool TryUse(Character target)
    {
        if (CanUse(target))
        {
            OnUseStarted(target);
            ApplyEffect(target);
            target.Inventory.Remove(this);
            OnUseCompleted(target);
            return true;
        }

        return false;
    }
}
```

```csharp
// HealingPotionConsumable.cs
public sealed class HealingPotionConsumable : Consumable
{
    protected override void ApplyEffect(Character target)
    {
        target.Heal(30);
    }

    protected override bool CanUse(Character target)
    {
        return target.Health < target.MaxHealth;
    }

    protected override void OnUseCompleted(Character target)
    {
        target.PlayEffect("Heal");
    }

    protected override void OnUseStarted(Character target)
    {
        target.PlayAnimation("Drink");
    }
}
```

`HealingPotionConsumable` keeps the sequence in `TryUse()` intact and implements only its use condition, opening presentation, effect, and completion behavior.

  </div>
</details>

<details class="framework-example">
  <summary><span>Subsystem</span> Request processing</summary>
  <div markdown="1">

```csharp
// RequestHandler.cs
public abstract class RequestHandler<TRequest, TResponse>
{
    protected abstract void Authorize(User user, TRequest request);

    // The framework owns validation → authorization → handling → completion.
    public TResponse Execute(User user, TRequest request)
    {
        Validate(request);
        Authorize(user, request);

        var response = Database.InTransaction(() => OnHandle(user, request));
        OnCompleted(user, request, response);
        return response;
    }

    protected virtual void OnCompleted(User user, TRequest request, TResponse response)
    {
    }

    protected abstract TResponse OnHandle(User user, TRequest request);

    protected abstract void Validate(TRequest request);
}
```

```csharp
// BuyItemRequestHandler.cs
public sealed class BuyItemRequestHandler : RequestHandler<BuyRequest, Receipt>
{
    protected override void Authorize(User user, BuyRequest request)
    {
        ShopPolicy.Check(user, request);
    }

    protected override void OnCompleted(User user, BuyRequest request, Receipt response)
    {
        Audit.Record(user, response);
    }

    protected override Receipt OnHandle(User user, BuyRequest request)
    {
        return Shop.Buy(user, request.ItemId);
    }

    protected override void Validate(BuyRequest request)
    {
        RequestValidator.Check(request);
    }
}
```

`BuyItemRequestHandler` implements only validation, authorization, request handling, and completion logging within the order and transaction boundary defined by `Execute()`.

  </div>
</details>

<details class="framework-example">
  <summary><span>Genre flow</span> Turn execution</summary>
  <div markdown="1">

```csharp
// TurnController.cs
public abstract class TurnController
{
    protected abstract Task<Command> OnChooseCommand(Unit actor);

    protected virtual void OnCommandResolved(Unit actor, Command command)
    {
    }

    protected virtual void OnTurnEnded(Unit actor)
    {
    }

    protected virtual void OnTurnStarted(Unit actor)
    {
    }

    // The framework owns turn start → action loop → turn end.
    public async Task Run(Unit actor)
    {
        actor.BeginTurn();
        try
        {
            OnTurnStarted(actor);

            while (actor.ActionPoints > 0)
            {
                var command = await OnChooseCommand(actor);
                Rules.Resolve(actor, command);
                OnCommandResolved(actor, command);
            }

            Rules.ApplyEndEffects(actor);
        }
        finally
        {
            try
            {
                actor.EndTurn();
            }
            finally
            {
                OnTurnEnded(actor);
            }
        }

        TurnOrder.Advance();
    }
}
```

```csharp
// PlayerTurnController.cs
public sealed class PlayerTurnController : TurnController
{
    protected override Task<Command> OnChooseCommand(Unit actor)
    {
        return Input.WaitForCommand(actor);
    }

    protected override void OnCommandResolved(Unit actor, Command command)
    {
        Hud.Refresh(actor);
    }

    protected override void OnTurnEnded(Unit actor)
    {
        Hud.HideTurn(actor);
    }

    protected override void OnTurnStarted(Unit actor)
    {
        Hud.ShowTurn(actor);
    }
}
```

`PlayerTurnController` keeps the turn flow in `Run()` intact and implements only the input and presentation behavior required at each stage. Turn cleanup still runs after a failure, and the controller advances only after every stage completes.

  </div>
</details>

<details class="framework-example">
  <summary><span>Main flow</span> Game runtime</summary>
  <div markdown="1">

```csharp
// GameApplication.cs
public abstract class GameApplication
{
    protected abstract GameSession OnCreateSession(MenuChoice choice);

    protected abstract Task<MenuChoice> OnSelectMode();

    protected virtual Task OnSessionEnded(GameSession session)
    {
        return Task.CompletedTask;
    }

    protected virtual Task OnStarted()
    {
        return Task.CompletedTask;
    }

    protected virtual Task OnStopping()
    {
        return Task.CompletedTask;
    }

    // The framework owns start → mode selection → session loop → shutdown.
    public async Task Run()
    {
        await Runtime.Initialize();

        try
        {
            await OnStarted();

            var choice = await OnSelectMode();
            while (choice != MenuChoice.Quit)
            {
                var session = OnCreateSession(choice);
                await session.Play();
                await OnSessionEnded(session);

                choice = await OnSelectMode();
            }
        }
        finally
        {
            try
            {
                await OnStopping();
            }
            finally
            {
                await Runtime.Shutdown();
            }
        }
    }
}
```

```csharp
// MyGameApplication.cs
public sealed class MyGameApplication : GameApplication
{
    protected override GameSession OnCreateSession(MenuChoice choice)
    {
        return new AdventureSession(choice);
    }

    protected override Task<MenuChoice> OnSelectMode()
    {
        return MainMenu.Select();
    }

    protected override Task OnSessionEnded(GameSession session)
    {
        return Storage.Save(session);
    }

    protected override Task OnStarted()
    {
        return Profile.Load();
    }

    protected override Task OnStopping()
    {
        return Settings.Save();
    }
}
```

`MyGameApplication` keeps the application lifecycle in `Run()` intact and implements only startup work, mode selection, session creation and saving, and shutdown preparation. Runtime shutdown still runs if a session or shutdown preparation fails.

  </div>
</details>

The following examples show one lifecycle framework from Unity and one from Unreal.

<details class="framework-example">
  <summary><span>Engine framework</span> Unity MonoBehaviour</summary>
  <div markdown="1">

```csharp
// EnemyView.cs
public sealed class EnemyView : MonoBehaviour
{
    // Unity invokes each method at its lifecycle stage.
    private void Awake()
    {
        CacheComponents();
    }

    private void LateUpdate()
    {
        FaceCamera();
    }

    private void OnDisable()
    {
        Events.Unsubscribe(this);
    }

    private void OnEnable()
    {
        Events.Subscribe(this);
    }

    private void Start()
    {
        PlaySpawn();
    }

    private void Update()
    {
        FollowTarget(Time.deltaTime);
    }
}
```

These methods are not C# `override` methods. They are event functions that Unity locates by name and invokes. `Start()` runs once after the first activation, while `OnEnable()` and `OnDisable()` can repeat as activation changes. The order of the same event function across different GameObjects is not generally guaranteed. See [Unity's event function execution order](https://docs.unity3d.com/6000.0/Documentation/Manual/execution-order.html) for the complete flow.

  </div>
</details>

<details class="framework-example">
  <summary><span>Engine framework</span> Unreal Actor</summary>
  <div markdown="1">

```cpp
// Enemy.h
#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Enemy.generated.h"

UCLASS()
class AEnemy : public AActor
{
    GENERATED_BODY()

public:
    AEnemy();

    virtual void Tick(float DeltaSeconds) override;

protected:
    virtual void BeginPlay() override;
    virtual void EndPlay(const EEndPlayReason::Type EndPlayReason) override;
};
```

```cpp
// Enemy.cpp
#include "Enemy.h"

AEnemy::AEnemy()
{
    PrimaryActorTick.bCanEverTick = true;
}

void AEnemy::BeginPlay()
{
    Super::BeginPlay();

    // Initialize gameplay state.
}

void AEnemy::Tick(float DeltaSeconds)
{
    Super::Tick(DeltaSeconds);

    // Update gameplay state.
}

void AEnemy::EndPlay(const EEndPlayReason::Type EndPlayReason)
{
    // Release gameplay state before base teardown.

    Super::EndPlay(EndPlayReason);
}
```

Unreal calls `BeginPlay()` when an Actor begins play, an enabled `Tick()` during updates, and `EndPlay()` when the Actor leaves the world. This example shows only the core portion of the full Actor lifecycle, and Actors that do not need per-frame updates should not enable ticking. See [Unreal Actor Lifecycle](https://dev.epicgames.com/documentation/en-us/unreal-engine/unreal-engine-actor-lifecycle) and [Actor Ticking](https://dev.epicgames.com/documentation/en-us/unreal-engine/actor-ticking-in-unreal-engine) for details.

  </div>
</details>

## Business Logic Frameworks {#business-framework}

Unity and Unreal do not define a project's own progression rules. If those rules remain scattered across feature code, every new feature must redesign the same wiring and exception handling. Fixing the shared sequence in the framework's entry point leaves each implementation with only the rules that vary by design.

A framework does not need to govern the entire project. A single consumable use, one request, or one view update can form a framework when it has a fixed sequence and defined extension points.

## How Much Flow Should a Framework Own? {#flow}

The framework owns the sequence repeated across implementations and leaves only varying decisions and behavior to callbacks. It also determines when, in what order, and how often each callback runs.

If every new implementation reconnects shared stages, the framework owns too little. Scope is too broad not merely when branch count grows, but when some implementations bypass stages or provide empty callbacks, mutually exclusive options move together, and adding one kind of implementation requires changing another kind's flow. At that point, split flows with different purposes into separate frameworks.

## A Good Framework {#quality}

A good business logic framework reflects a clearly bounded design. Before implementation, define one unit of work, the order it guarantees, and when it succeeds, fails, and ends. Only then can the boundary between shared flow and callbacks be drawn.

### Narrow the Implementation Target

Target `one use of a consumable item`, not `every item system`, and `one combat turn`, not `all game progression`. Define what the framework includes, what it excludes, and which responsibilities belong to other systems. Trying to accept every case multiplies options and exceptional paths until the result becomes an incomplete imitation of an existing general-purpose engine.

### Extract Flow from Real Design Cases

Place real design cases side by side and record their starting conditions, sequence, state changes, success and failure, termination, and cleanup. Move what remains the same into base flow and leave only varying decisions as callbacks or policies. Do not generalize future cases that have not appeared yet.

### Complete the Execution Contract

Do not let implementations alter the common entry point's execution order, and make missing or malformed required extension points fail the build. Documentation can explain how to use a contract, but it cannot replace one.

Fixing only the successful path is insufficient. Define the state left by callback failure or cancellation, and make the framework's common entry point remain responsible for rollback and shutdown when they are required.

### Verify the Boundary with the Next Implementation

Implement one more real feature through the proposed structure. Repeated wiring reveals missing shared flow. If accommodating a feature requires bypassing existing stages or modifying another kind of implementation, the structure includes problems with different purposes. Move the former into base flow and split the latter into a separate framework.

In the finished structure, its purpose and non-goals are brief, the full execution order is readable in one common entry point, and each new implementation contains only the rules unique to that feature.

## Conclusion {#conclusion}

Framework design means finding recurring execution rules and invariants in a design and fixing them as a common entry point and extension contract. By layering focused frameworks, each new implementation supplies only its own rules instead of redesigning the full flow.
