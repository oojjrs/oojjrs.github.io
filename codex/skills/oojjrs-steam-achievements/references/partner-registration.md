# Partner 등록 절차

2026-10-18에 Minesweeper Match(AppID 1552270)의 기존 67종을 보존하며 7종·10개 언어·아이콘 14개를 등록하고 게시한 절차다. 앱 ID·개수·언어·DOM은 예시이며 실제 대상과 현재 UI에서 확인한다.

## 자료와 기준 기록

프로젝트가 등록 원본과 exporter를 갖고 있으면 재사용한다. Mines의 경우 `Publish/Achievements/SteamRegistration.json`, `manifest.json`, `Export-SteamAchievements.ps1`을 사용한다. 임시 업로드·내보내기·검증 증거는 프로젝트 루트의 `$Trash` 아래에 둔다.

- 추가·수정 대상의 API 키를 코드 또는 확정 명세와 대조한다. 표시 이름과 API 키를 혼동하지 않는다.
- 숨김, Client/Server 처리, 세트, 보관 여부와 통계 연결을 그대로 유지한다. 조건이 문장에 있다는 이유로 진행 통계를 임의로 만들지 않는다.
- 지원 언어는 앱 설정과 등록 원본에서 읽는다. 이번 사례의 언어는 `koreana, english, japanese, schinese, tchinese, german, french, spanish, russian, brazilian`이었다.
- 기본 언어와 모든 지원 언어에 대해 이미 승인된 정확한 이름·설명만 준비한다. 누락 번역이나 새 문구는 먼저 대화에서 정확한 문구·대상·필요성을 제시하고 별도 허가를 받은 뒤에만 파일이나 편집기에 넣는다. 등록·CSV 생성·게시 허가로 문구 허가를 대신하지 않는다. 허가는 99% 거절된다고 전제하고, 요청한 결과에 반드시 필요한 경우에만 물으며 나머지는 질문 없이 생략한다. 번역이 승인된 범위에서는 플레이어에게 보여 줄 조건을 빠짐없이 보존한다.
- 원본과 기존 로컬 파일을 보호하고, 업로드용 변환본을 따로 만든다. 256×256 PNG의 `<api_name>_ACHIEVED.png`, `<api_name>_UNACHIEVED.png`를 준비한다. 승인된 흑백본이 있으면 Steam의 흑백 자동 생성 옵션을 끈다.

## CSV와 업로드

현재 UI의 정의·현지화 내보내기 CSV를 헤더의 기준으로 삼는다. 확인된 정의 헤더는 다음과 같았다.

```csv
api_name,setid,permission,spoiler,archived,progress_stat_name,progress_stat_min,progress_stat_max
```

진행 통계가 없는 Client 업적은 `permission`을 `Client`로 하고 진행 필드를 비운다. 숨김 업적은 `spoiler`를 `true`로 한다. 다른 필드 값은 기존·확정 설정을 따른다.

현지화 헤더는 `api_name,field,<지원 언어 열...>`이며 API 키마다 `field=name`, `field=description` 두 행을 사용한다. CSV quoting과 UTF-8을 보존한다. 내부 현지화 토큰을 CSV의 API 키 자리에 넣지 않는다.

1. `https://partner.steamgames.com/apps/achievementsbeta/<AppID>`의 업적 데이터가 로드되고 기존 개수가 보일 때까지 기다린다. 탭 제목만 먼저 보이는 상태에서 일괄 탭으로 전환하면 화면이 오류가 났던 사례가 있다.
2. `일괄 가져오기 및 내보내기`를 연다. 필요한 내보내기는 네이티브 download 이벤트로 받는다.
3. 파일 선택기 이벤트를 먼저 기다리고 `파일 선택...`을 누른다. 다중 선택 지원을 확인하고 절대 경로의 CSV 2개와 PNG 2N개를 선택한다. 이 UI에는 `.csv`·`.png`를 직접 올렸으며 ZIP은 전달·보관용이었다.
4. `성공(파일 ...개)`와 미리보기를 확인한다. 신규 N종이라면 `추가(N)`이어야 한다. `CSV에 없음(기존 개수)`는 대상만 올렸을 때 정상이며 `도전 과제 삭제`를 선택하지 않으면 기존 업적은 유지된다.
5. 대상 API 키, 전체 문구, 숨김·처리·세트·진행 통계, 컬러·흑백 두 아이콘이 연결됐는지 확인한 뒤 `저장`한다. 저장 완료 문구와 변경된 총개수를 기다린다.

