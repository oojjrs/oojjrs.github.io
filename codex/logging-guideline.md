# 로그 작성 지침

코드에 로그를 추가하거나 기존 로그를 수정하기 전에 이 문서를 읽는다. 이 문서는 직접 작성하는 애플리케이션·게임·도구 코드의 로그에 적용하며, 제3자 패키지와 자동 생성 코드는 제외한다.

## 목적과 우선순위

로그는 단순한 개발 출력이 아니라 실행 순서 검증, 사용자 리포트 분석, 경고 제거, 내부 동작 확인, UX 분석을 위한 기록이다. 로그를 작성할 때는 먼저 로그의 종류를 결정한 다음 그 종류의 언어·형식·수명 규칙을 적용한다.

우선순위는 현재 프로젝트의 명시적 규칙, 이 문서, 사용하는 로깅 프레임워크의 규칙 순서다. 로그 호출부를 수정하는 C# 코드는 `unity-csharp-coding-convention.md`도 함께 따른다.

## 공통 형식

1. 사용자에게 전달되거나 자동 비교에 사용되는 영어 로그의 고정 문구는 모두 대문자로 작성한다.
2. 변수, 필드, 객체 이름, ID, 키, 계정, 닉네임, 타입 이름, 경로, 인덱스, 상태, 크기, 개수, 시간 등 실행 중 결정되는 identifier는 모두 보간식 `{expression}`으로 참조한다.
3. 문자열 연결보다 보간 문자열 `$"..."`을 사용한다.
4. identifier의 실제 값은 대문자로 변환하지 않는다.
5. 일반 로그의 최종 출력에는 행위 주체자가 가장 앞에 `{actor}> ` 형태로 있어야 한다. 호출 문자열에 직접 작성하거나 태그가 설정된 로거가 시스템적으로 붙일 수 있으며, 로거가 붙이는 경우 호출부에서 중복 작성하지 않는다. 주체자는 객체 이름, 타입 이름, 사용자·세션 ID, 연결 이름, 컨트롤러 이름처럼 사건을 발생시킨 시스템이나 인스턴스를 식별해야 한다. catch된 예외 객체를 그대로 출력하는 예외 로그는 이 규칙에서 제외한다.
6. 분류와 값은 ` : `, 주체와 사건은 `> `, 상태 변화는 ` -> `로 구분한다.
7. 완결된 사건·상태 문장은 마침표로 끝낸다. 값 목록이나 구조화된 표제형 로그는 마침표를 생략할 수 있다.
8. 비밀번호, 인증 토큰, 개인식별정보처럼 리포트나 외부 저장소에 남아서는 안 되는 값은 기록하지 않는다.
9. catch된 예외는 행위 주체자나 설명 문구를 조합하지 않고 `e`를 그대로 예외 API에 전달한다. 문자열을 요구하는 기존 서버 로거에는 `e.ToString()`을 그대로 전달한다. 기존 태그 로거가 시스템적으로 태그를 붙이는 것은 그대로 두되, 예외 로그를 위해 새 태그를 만들거나 호출 문자열을 장식하지 않는다.

```csharp
Debug.Log($"{name}> ENABLED.");
Debug.Log($"{GetType().Name}> APP STEP : {_step} -> {value}");
Debug.LogWarning($"{GetType().Name}> NO HANDLERS : {request.GetType().Name}");
Debug.LogException(e);
```

`{}`는 출력 결과에 중괄호를 표시하라는 뜻이 아니다. 소스에서 고정 문구와 identifier 참조를 명확히 분리하라는 뜻이다.

## 행위 주체자와 시스템 태그

행위 주체자는 로그를 읽는 사람이 “누가 이 일을 했는가?”를 최종 출력의 첫 토큰에서 바로 알 수 있게 하는 필수 필드다. 로그 메시지 안에 대상 identifier가 있더라도 행위 주체자를 대신하지 않는다. 이 규칙은 호출 문자열의 모양이 아니라 실제로 저장·전송·표시되는 최종 로그를 기준으로 판단한다.

```text
{actor}> EVENT : {target}
```

