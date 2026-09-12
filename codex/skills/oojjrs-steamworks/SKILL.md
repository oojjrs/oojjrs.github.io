---
name: oojjrs-steamworks
description: Plan, implement, diagnose, validate, and operate Steamworks integrations from Valve's current official documentation. Use when Codex needs to work with Steamworks SDK APIs, Steam Web API, SteamCMD, SteamPipe builds and depots, app or depot configuration, achievements, stats, leaderboards, Steam Cloud, lobbies, matchmaking, networking, Workshop, DLC, authentication, dedicated servers, store or release setup, or other Steam partner tasks, including identifying an unimplemented capability and telling the user what must be added before proceeding.
---

# oojjrs Steamworks

Steamworks 문서 전체를 외워서 재현하지 말고, 사용자의 요청을 최신 Valve 공식 문서와 올바른 실행 채널로 연결한다. 구현 여부와 실계정 검증 여부를 분리하고, 부족한 자동화가 발견되면 사용자에게 명시적으로 알린다.

## 핵심 원칙

1. 공통 수명주기 라우팅은 이미 적용되었다고 가정하고, 이 스킬에서는 Steamworks 절차와 관련 공식 문서만 추가한다.
2. 매 작업에서 [공식 문서 지도](references/official-documentation-map.md)를 읽고 관련 최신 영문 Steamworks 문서를 다시 확인한다.
3. 공식 문서를 복제해 오래된 사본을 만들지 않는다. 이 스킬에는 라우팅, 안전 경계, 검증 절차, 재사용 자동화만 둔다.
4. Steamworks SDK, Web API, SteamCMD/SteamPipe, Partner 사이트, 안내 전용 작업을 구분한다.
5. 문서에 있다는 사실을 구현 완료나 실계정 검증 완료로 표현하지 않는다.
6. 비밀번호, Steam Guard 코드, 세션 토큰, 쿠키, Web API 키를 채팅·저장소·명령줄 인자에 넣지 않는다.

## 작업 흐름

1. 요청의 대상 앱, AppID, 프로젝트, 엔진, 운영체제, 원하는 결과를 식별한다.
2. [기능 라우팅과 상태 표](references/capability-matrix.md)에서 실행 채널과 현재 지원 수준을 확인한다.
3. 공통 참조인 문서 지도와 상태 표 외에는 분야별 참조 파일만 1~2개 읽고 해당 공식 문서 페이지를 연다.
4. 필요한 입력, 권한, 로그인 상태, 테스트 앱·브랜치·sandbox·preview 경로를 확인한다.
5. 읽기 전용 점검과 로컬 검증을 먼저 수행한다.
6. 사용자가 요청한 범위에서 구현된 안전한 단계는 끝까지 수행한다.
7. 외부 변경 전에 대상 AppID, DepotID, 패키지, 브랜치, 공개 범위를 다시 확인한다.
8. 결과를 로그, API 응답, Partner 페이지 상태, Steam 클라이언트 설치·실행 결과 중 적합한 증거로 검증한다.
9. 지원 수준과 남은 구현 공백을 보고한다.

## 참조 선택

- SDK 통합, 업적, 통계, Cloud, Input, 네트워킹, Workshop, 서버 기능에는 [Steamworks SDK](references/steamworks-sdk.md)를 읽는다.
- HTTP API, 사용자 인증, 소유권, publisher key, OAuth, 서버 기능에는 [Web API](references/web-api.md)를 읽는다.
- SteamCMD, ContentBuilder, VDF, Depot, Preview, 업로드, 브랜치에는 [SteamCMD와 SteamPipe](references/steamcmd-steampipe.md)를 읽는다.
- 온보딩, 앱·패키지·DLC, 상점, 가격, 출시, 마케팅, 재무, 접근성, 하드웨어에는 [Partner 사이트 작업](references/partner-site.md)을 읽는다.
- 구현·검증·차단 상태를 판단하거나 부족한 기능을 알릴 때는 [기능 라우팅과 상태 표](references/capability-matrix.md)를 읽는다.