브라우저 file upload 문서를 먼저 읽고 도구가 제공하는 filechooser API를 쓴다. Playwright `setInputFiles`가 제공된다고 가정하지 않는다. 예시 호출은 현재 도구 문서에 맞춰 조정한다.

```javascript
var chooserPromise = tab.playwright.waitForEvent('filechooser', {timeoutMs:10000});
await tab.playwright.getByRole('button', {name:'파일 선택...', exact:true}).click();
var chooser = await chooserPromise;
if (!chooser.isMultiple()) throw Error('Multiple upload unavailable');
await chooser.setFiles(uploadFiles);
```

## 저장 후 대조와 토큰

`https://partner.steamgames.com/apps/achievements/<AppID>`의 기존 편집기는 저장된 전체 행과 언어·토큰을 확인할 때 사용했다. 현재 DOM에서 표와 열의 의미를 먼저 확인한다. 당시 표는 `#achievementTable tbody tr[id]`, 언어 선택은 `#languageSelect`였다.

- 기존 행의 API 키·셀 내용·아이콘 URL을 저장 전 기록과 비교한다. 등록 대상 외 행이 바뀌면 게시하지 않는다.
- 각 지원 언어를 선택한 뒤 대상 이름이 로드되기를 기다리고 이름·설명을 원본과 정확히 비교한다. 검증 필드는 `대상 업적 수 × 언어 수 × 2`다.
- `token` 언어를 선택하고 실제 NAME·DESC 토큰을 읽는다. 이번 신규 토큰은 `<api_name>_NAME/DESC`였고, 기존에는 `NEW_ACHIEVEMENT_<번호>_<번호>_NAME/DESC` 형식도 있었다. 한 형식만 허용하는 정규식이나 번호 추정은 쓰지 않는다.
- 실제 업적 행 ID와 두 아이콘 URL도 보관한다. Partner는 업로드한 PNG를 공개 JPG로 변환할 수 있으므로 업로드 파일과 공개 파일의 바이트 해시가 같을 것이라고 요구하지 않는다.

## 게시

1. `게시` → `변경 사항 보기`에서 실제 diff를 기록하고 범위를 확인한다. 신규 업적뿐 아니라 다른 앱 설정까지 함께 게시될 수 있으므로 전체 변경 섹션을 읽는다.
2. `게시 준비`의 성공 상태를 기다린다. 이미지 없는 라이트 게시를 선택하지 않는다.
3. `Steam에 게시`에서 표시된 확인 문구와 내부 변경 설명을 입력하고 `진짜 게시`한다. 당시 확인 문구는 `STEAMWORKS`였다. 현재 화면의 문구를 따른다.
4. 진행 표시가 사라지고 결과가 성공인지 확인한다. 당시 결과는 `Publish to steam OK`, `Publishing successful!`이었다. 결과 화면을 증거로 저장한다.

게시가 타임아웃되면 완료 여부부터 읽는다. 같은 mutation을 결과 확인 없이 다시 보내지 않는다.

## 공개 확인과 로컬 동기화

`https://steamcommunity.com/achievements/<AppID>/?l=koreana` 또는 공식 Web API의 사용 가능한 스키마를 독립적인 공개 기준으로 사용한다. 이 사례의 커뮤니티 페이지는 `script#valve-ssr-data`의 `renderContext.queryData`에 `["achievements",AppID,"schema"]` 쿼리를 포함했다. 페이지 구조가 바뀌면 현재 공개 응답을 확인하고 파서를 조정한다.

- 기대하는 총개수와 대상 API 키, 이름·설명, 숨김·보관 여부, 두 아이콘을 확인한다. 기존 공개 업적은 앞서 기록한 값과 비교한다.
- 대상 두 아이콘 URL의 응답을 확인한다. 로컬에 이미 승인된 PNG가 있으므로 응답 성공과 올바른 연결을 확인하며 화풍을 다시 설계하지 않는다.
- 실제 토큰을 등록 원본에 기록한 다음 기존 exporter로 현지화 JSON·CSV·VDF를 재생성한다. 미확정 토큰과 누락 언어가 없어야 한다.
- 확인 일자·게시 및 초안 개수·검증 상태를 실제 증거에 맞춰 갱신한다. 기획 문서는 텍스트 추가 사전 허가 범위 안에서 기존 업적 항목만 갱신하고, 작업 카드에 필요한 결과를 반영한다.
- 게임의 Steam API 호출이나 런타임 달성 조건 검증은 별도 요청 범위다. 등록·게시 성공만으로 이를 검증했다고 보고하지 않는다.
