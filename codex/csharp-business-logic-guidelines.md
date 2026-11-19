# C# 비즈니스 로직 작성 지침

## 코딩을 시작할 때

1. **적용 여부를 확인한다.** 공용 지침을 읽고, 제품의 C# 비즈니스 로직을 작성하는 작업이면 이 지침을 확인한다. 해당 프로젝트에 엄격한 관리를 적용할지 사용자가 이미 답했으면 프로젝트 메모리의 답을 사용한다. 답이 없으면 먼저 묻고 기록한다.
2. **관리 대상이면 코드를 쓰기 전에 케이스를 찾는다.** 변경할 코드마다 아래 항목에서 선언 형태, 상태 소유자, 호출 방향을 확인한다. UI는 프리팹 계층과 컴포넌트 배치까지 한 작업으로 본다. 해당 케이스가 없거나 적용할 규칙끼리 충돌하면 작성을 멈추고 누락된 지점을 사용자에게 알린다. 엄격한 관리가 필요 없다고 답한 프로젝트는 프로젝트 관례에 따라 작성한다.
3. **네이밍은 모든 케이스에서 확인한다.** 의미 계층 지침으로 단어와 소속을 정하고, C# 컨벤션으로 `Ui`·`Id`, 필드명, `Interface`·`Enum` 접미사 등의 표기를 정한다. 프리팹·오브젝트·스크립트·클래스 사이의 이름도 맞춘다. Hub 멤버를 만들 때는 최신 Hub 키워드 문서를 추가로 확인한다. [의미 계층 네이밍](https://oojjrs.github.io/codex/semantic-layer-naming-guideline.md) · [Unity C# 코딩 컨벤션](https://oojjrs.github.io/codex/unity-csharp-coding-convention.md) · [Hub 구조와 분류 원칙](https://oojjrs.github.io/kr/unity/hub-architecture/)
4. **프로젝트 간 비교는 지침을 개정할 때 한다.** 유지된 제품 코드에서 같은 책임과 호출 방향이 반복되는지 보고, 구조가 달라졌으면 최근의 일관된 사용 형태를 우선한다. 테스트, 임시 산출물, 롤백한 구현은 근거에서 제외한다. 실제 코딩에는 이렇게 정리한 지침을 사용한다.

## 함수 작성 기준

1. **확장 함수는 판정의 대상에 붙인다.**
   Mines의 `Answer.IsAllFlaggingExactly()`는 정답 ID로 같은 셀을 다시 찾아 이웃의 깃발을 세. 호출자인 `Cell.Chord()`가 이미 그 셀을 갖고 있으니, 깃발 판정은 `Cell` 쪽에 두고 `Answer`에서는 정답 숫자만 읽자.

2. **여러 Entity를 처리할 때, 각 Entity의 변경은 그 Entity가 맡는다.**
   Mines에서 경기 종료 시 어떤 셀들을 처리할지는 `Game`이 정해. 셀 하나의 공개 상태를 바꾸고, 변경됐을 때 버전을 올려 `Ship()`하는 본문은 서버 `CellExtensions`에 두자. Rebellion도 `GameFunction.Win()`이 승리를 진행하고 사용자 한 명의 기록 변경은 `Ship.User.SetGameWin()`에 맡겨.

3. **인자는 실제로 쓰는 함수까지만 넘긴다.**
   Mines에서 `User`는 서버 Handler가 셀을 열 권한을 확인할 때 필요해. 그 뒤 `Cell.Open()`은 `user`를 아래로 전달만 하고 마지막 함수도 쓰지 않아. 권한 확인은 Handler에 두고, 통과하면 `cell.Open()`으로 호출하자.

4. **같은 행동은 어느 입력으로 들어와도 첫 상태 변경 전에 같은 조건을 검사한다.**
   Mines의 방 시작 버튼과 단축키는 둘 다 `StartInroomGame()`을 호출해. 그런데 이 함수는 방장·대기·준비 조건을 확인하기 전에 경기 설정부터 바꿔. 공통 진입점에서 시작 가능 여부를 먼저 확인하고, 통과했을 때만 설정을 바꾸자.

