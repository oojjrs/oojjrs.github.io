---
layout: page
title: "게임 UI 실무 노트"
lang: ko-KR
category: "GAME UI NOTES"
description: "FHD PC와 게임패드 지원을 기준으로 반복해서 참고할 UI 규격, 판단 근거, 측정 사례를 정리한 개인 작업 노트입니다."
permalink: /kr/unity/game-ui-notes/
toc_items:
  - id: current-standard
    label: "현재 작업 규격"
  - id: width-ratios
    label: "버튼 폭 비율"
  - id: controller
    label: "게임패드 기준"
  - id: know-how
    label: "설계 노하우"
  - id: measurements
    label: "측정 사례"
  - id: maintenance
    label: "노트 추가 형식"
---

[← Unity 문서]({{ "/kr/unity/" | relative_url }})
{: .article-backlink }

이 문서는 완성된 범용 규격서가 아니라, 게임 UI를 만들면서 반복해서 쓰는 결정과 판단법을 모아 두는 개인 작업 노트다. 실제 제작에 바로 적용할 값은 **규격**, 상황에 따라 재사용할 판단법은 **설계 노하우**, 결정을 검토할 때 참고한 관찰값은 **측정 사례**로 분리한다.
{: .article-lead }

> FHD PC에서 게임패드까지 지원하는 일반 버튼은 높이 60~64px가 무난하다. 새 8px 그리드에서는 64px를 기본으로 삼고, 기존 4px 그리드에서는 60px를 그대로 사용해도 된다.
{: .article-principle }

문서 상태: **초안 · 2026-08-02**. 아래 숫자는 프로젝트의 아트 스타일, 시청 거리, UI 배율에 따라 조정하되 어떤 이유로 바꿨는지 결정 기록에 남긴다.
{: .article-note }

## 현재 작업 규격 {#current-standard}

| 토큰 | 높이 | 행 피치 | 실제 글자 높이 | 주 용도 |
| --- | ---: | ---: | ---: | --- |
| `ButtonCompact` | 48px | 56px | 18~20px | 설정, 보조 기능, 조밀한 목록 |
| `ButtonStandard` | 64px | 72~76px | 24~26px | 일반 메뉴, 게임패드 지원 기본값 |
| `ButtonPrimary` | 72px | 84px | 26~28px | 시작, 확인, 구매 등 주요 행동 |
| `ButtonHero` | 96~100px | 개별 배치 | 28px 이상 | 화면에 하나뿐인 대형 CTA, 카드형 버튼 |

- `ButtonStandard`를 60px로 사용 중인 프로젝트는 억지로 64px로 바꾸지 않는다. 60px도 FHD 세로 높이의 약 5.6%로 충분하며 4px 그리드와 잘 맞는다.
- 64px는 FHD 세로 높이의 약 5.9%이고, 8px 그리드 및 1:1~6:1 폭 토큰을 만들기 편하다.
- 100px는 FHD 세로 높이의 약 9.3%다. 반복되는 메뉴 행에는 크고, 특별한 강조 요소에 적합하다.
- 세로 버튼 간 가시 간격은 마우스 중심 UI에서 8px, 게임패드 중심 UI에서 8~12px를 기본으로 한다.
- 글자 높이는 Unity나 그래픽 도구에 입력한 명목 폰트 크기가 아니라 화면에 렌더링된 ascender부터 descender까지의 실제 높이로 확인한다.

버튼에는 서로 다른 세 가지 높이가 있다.

| 구분 | 의미 | 확인할 것 |
| --- | --- | --- |
| 가시 높이 | 배경판과 테두리가 실제로 보이는 범위 | 장식과 투명 여백을 제외하고 잰다. |
| 히트·포커스 높이 | 마우스 클릭과 게임패드 포커스가 점유하는 범위 | 가시 높이와 같거나 더 크게 둔다. |
| 행 피치 | 다음 버튼 중심까지의 거리 | 가시 높이와 버튼 사이 간격을 합친다. |

32px짜리 작은 아이콘 아트가 필요하더라도 실제 히트 영역은 40~44px 이상 확보한다. 게임패드 UI에서는 히트 영역 자체보다 포커스가 차지하는 사각형과 이동 순서가 더 중요하다.

## 버튼 폭 비율 {#width-ratios}

높이는 입력 방식과 시청 거리로 정하고, 폭은 콘텐츠와 슬롯 역할로 정한다. 비율은 고정 폭이 아니라 최소 폭으로 사용한다.

