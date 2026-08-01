---
layout: page
title: "의미 계층 기반 네이밍"
lang: ko-KR
alternate_url: /en/csharp/semantic-layer-naming/
category: "NAMING DESIGN"
description: "식별자 경계를 코드의 소유·구조·관계·역할 계층으로 읽는 언어·엔진·플랫폼 중립 명명 규칙입니다."
permalink: /kr/csharp/semantic-layer-naming/
toc_items:
  - id: principle
    label: 핵심 원칙
  - id: tokens
    label: 단어가 아니라 계층
  - id: structure
    label: 구조를 이름으로 옮기기
  - id: matrix
    label: 2차원 좌표로 읽기
  - id: evidence
    label: 경계를 증명하는 것
  - id: failures
    label: 잘못된 경계
  - id: checklist
    label: 검토 순서
  - id: scope
    label: 적용 범위와 이력
---

<p class="article-backlink"><a href="{{ "/kr/" | relative_url }}">← 문서 목록</a></p>

<p class="article-lead">식별자 안의 경계는 보기 좋게 철자를 끊는 표시가 아니다. 각 경계는 이름이 나타내는 구조가 한 계층 확장된다는 선언이며, 언어·엔진·플랫폼에 따라 달라지지 않는다.</p>

<div class="article-principle">
  <p>이름의 각 의미 토큰은 실제 의미 계층 하나를 나타낸다. 한 계층은 한 토큰으로 쓴다. 경계는 사전이나 표면 casing이 아니라 코드의 소유·구조·관계·책임으로 판정한다.</p>
</div>

## 핵심 원칙 {#principle}

`FooBar`와 `Foobar`는 철자만 다른 이름이 아니다.

- `FooBar`는 `Foo → Bar`라는 두 계층을 선언한다.
- `Foobar`는 `Foobar`라는 원자적인 한 계층을 선언한다.
- 토큰을 하나 추가한다는 것은 이름이 가리키는 구조를 한 계층 확장하는 일이다.
- 이름이 길어지는 것 자체는 문제가 아니다. 실제 구조에서 가리키는 좌표가 없는 토큰이 문제다.
- 언어나 스코프의 이름 제약 때문에 표면상 토큰이 반복돼도 실제 구조가 늘어나지 않았다면 새 의미 계층으로 세지 않는다.

이 규칙은 PascalCase 문법을 정하는 컨벤션이 아니라, 이름에 아키텍처를 얼마나 드러낼지 정하는 설계 규칙이다.

예시는 PascalCase로 쓰지만 의미 판정이 먼저다. camelCase, snake_case, kebab-case 또는 다른 필수 형식에서도 같은 의미 묶음을 대상 컨벤션에 맞게 표현한다. `FooBar`, `fooBar`, `foo_bar`, `foo-bar`는 모두 `Foo → Bar`를 나타낼 수 있고, `Foobar`와 `foobar`는 원자적인 한 계층을 나타낸다.

## 단어가 아니라 계층 {#tokens}

한 개념을 한 계층으로 다룬다면 자연어에서 여러 음절로 나뉘어 보여도 한 토큰으로 쓴다.

| 이름 | 판정 | 이유 |
| --- | --- | --- |
| `Nickname` | 한 계층 | 시스템에 `Nick → Name` 구조가 없다. |
| `Lifetime` | 한 계층 | 수명을 하나의 기간 개념으로 다룬다. |
| `Gameplay` | 한 계층 | `Game`이 `Play`를 소유하는 구조가 아니다. |
| `TitleMenuButton` | 세 계층 | 실제 `Title → Menu → Button` 구조가 있다. |

따라서 `Nickname`이 맞는 이유는 사전에서 합성어이기 때문이 아니다. 현재 모델에 `Nick` 계층과 그 아래 `Name` 역할이 없기 때문이다.

반대도 가능하다. 실제로 `User → Name` 속성이나 역할을 모델링한다면 `UserName`이 맞다. 하나의 로그인 식별자 개념이라면 `Username`이 맞다. 모양만으로 어느 쪽을 강제하지 않는다.

