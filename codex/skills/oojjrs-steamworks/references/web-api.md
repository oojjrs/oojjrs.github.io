# Steamworks Web API

공식 시작점:

- https://partner.steamgames.com/doc/webapi_overview?l=english
- https://partner.steamgames.com/doc/webapi?l=english
- https://partner.steamgames.com/doc/webapi_overview/auth?l=english
- https://partner.steamgames.com/doc/webapi_overview/OAuth?l=english

## 인증 수준

- Public: 문서가 허용하는 공개 메서드만 사용한다.
- User key: Steam 계정과 도메인에 연결된 키의 허용 범위를 확인한다.
- Publisher key: publisher group, AppID, permission group, IP allowlist를 확인한다.
- OAuth: Valve가 발급하는 Client ID와 scope가 필요한지 확인한다.

Publisher key는 보안 서버에서만 사용한다. 게임 클라이언트, 모바일 앱, 저장소, 로그, 채팅에 포함하지 않는다. 보안 서버의 publisher 호출은 현재 공식 문서가 안내하는 partner.steam-api.com 호스트와 HTTPS를 우선한다.

## 요청 구현 흐름

1. Web API Reference에서 정확한 interface, method, version을 연다.
2. GET·POST 방식, form encoding 또는 input_json, 필수·선택 매개변수를 확인한다.
3. public, user, publisher, OAuth 중 필요한 인증을 판정한다.
4. publisher permission과 AppID group 범위를 최소화한다.
5. PowerShell·ASP.NET 등 현재 프로젝트의 서버 측 구현에 요청과 응답 모델을 만든다.
6. 문서화된 오류, 403, rate limit, 재시도 안전성을 처리한다.
7. 결제·인벤토리·통계 쓰기는 sandbox 또는 개발 앱에서 먼저 검증한다.
8. 비밀 값이 출력·예외·HTTP trace에 남지 않는지 확인한다.

## 구현 공백

범용 Web API 실행기는 아직 제공하지 않는다. 특정 메서드 요청이 들어오면 다음을 판단한다.

- 현재 프로젝트용 안전한 서버 구현이 없으면 project_specific 또는 implementation_required로 알린다.
- OAuth Client ID, publisher permission, AppID group이 없으면 외부 전제 부족으로 알린다.
- 응답 schema와 성공 판별을 검증하지 못하면 VERIFIED_LOCAL로 올리지 않는다.
