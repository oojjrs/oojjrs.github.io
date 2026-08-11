---
layout: reference
title: "Hub 구조와 분류 원칙"
lang: ko-KR
category: "UNITY ARCHITECTURE"
description: "Mines를 현재 기준으로 여러 OOJJRS 프로젝트의 Hub 계보를 비교해 전역 접근 구조, 카테고리, 영문 용어와 항목 추가 기준을 정리한 실무 노트입니다."
permalink: /kr/unity/hub-architecture/
parent_url: /kr/unity/
parent_label: "Unity 문서"
status: "초안"
last_updated: "2026-08-11"
summary: "Hub는 전역 잡동사니 통이 아니라 프로젝트가 소유한 전역 주소 공간이다. 새 항목은 전역성 확인 → 수명·소유 범위 선택 → 역할 선택 → 영문 의미 검토 순서로 배치하며, 현재 기준은 Mines의 논리적 실행 context별 단일 partial Hub와 App·Ingame·Ui·Net 중심 분류다."
quick_facts:
  - label: "CURRENT"
    value: "Mines"
    note: "현재 기준 구현"
    primary: true
  - label: "ROOT"
    value: "1 / context"
    note: "필요한 context별"
  - label: "PATH"
    value: "Scope → Role"
    note: "수명·소유 범위 우선"
  - label: "EVIDENCE"
    value: "4× · 2× · 1×"
    note: "최신 의미 변경 가중치"
toc_items:
  - id: current-standard
    label: "현재 기준"
  - id: decision-order
    label: "항목 추가 판단"
  - id: category-boundaries
    label: "카테고리 경계"
  - id: vocabulary
    label: "영문 용어 평가"
  - id: evidence
    label: "프로젝트 계보"
  - id: maintenance
    label: "유지보수 형식"
---

이 문서는 Hub 코드를 일괄 개명하기 위한 목록이 아니다. 현재 구조를 설명하고 새 항목의 좌표를 정하기 위한 기준선이다. 기존 직렬화 참조, Prefab, Scene, 외부 계약을 건드리는 이름 변경은 별도 migration으로 다룬다.

조사 기준일은 2026-08-11이다. first-party C#만 비교했고 package, vendor, sample, generated code, SignalR의 `Hub` 상속 endpoint처럼 이름만 같은 구조는 제외했다. 최근 저장소 커밋이 아니라 **Hub의 마지막 의미 있는 분류·책임 변경**을 최신성 판단에 사용했다.

## 현재 기준 {#current-standard}

`Hub`는 프로젝트 전역에서 안정된 경로로 접근해야 하는 상태, 서비스, registry와 진입점을 모은 **전역 정적 파사드**다. 필요한 객체를 타입이나 문자열로 동적 조회하는 전형적인 container는 아니지만, 전역 service locator의 성격은 가진다. 따라서 사용하기 편하다는 이유만으로 지역 상태까지 올리지 않는다.

- `Hub` 자체는 책임명이 아니라 주소 공간의 root다.
- 각 하위 경로가 실제 소유 범위와 역할을 설명해야 한다.
- 한 Scene, 한 Prefab, 한 기능 안에서만 쓰는 상태는 해당 객체나 지역 context가 우선이다.
- Client와 Server 양쪽에 전역 조정 구조가 필요하면 먼저 namespace로 논리적 실행 context를 나누고, 필요할 때 assembly도 분리해 각각 Hub를 둔다.
- 같은 전역 실행 context 안에서는 `PlayHub`, `TitleHub`, `EverywhereHub`처럼 root를 늘리기보다 하나의 `Hub` 아래에 책임을 분류한다. 부모 객체가 명확히 소유하는 local hub는 별도 패턴이다.

### 문서에서 쓰는 용어

| 용어 | 의미 | 예 |
| --- | --- | --- |
| root | 논리적 실행 context의 전역 주소 공간 | `Hub` |
| category | 소유 범위 또는 안정된 역할 node | `App`, `Ingame`, `Ui`, `Builder` |
| leaf | 실제 값·명령·event·registry를 소유하는 말단 | `Hub.App.Display`, `Hub.Builder.Game` |
| path | root부터 leaf까지의 전체 의미 좌표 | `Hub.App.Settings.Hotkey` |
| slice | path 하나를 구현하는 partial 파일 | `Hub.App.Settings.Hotkey.cs` |

