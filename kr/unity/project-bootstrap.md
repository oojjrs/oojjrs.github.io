---
layout: page
title: "신규 Unity 프로젝트 초기 설정"
lang: ko-KR
category: "GAME DEVELOPMENT"
description: "새 Unity 프로젝트를 만든 직후부터 패키지, Build Profile, Startup Scene과 Core 부팅 구조를 순서대로 구성하는 개인용 체크리스트입니다."
permalink: /kr/unity/project-bootstrap/
---

이 문서는 새 Unity 프로젝트를 만들 때 반복하는 초기 설정 순서를 기록한 개인용 작업 참고서다. 모든 Unity 프로젝트에 적용하는 일반 규칙이 아니라 OOJJRS 프로젝트의 현재 공통 출발점을 다룬다. 라이브러리와 기존 프로젝트 구조가 바뀌면 계속 갱신한다.

## 1. 프로젝트 생성

1. 프로젝트에 사용할 Unity 버전과 Render Pipeline을 정한다.
2. 프로젝트를 생성하고 첫 임포트가 끝날 때까지 기다린다.
3. `Project Settings > Player`에서 Company Name, Product Name, Version과 플랫폼별 Application Identifier를 설정한다.
4. Active Input Handling을 `Input System Package (New)`로 설정한다.
5. 프로젝트 전용 소스는 `Assets/Sources` 아래에서 시작한다.

## 2. 기본 패키지 정리

Package Manager를 열고 프로젝트 템플릿에 포함된 패키지를 확인한다. 프로젝트에서 쓰지 않는 AI, VR, Terrain, Vehicles, Cloth 등의 기능과 사용하지 않는 IDE 연동 패키지는 제거한다. Unity 기본 모듈은 이름만 보고 일괄 삭제하지 말고 대상 플랫폼과 사용할 기능을 기준으로 판단한다.

다음 패키지는 기본적으로 직접 설치한다.

| Package | Purpose |
| --- | --- |
| Input System | 키보드, 마우스와 게임패드 입력 |
| Localization | Locale, String Table과 현지화 리소스 |
| Cinemachine | 프로젝트 공통 카메라 조작 기반 |

Localization은 Locale과 Table을 Addressables로 관리하므로 Addressables도 의존성으로 설치된다. 별도 기본 패키지처럼 중복 설치하지 말고 설치 결과와 Addressables Settings 생성을 확인한다.

## 3. OOJJRS 패키지 연결

`Packages/manifest.json` 또는 Package Manager의 `Add package from git URL`을 사용해 다음 패키지를 연결한다.

```json
"com.oojjrs.oh": "https://github.com/oojjrs/unity_oh.git?path=/Packages/src",
"com.oojjrs.okey": "https://github.com/oojjrs/unity_okey.git?path=/Packages/src",
"com.oojjrs.onet": "https://github.com/oojjrs/unity_onet.git?path=/Packages/src",
"com.oojjrs.osys": "https://github.com/oojjrs/unity_osys.git?path=/Packages/src",
"com.oojjrs.oui": "https://github.com/oojjrs/unity_oui.git?path=/Packages/src"
```

- `Oh`, `Okey`, `Onet`, `Osys`, `Oui`는 기본 구성이다.
- 이동 기능이 필요한 프로젝트에만 `Omov`를 추가한다.
- `Oaudio`와 `Oauth`는 신규 프로젝트에서 사용하지 않는다.
- `Onet`이 Authentication, Multiplayer Services, Netcode for GameObjects와 Transport 등의 네트워크 패키지를 의존성으로 설치하므로 같은 패키지를 별도로 추가하지 않는다.
- 패키지 설치 후 Console 오류와 `Packages/packages-lock.json`의 실제 해석 결과를 확인한다.

## 4. Localization 구성

1. Localization Settings를 만든다.
2. 프로젝트가 지원할 기본 Locale을 추가한다.
3. 기본 String Table Collection을 만든다.
4. Locale과 String Table이 생성한 Addressables Group을 확인한다.
5. Startup 부팅 과정에서 `LocalizationSettings.InitializationOperation` 완료를 기다리도록 준비한다.

## 5. Build Profile 구성

`File > Build Profiles`에서 대상 플랫폼의 프로필을 만든다. 최소한 Development와 Release 용도를 구분한다.

| Check | Development | Release |
| --- | --- | --- |
| Development Build | On | Off |
| Script Debugging | 필요할 때 On | Off |
| 로그와 진단 기능 | 개발 기준 | 배포 기준 |
| 출력 경로 | 개발 빌드 폴더 | 릴리스 빌드 폴더 |
| 플랫폼 설정 | 실제 개발 대상 | 실제 배포 대상 |

Scene List의 첫 번째 Scene은 항상 `Startup`으로 둔다. 프로필별 Scene 구성이 다르면 `Override Global Scene List`를 사용하고, 공통이면 전역 Scene List를 유지한다. 플랫폼 전환과 Profile 활성화 상태도 함께 확인한다.

## 6. Startup Scene 생성

1. `Assets/Sources/Scenes/Startup.unity`를 만든다.
2. Startup Scene은 초기화 전용으로 유지한다.
3. 실제 Title, Lobby, Ingame Scene과 게임 콘텐츠를 Startup에 넣지 않는다.
4. Build Profile의 Scene List에서 Startup을 첫 번째로 등록한다.

## 7. 프로젝트 전역 상태 구성

Core를 연결하기 전에 프로젝트가 사용할 전역 상태와 서비스를 준비한다.

