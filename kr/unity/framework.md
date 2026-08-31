---
layout: page
title: "프레임워크"
lang: ko-KR
category: "GAME DEVELOPMENT"
description: "비즈니스 로직의 반복되는 실행 흐름과 설계 판단을 프레임워크로 만드는 기준과 방법을 설명합니다."
permalink: /kr/unity/framework/
alternate_url: /en/unity/framework/
toc_items:
  - id: example
    label: "코드 예제"
  - id: business-framework
    label: "비즈니스 로직 프레임워크"
  - id: flow
    label: "실행 흐름을 얼마나 소유할 것인가"
  - id: quality
    label: "좋은 프레임워크"
  - id: conclusion
    label: "결론"
---

[← Unity 문서]({{ "/kr/unity/" | relative_url }})
{: .article-backlink }

프레임워크는 반복되는 실행 순서와 참여 규칙을 미리 정하고, 그 흐름 안에서 사용자 코드를 호출하는 구조다. 사용하는 쪽은 전체 순서를 다시 조립하지 않고 정해진 지점에 기능별 로직만 작성한다.
{: .article-lead }

## 코드 예제 {#example}

<details class="framework-example">
  <summary><span>소단위</span> 아이템 사용</summary>
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

    // 프레임워크가 검증 → 시작 → 효과 → 소모 → 완료를 소유한다.
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

`HealingPotionConsumable`은 `TryUse()`의 순서를 바꾸지 않고 사용 조건, 시작 연출, 효과와 완료 처리만 구현한다.

  </div>
</details>

<details class="framework-example">
  <summary><span>서브시스템</span> 요청 처리</summary>
  <div markdown="1">

```csharp
// RequestHandler.cs
public abstract class RequestHandler<TRequest, TResponse>
{
    protected abstract void Authorize(User user, TRequest request);

    // 프레임워크가 검증 → 권한 → 처리 → 완료 순서를 소유한다.
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

`BuyItemRequestHandler`는 `Execute()`가 정한 순서와 트랜잭션 경계 안에서 검증, 권한 확인, 요청 처리와 완료 기록만 구현한다.

  </div>
</details>

<details class="framework-example">
  <summary><span>장르 규칙</span> 턴 진행</summary>
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

    // 프레임워크가 시작 → 행동 반복 → 종료 순서를 소유한다.
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

`PlayerTurnController`는 `Run()`이 진행하는 턴 흐름을 바꾸지 않고, 각 시점에 필요한 입력과 화면 처리만 구현한다. 도중에 실패해도 턴 정리는 실행되며, 모든 단계를 완료한 경우에만 다음 턴으로 이동한다.

  </div>
</details>

<details class="framework-example">
  <summary><span>메인 흐름</span> 게임 실행</summary>
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

    // 프레임워크가 시작 → 모드 선택 → 세션 반복 → 종료를 소유한다.
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

`MyGameApplication`은 `Run()`의 프로그램 생명주기를 바꾸지 않고 시작 준비, 모드 선택, 세션 생성·저장과 종료 준비만 구현한다. 세션이나 종료 준비에서 실패하더라도 런타임 종료는 실행된다.

  </div>
</details>

아래에는 Unity의 `MonoBehaviour`와 Unreal의 `Actor` 생명주기 예제를 하나씩 실었다.

<details class="framework-example">
  <summary><span>엔진 프레임워크</span> Unity MonoBehaviour</summary>
  <div markdown="1">

```csharp
// EnemyView.cs
public sealed class EnemyView : MonoBehaviour
{
    // Unity가 생명주기에 맞춰 각 메서드를 호출한다.
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

이 메서드들은 C#의 `override`가 아니라 Unity가 이름으로 찾아 호출하는 이벤트 함수다. `Start()`는 최초 활성화 뒤 한 번 호출되고, `OnEnable()`과 `OnDisable()`은 활성 상태가 바뀔 때마다 반복될 수 있다. 서로 다른 GameObject에 있는 같은 이벤트 함수의 호출 순서까지 보장되지는 않는다. 자세한 흐름은 [Unity 이벤트 함수 실행 순서](https://docs.unity3d.com/6000.0/Documentation/Manual/execution-order.html)에서 확인할 수 있다.

  </div>
</details>

<details class="framework-example">
  <summary><span>엔진 프레임워크</span> Unreal Actor</summary>
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

    // 게임 시작 로직
}

void AEnemy::Tick(float DeltaSeconds)
{
    Super::Tick(DeltaSeconds);

    // 프레임 갱신 로직
}