### Mines Client 현행 지도

아래는 커밋된 코드의 현행 구조다. 존재한다는 사실과 새 코드에 그대로 권장한다는 평가는 같지 않으며, 재검토할 단어는 뒤의 용어 표에서 따로 표시한다.

```text
Hub
├─ App
│  ├─ Canvas · Display · Input · Scene · Settings · Window
│  └─ account · nickname · quit lifecycle
├─ Ingame
│  ├─ Focus · Input · Manager · Model · My · Settings · Treasure
│  └─ session clear
├─ Ui
│  ├─ Asker · Effect · Panel
│  └─ navigation · page stack
├─ Net
│  └─ Lobby · My · Phase · Player · Room
├─ Audio
│  └─ Bgm
├─ Data
│  └─ Stub · Stub.Empty
├─ State
│  └─ Net
├─ Single
│  └─ Phase
└─ Asset · Const · Effect · Localization · Test · Timer
```

특히 `Canvas / Display / Window`는 같은 화면 계열처럼 보여도 좌표가 다르다.

- `App.Canvas`: 논리 UI 좌표계
- `App.Display`: 모니터, 표시 방식과 선택 가능한 해상도
- `App.Window`: 실제 게임 창의 현재 크기

### Mines Server 현행 지도

Server namespace의 논리적 실행 context가 게임 서버 범위를 이미 설명하므로 Client의 `Ingame` 계층을 기계적으로 복제하지 않는다. 역할을 먼저 놓고 대상을 그 아래 둔다.

```text
Hub
├─ Builder ─ Cell · Game · Map · Region · User
├─ Handler ─ Cell · Game · Map
├─ Manager ─ Cell · Game · Map · Region · User
├─ Keeper ─ Answer
├─ Net ─ ResponseBuilder
└─ Data · Test
```

`Hub.Builder.Game.Build`, `Hub.Handler.Cell.Open`처럼 **역할 → 대상 → 동사** 순서로 읽는다. `GameBuilder`를 다시 넣어 `Hub.Builder.GameBuilder`처럼 역할을 중복하지 않는다.

### 파일과 타입 구성

1. 파일명과 중첩 타입 path를 정확히 맞춘다.
2. 여러 파일이 이어 쓰는 root와 중간 node만 `static partial class`로 둔다.
3. 더 나뉘지 않는 말단은 `static class`로 닫는다.
4. cross-category·cross-slice 참조는 `App.State`처럼 축약하지 않고 `Hub.App.State`처럼 전체 좌표를 쓰는 것을 목표 규칙으로 둔다.
5. 전역 가변 상태에는 값을 넣는 지점과 비우는 지점을 함께 둔다. 상위 `Clear()`가 reset을 집계하는 것을 기본으로 하되, 흐름 사이에 유지할 값은 별도 owner와 reset 지점을 기록한다.

```csharp
// Hub.App.Settings.Hotkey.cs
public static partial class Hub
{
    public static partial class App
    {
        public static partial class Settings
        {
            public static class Hotkey
            {
            }
        }
    }
}
```

Mines는 `9063663`에서 전체 좌표 규칙을 정했지만 현재 `App.Settings` 2곳, `App.Account`, `App.Scene.StepEnum`의 축약 참조 4곳이 남아 있다. 새 축약을 늘리지 않고 이 네 곳을 Transitional 부채로 본다. 또한 `Hub.Ingame.Clear()`는 `Manager`, `Model`, `CurrentRoom`, `Treasure`만 비우며 `Players`는 `Net.Phase.StartLobby()`에서 따로 비운다. `GameMode`와 `RegionStub`까지 포함해 상위 `Clear()` 밖에 있는 값은 수명을 의도적으로 유지하는지, reset owner가 빠진 것인지 항목별로 기록한다.

## 항목 추가 판단 {#decision-order}

### 1. 전역이어야 하는가

다음 질문을 모두 설명하지 못하면 Hub에 넣지 않는다.