5. **같은 게임 상태를 다시 표시해도 플레이 기록은 달라지지 않아야 한다.**
   보물 셀의 모델을 두 번 만들거나 나중에 그려도 연속 발견 횟수와 업적 결과는 같아야 해. 이펙트 재생은 표시 함수가 맡아도 돼. 횟수를 서버에서 셀지, 클라이언트가 결과를 받을 때 셀지는 게임 구조에 따라 정하면 돼.

6. **기록을 표시할 때는 그 기록을 보관하는 데이터에서 읽는다.**
   Mines 점수판은 경기 참가자 `User`를 현재 방의 `Player`로 바꿨다가 다시 `User`를 찾아 승수를 읽어. 그래서 상대가 방을 나가면 경기 기록이 남아 있어도 승수가 0으로 표시될 수 있어. 점수판은 처음 찾은 경기 `User`에서 승수를 바로 읽자.

7. **기존 상태를 교체할 때는 새 요청이 유효한지 확인한 뒤 기존 상태를 비운다.**
   Mines는 새 경기 요청을 받자마자 현재 경기와 정답을 비우고, 그 뒤에 참가자 수와 스테이지 데이터를 검사해. 이 검사를 경기 생성 Handler에서 먼저 끝내서, 요청이 거절되면 진행 중인 경기가 그대로 남게 하자.

8. **비동기 저장은 ‘진행 중’과 ‘저장 완료’를 구분한다.**
   Mines의 `GameMonitor`는 저장을 시작하기 전에 경기 ID를 처리 완료로 표시해. 저장에 실패하면 같은 경기 결과가 다시 들어와도 건너뛰어. 저장 중에는 중복 호출을 막고, 성공해야 완료로 기록하자. 실패하면 승리 안내를 반복하지 않고 저장만 다시 시도할 수 있어.

## 케이스별 작성 지침