- 오디오 시스템과 AudioMixer 접근
- 저장된 Master, Music, Sound 볼륨과 백그라운드 오디오 설정
- 화면 크기, Screen Mode, Quality와 커서 설정
- Localization, 인증, 네트워크와 초기화 완료 상태
- 최초 Scene 이동 기능
- 애플리케이션 종료 상태
- 프로젝트가 필요로 하는 1초 Tick

구체적인 저장 위치와 이름은 프로젝트의 `Hub` 구조에 맞춘다. `Oh`는 이 상태를 소유하지 않고 프로젝트 Receiver를 통해 연결한다.

## 8. Core GameObject 구성

Startup Scene에 빈 `Core` GameObject를 만들고 `oojjrs.oh.CoreSingleton`을 추가한다. `RequireComponent`에 의해 다음 구성요소가 함께 추가된다.

```text
Core
├─ CoreSingleton
├─ ApplicationMonitor
├─ DevelopmentBuildPlayerPrefsResetter
├─ OneSecondTicker
├─ SolidObject
└─ 프로젝트 Core Receiver
```

`CoreSingleton`의 Audio Mixer 필드에 프로젝트 AudioMixer를 할당한다. 같은 GameObject에 프로젝트 Receiver를 추가하고 필요한 계약을 구현한다.

| Interface | Project responsibility |
| --- | --- |
| `CoreSingleton.AudioInterface` | AudioMixer와 Master, Music, Sound 볼륨을 실제 오디오 시스템에 적용 |
| `CoreSingleton.AudioSettingsInterface` | 저장된 볼륨과 백그라운드 오디오 설정 제공 |
| `CoreSingleton.CallbackInterface` | 초기 전역 상태와 화면, 품질, 커서 등의 동기 초기화 |
| `CoreSingleton.EntryInterface` | Localization, 인증과 시스템 준비를 기다린 뒤 최초 실제 Scene으로 이동 |
| `Ticker.CallbackInterface` | 프로젝트의 1초 Tick 실행 여부와 처리 제공 |
| `ApplicationMonitor.*CallbackInterface` | Focus, Pause와 Quit에 필요한 프로젝트별 상태 반영 |

동일한 Core 인터페이스를 여러 Receiver가 중복 구현하지 않는다. 역할별 Receiver로 분리할 수 있지만 각 계약의 소유자는 하나로 명확히 한다.

## 9. 부팅 순서 구현

현재 Core 부팅 순서는 다음과 같다.

1. `DevelopmentBuildPlayerPrefsResetter`가 개발 빌드의 버전 변경을 처리한다.
2. `CoreSingleton`이 영구 싱글턴을 확정하고 AudioMixer를 전달한다.
3. 프로젝트 Receiver의 `OnAwakened()`가 초기 전역 상태를 설정한다.
4. 저장된 오디오 설정이 적용된다.
5. `OnInitialized()`가 화면, 품질, 커서와 프로젝트의 동기 초기화를 마친다.
6. `EnterCoroutine()`이 Localization, 인증, 네트워크와 데이터 준비를 기다린다.
7. 준비가 끝나면 Title 등 최초 실제 Scene으로 이동한다.

기존 프로젝트의 별도 `$Initializer`, `$EntryPoint`, Application Monitor와 Ticker GameObject는 새 프로젝트의 기본 구조로 복제하지 않는다. 해당 역할은 Core Receiver와 `Oh` 구성요소에 배치한다.

## 10. 프로젝트별 Core 기능 추가

공통 부팅이 끝난 뒤 필요한 기능만 Core 주변에 추가한다.

- `InputDetector`와 프로젝트 `InputDetectorReceiver`
- `DeviceDetector`와 프로젝트 `DeviceDetectorReceiver`
- `WindowSizeDetector`와 프로젝트 `WindowSizeDetectorReceiver`
- 인증과 네트워크 Receiver
- `Okey` 입력 표시와 키 풀 설정
- `Oui` 공통 UI 사운드 연결
- 프로젝트 전용 Asset Setter와 데이터 Builder
- 서버·클라이언트 Bootstrapper

Nationz의 UDP·Web·Party 구성, Mines의 게임 결과와 Input Actions, Overlord의 Host·Client Bootstrapper 같은 기능은 공통 Core 부팅 프레임워크가 아니라 프로젝트별 선택 기능으로 유지한다.

## 11. 최초 실행 확인

- Console에 패키지 및 컴파일 오류가 없는가?
- Input System, Localization, Cinemachine이 설치되었는가?
- Localization의 Addressables 구성이 만들어졌는가?
- `Onet`의 네트워크 의존성이 정상 설치되었는가?
- Development와 Release Build Profile이 구분되었는가?
- 각 Scene List의 첫 번째 항목이 Startup인가?
- Core가 Scene 전환 후에도 하나만 유지되는가?
- AudioMixer와 저장된 볼륨이 적용되는가?
- Focus와 Pause에 따른 오디오 동작이 맞는가?
- Localization과 프로젝트 준비가 끝난 뒤 최초 Scene으로 이동하는가?
- 개발 빌드와 릴리스 빌드가 각각 한 번 이상 성공하는가?

## 참고

- [Unity Build Profiles](https://docs.unity3d.com/kr/current/Manual/build-profiles.html)
- [Unity 빌드의 Scene List 관리](https://docs.unity3d.com/kr/current/Manual/build-profile-scene-list.html)
- [Localization의 Addressables 통합](https://docs.unity3d.com/Packages/com.unity.localization@1.4/manual/Addressables.html)
- [Cinemachine 패키지](https://docs.unity3d.com/current/Manual/com.unity.cinemachine.html)
- [UnityOh](https://github.com/oojjrs/unity_oh)
- [UnityOnet](https://github.com/oojjrs/unity_onet)