1. 서로 독립된 둘 이상의 소비자, Scene 또는 수명 구간이 공유하는가?
2. 소유자가 하나이고 초기화·reset 시점을 설명할 수 있는가?
3. 호출자가 안정된 전역 좌표를 알아야 하는가?
4. 일반 instance 참조, component hierarchy, method parameter나 domain service로 전달하는 편이 더 자연스럽지 않은가?

순수 helper와 extension, 한 기능의 command, 일회성 orchestration은 Hub 밖에 둔다. 전역 context의 root 하나 원칙과 달리 Meister2의 지역 `ItemTagHub`처럼 부모 hierarchy가 소유하는 작은 local hub는 정상적인 대안이다.

### 2. 수명과 소유 범위를 먼저 고른다

Scene 이름이나 현재 호출자보다 **값이 살아 있는 기간과 실제 owner**를 우선한다.

| 질문 | 기본 좌표 |
| --- | --- |
| 앱 실행 동안 유지되는 host·platform·display·scene·설정인가? | `Hub.App` |
| 현재 게임 session과 함께 생성·clear되는가? | `Hub.Ingame` |
| 전송, 원격 명령 또는 network cache인가? | `Hub.Net` |
| 화면 탐색, panel, dialog처럼 순수 presentation 책임인가? | `Hub.Ui` |
| 여러 subsystem이 읽는 cross-cutting runtime state·readiness·derived predicate인가? | `Hub.State` |
| 정적 definition·catalog인가? | `Hub.Data` |
| Unity 참조를 주입받는 asset registry인가? | `Hub.Asset` |
| 독립된 cross-scope subsystem인가? | `Hub.Audio`, `Hub.Localization` 같은 root category |
| Server entity 생성·요청 처리·저장·비공개 보관인가? | `Builder`, `Handler`, `Manager`, `Keeper` |

### 3. 새 category가 정말 필요한가

새 node는 다음 중 하나가 있을 때만 만든다.

- 기존 path와 다른 reset 시점 또는 수명
- 별도 producer, binder, transport나 persistence owner
- 여러 sibling이 공유할 안정된 역할 행
- 호출자가 알아야 할 실제 domain 경계

leaf 하나를 넣기 위해 `Common`, `Utility`, `Misc`, `Temp` 같은 umbrella를 먼저 만들지 않는다. 반대로 category가 아직 leaf 하나뿐이어도 runtime 경계나 보안 경계처럼 독립 owner를 증명한다면 허용한다.

### 4. 상태와 작업을 분리한다

Mines의 현재 구조는 이 구분을 의도적으로 사용한다.

- `Hub.Ingame.Settings.CurrentRoom`과 `Players`: 싱글·멀티가 함께 읽는 session 상태다. 현재 위치는 유지 중이지만 `Settings`라는 역할명은 Transitional이다.
- `Hub.Net.Room`과 `Player`: 원격 생성·참가·퇴장·갱신 작업
- `Hub.App.Input`: device mode, cursor, key log 같은 앱 입력 상태
- `Hub.Ingame.Input`: 이동·포인터·zoom처럼 게임에서 해석한 입력
- `Hub.Effect`: gameplay effect 재생 서비스
- `Hub.Ui.Effect`: UI effect 참조

생성 경로가 network였다는 이유만으로 값의 owner까지 `Net`으로 두지 않는다. 반대로 상태를 보관한다는 이유만으로 원격 작업까지 `Settings`나 `State`에 넣지 않는다.

### 5. 등록 비용을 함께 확인한다

Hub 파일 하나를 추가해도 실제 등록은 끝나지 않을 수 있다.

| 항목 종류 | 함께 확인할 곳 |
| --- | --- |
| 정적 collection·service | 선언 시 초기화, 상위 `Clear()` 또는 문서화된 별도 reset owner |
| Unity asset·component 참조 | Setter·Receiver의 serialized field와 할당 |
| UI panel·effect | Hub property, Setter의 `nameof` switch, 동일한 child 이름 |
| 변경 event | 선언·호출, listener의 subscribe/unsubscribe 한 쌍 |
| readiness | producer, `Hub.State`의 종합 predicate, 최초 Scene 진입 |
| session 값 | 생성, 재시작·퇴장·Scene 전환 시 reset |
| 문자열 key | owner별 constant·enum·`nameof`; 새 raw string 금지 |

