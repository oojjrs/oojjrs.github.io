# Steamworks 공식 문서 지도

## 출처 정책

- 현재 영문 Steamworks 문서를 최우선으로 사용한다.
- 사용자가 특정 문서 URL을 주거나 최신 규격·일정·권한·API를 묻는 경우 해당 공식 페이지를 작업 시점에 다시 연다.
- 번역 페이지가 영문보다 오래되었다는 경고를 표시하면 영문 페이지를 기준으로 판단한다.
- 엔진 플러그인·래퍼·커뮤니티 자료는 보조 자료로만 사용하고, Steamworks 계약과 API 동작은 공식 문서로 검증한다.
- 정적 문서 지도를 완전한 사본으로 간주하지 않는다. 문서 홈 검색 결과가 현재 범위를 결정한다.
- 공식 페이지에 접근하지 못하면 정적 지도는 라우팅에만 사용하고 verification.documentation을 unverified_current로 기록한다. 현재성에 민감한 변경은 재확인 전까지 수행하지 않는다.

## 최상위 라우팅

| 영역 | 공식 시작점 | 기본 실행 채널 |
|---|---|---|
| 전체 문서 검색 | https://partner.steamgames.com/doc/home?l=english | 안내·라우팅 |
| 시작·계정·앱 관리 | https://partner.steamgames.com/doc/gettingstarted?l=english | Partner 브라우저 |
| 상점·앱·패키지·출시 | https://partner.steamgames.com/doc/store?l=english | Partner 브라우저 |
| 통합 기능 | https://partner.steamgames.com/doc/features?l=english | SDK·Web API·Partner 브라우저 |
| 재무·세금·지급 | https://partner.steamgames.com/doc/finance?l=english | Partner 브라우저·안내 |
| 판매·마케팅·커뮤니티 | https://partner.steamgames.com/doc/marketing?l=english | Partner 브라우저·안내 |
| Steamworks SDK | https://partner.steamgames.com/doc/sdk?l=english | SDK·로컬 도구 |
| 클라이언트·게임 서버 API | https://partner.steamgames.com/doc/api?l=english | Steamworks SDK |
| SteamPipe 업로드 | https://partner.steamgames.com/doc/sdk/uploading?l=english | SteamCMD·Partner 브라우저 |
| Web API 개요 | https://partner.steamgames.com/doc/webapi_overview?l=english | 보안 서버·HTTP |
| Web API 전체 목록 | https://partner.steamgames.com/doc/webapi?l=english | 보안 서버·HTTP |
| 접근성 | https://partner.steamgames.com/doc/accessibility_features?l=english | 게임 검증·Partner 브라우저 |
| Steam 하드웨어·Proton | https://partner.steamgames.com/doc/steamhardware?l=english | 로컬·실기기·Partner 브라우저 |
| SteamVR | https://partner.steamgames.com/doc/features/steamvr?l=english | SDK·실기기 |
| PC Café | https://partner.steamgames.com/doc/sitelicense?l=english | Partner 브라우저·안내 |

## 페이지 선택 규칙

1. 사용자의 표현을 위 영역 중 하나 이상으로 분류한다.
2. 시작점에서 정확한 하위 기능 페이지를 찾는다.
3. API 메서드, 권한, 파일 규격, 가격·할인 일정, 심사 조건은 하위 페이지를 직접 확인한다.
4. deprecated 경고와 SDK·API 버전을 확인한다.
5. 최종 보고에 실제로 근거로 사용한 공식 URL만 남긴다.