| 비율 | 높이 60px | 높이 64px | 적합한 용도 |
| ---: | ---: | ---: | --- |
| 1:1 | 60×60 | 64×64 | 아이콘 전용 버튼 |
| 2:1 | 120×60 | 128×64 | 예/아니오, 짧은 단어 |
| 3:1 | 180×60 | 192×64 | 짧은 행동 라벨 |
| 4:1 | 240×60 | 256×64 | 일반 대화상자 버튼 |
| 6:1 | 360×60 | 384×64 | 긴 메뉴 행, 라벨과 우측 값 |

```text
실제 폭 = max(비율 × 높이, 좌우 패딩 + 아이콘 + 간격 + 현지화된 라벨 폭)
```

- 1:1 버튼은 아이콘 전용으로 사용하고 tooltip과 접근성 이름을 제공한다.
- 같은 세로 목록에서는 높이와 글자 기준선을 통일한다. 중요도는 높이를 뒤섞기보다 채움색, 대비, 위치, 폭으로 표현한다.
- 2:1이나 3:1을 정확한 고정 폭으로 강제하면 한국어, 독일어, 키 바인딩 glyph가 들어갈 때 쉽게 넘친다.
- 6:1은 긴 버튼이지 중요한 버튼이라는 뜻은 아니다.

## 게임패드 기준 {#controller}

게임패드는 작은 포인터로 버튼을 직접 맞히지 않는다. 따라서 무조건 큰 버튼을 만드는 것보다 현재 포커스와 다음 이동 위치가 즉시 읽히게 만드는 편이 중요하다.

- 기본 포커스 외곽선은 3~4px로 하고 레이아웃 바깥쪽에 그린다.
- 색상만 미세하게 바꾸지 않는다. 외곽선, 채움, 글자 굵기, 2~4% 확대 중 두 가지 이상을 함께 사용한다.
- 확대 애니메이션은 주변 레이아웃을 밀지 않도록 transform이나 overlay로 처리한다.
- 포커스 외곽선과 확대를 위해 버튼 주위에 최소 4px의 여유를 예약한다.
- 상하좌우 이동 결과가 화면 배치와 일치하도록 명시적인 navigation을 검토한다.
- 비활성 버튼도 읽을 수 있어야 하지만 활성 버튼이나 현재 포커스와 혼동되어서는 안 된다.
- 메인 메뉴처럼 멀리서 읽을 가능성이 있는 화면은 64~72px, 조밀한 설정 화면은 48~64px 안에서 밀도를 조절한다.

## 설계 노하우 {#know-how}

### 폭보다 높이를 먼저 정한다

- 적용 상황: 한 UI 시스템 안에 1:1부터 6:1까지 여러 폭의 버튼이 함께 존재할 때
- 권장: 입력 방식과 시청 거리로 높이 토큰을 먼저 고르고 폭은 콘텐츠에 맞춰 늘린다.
- 이유: 폭은 라벨과 현지화에 따라 바뀌지만 높이는 가독성, 행 리듬, 포커스 탐색을 결정한다.
- 예외: 카드, 탭, 툴바처럼 컨테이너 역할이 다른 요소는 별도의 높이 토큰을 둔다.

### 100px는 일반 버튼이 아니라 강조 토큰으로 남긴다

- 적용 상황: FHD에서 현재 버튼 높이가 100px이고 반복 메뉴가 크게 느껴질 때
- 권장: 일반 버튼은 60~64px로 내리고 96~100px는 `ButtonHero`로 보존한다.
- 이유: 크기를 모두 줄이는 대신 큰 규격의 역할을 제한하면 화면 위계가 생긴다.
- 예외: 소파 거리 TV UI, 커다란 이미지 카드, 접근성 확대 모드에서는 96~100px가 기본이 될 수 있다.

### 래스터 버튼은 단순 축소보다 9-slice를 우선한다

- 적용 상황: 100px 기준으로 제작된 배경 아트를 60~64px 규격으로 바꿀 때
- 권장: 모서리와 테두리를 고정하는 9-slice로 가시 높이를 조절한다.
- 이유: 전체 이미지를 60%대로 축소하면 테두리 두께와 픽셀 정렬이 흐려질 수 있다.
- 주의: 원본 이미지의 투명 여백이 RectTransform 높이에 포함되어 있으면 먼저 실제 배경판 높이를 잰다.

### 해상도보다 화면 높이 비율을 함께 기록한다

- 48px = FHD 세로 높이의 약 4.4%
- 60px = 약 5.6%
- 64px = 약 5.9%
- 72px = 약 6.7%
- 100px = 약 9.3%