- 인스턴스 동작은 `{name}>`, 컴포넌트·서비스 동작은 `{GetType().Name}>`를 기본으로 한다.
- 사용자 요청은 사용자·세션과 처리 시스템을 조합한 `{memberId}:{GetType().Name}>` 형태를 사용할 수 있다.
- 네트워크 연결은 `{connectionName}>`, `{remoteEndpoint}:{GetType().Name}>`처럼 연결과 처리 계층을 식별한다.
- 자식 객체나 도메인 계층은 소유자에게 받은 태그에 자신의 타입을 덧붙일 수 있다. 예: `{ownerId}:{GetType().Name}>`.
- 앱 전체에서 한 번 호출되는 전역 생명주기·환경·네트워크 로그도 주체자를 생략하지 않고 예약 전역 태그를 사용한다.
- `SEND>`, `RECV>`, `RECEIVED>`, `HANDLED>`는 네트워크 단계 자체를 주체처럼 사용해 온 제한적 축약형이다. 연결·요청이 여러 개 섞일 수 있으면 축약하지 말고 `{connection}> SEND : {packet}`처럼 실제 주체자를 앞에 둔다.
- 주체자를 정하기 어렵거나 기존 로그에 주체자가 없다면 생략을 기본값으로 삼지 않는다. 어느 객체·시스템·요청 컨텍스트가 책임져야 하는지 설계를 다시 검토한다.
- catch된 예외를 그대로 출력하는 로그는 예외다. `Debug.LogException(e)`, `logger.WriteExceptionLine(e.ToString())`, `Console.WriteLine(e)`처럼 예외 자체만 전달하며 명시적 주체자나 별도 영문 문구를 덧붙이지 않는다.

### 예약 전역 태그

- `SYSTEM>`: 애플리케이션 전체의 시작·종료, 부팅, 전역 초기화 시작·완료, 초기화 단계 전환을 기록한다.
- `ENV>`: 빌드, 플랫폼, 런타임, 하드웨어, 언어, 시간대, 해상도, 실행 인자와 환경 설정값을 기록한다.
- `NETWORK>`: 특정 연결·소켓·클라이언트에 귀속되지 않는 전역 네트워크 관리자, 리스너, 공용 연결 상태를 기록한다.
- `NET>`으로 줄이지 않는다. `.NET`과 혼동될 수 있고 검색성과 즉시 판독성이 떨어지므로 `NETWORK>`를 사용한다.
- 구체적인 컴포넌트나 연결 주체자가 있으면 예약 전역 태그보다 `{component}>`, `{connection}>`, `{remoteEndpoint}>` 같은 실제 주체자를 우선한다.

```text
SYSTEM> APPLICATION START.
SYSTEM> INITIALIZE BEGIN.
ENV> BUILD : {version} ({configuration})
ENV> PLATFORM : {platform}
NETWORK> LISTEN : {endpoint}
{connectionName}> CONNECTED : {remoteEndpoint}
SYSTEM> INITIALIZE END.
```

주체자 표기는 개별 호출부의 기억에만 맡기지 않는다. 상위 부모 클래스, 공통 로거, 미들웨어, 컨트롤러 베이스, 패킷 핸들러 팩터리에서 태그를 한 번 받고 모든 하위 로그에 시스템적으로 붙이는 방식을 우선한다. 태그가 설정된 로거의 호출 문자열은 사건만 작성하며 `{actor}>`를 다시 넣지 않는다.

```csharp
public sealed class Logger
{
    public Logger(string tag)
    {
        Tag = tag;
    }

    public void WriteNotice(string message)
    {
        reporter.Write($"{Tag}> {message}");
    }

    private string Tag { get; }
}
```

ASP.NET 요청 계층에서는 베이스 컨트롤러나 미들웨어가 사용자·세션·컨트롤러 태그를 구성하고, 요청 수신·처리 시작·처리 완료·응답을 공통으로 기록한다. 자식 컨트롤러는 이미 태그가 부착된 로거를 사용하며 같은 접두사를 반복 작성하지 않는다.

```csharp
var tag = $"{memberId}:{GetType().Name}";
logger.Tag = tag;

logger.WriteNoticeLine("RECEIVED.");
logger.WriteNoticeLine("START HANDLE.");
logger.WriteNoticeLine($"END HANDLE : {elapsedMilliseconds} MS");
logger.WriteNoticeLine($"RESPONSE : {result} ({bytes.Length} BYTES)");
```

위 호출은 최종 출력에서 다음처럼 기록된다.

```text
{memberId}:{controllerType}> RECEIVED.
{memberId}:{controllerType}> START HANDLE.
{memberId}:{controllerType}> END HANDLE : {elapsedMilliseconds} MS
{memberId}:{controllerType}> RESPONSE : {result} ({bytesLength} BYTES)
```

## 1. 필수 시스템 로그

필수 시스템 로그는 정상 실행에서 100% 항상 출력되어야 하는 가장 중요한 로그다. 실행 환경, 주요 시스템의 진입과 종료, 초기화 순서, 상태 전이처럼 실행마다 비교할 기준점을 기록한다.

