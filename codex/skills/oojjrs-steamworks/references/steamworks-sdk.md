# Steamworks SDK와 기능 통합

공식 시작점:

- https://partner.steamgames.com/doc/sdk?l=english
- https://partner.steamgames.com/doc/features?l=english
- https://partner.steamgames.com/doc/api?l=english

## 기능 분류

- 런타임: Stats, Achievements, Leaderboards, Rich Presence, Cloud, Input, Overlay, Screenshots, Timeline, Voice, HTML Surface
- 멀티플레이: Lobbies, Matchmaking, Game Servers, Steam Networking, Steam Datagram Relay, Remote Play
- 콘텐츠: Workshop·UGC, Inventory, Community Items, Playtest, DLC
- 신뢰·소유권: Authentication, App Tickets, Anti-cheat, Game Bans, DRM
- 상거래·서버: Microtransactions, Game Notifications, server stats, ownership checks
- 플랫폼: redistributables, SteamOS·Linux, VR, 접근성·하드웨어 연계

## 구현 흐름

1. 정확한 기능 페이지와 현재 API interface를 연다.
2. 프로젝트 엔진, 언어, 운영체제, SDK와 래퍼 버전을 확인한다.
3. 클라이언트, listen server, dedicated server, 보안 백엔드 중 신뢰 경계를 결정한다.
4. Partner 사이트에서 먼저 만들거나 활성화해야 하는 정의·설정을 확인한다.
5. 초기화, callback 처리, 오류, 종료 순서와 스레드 요구사항을 구현한다.
6. 개발 AppID와 테스트 계정으로 로컬 기능을 검증한다.
7. Steam 클라이언트·서버 로그와 Partner 설정을 대조한다.
8. 특정 프로젝트에서 확인한 범위만 VERIFIED_LOCAL 또는 VERIFIED_PARTNER로 기록한다.

## 엔진과 래퍼

- Valve가 문서화한 API 계약을 기준으로 삼고, Unity·Unreal·Godot·서드파티 래퍼의 메서드명과 수명 주기는 별도로 확인한다.
- 공식 기능 안내와 API 레퍼런스가 충돌하면 현재 API 레퍼런스의 deprecation 표시와 정확한 interface 계약을 우선하고, 사용 중인 SDK 헤더와 래퍼 버전에서 실제 노출 여부를 확인한다.
- 충돌이 해소되지 않으면 임의로 한쪽을 선택하지 말고 문서 불일치와 선택 가능한 구현 경로를 사용자에게 알린다.
- 래퍼가 현재 SDK 기능을 노출하지 않으면 프로젝트 어댑터 구현이 필요하다고 알린다.
- deprecated interface를 새 코드에 도입하지 않는다.
- Unity 코드나 자산을 변경하면 해당 oojjrs Unity 스킬과 프로젝트 규칙을 함께 적용한다.

## 안전 경계

- 인벤토리 지급, 통계 쓰기, Game Ban, 결제는 클라이언트를 신뢰하지 않는다.
- Microtransactions는 sandbox부터 검증하고 주문 생성·완료·환불을 금전 변경으로 취급한다.
- Game Ban은 공개 프로필과 접근 권한에 영향을 줄 수 있으므로 명시적 실행 지시 없이 적용하지 않는다.
- 실기기·Valve 심사 결과를 로컬 코드 성공으로 대체하지 않는다.