## 구조를 이름으로 옮기기 {#structure}

Unity UI는 구체적인 예시 하나다. 이름으로 Prefab과 Scene의 소유 경로를 드러낼 수 있다.

```text
Title
└─ Menu
   └─ Singleplayer Button

TitleMenuSingleplayerButton
```

`Button`은 단순한 접미사가 아니라 말단 컴포넌트의 역할이다. 같은 원리로 `LobbyRoomListEntryHostText`는 `Lobby → Room → List → Entry → Host → Text`를 읽을 수 있게 한다.

ASP.NET 서버는 또 다른 예시다.

```text
Db → Character → Mapper
Db → Character → Record

DbCharacterMapper
DbCharacterRecord
```

`RoomLobbyService`, `RoomPlayerView`처럼 aggregate와 역할이 실제로 분리돼 있다면 각각의 토큰은 독립된 계층이다.

원리 자체는 Unity나 ASP.NET에 의존하지 않는다. 다른 언어·엔진·플랫폼에서도 같은 의미 계층을 사용하고 표면 형식만 각자의 명명 문법에 맞춘다.

## 2차원 좌표로 읽기 {#matrix}

일관된 이름 패밀리는 구조 경로를 나타내는 행과 말단 역할을 나타내는 열로 정돈된다.

| 구조 행 | 역할 열 | 결과 이름 |
| --- | --- | --- |
| `Title → Menu` | `SingleplayerButton` | `TitleMenuSingleplayerButton` |
| `Lobby → Room → List → Entry` | `HostText` | `LobbyRoomListEntryHostText` |
| `Lobby → Room → List → Entry` | `JoinButton` | `LobbyRoomListEntryJoinButton` |
| `Db → Character` | `Mapper` | `DbCharacterMapper` |
| `Db → Character` | `Record` | `DbCharacterRecord` |

반복되는 prefix는 구조 행을 만들고, 반복되는 역할 suffix는 열을 만든다. 그래서 코드가 문장 목록이 아니라 2차원 표처럼 보인다.

## 경계를 증명하는 것 {#evidence}

다음 중 하나를 실제 코드에서 가리킬 수 있어야 토큰 경계가 성립한다.

1. file, module, package, resource, object, component 또는 직렬화된 소유 경로
2. namespace, 중첩 타입, aggregate, domain, schema, persistence, transport 또는 application service 경계
3. `Entry`, `Button`, `Text`, `Mapper`, `Record`, `Handler`처럼 sibling 이름에서 반복되는 안정된 역할
4. 실제 관계를 나타내는 `From`, `For`, `Of`, `Via`, `Without`
5. 플랫폼 타입을 감싸는 first-party facade를 일관되게 나타내는 `My`
6. resource, Scene, Prefab, slot, stage, schema version 또는 실제 순번과 대응하는 숫자

`MyButton`은 모양만 보고 위반으로 판정하지 않는다. `My`가 Unity 기본 타입과 구분되는 일관된 first-party facade 계층이면 정상이다. `FinderFromVariable`의 `From`도 실제 source 관계가 있다면 정상이다.

`GameObject`, `DateTime`, `TimeSpan`, `AudioSource`, `Texture2D` 같은 플랫폼 명칭은 공식 철자를 보존한다. 내부 대문자 경계를 first-party domain 계층으로 다시 해석하지 않는다.

## 잘못된 경계 {#failures}

### 존재하지 않는 계층을 만든다

`NickName`, `LifeTime`, `GamePlay`는 실제로 존재하지 않는 `Nick → Name`, `Life → Time`, `Game → Play` 구조를 선언한다.

### 실제 계층을 한 토큰 안에 숨긴다

Prefab에 `Title → Hud`가 있는데 `TitlehudStartButton`이라고 쓰거나, `Tile` domain과 `Logic` 역할이 분리돼 있는데 `Tilelogic`이라고 쓰면 실제 경계를 숨긴다.

