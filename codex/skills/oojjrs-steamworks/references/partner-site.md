# Steamworks Partner 사이트 작업

## 목차

1. 계정과 권한
2. 앱·상점·배포 구성
3. 심사와 출시
4. 판매·마케팅·커뮤니티
5. 재무·계약
6. 접근성·하드웨어·VR·PC Café
7. 브라우저 작업 규칙

## 1. 계정과 권한

시작점: https://partner.steamgames.com/doc/gettingstarted?l=english

- 파트너, 앱, AppID, 사용자 group과 현재 권한을 먼저 식별한다.
- 사용자를 추가하거나 group·앱 접근을 바꾸려면 관리자 권한을 확인한다.
- Actual Authority가 필요한 계약, 앱 이전, 은행·세금·지급 변경은 사용자 결정을 대신하지 않는다.
- Steam Direct Fee, Content Survey, 연령 등급과 현재 지역 요구사항은 최신 하위 문서를 다시 확인한다.

## 2. 앱·상점·배포 구성

시작점: https://partner.steamgames.com/doc/store?l=english

- 앱, build, branch, depot, package, demo, DLC, soundtrack, bundle, platform을 정확한 ID로 구분한다.
- Coming Soon, Early Access, editions, free-to-play, localization, tags, trailers와 written description 요구사항을 해당 페이지에서 확인한다.
- 그래픽 자산 규격은 생성 전에 현재 Graphical Assets 하위 페이지를 확인한다. 이미지 제작이 필요하면 $oojjrs-image-first-art-workflow와 imagegen을 함께 사용한다.
- 가격, 통화, subscription, pre-purchase, season pass는 지역·심사·일정 조건을 확인한다.
- 저장과 Publish를 구분하고, 공개되는 변경은 바로 앞 사용자 지시에 대상이 명시된 경우에만 실행한다.

## 3. 심사와 출시

- 상점 페이지와 제품 build의 현재 review 요구사항을 각각 확인한다.
- 개발 build를 Steam 클라이언트에서 설치·실행하고 launch option, package depot 포함, 언어·플랫폼을 검증한다.
- 출시 날짜, release option, default branch, 공개 범위를 교차 확인한다.
- Valve 승인 대기는 구현 부족이 아니라 external 상태로 기록한다.
- 앱 제거·이전과 실제 출시를 되돌리기 어려운 외부 작업으로 취급한다.

## 4. 판매·마케팅·커뮤니티

시작점: https://partner.steamgames.com/doc/marketing?l=english

- discount, seasonal sale, event, announcement, livestream, Curator Connect, follower, community moderation과 traffic report를 현재 일정·가이드에 따라 처리한다.
- 공개 공지, 이벤트, sale page, 할인 제출은 초안을 먼저 검토하고 명시적 실행 지시 후 게시한다.
- Steam Keys는 현금성 자산으로 취급한다. 생성·다운로드·ban 대상과 수량을 재확인한다.
- community ban과 Game Ban을 혼동하지 않는다.

## 5. 재무·계약

시작점: https://partner.steamgames.com/doc/finance?l=english

- reporting, payment, refund, tax 문서를 최신 상태로 확인한다.
- 재무 정보를 설명할 수는 있지만 세무·법률 판단을 대신하지 않는다.
- 은행·세금·지급·계약 변경은 Actual Authority와 사용자의 즉시 지시가 필요하다.
- Sales Data API에는 publisher key와 해당 permission이 필요한지 확인한다.

## 6. 접근성·하드웨어·VR·PC Café

- 접근성: https://partner.steamgames.com/doc/accessibility_features?l=english
- 하드웨어·Proton: https://partner.steamgames.com/doc/steamhardware?l=english
- VR: https://partner.steamgames.com/doc/features/steamvr?l=english
- PC Café: https://partner.steamgames.com/doc/sitelicense?l=english

게임에서 검증하지 않은 접근성 기능을 Partner Wizard에 표시하지 않는다. Deck·Machine·Frame·Proton·OpenXR·SteamVR은 로컬 또는 실기기 테스트와 Valve Compatibility Review를 분리한다. PC Café는 일반 소비자 배포와 다른 계약·라이선스 경계를 가진다.

## 7. 브라우저 작업 규칙

1. 가능한 경우 로그인된 in-app browser 또는 Chrome 세션을 사용한다.
2. 로그인·Steam Guard·새 보안 승인은 사용자가 직접 처리하게 한다.
3. 저장 전 현재 AppID와 페이지 제목을 확인한다.
4. 변경 전후 값을 기록하고 성공 알림 또는 페이지 상태를 검증한다.
5. 권한이 없으면 구현 부족으로 오표시하지 말고 permission_required로 보고한다.