void AEnemy::EndPlay(const EEndPlayReason::Type EndPlayReason)
{
    // 종료 정리 로직

    Super::EndPlay(EndPlayReason);
}
```

Unreal은 Actor가 플레이를 시작할 때 `BeginPlay()`, 활성화된 틱마다 `Tick()`, 월드에서 제거될 때 `EndPlay()`를 호출한다. 위 코드는 전체 Actor 생명주기 중 핵심 부분만 줄인 것이며, 매 프레임 갱신이 필요 없는 Actor는 틱을 활성화할 필요가 없다. 자세한 흐름은 [Unreal Actor Lifecycle](https://dev.epicgames.com/documentation/en-us/unreal-engine/unreal-engine-actor-lifecycle)과 [Actor Ticking](https://dev.epicgames.com/documentation/en-us/unreal-engine/actor-ticking-in-unreal-engine)에서 확인할 수 있다.

  </div>
</details>

## 비즈니스 로직 프레임워크 {#business-framework}

Unity나 Unreal은 프로젝트 고유의 진행 규칙까지 정해 주지 않는다. 이를 기능 코드에 흩어 두면 새 기능마다 연결 순서와 예외 처리를 다시 설계해야 한다. 공통 순서를 프레임워크의 진입점에 고정하면 구현체에는 기획마다 달라지는 규칙만 남는다.

프레임워크는 프로젝트 전체를 지배하는 거대한 구조일 필요가 없다. 소비 아이템 한 번의 사용, 요청 하나의 처리, 화면 한 번의 갱신 같은 작은 흐름도 고정된 순서와 확장 지점을 가지면 프레임워크로 작동한다.

## 실행 흐름을 얼마나 소유할 것인가 {#flow}

여러 구현에서 반복되는 순서는 프레임워크가 소유하고, 구현마다 달라지는 판단과 동작만 콜백으로 둔다. 콜백의 호출 시점·순서·횟수도 프레임워크가 결정한다.

새 구현마다 공통 단계를 다시 연결한다면 프레임워크의 소유 범위가 부족한 것이다. 범위가 지나치게 넓다는 신호는 분기의 개수 자체가 아니라, 일부 구현이 단계를 우회하거나 빈 콜백을 두고, 서로 배타적인 옵션이 묶여 움직이며, 한 종류를 추가할 때 다른 종류의 흐름까지 수정하게 되는 것이다. 이때 목적이 다른 흐름을 별도 프레임워크로 나눈다.

## 좋은 프레임워크 {#quality}

좋은 비즈니스 로직 프레임워크는 기획의 범위를 정확히 반영한다. 구현 전에 무엇을 한 번의 처리 단위로 볼지, 어떤 순서를 보장할지, 언제 성공·실패·종료할지 정한다. 이 답이 선명해진 뒤에 공통 흐름과 콜백의 경계를 정할 수 있다.

### 구현 대상을 좁힌다

`모든 아이템 시스템`이 아니라 `소비 아이템 한 번의 사용`, `게임의 모든 진행`이 아니라 `전투의 한 턴`처럼 대상을 좁힌다. 지원 대상과 제외 대상, 다른 시스템에 맡길 책임을 함께 정한다. 모든 경우를 수용하려 하면 옵션과 예외 경로가 늘어나고, 결국 이미 존재하는 범용 엔진의 불완전한 축소판이 된다.

### 실제 기획에서 흐름을 추출한다

실제 기획 사례를 나란히 놓고 시작 조건, 진행 순서, 상태 변화, 성공과 실패, 종료와 정리를 적는다. 모든 사례에서 같은 부분은 기반 흐름으로 옮기고, 사례마다 달라지는 판단만 콜백이나 정책으로 남긴다. 아직 등장하지 않은 미래의 경우는 미리 일반화하지 않는다.

### 실행 계약을 완성한다

공통 진입점은 구현체가 실행 순서를 바꾸지 못하게 하고, 필수 확장 지점은 누락하거나 잘못 구현하면 빌드에 실패하도록 만든다. 문서는 사용법을 설명할 수 있지만 계약을 대신할 수 없다.

정상 경로만 고정해서는 부족하다. 콜백의 실패와 취소가 어느 상태를 남기는지 정하고, 롤백과 종료 처리가 필요한 경우 프레임워크의 공통 진입점이 끝까지 책임져야 한다.

### 다음 구현으로 경계를 검증한다

그 구조로 실제 기능을 하나 더 구현해 보면 범위가 맞는지 드러난다. 같은 연결 코드가 다시 나타나면 공통 흐름이 빠진 것이다. 특정 기능을 수용하려고 기존 단계를 건너뛰거나 다른 종류의 구현까지 수정해야 한다면 목적이 다른 문제까지 포함한 것이다. 전자는 기반 흐름으로 올리고, 후자는 별도의 프레임워크로 나눈다.

완성된 구조에서는 목적과 비목표를 짧게 설명할 수 있고, 전체 실행 순서를 공통 진입점 한곳에서 읽을 수 있으며, 새 구현에는 해당 기능의 고유한 규칙만 남는다.

## 결론 {#conclusion}

프레임워크 설계는 기획에서 반복되는 실행 규칙과 불변 조건을 찾아 공통 진입점과 확장 계약으로 고정하는 일이다. 목적이 분명한 소단위 프레임워크를 쌓으면, 새 구현은 전체 흐름을 다시 설계하지 않고 자신의 규칙만 제공한다.