추가 후 책임 없는 중간 node나 의미 반복이 생기거나 수동 등록 지점이 계속 늘어나면, Hub category가 아니라 별도 domain type·registry가 필요한지 다시 본다. `Hub.App.Settings.Hotkey`처럼 각 단계가 실제 경계를 설명한다면 깊이 자체는 문제가 아니다.

현행 Mines의 디버그 key `"Steam"`, `"audio_log"`, `"Keylogger"`는 표기까지 일관되지 않은 legacy raw string이다. 새 key는 같은 방식으로 추가하지 않고 owner별 constant·enum 전환 대상으로 둔다.

## 카테고리 경계 {#category-boundaries}

아래 표는 새 코드에 적용할 **권장 경계**다. 현행 코드가 이미 모두 지킨다는 뜻은 아니며, 알려진 예외는 표 아래에 Transitional로 기록한다.

### Client 기준

| category | 포함 | 제외·주의 |
| --- | --- | --- |
| `App` | account context, 종료, Scene, display, window, app input, 영구 설정 | 현재 game entity와 UI panel registry |
| `State` | 여러 subsystem이 함께 읽는 application·game runtime flag, readiness와 파생 boolean | domain record, 임의 cache, 명령 모음 |
| `Ingame` | 현재 session의 entity, model binding, local 관점, session 설정·상태 | title/profile처럼 session 밖에서도 유지되는 값 |
| `Net` | transport, remote operation, lobby/room network cache | 싱글플레이도 사용하는 session 원본 상태 |
| `Ui` | navigation, page stack, panel, prompt, UI 전용 effect | gameplay rule과 network orchestration |
| `Data` | key로 찾는 정적 definition과 stub | Unity scene object, mutable entity state, readiness flag만 있는 빈 shell |
| `Asset` | Startup/Ingame 등 주입된 asset 묶음 | 범용 download 절차나 모든 `Object` 생성 책임 |
| `Audio` | mixer 적용과 재생 facade | 저장된 사용자 음량 값은 `App.Settings` |
| `Localization` | locale와 localized value 조회 | UI panel state |
| `Const` | owner를 더 좁힐 수 없는 소수의 cross-cutting constant | 임시 key와 domain별 잡다한 값 |

`App.Settings`는 영구 사용자 설정이라는 책임이 분명하다. 반면 `Ingame.Settings.GameMode / RegionStub`는 session 초기 조건을 설정으로 볼 때만 조건부로 유지하고, `CurrentRoom / Players`는 실제 session 상태이므로 Transitional로 본다. 재분류할 때는 `Ingame.Session` 또는 `Ingame` 직속 leaf를 검토하되 reset 경계를 함께 옮긴다.

Mines의 `Net.Lobby / Player / Room`이 `Ui.Asker`를 직접 호출하고 `Net.Phase`가 `Ui.Panel`을 조작하는 흐름은 현행 예외다. 새 Net 코드에는 이 결합을 늘리지 않고 presentation orchestration을 별도 owner로 옮길 후보로 둔다.

root category가 많아지면 먼저 `App`, `Ingame`, `Ui`, `Net` 중 실제 owner가 빠졌는지 본다. Rebellion처럼 UI·표시 관련 `Panel / Canvas / Window`와 domain 항목을 모두 root에 펼치는 방식은 새 표준으로 사용하지 않는다.

### Server 기준

| category | 책임 | 경계 |
| --- | --- | --- |
| `Builder` | entity를 만들고 필요한 registry에 등록 | 현행 Mines는 `Ship()`을 통해 응답 대상 등록까지 수행함. request 분기는 소유하지 않음 |
| `Handler` | request dispatch, 검증, domain operation 호출 | 장기 entity 저장소가 아님 |
| `Manager` | 공개 가능한 runtime entity 저장·조회 | 비밀값과 정적 definition 제외 |
| `Keeper` | client에 ship하지 않는 server-only 값 | 일반 entity repository와 구분되는 보안 경계가 있어야 함 |
| `Data` | server definition 원본 | session entity 제외 |
| `Net` | 요청 수신·응답 송신과 transport buffer | gameplay rule과 lifecycle reset의 실제 owner가 되지 않음 |

