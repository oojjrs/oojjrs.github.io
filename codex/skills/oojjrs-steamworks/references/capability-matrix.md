# Steamworks 기능 라우팅과 상태

## 상태 축

상태를 하나의 완료 값으로 합치지 않는다. 다음 축을 별도로 기록한다.

- documentation: documented 또는 unknown
- verification.documentation: verified_current 또는 unverified_current
- implementation: implemented, project_specific, not_implemented
- verification.local: verified 또는 unverified
- verification.partner: verified 또는 unverified
- availability: available, input_required, permission_required, implementation_required, external

availability는 동시에 존재하는 차단 조건을 모두 기록할 수 있다. `available`은 다른 차단 조건이 없을 때만 단독으로 사용한다.

지원 수준을 요약해야 할 때만 다음 표현을 사용한다.

- ROUTED: 공식 문서와 실행 채널만 식별됨
- SCAFFOLDED: 코드·설정·절차 초안을 만들 수 있으나 실제 환경 미검증
- VERIFIED_LOCAL: 로컬 검사·preview·컴파일·응답 파싱을 검증함
- VERIFIED_PARTNER: 특정 AppID와 Partner 환경에서 성공을 검증함
- EXTERNAL: Valve 심사·계약·실기기·사람의 판단이 최종 단계임

## 초기 기능 표

| 기능 ID | 채널 | Documentation | Doc check | Implementation | Local | Partner | 초기 Availability |
|---|---|---|---|---|---|---|---|
| docs.routing | 공식 웹 문서 | documented | unverified_current | implemented | verified | unverified | available |
| tooling.steamcmd.static-discovery | PowerShell | documented | unverified_current | implemented | verified | unverified | input_required |
| steampipe.build-files | PowerShell·VDF | documented | unverified_current | implemented | verified | unverified | input_required |
| steampipe.preview | SteamCMD | documented | unverified_current | implemented | verified | unverified | input_required + permission_required |
| steampipe.upload | SteamCMD | documented | unverified_current | implemented | verified | unverified | input_required + permission_required |
| steampipe.branch.set-live | Partner 브라우저 | documented | unverified_current | project_specific | unverified | unverified | input_required + permission_required |
| sdk.client-feature | SDK·프로젝트 코드 | documented | unverified_current | project_specific | unverified | unverified | input_required |
| sdk.game-server | SDK·서버 코드 | documented | unverified_current | project_specific | unverified | unverified | input_required |
| webapi.request | 보안 서버·HTTP | documented | unverified_current | project_specific | unverified | unverified | input_required |
| partner.store.configure | Partner 브라우저 | documented | unverified_current | project_specific | unverified | unverified | input_required + permission_required |
| partner.discount.submit | Partner 브라우저 | documented | unverified_current | project_specific | unverified | unverified | input_required + permission_required |
| partner.release.publish | Partner 브라우저 | documented | unverified_current | project_specific | unverified | unverified | input_required + permission_required |
| partner.finance-and-contract | Partner 브라우저 | documented | unverified_current | project_specific | unverified | unverified | input_required + permission_required + external |
| hardware.compatibility | 로컬·실기기·Valve 심사 | documented | unverified_current | project_specific | unverified | unverified | input_required + external |

이 표는 범용 스킬의 초기 상태이다. 특정 프로젝트에서 성공했더라도 다른 AppID·엔진·계정에 VERIFIED_PARTNER를 자동 전파하지 않는다.

## 구현 필요 판정

다음이면 implementation_required로 분류한다.

- 요청한 기능 ID가 표에 없고 실행 절차도 없다.
- implementation이 not_implemented이다.
- 필요한 어댑터, script, template, validator가 없다.
- 공식 문서와 현재 자동화의 입력·출력·권한이 다르다.
- 안전한 테스트 또는 성공 판별 경로가 없다.

입력·권한·인증·Valve 승인 부족은 각각 input_required, permission_required, external로 분류하고, 둘 이상이면 모두 남긴다. 공식 페이지를 이번 작업에서 열지 못했으면 구현 여부와 별개로 verification.documentation을 unverified_current로 둔다.

## 사용자 알림 형식

    구현 필요 — 기능명
    기능 ID: capability-id
    현재 상태: 문서화 / 문서 현재성 / 구현 / 로컬 검증 / Partner 검증 / 가용성
    발견 지점: 요청 또는 실패한 단계
    부족한 부분: adapter, script, template, validator 중 해당 항목
    공식 근거: 현재 Steamworks 문서 URL
    필요한 입력·권한: AppID, DepotID, 프로젝트, 권한 등
    현재 가능한 범위: 문서 확인, 코드 초안, 정적 검사 등
    제안 구현: 파일명과 검증 방법

구현은 있으나 실계정 검증만 안 되었으면 실사용 검증 필요로, 구현은 되었지만 입력이나 권한이 없으면 차단으로 알린다.