- 조건부 디버그 빌드나 임시 플래그로 제거하지 않는다.
- 동일한 정상 실행에서는 같은 기준점이 같은 순서로 출력되어야 한다.
- 자동 비교가 가능하도록 문구와 identifier 배치를 안정적으로 유지한다.
- 기존 문구의 변경·삭제·순서 변경은 로그 소비 시스템의 계약 변경으로 취급한다.
- 주요 시스템은 시작과 완료를 짝으로 기록한다. 중간 실패가 가능하면 어느 쪽이 누락되었는지 식별할 수 있어야 한다.
- 실행 환경은 문제 재현에 필요한 범위에서 버전, 플랫폼, 빌드, 해상도, 서버 환경 등을 기록한다.
- 정상 경로에서 반복적으로 많이 호출되는 세부 스텝은 필수 로그로 승격하지 않는다.
- 주요 컴포넌트의 초기화 로그는 컴포넌트 태그를 부모나 공통 초기화 계층에서 부착해 앞뒤 순서를 안정적으로 비교할 수 있게 한다.

```csharp
Debug.Log("SYSTEM> APPLICATION START.");
Debug.Log($"ENV> APPLICATION : {Application.version} ({Application.platform})");
Debug.Log($"{system.GetType().Name}> INITIALIZE BEGIN.");
Debug.Log($"{system.GetType().Name}> INITIALIZE END.");
Debug.Log($"{GetType().Name}> APP STEP : {previousStep} -> {currentStep}");
Debug.Log($"{GetType().Name}> WINDOW SIZE : {width} x {height}");
```

필수 로그의 핵심 질문은 “이 줄이 없거나 순서가 달라졌을 때 정상 실행이 달라졌다고 판단할 수 있는가?”다. 그렇다면 필수 시스템 로그로 둔다.

## 2. 경고 로그

경고 로그는 기대하는 환경·값·사용법에서 벗어난 모든 상황을 기록한다. 정상적인 실행과 테스트에서 경고 0개를 유지하는 것을 목표로 한다.

- 복구했거나 계속 실행할 수 있다는 이유로 이상 상태를 숨기지 않는다.
- 잘못된 API 사용, 누락된 설정, 범위 이탈, 예상하지 않은 null, 사용되지 않는 요청도 경고 대상이다.
- 같은 원인으로 매 프레임 또는 반복문마다 경고가 폭주하지 않도록 최초 1회나 의미 있는 상태 변화 시점에 기록한다.
- 경고를 없앨 때는 출력만 삭제하지 말고 원인을 수정한다.
- 호출부가 이미 경고 수준을 표현하므로 고정 문구에 `WARNING`을 기계적으로 반복하지 않는다.
- 실행을 안전하게 계속할 수 없거나 데이터가 손상된 상태는 경고가 아니라 오류 또는 예외로 처리한다.
- 경고에도 반드시 행위 주체자를 붙여 어느 컴포넌트·요청·사용자가 기대 상태를 벗어났는지 알 수 있게 한다.

```csharp
Debug.LogWarning($"{name}> UI EFFECT NOT SET : {child.name}");
Debug.LogWarning($"{GetType().Name}> OUT OF INDEX : {index} / {values.Length}");
Debug.LogWarning($"{GetType().Name}> NO HANDLERS : {request.GetType().Name}");
Debug.LogWarning($"{name}> NOT INITIALIZED.");
```

경고의 핵심 질문은 “기대 상태에서 벗어났지만 실행은 계속할 수 있는가?”다. 그렇다면 반드시 경고를 남기고 경고 0개 상태로 되돌릴 수정 대상을 만든다.

## 3. 디버깅 로그

디버깅 로그는 평상시 필요하지 않지만 인캡슐레이션된 시스템 내부의 세부 스텝과 값을 직접 확인할 때 사용한다. 네트워크, 멀티스레드, 운영체제, 파일 시스템처럼 외부 상태와 타이밍의 영향을 많이 받는 코드에서 특히 유용하다.

- 기본 실행에서는 끄거나 필터링할 수 있어야 한다.
- 조사할 가설과 범위를 정한 뒤 필요한 스텝에만 추가한다.
- 스레드, 요청, 연결, 작업처럼 흐름을 묶는 identifier를 포함한다.
- 병렬 흐름은 시작·대기·재개·완료·취소를 구분할 수 있게 기록한다.
- 유저에게 공개되지 않는 내부 전용 로그는 빠른 판독을 위해 한글로 작성할 수 있다.
- 영어로 작성하는 경우에는 공통 대문자·identifier 규칙을 그대로 적용한다.
- 임시 디버깅 로그는 조사 후 삭제하거나, 재사용 가치가 있으면 명시적인 디버그 채널과 토글 아래에 둔다.
- 네트워크 축약 동사를 사용하더라도 동시 연결·요청을 구분해야 하면 연결 또는 요청 태그를 앞에 둔다.