현행 Mines Server의 새 게임 요청 흐름은 `Keeper`, `Manager`, `ResponseBuilder` reset까지 `Net`에서 조정한다. 동작 흐름을 한곳에서 시작할 수는 있지만, 각 reset 구현과 상태 소유권까지 `Net`으로 옮기지 않는 것을 경계로 삼는다.

Client와 Server가 같은 단어를 쓰더라도 namespace와 논리적 실행 context가 다르면 path의 의미가 달라질 수 있다. 두 tree를 모양만 맞추려고 불필요한 계층을 추가하지 않는다.

## 영문 용어 평가 {#vocabulary}

영어 사전 표기만으로 category를 결정하지 않는다. 먼저 실제 소유·수명·역할 경계를 정하고, 그 경계를 가장 좁게 표현하는 명사를 고른다. 자세한 토큰 경계 판단은 [의미 계층 기반 네이밍]({{ "/kr/csharp/semantic-layer-naming/" | relative_url }})을 따른다.

### 현재형 용어

| 용어 | 판정 | 짧은 평가 |
| --- | --- | --- |
| `Hub` | 적합 | 여러 전역 subsystem을 잇는 중심 주소 공간이라는 의도와 맞는다. 문서에서 static facade임을 명시한다. |
| `App` | 적합 | application 수명과 host 책임을 짧고 명확하게 나타내며 framework의 `System` namespace와 이름 충돌도 피한다. |
| `Canvas / Display / Window` | 적합 | 논리 UI 공간, 표시 장치·방식, 실제 창 크기를 각각 가리킨다. |
| `State` | 적합 | 여러 subsystem이 함께 읽는 cross-cutting runtime flag, readiness와 derived predicate에 한정할 때 명확하다. 단순 값 보관함으로 넓히지 않는다. |
| `Asset / Audio / Data / Localization` | 적합 | 현재 구현의 registry·service·definition 책임과 대체로 일치한다. |
| `App.Settings` | 적합 | 앱 수명에 속한 영구 사용자 설정이라는 owner가 분명하다. |
| `Ingame.Settings` | 재검토 | `GameMode / RegionStub`는 session 초기 조건으로 볼 때만 조건부다. `CurrentRoom / Players`는 설정이 아니라 session 상태이므로 Transitional이다. |
| `Builder / Handler` | 적합 | entity construction과 request handling이라는 역할이 분명하다. 대상은 하위 node로 둔다. |
| `Net` | 적합 | 축약어지만 game code에서 관용적이다. `Web`, `Sync`, `Network`와 함께 쓸 때 transport 경계를 문서화한다. |
| `Ingame` | 조건부 유지 | 프로젝트의 현재 game session을 뜻하는 확립된 어휘지만 영어에서는 보통 `in-game` 형용사다. 새 체계를 다시 정한다면 `Session` 또는 `Gameplay`를 검토하고, casing만 `InGame`으로 바꾸지는 않는다. |
| `Manager / Model` | 조건부 유지 | Mines에서는 entity registry와 entity↔Unity model binding으로 정의돼 있다. 이 정의가 없으면 너무 넓다. |
| `Keeper` | 조건부 유지 | server-only secret을 지킨다는 domain 의미는 맞지만 일반적인 storage 용어는 아니다. 보안 경계가 없으면 `Store`나 `Repository`가 더 직접적이다. |
| `My` | 재검토 | local user 관점을 짧게 표현하지만 구어적이고 검색성이 약하다. 새 이름은 `Local`, `CurrentUser`, `PlayerContext`처럼 대상을 드러낸다. |
| `Single` | 재검토 | `Singleplayer`를 지나치게 줄였다. mode owner를 유지한다면 전체 개념을 쓴다. |
| `Phase` | 재검토 | 현재 구현은 phase 값보다 흐름을 조정한다. `Flow`나 `Coordinator`가 책임에 더 가깝다. |
| `Asker` | 재검토 | 영어로 질문하는 사람에 가깝다. 새 UI 용어는 `Prompt`, `Dialog`, `Confirmation`이 자연스럽다. 외부 library API이면 quoted vocabulary로 취급한다. |
| `Presentation` | 재검토 | fullscreen/window mode를 뜻하기에는 넓다. 실제 값에 맞춰 `FullScreenMode` 또는 `WindowMode`를 검토한다. |
| `Timer` | 재검토 | 현재는 시간을 재지 않고 tick event를 전달하므로 `Ticker`가 더 정확하다. |
| `Test` | 재검토 | 현재 leaf 하나가 development build 판정뿐이라면 `App.Build`나 `State`의 명시적 predicate가 더 좁다. test utility가 실제 family로 늘어날 때 category를 둔다. |
| `Const` | 조건부 유지 | 의미는 통하지만 owner별 constant를 먼저 배치한다. category를 유지해도 잡동사니 통으로 넓히지 않는다. |
| `Empty` | 재검토 | 현재는 null-key sentinel이다. `Null`, `Missing`, `Fallback` 중 실제 동작을 표현하는 단어가 더 가깝다. |
| `Effect` / `Ui.Effect` | 조건부 유지 | path로 gameplay 재생 service와 UI reference를 구분할 수 있다. 둘 다 단순 registry가 되면 더 구체적인 leaf가 필요하다. |