공식 문서 홈에 새 영역이 추가되었거나 지도에 없는 문서가 요청되면 문서 홈 검색으로 정확한 현재 페이지를 찾고 ROUTED 상태로 처리한다. 그 작업을 수행할 실행 경로가 없으면 구현 필요로 보고한다.

공식 페이지에 접근할 수 없으면 정적 문서 지도로 라우팅만 하고 문서 현재성을 `unverified_current`로 보고한다. 가격·할인 일정, 권한, 파일 규격, API 폐기 여부처럼 현재성에 따라 결과가 달라지는 작업은 페이지를 다시 확인할 때까지 실행하지 않는다.

## SteamCMD 정적 점검

사용자가 SteamCMD 실행 파일, builder, ContentBuilder, Steamworks SDK 루트 중 하나의 경로를 제공하면 다음 읽기 전용 검사기를 사용한다.

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<skill-dir>\scripts\Test-SteamworksEnvironment.ps1" -Path "<path>"

이 검사는 SteamCMD를 실행하지 않고 파일과 ContentBuilder 레이아웃만 확인한다. SteamCMD는 실행 시 부트스트랩과 자동 업데이트가 발생할 수 있으므로 버전 확인만을 위해 실행하지 않는다.

## SteamPipe 배포 자동화

Preview와 실제 업로드에는 `scripts/Publish-SteamPipeBuild.ps1`을 사용한다. 프로젝트 저장소에 이 스크립트나 생성 VDF를 복제하지 말고, AppID·DepotID·ContentRoot·SteamCmdPath·BuildOutput·SteamUser와 필수 파일을 실행 인자로 전달한다. Preview와 Upload는 별도 호출하며 `-SetLive`는 사용자가 정확한 beta branch 변경을 요청한 경우에만 쓴다. default branch는 자동 SetLive하지 않는다.

## 구현 공백 처리

다음 중 하나면 즉시 구현 필요를 알린다.

- capability matrix에서 implementation이 not_implemented이다.
- 현재 엔진·언어·CI에 맞는 어댑터, VDF 생성기, 요청 실행기, validator가 없다.
- 공식 문서 또는 Partner UI가 기존 절차와 달라졌다.
- 안전한 preview·sandbox 또는 성공 판별 방법이 없다.
- 첫 실제 사용에서 scaffold가 실패하거나 결과를 검증할 수 없다.

AppID·경로·권한·로그인 부족, Valve 심사 대기, OAuth Client ID 발급 대기, 실기기 부재는 구현 부족과 구별한다. 현재 요청이 구현 자체를 포함하지 않으면 범용 스킬을 조용히 확장하지 말고 부족한 부분과 제안 파일을 먼저 알린다.

## 외부 변경 경계

다음은 사용자의 바로 앞 지시에 정확한 대상과 동작이 포함된 경우에만 수행한다.

- 빌드 업로드, Partner 설정 저장·게시, 베타 브랜치 변경
- 가격·할인 제출, 공개 공지·이벤트·상점 페이지 게시
- 기본 브랜치 Set Live, 출시, 앱 제거·이전
- Steam Key 생성·다운로드·차단, Game Ban
- 은행·세금·지급 정보, 계약, publisher key·OAuth 설정 변경

로그인과 2단계 인증은 사용자가 직접 처리하게 한다. publisher key는 보안 서버에서만 사용하고 게임 클라이언트나 저장소에 포함하지 않는다.

## 보고

결과와 함께 다음을 짧게 보고한다.

- 사용한 공식 문서 URL과 실행 채널
- 구현 상태, 로컬 검증 상태, Partner 검증 상태
- 실제로 변경된 AppID·DepotID·브랜치·설정
- 확인하지 못한 권한·로그인·심사·실기기 조건
- 구현이 필요하면 기능 ID, 부족한 구성요소, 현재 가능한 범위, 제안 구현