1. **Entity · `Data`, `Record`, `Manager`**
   작성 전에 세 형태 중 하나를 고른다. **Record 전용**은 `X`, `XRecord`, `XManager`를 두고 `Record.Id`로 식별한다. **Data+Record**는 `XData.Key`와 `XRecord.DataKey`로 정의와 상태를 연결하고 `XManager`가 둘을 결합한다. **Data 전용**은 `XData`를 두고 실제 클라이언트 사용처에 필요한 `Stub`을 연결한다. `Data`가 있으면 `ReferenceIndex` 필요 여부를 먼저 확정한다. `DataBuilder` 등록, Manager 소유·정리, 필요한 저장·송수신까지 기존 Entity 지침을 따른다. [Entity 작성 지침](https://raw.githubusercontent.com/oojjrs/oojjrs.github.io/master/codex/skills/oojjrs-unity-csharp-entity-workflow/SKILL.md)

2. **UI · 화면 코드와 프리팹**
   UI의 필드·일반 프로퍼티·일반 메서드는 `private`으로 둔다. `oui` 콜백은 명시적으로 구현하고, `Page`·`Updater` 생명주기는 `protected override`로 받는다. **입력은 `UI → 담당 시스템 함수 한 번`**, **표시는 `시스템 상태 변경 → Listener → Updater.OnUpdate → 컨트롤`**이다. 외부에서 최초 구독을 위해 직접 여는 화면은 프로젝트가 정한 최상위 UI 루트로 한정한다. `Page` 화면 루트에는 화면 스크립트, `RectTransform`, `CanvasGroup`, `GamepadSupporter`를 둔다. 버튼·입력·텍스트의 역할 스크립트는 각각 담당 컨트롤과 같은 GameObject에 붙인다.

3. **UI List · 동적 목록의 고정 작성 형태**
   **목록**은 `[RequireComponent(typeof(MyList))]`를 선언한 `XList : Updater, MyList.Master<XListEntry, T>`다. `[SerializeField] private XListEntry _prefab`을 두고 `Master.Data`와 `Master.Prefab`을 명시적으로 구현한다. `OnUpdate()`에서 `GetComponent<MyList>().UpdateEntries(this, values)`를 호출한다.
   **행 루트**는 `XListEntry : Updater, MyListEntry<T>`이며 `Value`와 `SortingOrder`를 명시적으로 구현한다. 행 값은 `MyList`가 넣는다. **프리팹**에서는 `MyList`가 붙은 오브젝트에 `XList`를 붙이고 `_prefab`에 행 루트의 `XListEntry`를 연결한다. 행 루트에는 값 타입의 `FinderFromListEntry`를, 값을 쓰는 자식에는 `FinderInParent`와 표시·입력 컴포넌트를 함께 둔다. 이름도 `LobbyRoomList → LobbyRoomListEntry → LobbyRoomListEntryTitleText`처럼 소속을 따른다. 자리가 고정된 점수판은 프리팹에 슬롯을 직접 배치한다.
4. **Enhancer · `Updater`와 `UpdaterListener`**
   화면은 `OnEnabled()`에서 `Listener.X = true`, `OnDisabled()`에서 `false`로 구독을 맞춘다. 실제 `+=`와 `-=`는 Listener의 `bool` setter가 같은 콜백으로 처리한다. Hub 구독명은 **소유 경로 + 사건명**에서 `Hub`, `On`, 중복 단어를 뺀다. `Hub.App.Display.OnResolutionChanged`는 `AppDisplayResolutionChanged`, `Hub.App.Settings.OnSettingsChanged`는 `AppSettingsChanged`다. Entity의 `Notifier.Cell.OnUpserted` 구독명은 `Cell`이다.
   **특정 Entity 변경만 표시할 때**는 구독하는 쪽이 `XCondition`을 설정하고 해제 시 `default`로 비운다. Listener는 조건이 있으면 `Flag |= XCondition(values)`, 없으면 `Flag = true`로 처리한다. 그래야 다음 화면 갱신 전에 무관한 이벤트가 와도 이미 요청한 갱신이 유지된다.
5. **Control · 기존 컨트롤의 조합**
   기본 모양은 기존 `Primitive`를 사용한다. 한 화면의 차이는 인스턴스에 설정하고 공용 스타일은 Variant로 만든다. 공용 배치·조작은 `Control/Layout`, 여러 화면이 공유하는 게임 기능 부품은 `Control/Parts`, 한 화면 전용 동작은 해당 `Ui`에 둔다. 조작 스크립트는 담당 컴포넌트와 같은 오브젝트에 둔다. 게임 기능 호출은 `oui 컨트롤 → 명시적 콜백 → 담당 Hub 함수` 순서다.

6. **Core · `oh` 콜백 Receiver**
   `oh` 컴포넌트가 같은 GameObject에서 콜백을 찾을 때 적용한다. 보내는 컴포넌트 이름에 `Receiver`를 붙이고 `[RequireComponent]`를 선언한다. 프리팹에 두 컴포넌트를 함께 두고 라이브러리 인터페이스를 명시적으로 구현한다. 호출은 `oh → XReceiver → 담당 Hub 함수`로 이어진다.

7. **Hub · 상태 소유자와 하위 이름**
   실행 주체, 상태의 수명, 책임을 확인하고 최신 Hub 문서에서 기존 키워드를 고른다. `Hub.App.Display.cs`처럼 파일명과 중첩 `static` 타입 경로를 맞추고, 여러 파일에 걸친 타입은 `partial`로 둔다. 다른 Hub 하위 시스템을 부를 때는 Hub 내부에서도 `Hub.App.Settings`처럼 전체 경로를 쓴다. 상태 변경은 소유 Hub의 함수로 들어가며, 소유자가 값을 바꾸고 이벤트를 발행한다. [Hub 구조와 분류 원칙](https://oojjrs.github.io/kr/unity/hub-architecture/)

8. **Extensions · 공유 Entity의 환경별 동작**
   Entity는 서버와 클라이언트가 함께 사용한다. 한쪽의 Manager·Hub·Unity 리소스가 필요한 함수는 해당 쪽 `EntityPlus/XExtensions`에 `public static` 확장 메서드로 둔다. 양쪽에서 `region.GetCells()`라는 같은 이름을 쓸 수 있다. 클라이언트 구현은 `Hub.Ingame.Manager.Cell`, 서버 구현은 `Hub.Manager.Cell`을 조회한다.

9. **Command · 클라이언트 행동을 요청으로 변환**
   `Client/Command`에 대상별 `static` 클래스 `XCommand`를 둔다. 메서드명은 `Open`, `Create`처럼 동작으로 짓고 실행자만 다르면 같은 이름으로 오버로드한다. `클라이언트 시스템 → XCommand.동작 → Hub.Net.SendRequest()` 순서다. Command는 인자에서 ID·DataKey 등 요청 필드를 꺼낸다. 행동 여부와 전후 정리는 호출한 시스템이, 요청자 ID·리플레이 기록·송신은 `Hub.Net.SendRequest()`가 맡는다.

10. **요청 Packet · 대상과 동작을 서버에 전달**
    공용 `Net/Requests`에 `Request`를 상속한 `대상+동작+Request`를 둔다. `CellOpenRequest`에는 서버 처리에 필요한 값만 선언하고 요청자 ID는 공용 `Request`가 소유한다. Command가 요청을 만들고 서버 `Hub.Handler.CallBy()`가 타입별 Handler로 분기한다. 요청 타입이나 전송 필드를 바꾸면 기존 생성기로 `ReplayDefinition`도 갱신한다.

11. **Db · ODB 저장 테이블**
    `Db`에 `XRow`를 `record`로 선언한다. 정의에 연결되는 행은 `DataKey`, 개별 경기 기록은 해당 기록의 식별자를 키로 쓴다. `GameDbContext`에 `OdbSet<XRow, TKey>` 조회 프로퍼티와 `OnModelCreating()`의 `AddEntity` 등록을 함께 추가하고 테이블 이름은 `nameof`로 맞춘다. 파일 선택·로드·저장은 `Hub.Db`가 맡는다. 저장 실패 시 직전에 추가한 행을 거둬야 하는 동작은 그 저장 함수에서 처리한다.

12. **EntityPlus Model · Entity와 Unity 모델 연결**
    프리팹의 같은 오브젝트에 `XModel : Updater`와 `XFinder`를 두고 모델에 `[RequireComponent(typeof(XFinder))]`를 선언한다. `XModelSpawner`는 `Listener.X`로 갱신을 받고 모델이 없는 Entity의 프리팹을 Stub에서 가져온다. **생성 → Finder에 Entity 대입 → `Hub.Ingame.Model.X`에 `Record.Id`로 등록** 순서다. 모델은 `OnStart()`에서 Finder를 읽고, 경기 정리 때 모델 등록도 비운다.

13. **`oh`·`oui` · 기존 라이브러리 API 사용**
    Unity 컴포넌트에 대응하는 래퍼가 있으면 프로젝트 코드에서 그 API를 사용한다. 버튼은 `MyButton`, 텍스트는 `MyText`를 사용하고 닉네임처럼 그대로 보여 줄 값은 `EscapedText`에 넘긴다. 활성화·삭제도 기존 `SetActiveSafety()`·`DestroyObjectSafety()`의 계약을 따른다. 필수 참조는 선언·초기화·프리팹 배치에서 보장한다.

14. **Stub · 공용 `XData`의 클라이언트 사용 형태**
    `Client/EntityPlus/XStub`은 생성자로 받은 `XData`를 `Data { get; }`에 보관하고 이미지·프리팹·번역문을 프로퍼티로 제공한다. `DataBuilder`가 만들어 `Data.Key`로 등록하고 클라이언트는 `Hub.Data.Stub.X`에서 찾는다. 빈 값 경로가 정의된 타입은 `Hub.Data.Stub.Empty.X`를 사용한다. **Stub 조회에는 `Key`, 리소스 조회에는 `ReferenceIndex`**를 쓴다.

15. **서버 Handler · 요청 검증과 예외 처리**
    `Hub.Net.HandleRequest() → Hub.Handler.CallBy() → Hub.Handler.대상.동작 → 도메인 함수` 순서다. Handler는 필요한 대상·소속·권한·현재 상태를 확인한 뒤 변경한다. 거절 이유는 `CellNotFound`, `UserNotPermitted`처럼 구체적인 `ReplyCodeException`으로 전달한다.
    **예외를 응답으로 바꾸는 곳은 공통 수신부다.** `ReplyCodeException`을 먼저 잡아 `FlushError(e.Value)`를 호출한다. 예상 밖 예외는 `FlushError(ReplyCode._Exception)`으로 응답하고 `Debug.LogException(e)`에 원본 예외를 넘긴다. `FlushError()`는 응답 버퍼를 비운다. 도중에 이미 바뀐 Entity를 복구해야 하면 상태를 변경한 코드가 책임진다. [로그 작성 지침](https://oojjrs.github.io/codex/logging-guideline.md)

16. **응답 Packet · 변경분 반영과 알림**
    서버는 갱신 Entity를 `ResponseBuilder.Upserts.X`, 삭제 ID를 `Deletions.XIds`에 모아 `Flush()`에서 응답 배열로 만든다. 클라이언트는 성공 응답의 삭제를 먼저 반영하고, 이어서 Record를 Manager에 `Upsert()`해 반환된 Entity를 `Notifier.X`에 모은다. **수신 묶음이 끝나는 `OnFinishThisHandling()`에서 `Notifier.Notify()`를 호출한다.**

17. **Oplat · `Config`와 `Result`를 통한 서비스 호출 — 잠정안**
    서비스를 소유한 `Hub.Net.X`가 `SendConfig`처럼 동작명에 맞는 Config를 만든다. Config는 인터페이스를 명시적으로 구현해 인자와 취소 토큰을 제공한다. `Hub.Net.X → Oplat 서비스 → Result 콜백`으로 연결하고 `OnOk`, `OnBusy`, `OnFailed`, `OnException`에서 해당 결과를 처리한다. 호출별 상태가 필요한 Result는 호출마다 만든다. 사용자가 직접 작성해 본 뒤 재검토할 항목이다.

18. **씬 전환 · 로드 전후 처리**
    `Hub.App.Scene.GoToX()`가 `Core/XSceneTransition`을 생성한다. 전환 컴포넌트에 `[RequireComponent(typeof(SceneTransition))]`를 선언하고 `SceneTransition.RequestInterface`를 명시적으로 구현한다. `OnLoadBeginAsync()`에서 Loading 단계 설정, 기존 씬 정리, 대상 리소스 준비를 한다. 실패 시 확보한 참조를 해제하고 복귀 경로로 보낸다. `oh`의 로드가 끝나면 `OnLoadEndAsync()`에서 대상 화면을 열고 최종 단계를 설정한 뒤 전환 오브젝트를 제거한다.

19. **Setter · 씬·프리팹 참조의 Hub 등록**
    새 Setter는 **`private Awake()`에서 등록하는 것이 기본**이다. 같은 오브젝트의 참조는 `[RequireComponent]`와 `GetComponent<T>()`로 가져와 소유 Hub 멤버에 넣는다. 직계 자식 여러 개를 등록할 때는 부모에 Setter를 두고 자식 이름과 대상 멤버의 `nameof`를 맞춘다. 등록을 마치면 `this.DestroySafety()`로 Setter 컴포넌트만 제거한다.

20. **Input Actions Receiver · 액션 맵과 게임 입력 연결**
    `Core/XReceiver : Updater`가 생성된 액션 맵 인터페이스를 명시적으로 구현한다. `OnAwake()`에서 인스턴스를 만들고 `SetCallbacks(this)`로 연결한다. `Listener`와 `OnUpdate()`로 입력 허용 조건에 따라 맵을 켜고 끈다. `OnDisabled()`에서 맵·구독을 끄고 `OnDestroyed()`에서 콜백 해제 후 `Dispose()`한다. 입력 단계에 맞춰 UI 단축키는 `Hub.Ui.Handle`, 플레이 입력은 담당 `Hub.Ingame` 함수에 넘긴다.

21. **ReferenceTable · 인덱스로 클라이언트 리소스 조회**
    `Client/EntityPlus`에 `[Serializable] struct XReference`로 리소스 필드를 선언하고, 빈 `XReferenceTable : TableT<XReference>`로 에셋 타입을 정한다. 사용 시점에 맞춰 `AssetStartup` 또는 `AssetIngame`에 연결한다. 호출은 `XStub → Hub.Asset → XReferenceTable.Get(Data.ReferenceIndex)`다. 배열 순서를 바꾸면 해당 항목을 가리키는 `ReferenceIndex`도 함께 맞춘다.

22. **Finder · `Value`를 누가 공급하고 어디서 읽는가**
    **모델**은 `Instantiate()`를 호출한 코드가 생성된 오브젝트의 `XFinder.Value`에 Entity를 넣는다. `XFinder : FinderT<X>`의 본문은 비워 두고, 같은 오브젝트의 모델이 그 값을 읽는다. **UI 목록**은 `MyList`가 행의 `MyListEntry<X>.Value`에 값을 넣는다. 행 루트의 `XFinderFromListEntry`가 그 값을 제공하고 자식 UI는 자기 오브젝트의 `XFinderInParent.Value`로 읽는다. **Hub가 소유한 값**은 `XFinderFromHub`가 `Value`의 getter에서 해당 Hub 값을 읽는다.
23. **Monitor · 상태 변화 또는 프레임에 따른 구동**
    `XMonitor`의 `X`는 감시하거나 구동하는 대상이다. 상태 변화에 반응하면 `Updater`에서 필요한 Listener만 구독하고 `OnUpdate()`에서 현재 상태와 필요한 이전 값을 비교한다. 매 프레임 구동하면 `private Update()`에서 실행 조건을 검사해 담당 Hub 함수를 호출한다. 세션처럼 씬을 넘는 대상은 `Core` 프리팹에, 인게임 오브젝트를 갱신하는 Monitor는 해당 씬에 둔다.

24. **MyReel · 행 높이가 달라지는 채팅 목록**
    `MyReel.Vertical`의 `ScrollRect → Viewport → Content` 계층을 사용한다. `Content`에 `MyReel`과 `XReel`을 붙이고 `_prefab`에 행 프리팹을 연결한다. `XReel : Updater, MyReel.Master<XReelEntry, T>`가 `OnUpdate()`에서 `UpdateEntries(this, values)`를 호출한다. 행 루트는 `EntryInterface<T>`를 구현하고, 높이를 정하는 자식은 `SizeResolverInterface.ResolveSize()`에서 내용을 채운다. **행 값 주입 → 자식의 내용·크기 결정 → 행 배치** 순서다. 채팅은 `FollowBottom`으로 이미 맨 아래에 있던 경우에만 새 메시지를 따라간다.

25. **서버 Ruleset · 모드별 경기 판정 (Mines)**
    `Server/Hub.Ingame.Ruleset`이 `private RulesetInterface`와 현재 구현을 소유한다. 모드별 파일에 `private sealed` 구현을 두고 생성자로 `Game`을 받는다. 경기 생성 때 `game.Record.Mode`로 선택하고 정리 때 비운다. Handler와 서버 Ingame은 `Ruleset.CanAct`, `ShouldSwitchTurn` 같은 함수로 판정을 요청한다. 행동 거절에 대응하는 Handler와 실제 턴을 전환하는 Ingame이 각 결과를 처리한다. 미지원 모드와 미생성 조회는 각각 `RulesetNotSupported`, `RulesetNotFound`로 처리한다.

26. **클라이언트 Behavior · 모드별 입력과 연출 (Mines)**
    `Client/Hub.Ingame.Behavior`가 `private BehaviorInterface`와 현재 구현을 소유한다. 모드별 파일에 `private sealed` 구현을 두고 게임 준비 후 선택하며 경기 정리 때 `NoneBehavior`로 돌린다. 호출은 `CellExtensions → Hub.Ingame.Behavior → 모드별 구현 → CellCommand`다. 같은 셀 활성화를 모드에 따라 `Open` 또는 `Pick`으로 해석하고 셀 연출도 해당 모드에서 정한다.

27. **AI Brain · 난이도별 판단과 행동 요청 (Mines)**
    `Hub.Ingame.Ai`가 난이도별 Brain을 선택한다. 각 Brain은 `BrainInterface.Run()`·`Clear()`를 명시적으로 구현한다. `AiMonitor → Hub.Ingame.Ai.Run() → Brain → CellCommand.Pick(cell, user)` 순서로 방장이 현재 턴의 AI 행동을 요청한다. 백그라운드 계산은 셀 스냅샷을 사용하고 경기·턴·셀 상태가 달라지면 결과를 버린다. 요청 후에는 상태가 바뀔 때까지 중복 요청을 보류하며, `Clear()`에서 계산과 대기 상태를 정리한다.

28. **리플레이 · 패킷 수집과 경기 단위 저장 (Mines)**
    `Hub.Net`은 요청자 ID를 채운 뒤 송신 전에 요청을 기록한다. 응답은 상태 반영 전에 직렬화하고 반영 후 `Hub.Replay.Receive()`에 넘겨 마지막 응답까지 해당 경기에 포함한다. 생성·재시작·계속하기 요청은 새 경기 ID가 정해지면 그 경기 기록 앞에 붙인다. `ReplayCodec`은 인코딩, `ReplayArchive`는 파일 형식을 맡는다. 로컬 저장 성공 후 큐에서 꺼내고 클라우드 작업을 순서대로 실행한다. 병합 기준은 계정과 `TableId`이며 종료 시 `FlushAsync()`를 기다린다.

29. **서버 비공개 원본 · `XSecret`과 `XKeeper` (Mines)**
    서버 내부 타입은 `Server` 아래에서 실제 역할로 이름 짓는다. 그중 **클라이언트에 보내지 않고 서버가 지켜야 하는 원본**은 `XSecret`, 이를 보관·조회하는 타입은 `XKeeper`, 접근 경로는 `Server.Hub.Keeper.X`로 둔다. Mines는 `AnswerSecret`을 가진 `Answer`를 셀 ID로 `AnswerKeeper`에 보관한다. 셀 생성·삭제에 맞춰 정답도 등록·삭제하고 게임·세션 정리 때 Keeper를 비운다.
    **원본은 서버에 보관하고, 게임 규칙상 공개할 시점에 공개할 값만 공용 `Record`에 반영해 전송한다.** 셀을 공개할 때 `CellRecord.Number`를 채워 `Ship()`하는 것이 그 예다. [Hub의 Keeper 정의](https://oojjrs.github.io/kr/unity/hub-architecture/)

30. **클라이언트 Room·Player · 생성과 조회 (Mines)**
    `Client/EntityPlus`의 `Room`과 `Player`에는 로컬 값으로 만드는 생성자와 플랫폼 인터페이스를 받는 생성자를 둔다. UI와 Finder는 양쪽에서 같은 조회 프로퍼티를 사용한다. 내부에서 로컬 값 또는 `MyRoom`·`MyPlayer`를 읽는다. 이 항목의 적용 범위는 두 타입의 생성과 조회까지다.

31. **Session · 방장의 단계 결정과 각 클라이언트의 실행 (Mines)**
    `Hub.Session.Host`가 방장과 현재 단계를 확인해 다음 단계와 예약 시각을 `Hub.Net.Room`에 반영한다. 실제 플레이어 모두가 현재 세션 ID로 로드 완료를 보고하면 시작 시각을 정한다. AI와 관전자는 이 집계에서 제외한다. `Hub.Session`은 방 상태 갱신과 `IntervalTick()`에서 플랫폼 UTC 시각으로 실행 시점을 판단한다. 각 클라이언트의 `Hub.Session.My`는 세션 ID로 로드와 시작의 중복을 막고, 로드 완료는 `IngameSceneTransition → Hub.Session.My.ReportLoaded() → Hub.Net.Player.StartUpdateLoadedSessionId()`로 보고한다.