### `Environment` 최신 후보

2026-08-11 작업 트리의 `Hub.App.Environment.IsUsingSteam()`은 아직 커밋되지 않은 후보이므로 현행 표준 지도에서는 제외했다. 함께 수정 중인 `PlatformInitializerReceiver.InitialType`은 이 값을 이용해 Steam과 Anonymous service route를 고른다.

- `App` 아래에 둔 것은 적합하다.
- store, build channel, runtime integration처럼 sibling이 늘어날 예정이면 `Environment`도 성립할 수 있다.
- Steam 여부 하나만 소유한다면 `Platform` 또는 `Distribution`이 더 좁다.
- 질문이 “이 build에 Steamworks가 포함됐는가”라면 `App.Build.IsSteamworksEnabled`가 가깝다.
- 질문이 “현재 어떤 store route를 사용하는가”라면 `App.Distribution.IsSteam`이 가깝다.
- `IsUsingSteam`은 compile capability와 실제 runtime 사용을 모두 뜻할 수 있으므로 먼저 의도를 하나로 고정한다.

### 레거시에서 새 category로 가져오지 않을 단어

| 유형 | 관찰된 예 | 처리 |
| --- | --- | --- |
| catch-all | `Actions`, `Temp`, `Utility`, `Common`, `Misc` | 실제 owner와 역할로 분해 |
| 위치만 넓게 말함 | `EverywhereHub`, 과도하게 커진 `TitleHub` | `App`, `Ui`, `Net`, session 등 수명으로 재분류 |
| 임시 단계 | `Alpha`, `First`, `Second`, `Old`, `New` | `Combat`, `Startup`, `Content`처럼 지속 책임 사용 |
| 구현 은유 | `Bucket`, 불명확한 `GhostHub` | `Catalog`, `Cache`, `Registry`, `Replica`, `View`처럼 실제 역할 사용 |
| 동사 category | `Prepare` | `Preparation`, `Setup`, `Deployment` 등 명사 역할 사용 |
| 비표준 축약·casing | `Multiplay`, `Cam`, `Phys`, `GamePlay` | `Multiplayer`/`Net`, `Camera`, `Physics`, `Gameplay` 검토 |
| 단복수 convention | `Tooltips` | 영어 복수형 자체는 맞지만 category 이름은 단수 `Tooltip`을 우선 검토 |
| 실제 의미와 충돌 | `Roll`, `Tek` | unit roster/filter인 `Roll`은 `Roster`, 일반 영어가 아니며 `Tech`와 병존하는 `Tek`은 실제 책임에 따라 `TechSlot`·`ResearchSlot` 검토 |
| category와 내용 불일치 | `Cargo.Tech` | 원본 주석부터 Cargo에 실리는 대상이 아니라고 밝힌 사례다. 편의상 기존 묶음에 넣지 말고 실제 owner로 이동 |

과거 이름이 많이 남아 있다는 사실은 현재 권장 근거가 아니다. 특히 `Temp`에 들어갔던 코드가 오래 살아남았다는 것은 category의 유용성이 아니라 분류 비용이 미뤄졌다는 증거다.

## 프로젝트 계보와 가중치 {#evidence}

