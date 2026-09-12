# SteamCMD와 SteamPipe

공식 시작점:

- https://partner.steamgames.com/doc/sdk/uploading?l=english
- https://partner.steamgames.com/doc/sdk?l=english

## ContentBuilder 구조

- builder\steamcmd.exe: Steam 명령줄 클라이언트
- content: Depot에 매핑할 게임 파일
- output: 로그, chunk cache, 중간 출력
- scripts: app build와 depot build VDF

output은 공식 문서상 삭제 가능한 디렉터리이므로 정적 검사에서 누락을 경고로만 처리한다. content와 scripts 누락은 실제 빌드 준비가 되지 않은 상태이다.

## 단계별 지원

1. 정적 경로·레이아웃 검사: scripts/Test-SteamworksEnvironment.ps1로 구현됨
2. app build·depot VDF 생성: scripts/Publish-SteamPipeBuild.ps1로 구현됨
3. Preview 빌드 실행과 manifest 검사: scripts/Publish-SteamPipeBuild.ps1로 구현됨
4. 실제 chunk 업로드와 BuildID 확인: scripts/Publish-SteamPipeBuild.ps1로 구현됨
5. beta branch 또는 default branch Set Live: Partner 브라우저와 권한 필요

Preview 구성과 실제 업로드 구성은 별도 실행 단계로 취급한다. Preview 성공을 실제 업로드 성공으로 간주하지 말고, Preview 결과와 output 로그를 검증한 뒤 업로드 동작을 다시 명시적으로 확정한다.

배포 스크립트는 AppID, DepotID, ContentRoot, SteamCmdPath, BuildOutput, SteamUser를 명시적으로 받고 프로젝트 파일에 복제하지 않는다. Preview 성공 뒤 실제 Upload를 별도 호출하며, beta SetLive는 `-SetLive -Branch <name>`을 모두 전달한 경우에만 포함한다. default branch SetLive는 항상 Partner에서 수동으로 수행한다.

## 안전 규칙

- SteamCMD는 실행만 해도 부트스트랩·자동 업데이트와 파일 변경이 발생할 수 있다.
- 정적 검사에서는 SteamCMD를 실행하거나 config.vdf, build script, 로그인 토큰을 읽지 않는다.
- 비밀번호나 Steam Guard 코드를 명령줄 인자·스크립트·로그에 넣지 않는다.
- 로그인과 2단계 인증은 사용자가 직접 처리하고, 보존된 로그인 토큰을 저장소에 복사하지 않는다.
- AppID, DepotID, ContentRoot, BuildOutput, 파일 매핑·제외 규칙을 Preview 전에 검토한다.
- 업로드 계정의 현재 앱 권한을 확인한다.
- Preview 결과와 output 로그를 검증하기 전 실제 업로드로 진행하지 않는다.
- 새 빌드는 테스트 branch에서 설치·실행한 뒤 공개 branch로 전환한다.
- Set Live, 출시, 기본 branch 변경은 업로드와 별도 외부 작업으로 취급한다.

## 정적 검사 사용

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<skill-dir>\scripts\Test-SteamworksEnvironment.ps1" -Path "<steamcmd-or-contentbuilder-path>"

결과의 Safety 항목은 실행·네트워크·쓰기·비밀정보 접근이 없었는지 보여 준다. OperationalReadiness가 Unverified인 것은 정상이며, 이 검사만으로 로그인·권한·업로드 가능성을 주장하지 않는다.

## Preview와 업로드 사용

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<skill-dir>\scripts\Publish-SteamPipeBuild.ps1" -AppId <appid> -DepotId <depotid> -ContentRoot "<content>" -SteamCmdPath "<steamcmd.exe>" -BuildOutput "<output>" -SteamUser "<builder>" -Mode Preview -Branch "<beta>" -RequiredFiles @("<exe>")

Preview가 검증된 뒤 같은 입력으로 `-Mode Upload`를 별도 실행한다. 실제 업로드만 하고 브랜치를 바꾸지 않으려면 `-SetLive`를 생략한다. 비밀번호와 Steam Guard 코드는 인자로 전달하지 않는다.