```csharp
logger.LogDebug($"{connectionName}> SEND : {request.GetType().Name} ({requestId})");
logger.LogDebug($"{threadId}> 응답 대기를 시작함 : {requestId}");
logger.LogDebug($"{connectionName}> RECV : {response.GetType().Name} ({requestId})");
logger.LogDebug($"{threadId}> 작업 완료 : {elapsedMilliseconds}ms");
```

디버깅 로그의 핵심 질문은 “평상시 계약에는 필요 없지만 지금 내부 스텝이나 실제 값을 눈으로 확인해야 하는가?”다. 그렇다면 디버깅 로그로 둔다.

## 4. UX LOG

UX LOG는 선택적인 사용자 행동 분석 채널이다. 진단용 필수 로그나 경고를 대신하지 않으며, 사용자가 무엇을 보고 선택하고 진행했는지를 세션과 사용자 컨텍스트에 연결해 분석할 필요가 있는 프로젝트에서만 사용한다.

- 버튼 클릭 자체보다 분석 목적이 있는 행동과 결과를 기록한다.
- 이벤트 이름과 속성 스키마를 먼저 정하고 안정적으로 유지한다.
- 사용자, 세션, 캐릭터, 지역, 클라이언트 버전 등 공통 컨텍스트는 로거가 일관되게 부착한다.
- 사용자 행동의 주체자는 자유 문구뿐 아니라 사용자·세션 컨텍스트의 구조화된 필드로도 보존한다.
- 검색·집계할 값은 자유 문장에만 넣지 말고 구조화된 속성으로 함께 전송한다.
- UX LOG 실패가 게임 진행을 막지 않도록 주 실행 로직과 분리한다.
- 개인정보, 인증정보, 자유 입력 원문은 수집 목적과 보관 정책 없이 기록하지 않는다.
- 이벤트 추가 시 무엇을 판단하기 위한 로그인지, 언제 발생하는지, 중복 발생 조건은 무엇인지 문서화한다.

```csharp
analyticsLogger.WriteLine(
    $"{user.Id}> USER LOGIN : {user.Nickname}",
    () => (nameof(AnalyticsEventGroup.User), new
    {
        UserId = user.Id,
        user.Nickname,
    }));
```

UX LOG의 핵심 질문은 “이 기록으로 사용자 행동이나 UX 결과에 관한 어떤 결정을 내릴 것인가?”다. 답이 없다면 UX LOG를 추가하지 않는다.

## 선택 기준

1. 정상 실행에서 반드시 존재하고 순서 비교의 기준점인가? 필수 시스템 로그다.
2. 기대 상태나 올바른 사용에서 벗어났지만 실행을 계속할 수 있는가? 경고 로그다.
3. 내부 구현의 세부 스텝이나 실제 값을 일시적으로 확인하려는가? 디버깅 로그다.
4. 사용자 행동을 장기적으로 집계해 UX 결정을 내리려는가? UX LOG다.

한 사건이 여러 목적을 가지면 각 채널의 책임을 분리한다. 예를 들어 로그인 시스템 초기화 완료는 필수 로그이고, 비정상 설정은 경고이며, 패킷별 왕복 과정은 디버깅 로그이고, 사용자의 로그인 방식 선택은 UX LOG다.

## 검토 체크리스트

- 로그 종류를 먼저 결정했는가?
- 필수 로그가 정상 실행에서 항상 같은 기준점과 순서로 출력되는가?
- 경고가 기대 상태 이탈을 빠짐없이 드러내며 정상 상태에서 0개인가?
- 디버깅 로그를 기본 상태에서 필터링할 수 있는가?
- UX LOG에 분석 목적과 구조화된 속성이 있는가?
- 외부에 전달되는 영어 고정 문구가 모두 대문자인가?
- 모든 identifier가 `{expression}`으로 참조되는가?
- 모든 로그의 최종 출력 첫 토큰에서 행위 주체자를 식별할 수 있는가?
- 상위 프레임워크나 공통 로거가 태그를 시스템적으로 보장할 수 있는가?
- 태그가 붙는 로거의 호출 문자열에 주체자를 중복 작성하지 않았는가?
- 전역 생명주기·환경·네트워크 로그에 `SYSTEM>`, `ENV>`, `NETWORK>`를 올바르게 사용했는가?
- 구체적인 컴포넌트·연결 주체자가 있는데 예약 전역 태그로 뭉뚱그리지 않았는가?
- catch 예외 로그에 행위 주체자나 설명 문구를 불필요하게 조합하지 않고 `e`를 그대로 전달했는가?
- 민감한 값이 포함되지 않았는가?
- 제3자·자동 생성 코드를 불필요하게 수정하지 않았는가?