가중치는 단순 투표 수가 아니라 **의미 변경의 최근성 × 의도적인 분류 작업 × 현재 사용성**을 나타내는 우선순위다. 줄바꿈 정리, Unity version update, 일괄 null 표기 변경처럼 taxonomy를 바꾸지 않은 commit은 최신 근거로 세지 않는다.

| 가중치 | 프로젝트 | 의미 있는 시점 | 해석 |
| ---: | --- | ---: | --- |
| `4×` | Mines | 2026-08 | 현재 기준. `App / Ingame / Ui / Net / State`, Client·Server 논리 context 분리, 역할→대상 server tree가 계속 갱신되고 있다. |
| `2×` | Overlord | 2026-03~04 | 유용한 최신 보조 표본 중 하나다. Client scope 분류와 Server `Builder / Handler / Net` 분리를 지지한다. `Alpha`, `Asset.First`는 예외로 남는다. |
| `2×` | ProjectA | 2024-11, 2026-03 | flat root를 `App / Ingame / Ui`로 옮긴 직접적인 분류 전환 근거다. 후대 `State` 분리 전 단계다. |
| `1×` | Rebellion | 구조 2022~24, 명명 2024-11 | 단일 Hub의 장점과 root 52개 확장의 유지보수 한계를 함께 보여 준다. 마지막 taxonomy 조정은 `Screen → Window` 단일 명명 변경이다. |
| `1×` | Meister2 | 2022-09 | scene·접근 범위·책임을 혼합해 `PlayHub / TitleHub / EverywhereHub / MultiplayHub / ModelHub / GhostHub`로 root를 늘린 과도기이며, `ItemTagHub`에서는 hierarchy-local instance도 시험했다. |
| history | Meister | 2018 | Hub 이전의 분산 `*Manager` 구조다. Hub가 왜 단일 접근 좌표로 발전했는지 설명하는 전사다. |
| counterexample | Beat | 2026-01 | 날짜는 최근이지만 game-jam 보관본의 flat state bag이다. 최신 날짜만으로 표준을 고르지 않는 반례다. |

### 대표 재검증 anchor

- **Mines** — `MinesClient/Assets/Sources/Scripts/Client/Hub*.cs`, `MinesClient/Assets/Sources/Scripts/Server/Hub*.cs`. 초기 분류는 `180830f`, `68680e3`, `9748676`, `7776b13`, `9063663`, `5c4c272`, Server 통합은 `47a7e96`에서 확인한다. 최신 구조는 `e7144ff`(`State`), `7554687`(역할→대상), `6e31693`(`Keeper.Answer`), `a9b4315`(UI page stack), `766545f`(Input), `b1e0840`(Display)를 본다.
- **Rebellion** — `Rebellion/Assets/Sources/Scripts/Client/Hub*.cs`. `777a8ee`(`Screen → Window`, 2024-11-21); 이 commit 하나를 전체 구조의 생성 시점으로 해석하지 않는다.
- **Meister2** — `Meister2/Assets/Sources/Scripts/Client/*Hub*.cs`. `72964f0`(partial 분리, 2022-01-12), `47723b1`(마지막 Hub 의미 변경, 2022-09-02).
- **ProjectA** — `Client/Assets/Blackstorm/Scripts/Client/Hub*.cs`. `359af12`(분류 최신화, 2024-11-27), `54600d7`(`Ui.Asker / Panel`, 2026-03-21).
- **Overlord** — `Client/Assets/Sources/Scripts/Client/Hub*.cs`, `Client/Assets/Sources/Scripts/Server/Hub*.cs`. `8fe1fbb`(`State`, 2026-03-07), `425c85b`(`Builder.Item` 등 마지막 Hub 기능 변경, 2026-04-27).
- **Beat** — `Client/Assets/Sources/Scripts/Client/Hub.cs`. `9569a7e`(보관본 최초 Hub, 2026-01-25).

아래 화살표는 프로젝트 간 직접 계승 관계가 아니라 여러 프로젝트에서 관찰된 구조 변화 경향이다.

```text
분산 *Manager
→ scene·역할별 여러 *Hub
→ 하나의 flat partial Hub
→ App / Ingame / Ui 중심 재분류
→ State 분리 + Client/Server 논리 context별 역할 tree
```