### 임시 상태를 아키텍처처럼 남긴다

`PlayerInputBugTemp`, `ItemLogicTemp`에서 `Temp`가 소유·구조·역할이 아니라 단지 임시 수명 표지라면 의미 계층이 아니다. 장기간 존재하는 우회 책임이라면 `Workaround`처럼 실제 역할을 이름에 둔다.

### 필요한 표기 반복을 의미 중복으로 오판한다

중첩 클래스가 이름 충돌 때문에 짧은 `Arguments`를 쓸 수 없다면 `MyAsker.MyAskerArguments` 같은 표기가 필요할 수 있다. 이때 표면상 반복되는 두 번째 `MyAsker`는 새 의미 계층이 아니다. 의미 구조는 `MyAsker → Arguments`로 읽고, 언어 또는 스코프 제약에 따른 예외로 기록한다. `MyAsker.Arguments`로 기계적으로 줄이지 않는다.

### 이름의 범위와 구현의 범위가 다르다

Prefab만 인스턴스화하는 타입을 `AssetLoader`라고 부르거나, obstacle을 주로 담는 컨테이너를 `AgentContainer`라고 부르면 이름이 실제 책임보다 넓거나 좁다. 토큰 경계뿐 아니라 각 토큰의 내용도 구현과 맞아야 한다.

## 검토 순서 {#checklist}

새 이름이나 변경된 이름을 받아들이기 전에 다음을 확인한다.

1. 이름의 각 의미 토큰은 실제 구조·소유·관계·책임 중 무엇을 가리키는가?
2. 중간 토큰을 독립적으로 설명하거나 sibling 이름의 공통 행으로 묶을 수 있는가?
3. 두 토큰을 합치면 실제 계층을 숨기는가?
4. 한 토큰을 나누면 존재하지 않는 계층을 발명하는가?
5. 관련 소유 hierarchy, 코드나 데이터 model, domain 또는 역할 matrix가 경계를 뒷받침하는가?
6. `Temp`, `Old`, `New`, `Legacy`가 책임이 아니라 구현 시점만 나타내지는 않는가?
7. 같은 개념이 최신 first-party 코드에서 어떤 형태로 수렴했는가?
8. 겉보기 중복이 중첩 타입의 이름 충돌 같은 언어·스코프 제약 때문에 필요한가?
9. 이름 변경에 직렬화, resource, route, database, public API 또는 wire format migration이 필요한가?

## 적용 범위와 이력 {#scope}

이 규칙은 언어·엔진·플랫폼과 관계없이 코딩 중 생성하거나 변경하는 모든 first-party 이름에 적용한다. 타입, 멤버, module, package, file, resource, 직렬화 객체, DTO, persistence 타입, service 역할처럼 코드 식별자와 코드가 소유하는 이름을 모두 포함한다.

먼저 의미 계층을 정한 뒤 대상 컨벤션이 요구하는 문법, 구분자, casing으로 표현한다.

생성 코드, vendor, 외부 sample, dependency cache, framework 소유 이름은 first-party 일관성 판정에서 제외한다. 팀 프로젝트에서는 다른 작성자의 레거시와 사용자가 직접 만든 이름도 분리한다.

기존 관례를 추론할 때는 오래된 코드보다 최신 first-party 코드를 더 강한 증거로 본다. 레거시는 현재 규칙의 반례가 될 수는 있어도 새 코드의 선례로 자동 승격되지 않는다.

<div class="article-note">
  <p>명명 원리가 맞더라도 직렬화, resource, public API 또는 외부 계약을 깨는 일괄 rename은 별도 migration 작업이다. 안전한 참조 추적과 이전 계획 없이 스타일 정리만으로 실행하지 않는다.</p>
</div>

Unity C# 작업이라면 형식과 파일 구성 규칙을 <a href="{{ "/kr/unity/csharp-coding-convention.html" | relative_url }}">Unity C# 컨벤션</a>에서 이어서 다룬다.