울트라와이드에서도 버튼 크기는 가로 해상도보다 세로 해상도를 기준으로 유지한다. 1440p와 4K에서는 1080p 논리 캔버스를 기준으로 확대하되, 작은 해상도로 내릴 때 글자와 히트 영역이 접근성 하한 아래로 단순 축소되지 않게 한다.

## 측정 사례 {#measurements}

아래 값은 크롭되지 않은 1920×1080 스크린샷에서 잰 근사치다. 배경이 없는 텍스트 메뉴는 실제 히트박스가 아니라 인접 행의 중심 간격을 측정했다.

| 게임과 화면 | 측정 대상 | 약식 측정값 |
| --- | --- | ---: |
| Death Stranding 메인 메뉴 | 텍스트 메뉴 행 피치 | 40px |
| NieR:Automata 대화 선택지 | 선택 바 | 49~50px |
| Cyberpunk 2077 메인 메뉴 | 선택 외곽선 | 54px |
| Assassin's Creed Valhalla 메인 메뉴 | 일반 / 강조 버튼 | 60px / 82px |
| Hades 메인 메뉴 | 텍스트 메뉴 행 피치 | 70~71px |
| Overwatch 2 메인 메뉴 | 대형 텍스트 행 피치 | 72px |
| Control 메인 메뉴 | 가시 직사각형 버튼 | 80px |

사례 범위는 40~82px로 넓지만 일반적인 중심 구간은 50~64px였다. 이 표는 평균 규격을 강제하기 위한 통계가 아니라, 현재 프로젝트의 60~64px 결정이 상용 게임의 화면 밀도에서 벗어나지 않는지 확인하는 참고 자료다. 게임 내 UI 배율, 투명 히트박스, 최신 빌드 변경은 스크린샷만으로 확인할 수 없다.

<details>
  <summary>측정 원본과 접근성 참고 링크</summary>
  <p><small>측정 원본: <a href="https://interfaceingame.com/screenshots/death-stranding-main-menu/">Death Stranding</a> · <a href="https://interfaceingame.com/screenshots/nierautomata-dialoge-options/">NieR:Automata</a> · <a href="https://interfaceingame.com/screenshots/cyberpunk-2077-main-menu/">Cyberpunk 2077</a> · <a href="https://interfaceingame.com/screenshots/assassins-creed-valhalla-main-menu/">Assassin's Creed Valhalla</a> · <a href="https://interfaceingame.com/screenshots/hades-main-menu/">Hades</a> · <a href="https://interfaceingame.com/screenshots/overwatch-2-main-menu/">Overwatch 2</a> · <a href="https://interfaceingame.com/screenshots/control-main-menu/">Control</a></small></p>
  <p><small>접근성 참고: <a href="https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/101">Xbox XAG 101</a> · <a href="https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/113">Xbox XAG 113</a> · <a href="https://learn.microsoft.com/en-us/windows/apps/develop/input/guidelines-for-targeting">Microsoft Targeting</a> · <a href="https://www.rnib.org.uk/documents/2627/RNIB_Best_Practice_in_Accessible_Gaming.pdf">RNIB Accessible Gaming</a></small></p>
</details>

## 노트 추가 형식 {#maintenance}

새 노하우는 결론만 적지 않고 다음 형식으로 추가한다.

```text
### 노하우 제목

- 적용 상황:
- 권장:
- 이유:
- 예외:
- 주의:
```

확정된 숫자는 `현재 작업 규격`에 반영하고, 판단법은 `설계 노하우`에 남긴다. 외부 사례나 공식 문서는 `측정 사례` 또는 접힌 참고 링크에만 추가한다. 이렇게 하면 참고 링크가 늘어나도 실제 제작 규격과 개인 판단 노트가 뒤섞이지 않는다.

### 결정 기록

| 날짜 | 결정 | 이유 |
| --- | --- | --- |
| 2026-08-02 | 패드 지원 일반 버튼의 초안 기본값을 64px로 둔다. | 상용 게임 측정 중심 구간과 8px 그리드를 함께 만족한다. |
| 2026-08-02 | 기존 60px 규격도 허용한다. | 4px 그리드와 잘 맞고 FHD에서 충분한 가시 높이를 확보한다. |
| 2026-08-02 | 기존 100px 규격은 Hero 용도로 제한한다. | 반복 메뉴의 과도한 밀도를 줄이면서 강조 위계를 보존한다. |