다음 원칙을 유지한다.

1. Mines와 최신 보조 프로젝트가 같은 방향으로 수렴하면 오래된 다수 사례보다 우선한다.
2. 오래된 코드는 현재 표준의 표가 아니라 왜 문제가 생겼는지 설명하는 반례로 사용한다.
3. 최근 코드라도 보관본, prototype, 임시 release 단계면 구조 가중치를 낮춘다.
4. SignalR `GameHub`, package sample, vendor code는 이 static coordination Hub 계보에서 제외한다.
5. 새 프로젝트가 충분히 유지된 뒤 다른 구조로 수렴하면 가중치 표와 현재 기준을 함께 갱신한다.

## 유지보수 형식 {#maintenance}

### 새 항목 검토 카드

Hub에 새 leaf나 category를 추가할 때 아래 항목만 짧게 채운다. 모든 property를 영구 표로 복제하지 않고, 새 경계·애매한 단어·예외가 생겼을 때 기록한다.

```text
path:
category:
label:
keywords:
kind: State | Registry | Facade | Factory | Cache | Event | Command
description:
owner:
lifetime: Process | Scene | Session | Stage | Request
producer_or_binder:
main_consumers:
reset_or_clear:
events:
last_semantic_change:
assessment: Standard | Transitional | Legacy | Candidate
```

최소 결정은 다음 한 줄로 남길 수 있어야 한다.

```text
Hub.<Scope>.<Role> — <무엇을 소유하며 언제 생성·해제되는지> — <왜 기존 category가 아닌지>
```

### 구현 완료 확인

- path와 파일명이 일치하는가?
- 중간 node만 `partial`인가?
- cross-category·cross-slice 참조가 `Hub.` 전체 경로를 쓰는가?
- Unity 참조의 Setter·Receiver가 연결됐는가?
- event 구독과 해제가 대칭인가?
- 상위 `Clear()` 또는 명시한 별도 owner에서 reset되는가?
- 새 raw string key를 늘리지 않았는가?
- category와 leaf가 명사이며 실제 책임보다 넓지 않은가?
- Client/Server 논리 context와 local/global 경계를 먼저 나눴는가?
- rename이면 serialized reference와 외부 계약 migration을 별도로 추적했는가?

### 문서 갱신 규칙

1. snapshot 날짜는 실제 코드를 다시 조사한 날만 바꾼다.
2. 마지막 commit 날짜가 아니라 마지막 **의미 변경일**을 기록한다.
3. 새 category, category 이동, 용어 판정 변경, 예외 발생만 본문과 결정 기록에 반영한다.
4. 오래된 항목 수가 많아도 가중치를 다수결로 계산하지 않는다.
5. 기존 판정을 바꿀 때는 새 근거를 추가하고 superseded 문장을 제거한다.
6. 코드에 없는 `label`, `keywords`, `description`은 이 문서가 토론용 메타데이터로 소유한다. runtime registry를 새로 만들지는 않는다.

### 결정 기록

| 날짜 | 결정 | 근거 |
| --- | --- | --- |
| 2024-11 | `App / Ingame / Ui`를 1차 소유 범위로 둔다. | Mines·ProjectA의 의도적인 flat root 재분류 |
| 2024-12 | Client와 Server 양쪽에 Hub가 필요하면 별도 context tree로 본다. | Mines Server의 개별 static 통합 |
| 2026-03 | cross-cutting runtime flag, readiness와 derived predicate를 `State`로 분리한다. | Mines·Overlord의 수렴 |
| 2026-08 | Mines를 현재 `4×` 기준으로 두고 최신 보조 표본은 `2×`로 본다. | 최근 의미 변경과 실제 유지보수 빈도 |
| 2026-08-11 | `App.Environment`는 후보로만 기록한다. | 아직 미커밋이며 Steam predicate 하나의 category 범위가 확정되지 않음 |

형식·선언 순서는 [Unity C# 코딩 컨벤션]({{ "/kr/unity/csharp-coding-convention.html" | relative_url }}), 의미 token과 대소문자 경계는 [의미 계층 기반 네이밍]({{ "/kr/csharp/semantic-layer-naming/" | relative_url }})을 함께 따른다.
