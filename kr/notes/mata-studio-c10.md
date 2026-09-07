---
layout: reference
title: "C10 마이크 설정 실험 기록"
lang: ko-KR
category: "PERSONAL NOTES"
description: "마타스튜디오 C10의 이전 설정 복기, 거리·EQ·음색 비교와 Windows 통신용 소음 억제 검증을 정리한 기록."
permalink: /kr/notes/mata-studio-c10/
status: "APO 제거 완료 · Windows 기본 입력 유지"
last_updated: "2026-09-06"
summary: "Equalizer APO·RNNoise를 C10에 실제 연결했지만, 동일 녹음 비교에서 유지할 만큼의 이득을 입증하지 못했다. 새 모델은 키보드를 줄이는 대신 목소리를 먹먹하게 만들어 제외했다. 2026-09-06 22:16에 Equalizer APO를 제거하고 오디오 서비스를 재시작했다. C10 입력·Razer 출력의 기본 장치 선택과 음량은 보존했으며, 아래 설정과 녹음 비교는 실험 이력이다."
toc_items:
  - id: current-state
    label: "현재 상태"
  - id: current-profile
    label: "기존 비교 기준"
  - id: persistent-processing
    label: "공통 처리 구성과 적용 범위"
  - id: windows-default-devices
    label: "일반·통신 기본 장치 바꾸기"
  - id: conclusion
    label: "중단 당시 결론"
  - id: sources
    label: "설명서와 공식 자료"
  - id: previous-setup
    label: "2024년 설정 기록"
  - id: principles
    label: "재시도 참고사항"
  - id: input-path
    label: "Windows 입력 경로"
  - id: distance
    label: "거리 비교 녹음"
  - id: tone
    label: "EQ와 음색 미리듣기"
  - id: final-state
    label: "실행·미실행 구분"
  - id: resumed-session
    label: "설정 재개와 통신용 녹음"
---

## 현재 상태 {#current-state}

2026-09-06 22:16에 Equalizer APO 1.4.2를 공식 제거 프로그램으로 제거했다. 설치 전의 기본 Windows 입력을 유지하는 쪽으로 정리했으며, 앞선 일반 녹음기의 수용 가능한 결과만으로 RNNoise의 추가 이득을 확정하지 않는다. 동일 입력의 RNNoise 미추가·VAD 0%·40%는 청취 차이가 뚜렷하지 않았고, 새 모델은 목소리 손상이 커서 채택하지 않았다.

제거 프로그램 종료 코드 0, 프로그램 등록 해제, C10의 Equalizer APO 효과 연결 해제를 확인했다. 오디오 서비스를 재시작하고 기존 Realtek 종속 서비스도 실행 상태로 복구했으며, 남은 설치 DLL을 정리했다. 후속 확인에서 Windows 오디오 프로세스에 Equalizer APO·RNNoise 모듈이 없고 편집기·APO DLL도 제거된 것을 확인했다. 재부팅은 하지 않았다.

일반·통신 기본 입력은 모두 C10, 출력은 모두 Razer Leviathan V2 X로 보존했다. 제거 전후 C10 음량 99.61%, Razer 음량 10%, 음소거 해제 상태가 같았다. 기존 Windows·장치 효과나 Discord 설정은 이번 제거에서 변경하지 않았다. 제거 후 새 음질 녹음은 진행하지 않았으므로 이전 청취 평가를 제거 후 결과로 간주하지 않는다.

과거 설정과 실험 기록은 보존했다. 제거 직전 설정·등록 정보·장치 상태는 작업 폴더의 `apo-install/before-uninstall-20260906-221538`에 백업했다. 프로그램 설치 폴더에는 보존된 `config`만 남았으며, 2024년부터 있던 별도 VST 폴더의 RNNoise DLL도 삭제하지 않았다. 파일 보관과 실제 마이크 효과 적용은 별개이며, C10에 Equalizer APO를 통한 RNNoise 처리는 더 이상 연결되어 있지 않다. 아래의 설치·프리셋 유지 설명은 제거 이전의 실험 이력이다.

## 기존 비교 기준 {#current-profile}

아래는 2026-09-06 저녁에 확인한 기존 비교 기준이다. 이후 실제 Discord·Steam 통화에서는 약간의 음질 저하가 보고됐고, 직접 실행한 녹음기에서도 키보드 소리가 남았다. 이 기준만으로 공통 잡음 제거 설정이 완료된 것은 아니다.

| 항목 | 당시 비교 기준 |
| --- | --- |
| 사용 거리 | 입에서 약 35~40cm |
| Windows 마이크 입력 | 일반·통신 기본 장치 모두 C10, 음량 100%, 음소거 해제 |
| Windows 소리 출력 | 일반·통신 기본 장치 모두 Razer Leviathan V2 X |
| Discord 입력 / 출력 | C10 / Razer Leviathan V2 X를 명시적으로 선택하는 절차 사용 |
| Discord 소음 억제 | 없음; Krisp 비교 후 복귀 확인 |
| Discord 에코 억제 | 켬 |
| Discord 자동 증폭 조절 | 끔 |
| Discord 입력 감도 자동 설정 | 켬 유지; 수동 감도는 조정하지 않음 |
| 스피커 음량 | 후속 비교의 Windows 출력 기준 10%; 영상 앱 음량과 재생 구간도 함께 유지 |
| 시스템 EQ·피치·추가 APO 프리셋 | 적용하지 않음 |

Discord에서 자동 증폭을 끄면 목소리가 더 자연스럽게 들렸고, 작은 타건음과 영상 소리는 남았다. Krisp를 추가하면 잡음은 줄었으나 목소리가 먹먹하거나 끊겨 제외했다. 이 앱 설정과 Windows 통신용 녹음의 처리 결과는 구분해서 기록한다.

## 공통 처리 구성과 적용 범위 {#persistent-processing}

좋은 평가를 받은 샘플은 별도 `Record-Communications.ps1`가 `MediaCapture`를 초기화하면서 `Communications + Default`를 요청한 결과다. 해당 녹음 세션에서 에코 제거·소음 억제·자동 증폭·Deep Noise Suppression이 활성 상태였고, Razer를 에코 제거의 출력 참조로 지정하는 요청도 수락됐다. 이 처리를 C10의 모든 입력 경로에 적용하는 시스템 필터를 설치하거나, Windows 녹음기의 설정을 변경한 것은 아니다. 기본 통신 장치 지정과 앱이 요청하는 녹음 처리 방식은 별개다. [Microsoft 처리 모드 설명](https://learn.microsoft.com/en-us/windows-hardware/drivers/audio/audio-signal-processing-modes)

일반 녹음기에서 다른 결과가 나온 사실만으로 그 앱의 처리 모드를 확정할 수는 없다. Discord·Steam에서 추가 보정이 겹쳤는지, Windows 처리 자체가 달랐는지, 통화 전송 과정이 얼마나 영향을 줬는지도 분리 검증하지 않았다. 이전 샘플은 통신용 처리의 품질 기준으로 남기되, 일반 앱에 같은 음질이 설치됐다는 근거로 사용하지 않는다.

2026-09-06 21시 후속 작업에서는 **C10에만 Equalizer APO와 RNNoise를 적용하는 구성**을 우선 준비한다. Equalizer APO는 Windows 오디오 처리 경로에 필터를 연결하고, RNNoise는 잡음 제거를 담당한다. 설정 창을 계속 켜두는 중계 방식은 아니며, 효과 처리 자체는 Windows 오디오 엔진 안에서 실행된다. RNNoise는 이전 Windows 통신용 효과와 다른 알고리즘이므로 음질은 새로 확인해야 한다. [Equalizer APO 공식 문서](https://sourceforge.net/p/equalizerapo/wiki/Documentation/), [RNNoise 플러그인 개발자 안내](https://github.com/werman/noise-suppression-for-voice)

2026-09-06 21:36 기준으로 Equalizer APO 1.4.2 설치와 C10 장치 등록을 확인했고, `C:\Program Files\EqualizerAPO\config\config.txt`에 `Include: c10-rnnoise.txt`를 추가했다. 기존 2024년 필터 행은 모두 주석 상태로 보존했다. 이후 21:39에 Windows 오디오 서비스를 재시작했고 기존에 실행 중이던 Realtek 오디오 서비스도 실행 상태로 복구했다. 21:41 진단에서는 Windows 오디오 프로세스에 Equalizer APO와 RNNoise DLL이 로드된 것을 확인했다. 로그에도 현재 C10 GUID 일치, capture 단계 선택, 48kHz 조건 통과, 새 설정 파일 읽기, RNNoise 로드 성공이 남았다. 진단용 상세 로그 설정은 원래의 꺼짐 상태로 복구했다. 이는 실제 오디오 엔진의 필터 연결 증거다. 이후 일반 녹음기의 타건·영상 재생 조건은 아래와 같이 검증했고, 후속 실제 통화 검증은 남아 있다. VB-CABLE과 별도 상주 중계는 설치하지 않았다.

새 초기 프리셋은 지금의 거리·스피커 조건에서 비교를 시작하기 위한 값이며, 과거 프리셋의 재활성화가 아니다.

| 항목 | 새 초기값 |
| --- | --- |
| 적용 대상 | 현재 C10 장치 GUID만, capture 단계 |
| 플러그인 | werman RNNoise v1.10 stereo |
| 처리 샘플레이트 | 48,000Hz에서만 실행 |
| 추가 증폭 | 0dB |
| VAD 임계값 | 0%; RNNoise 처리 뒤 추가로 음성을 차단하는 게이트를 끔 |
| VAD 유예 / 소급 유예 | 200ms / 0ms; 임계값 0%에서는 게이트 동작 없음 |
| 추가 EQ·컴프레서·제한기 | 사용하지 않음 |

기존 RNNoise DLL은 공식 v1.10 배포 파일과 바이트 단위로 같음을 확인했다. 실제 플러그인을 마이크 없이 불러와 파라미터 저장·복원과 48kHz 합성 신호의 양 채널 출력을 확인한 뒤 프리셋을 연결했다. 이 검사는 플러그인과 설정의 유효성을 확인한 것이며, C10 실사용 음질을 검증한 것은 아니다.

VAD 임계값은 RNNoise의 잡음 제거 강도가 아니라, 처리한 블록 전체를 음소거할 음성 확률 기준이다. 0%에서도 RNNoise 처리는 실행되며 추가 게이트만 열려 있다. 임계값을 높이면 비발화 구간을 더 차단할 수 있으나, 발화 중 섞인 키보드만 제거하는 강도가 높아지는 것은 아니다. 약한 목소리나 말끝까지 차단할 수 있어 청취 비교가 필요하다. [v1.10 처리 순서와 VAD 판정 소스](https://github.com/werman/noise-suppression-for-voice/blob/v1.10/src/common/src/RnNoiseCommonPlugin.cpp)

후속 확인에서는 APO 설치 전의 같은 40cm 녹음에 RNNoise 미추가, VAD 0%, VAD 40%를 각각 적용한 오프라인 비교본을 만들었다. 세 파일의 재생 증폭은 모두 +10dB로 같고 별도 EQ·압축은 없다. 이 원본이 당시 Windows 효과까지 우회한 순수 무처리 음성인지는 확인하지 않았다. 15~20초 발화·타건 혼합 구간의 재생 증폭 전 전체 RMS는 -40.09dBFS, -40.42dBFS, -40.43dBFS로 차이가 작았다. 이 값은 키보드 단독 제거량이나 SNR이 아니며, 예전 입력에 대한 결과로 현재 실시간 처리의 감소량을 확정할 수 없다. 플러그인의 선언 지연은 0이지만 이 비교의 측정 지연은 약 20ms였으므로 파형의 단순 표본 차이도 제거량으로 해석하지 않는다. 실제 청취에서 충분한 개선이 있는지는 별도로 판단하며, 비교본 생성 중 시스템 프리셋은 VAD 0% 그대로 유지했다.

이 세 비교본은 사용자 청취에서도 차이를 구별하기 어려웠다. 같은 원본의 VAD 80·90·95% 후보도 오프라인에서 확인했으나, 주로 비발화 구간이 닫히고 발화·타건이 겹친 구간은 대부분 통과했다. 단순한 VAD 상향을 개선으로 채택하지 않는다.

추가로 새 RNNoise 모델을 포함한 v1.21 시험판을 작업 임시 폴더에서만 불러와 비교했다. 공식 배포 ZIP의 SHA-256을 GitHub 릴리즈 자산 값과 대조했고, VAD 0%, 유예 200ms, 소급 유예 0ms, 처리음 비율 100%로 시험했다. 새 네 개 파라미터의 저장·복원과 유한한 양 채널 출력을 확인했으며, 현재 시스템 DLL과 APO 설정 파일은 바꾸지 않았다. 이전 모델과 새 모델의 15~20초 혼합 구간 RMS는 지연 정렬 후 각각 -40.45/-40.85dBFS였다. 두 비교본은 동일하게 +10dB만 증폭했고, 짧은 청취본은 동일한 14~20초 구간이다. 이 작은 전체 음량 차이가 키보드 제거 성능의 향상을 증명하지는 않는다. v1.21은 정식 안정판으로 교체 설치한 상태가 아니다. [v1.21 시험판 릴리즈](https://github.com/werman/noise-suppression-for-voice/releases/tag/v1.21)

후속 피드백에서는 현재 설정으로 키보드 소리가 심하게 크지는 않다고 보고됐다. 새 모델의 6초 비교본은 키보드 소리가 더 줄었지만 목소리가 많이 먹먹해져 사용하기 어렵다는 청취 평가를 받았으므로 채택하지 않는다. 현재 RNNoise v1.10·VAD 0% 프리셋을 수용 가능한 기준으로 유지하고, 목소리를 손상하지 않으면서 잡음을 더 줄이는 이득이 확인될 때만 변경한다. 새 모델은 오프라인 비교에만 사용했으며 시스템 플러그인과 설정 파일에는 적용하지 않았다.

2026-09-06 21:43에는 사용자가 Windows 기본 녹음기(11.2607.1.0)에서 직접 녹음했다. 별도 MediaCapture 녹음 도구는 사용하지 않고 준비·발화·종료 신호음만 재생했다. 영상 소리를 멈추고 타건만 하는 구간과 말하며 타건하는 구간을 넣었으며, 재청취에서 **키보드가 줄고 목소리도 수용 가능하다**는 평가를 얻었다. 이는 일반 녹음기에서 확인한 첫 실사용 결과다.

저장 원본은 AAC·48kHz·2채널, 30.101초였고, 신호음과 준비·종료 여유 시간이 포함돼 있다. 전체 피크는 좌우 약 -12.76/-12.77dBFS이며, 디코딩한 표본 중 풀스케일 이상인 표본은 없었다. 재청취용 추가 EQ·증폭·소음 제거를 넣지 않았다. 이 원본의 작업용 사본은 바이트 그대로 보관하며 음성 파일은 웹 문서에 게시하지 않는다. 구간별 정확한 정렬이나 무처리 동시 녹음이 없어 소음 감소량을 수치로 확정하지 않는다.

이어 21:45~46에는 스피커로 영상을 재생하면서 같은 녹음기에서 타건·발화를 녹음했다. 재청취에서 **영상·키보드 소리가 충분히 작고 목소리도 수용 가능하다**는 평가를 얻어 초기 프리셋을 유지했다. Razer 음량은 녹음 직전 10%, 후속 조회에서 30%였으나, 사용자가 녹음 종료 후 재청취를 위해 올렸다고 확인했다. 따라서 이번 녹음 조건은 10%로 기록하며 30% 스피커 재생 조건을 검증한 것으로 해석하지 않는다.

영상 포함 원본은 AAC·48kHz·2채널, 52.715초다. 사용자 조작으로 녹음을 먼저 켜둔 시간이 포함돼 있으므로 파일 전체가 20초 시험 구간은 아니다. 전체 피크는 좌우 약 -13.28dBFS이고 풀스케일 이상으로 디코딩된 표본은 없었다. 이 파일도 추가 보정 없이 원본 그대로 재청취했다. Windows 녹음기의 두 조건에서는 개선을 확인했지만, 새 APO 프리셋을 적용한 뒤의 Discord·Steam 실제 송신 결과는 아직 별도 확인 전이다. 실제 통화 평가는 후속 실사용 때 진행하기로 하고 현재 프리셋을 유지한다. 이후에는 상대가 듣는 목소리 음량, 말끝 잘림, 타건음·스피커 재생음의 잔여 정도를 기준으로 필요한 부분만 조정한다.

완료 여부는 별도 통신용 테스트 도구를 종료한 상태에서 다음을 확인해 판단한다.

- 평소 사용하는 Windows 녹음기에서 C10 잡음 제거의 적용 여부와 목소리·타건음을 비교한다.
- Discord와 Steam 등 실제 사용하는 음성 채팅에서 상대가 받는 소리를 확인한다.
- 오디오 서비스 재시작 또는 재부팅 뒤에도 설정이 유지되고, 헤드셋 마이크에는 C10 전용 필터가 적용되지 않는지 확인한다.

## 일반·통신 기본 장치를 직접 바꾸는 방법 {#windows-default-devices}

Windows는 일반 소리와 통화용 소리에 사용할 기본 장치를 따로 정할 수 있다. Razer만의 기능이 아니라 Windows 오디오 장치의 역할 설정이다. 예를 들어 게임·영상은 스피커로 듣고 통화는 헤드셋으로 들으려면 두 역할에 서로 다른 장치를 지정할 수 있다. 두 종류의 소리를 모두 스피커로 들으려면 두 역할을 같은 스피커에 지정한다. [Microsoft 통신 장치 설명](https://learn.microsoft.com/en-us/windows/win32/coreaudio/using-the-communication-device)

| 출력 역할 | 변경 전 확인값 | 변경 후 |
| --- | --- | --- |
| 일반 기본 장치 | Razer Leviathan V2 X | Razer Leviathan V2 X |
| 기본 통신 장치 | C10 헤드폰 | Razer Leviathan V2 X |

이 변경은 게임·통화 소리를 어느 스피커로 재생할지 정한다. C10이 목소리를 받는 입력 장치라는 점은 그대로이며, Razer 스피커에 새 소음 억제 기능을 켠 것은 아니다. 앞서 좋은 평가를 받은 마이크 처리는 Windows 통신용 캡처에서 확인한 별도 기능이다.

### Windows 화면에서 변경하기

1. `Win + R`을 누르고 `mmsys.cpl`을 입력한 뒤 Enter를 누른다.
2. **재생** 탭에서 **스피커 — Razer Leviathan V2 X**를 찾는다.
3. 해당 항목을 우클릭하고 **기본 장치로 설정**을 선택한다.
4. 다시 우클릭하고 **기본 통신 장치로 설정**을 선택한다. 이미 지정된 역할의 메뉴가 비활성화돼 있다면 그 역할은 그대로 두면 된다.
5. **녹음** 탭에서는 **데스크톱 마이크 — 2- MATA STUDIO C10**을 일반 기본 장치와 기본 통신 장치로 지정한다.
6. **확인**으로 창을 닫는다.

스피커 대신 헤드셋으로 듣고 싶다면 재생 탭에서 사용할 헤드셋에 필요한 역할을 지정하면 된다. 특정 게임이나 통화 앱에서 출력 장치를 직접 지정했다면 해당 앱의 장치 선택도 확인한다. [Microsoft 기본 소리 설정 안내](https://support.microsoft.com/en-us/surface/audio/surface-sound-volume-and-audio-accessories)

### 이번에 자동으로 바꾼 방법

Windows 기본 내장 명령이 아닌 오픈소스 설정 도구 AudioDeviceCmdlets 3.1.0.2를 임시 폴더에서 불러와 Razer의 장치 ID와 이름을 확인한 다음, `Set-AudioDevice -ID … -CommunicationOnly`를 실행했다. 이 옵션은 선택한 장치의 통신 기본 역할만 바꾸므로 이미 Razer였던 일반 기본 출력과 C10 입력은 유지됐다. 변경 뒤에는 다른 CoreAudio 조회 도구로도 결과를 확인했다. [AudioDeviceCmdlets 명령 설명](https://github.com/frgnca/AudioDeviceCmdlets)

아래는 같은 작업을 다시 할 때 사용할 수 있는 예다. 이 PC에 받은 모듈 경로를 사용하므로, 임시 폴더를 정리한 뒤에는 경로를 준비하거나 위의 Windows 화면 방식으로 변경한다. 장치 번호와 ID는 다시 연결했을 때 달라질 수 있어, 현재 목록에서 이름과 종류를 확인한다.

```powershell
# Windows PowerShell에서 이 PC에 받은 모듈을 불러온다.
Import-Module 'H:\oojjrs.github.io\$Trash\c10-setup\audio-device-cmdlets\3.1.0.2\AudioDeviceCmdlets.psd1'

Get-AudioDevice -List |
    Format-Table Index, Name, Type, Default, DefaultCommunication

$razerDevices = @(Get-AudioDevice -List | Where-Object {
    $_.Type -eq 'Playback' -and $_.Name -like '*Razer Leviathan V2 X*'
})
if ($razerDevices.Count -ne 1) {
    throw 'Razer 출력 장치를 하나로 확인할 수 없습니다. 장치 목록을 확인하세요.'
}

Set-AudioDevice -ID $razerDevices[0].ID -CommunicationOnly
Get-AudioDevice -PlaybackCommunication
```

이 코드는 통신 출력만 바꾸는 예다. 현재처럼 일반 출력도 이미 Razer인 경우에 쓰면 된다. PowerShell을 종료하거나 설정용 모듈을 나중에 지워도 Windows에 저장된 기본 장치 선택은 유지되며, 마이크 사용 중 이 도구를 계속 실행할 필요는 없다.

## 1차 설정의 중단 기록 {#conclusion}

2026-09-05~06에 게임·Discord용 C10 설정을 다시 조사했다. 기존 설정 복기, Windows 입력 경로 확인, 두 거리에서의 녹음과 EQ·음색 비교까지 진행한 뒤 한 차례 추가 설정을 중단하고 헤드셋 마이크를 사용하기로 했다. 아래 중단 기록은 당시 상태이며, 같은 날 저녁의 재개 결과는 마지막 절에 구분했다.

목소리 톤은 두 거리 모두 수용 가능했지만 타건음이 크게 남았다. 스피커 게임 소리가 함께 나는 조건과 실제 Discord 송신 결과는 검증하지 않았다. 이 기록에는 실측값과 미리듣기 후보가 있으며, 최종 채택한 마이크 프리셋은 없다.

**1차 중단 시점까지 Windows 입력 음량·기본 장치, 시스템 EQ·피치·APO 설정은 변경하지 않았다.** EQ와 목소리 변조는 녹음 파일에만 적용했다. 2026-09-06 재확인에서도 기존 APO 설정 파일의 모든 필터 행은 비활성 상태였다. 이번에 만든 C10 보정이 헤드셋 입력에 연결된 상태는 아니다.

Discord 화면에서 별도로 변경한 항목의 최종값은 확인하지 않았다. 앱의 소음 억제 선택은 장치 효과와 구분해야 한다. Discord는 Krisp 선택이 이후 통화에도 유지된다고 안내한다. [Discord Krisp FAQ](https://support.discord.com/hc/en-us/articles/360040843952-Krisp-FAQ)

## 설명서와 공식 자료 {#sources}

| 자료 | 용도 |
| --- | --- |
| [마타스튜디오 C10 공식 영상 설명서](https://www.youtube.com/watch?v=QyCfTe-PLvg) | 마이크 설치, 연결, 연결 확인, 출력 장치 설정, FAQ |
| [Windows 마이크 설정과 테스트](https://support.microsoft.com/ko-kr/windows/hardware/drivers/how-to-set-up-and-test-microphones-in-windows) | Windows에서 입력 장치와 녹음 상태 확인 |
| [Equalizer APO 공식 문서](https://sourceforge.net/p/equalizerapo/wiki/Documentation/) | 오디오 장치 선택과 필터 구성 |
| [ReaPlugs 공식 페이지](https://www.reaper.fm/reaplugs/) | ReaGate, ReaEQ, ReaComp, ReaXcomp의 역할과 배포처 |
| [werman RNNoise 플러그인 공식 README](https://github.com/werman/noise-suppression-for-voice) | 소음 억제의 한계, 샘플레이트, 음성 감지 설정 |
| [Discord 마이크 테스트](https://support.discord.com/hc/en-us/articles/360020641332-Mic-Testing) | Discord가 받는 소리를 선택한 출력 장치로 확인 |
| [Discord Krisp FAQ](https://support.discord.com/hc/en-us/articles/360040843952-Krisp-FAQ) | Discord 내장 소음 억제 설정과 음질 영향 |

C10 영상은 공식 채널의 2026-07-09 게시물이며 길이는 4분 26초다. 설명란에서 확인한 구간은 [설치 00:11](https://www.youtube.com/watch?v=QyCfTe-PLvg&t=11s), [연결 00:34](https://www.youtube.com/watch?v=QyCfTe-PLvg&t=34s), [연결 확인 01:04](https://www.youtube.com/watch?v=QyCfTe-PLvg&t=64s), [출력 장치 01:56](https://www.youtube.com/watch?v=QyCfTe-PLvg&t=116s), [FAQ 02:23](https://www.youtube.com/watch?v=QyCfTe-PLvg&t=143s)다.

영상의 내레이션 전체와 FAQ 답변은 아직 확인하지 않았다. 공개된 공식 PDF 설명서는 이번 검색에서 찾지 못했다. 2024년에 사용한 제품과 영상 속 제품의 세부 차이도 미확인이다.

## 2024년 설정 기록 {#previous-setup}

원자료는 2024-12-18 작성된 개인 기록 「마이크 설정에 관하여.pdf」 3쪽이다. 당시 참조한 글은 [Project Eli의 마이크 설정 가이드](https://projecteli.tistory.com/167)다. 아래 값은 당시 기록이며 현재 권장값이 아니다.

| 항목 | 문서에서 확인한 내용 |
| --- | --- |
| 프로그램 | Equalizer APO 1.4, ReaPlugs, werman 계열 RNNoise 플러그인 |
| 대상 장치 | 재생 장치가 아닌 Capture 장치의 데스크톱 마이크 MATA STUDIO C10 선택 |
| Windows 입력 볼륨 | 11로 맞췄다는 기록과 80%였을 수도 있다는 기록이 함께 있어 최종값 불명 |
| APO 프리앰프 | 마지막 스크린샷에 +9 dB |
| ReaGate | 스크린샷 기준 임계값 -50 dB, Attack 3 ms, Hold 0 ms, Release 10 ms, Hysteresis 0 dB |
| ReaEQ | 적용하지 않았다고 명시 |
| 필터 나열 순서 | 장치 선택 → 프리앰프 → ReaGate → RNNoise → ReaComp → ReaXcomp |
| 남아 있던 증상 | 입력 볼륨이 저절로 바뀌는 느낌, 날카로운 숨소리, 말하는 동안 남는 클릭음 |
| 제한기 | 본문에는 적용하지 않았다고 기록 |

마지막 스크린샷에서 RNNoise, ReaComp, ReaXcomp는 회색 항목과 검정 전원 아이콘으로 표시된다. 해당 UI는 명령을 실행하지 않는 비활성 상태라는 [Equalizer APO 공식 프로젝트 포럼 설명](https://sourceforge.net/p/equalizerapo/discussion/general/thread/7e6b4c486a/)과 일치한다. 즉, 그 화면에는 플러그인이 등록되어 있지만 세 개는 꺼져 있다. 다른 시점의 활성 상태나 당시 클릭음의 원인까지 확정할 수는 없다.

## 재시도 참고사항 {#principles}

**말하는 동안의 타건음과 말하지 않을 때의 타건음을 따로 평가한다.** werman 플러그인 개발자는 기계식 키보드처럼 큰 소리는 음성이 없을 때 억제되지만, 음성이 있을 때는 음량을 줄이는 수준이라고 설명한다. 당시 남은 클릭음은 이 한계와 부합하지만, 활성 상태와 실제 녹음을 확인해야 원인을 좁힐 수 있다. [RNNoise 플러그인 README](https://github.com/werman/noise-suppression-for-voice)

**RNNoise를 사용할 때는 처리 샘플레이트를 확인한다.** 위 플러그인의 README는 48,000 Hz 입력을 요구한다. 마이크의 최대 지원 수치만 보고 샘플레이트를 높이지 않는다. 설치된 플러그인 버전과 Windows 장치 형식을 함께 기록한다. [RNNoise 플러그인 README](https://github.com/werman/noise-suppression-for-voice)

**ReaGate의 Release는 게이트가 닫히는 시간이다.** 당시 10 ms를 최적값으로 재사용하지 않는다. 말끝이 잘리거나 열리고 닫히는 경계가 거슬리면 임계값, Hold, Release를 하나씩 비교한다. 이는 재설정 시 확인할 가설이며 당시 증상의 확정 원인은 아니다. [REAPER 효과 설명서의 ReaGate 항목](https://www.reaper.fm/guides/ReaEffectsGuide.pdf#page=23)

**EQ, 소음 억제, 음량 보정은 역할이 다르다.** ReaEQ는 주파수별 톤 조절, ReaGate는 일정 음량 아래에서 신호를 닫는 처리, ReaComp는 컴프레서, ReaXcomp는 주파수 대역별 컴프레서다. ReaComp와 ReaXcomp를 함께 쓰는 구성을 기본값으로 삼지 말고 필요한 효과부터 확인한다. [ReaPlugs 공식 설명](https://www.reaper.fm/reaplugs/)

**Windows 처리도 소음 억제 비교에 포함한다.** 이 PC에서는 Windows 자체 효과가 발견됐다. 재시도 시에는 기존 Windows 처리와 Discord 소음 억제 ‘없음’을 출발점으로 삼고, 필요하면 Krisp를 켠 결과와 비교할 수 있다. APO 재설치는 이 비교 이후에 판단한다. Discord도 조용한 환경에서는 Krisp로 음질이 저하될 수 있다고 안내한다. [Discord Krisp FAQ](https://support.discord.com/hc/en-us/articles/360040843952-Krisp-FAQ)

## 2026-09-05 설치 흔적과 입력 경로 {#input-path}

이전 기본 경로와 설치 흔적을 확인했다.

- Equalizer APO 기본 설치 폴더의 `config\config.txt`가 남아 있으며 장치 선택과 모든 필터 행 앞에 `#`가 붙어 있다. 이 파일에는 활성 설정 행이 없다.
- 남아 있는 주석에는 프리앰프 +10 dB와 LoudMax 제한기가 포함되어 있다. 2024년 PDF의 마지막 화면과 구성이 다르다.
- Equalizer APO 기본 경로에는 설정 폴더만 남아 있고 실행 파일과 프로그램 제거 항목은 발견되지 않았다. ReaPlugs 기본 경로에도 플러그인 DLL이 없다.
- 이전 경로의 `win-rnnoise\vst\rnnoise_mono.dll`과 `rnnoise_stereo.dll`은 남아 있다.
- 주석 속 과거 장치 식별자는 현재 연결된 C10의 식별자와 다르다. 이전 설정을 그대로 활성화하는 것으로 복원이 끝나지 않는다.

기존 설정 파일과 Windows 입력 상태를 작업용 폴더에 보관했다. 시스템 음량, 기본 장치, 드라이버, APO 설정은 변경하지 않았다.

| 확인 항목 | 실제 확인값 |
| --- | --- |
| Windows / Discord | Windows 11 Pro, 빌드 26200 / Discord 데스크톱 앱 |
| 기본 입력 / 기본 통신 입력 | 모두 데스크톱 마이크(MATA STUDIO C10) |
| 기본 출력 / 기본 통신 출력 | 모두 같은 USB 스피커 |
| 스피커 음량 | 추가 조회 시 Windows 기준 20%; 게임 내부 음량과 실제 음압은 미확인 |
| Windows 마이크 입력 음량 | 100%, 0 dB, 음소거 해제; 두 녹음 전후 동일 |
| Windows 공유 모드 믹스 형식 | 48,000 Hz, 32비트, 2채널; 마이크 ADC의 물리적 비트 깊이를 뜻하지 않음 |
| 실제 비교 녹음 형식 | FFmpeg DirectShow, 48,000 Hz, PCM 16비트, 2채널 |
| 물리적 배치 | 평소 입에서 약 35~40 cm; 비교 시 10~15 cm 요청 |
| 아직 확인하지 않은 항목 | USB 포트 위치, 본체 조절 위치, 거치·키보드 위치, Discord 개별 설정 |

### Windows 자체 처리 확인

C10에 대해 Windows 공개 API `AudioCaptureEffectsManager`로 미디어 용도와 처리 모드별 효과를 조회했다. [Microsoft API 설명](https://learn.microsoft.com/en-us/uwp/api/windows.media.effects.audiocaptureeffectsmanager?view=winrt-26100)

| 요청한 용도 / 처리 모드 | 보고된 효과 |
| --- | --- |
| Other / Default | 소음 억제 On |
| Communications, GameChat, Speech 각각 / Default | 에코 제거, 소음 억제, 자동 게인, 심층 소음 억제 모두 On |
| 위 네 용도 각각 / Raw | 효과 목록 비어 있음 |

보고된 효과는 모두 `CanSetState=false`여서 이때 조회한 효과 객체에서는 상태 변경이 지원되지 않았다. 이 결과는 장치·용도별 처리 경로에 대한 조회다. 이미 실행 중인 Discord나 FFmpeg의 개별 스트림이 어떤 용도를 요청했는지는 확인하지 않았으므로 두 녹음을 ‘무처리 원음’이라고 부르지 않는다.

Microsoft Voice Clarity 드라이버도 설치되어 있었다. Microsoft는 Voice Clarity 또는 Studio Effects 활성 시 OEM 소프트웨어 APO를 대체한다고 설명한다. 이 설명만으로 Equalizer APO와의 공존 여부를 확정할 수는 없다. 해당 효과가 두 DirectShow 녹음이나 Discord 송신에 실제로 적용됐는지도 확정하지 않았다. [Microsoft 드라이버 문서](https://learn.microsoft.com/en-us/windows-hardware/drivers/audio/pkey-devices-audiodevice-microphone-eqcoefficientsdb)

## 거리 비교 녹음 {#distance}

같은 Windows 입력 음량에서 각각 약 20초 녹음했다. 요청한 순서는 5초 조용히, 10초 평소 말투, 마지막 5초 말하면서 타건이다. 실제 말 시작 시점이 서로 달라 요청한 시간대로 음성과 소음을 분리하지 않았다.

| 지표 | 35~40 cm | 10~15 cm 요청 후 |
| --- | ---: | ---: |
| 전체 RMS | -40.57 dBFS | -34.80 dBFS |
| 최대 피크 | -20.31 dBFS | -13.65 dBFS |
| 큰 소리 구간 RMS¹ | -35.08 dBFS | -29.40 dBFS |
| 디지털 클리핑 표본 | 0% | 0% |

¹ 10 ms 단위 구간 중 음량이 큰 상위 25%를 합산한 RMS다. 음성만 분리한 수치가 아니며, dBFS는 녹음 신호의 최대 표현값을 기준으로 한 수치다.

가까운 녹음의 큰 소리 구간은 약 5.68 dB 높았다. 발화 차이와 Windows 처리의 영향이 있을 수 있으므로 거리만의 정확한 증폭량이나 신호 대 잡음비 개선량으로 해석하지 않는다. 두 녹음 모두 클리핑은 없었다. 청취 비교에서는 두 거리의 목소리 톤 모두 수용 가능했지만 타건음이 크게 남아 소음 억제가 우선 과제로 남았다. 말끝 잘림과 숨소리는 아직 개별 평가하지 않았다.

청취 비교본은 먼 녹음에 +10 dB, 가까운 녹음에 +4.32 dB만 더해 위 지표를 비슷하게 맞췄다. 추가 EQ나 소음 제거를 적용하지 않았고 Windows 설정도 바꾸지 않았다.

### 반복 녹음용 대사

- 처음 5초: 말하지 않고 평소 배치 유지.
- 다음 10초: “마이크 테스트를 시작합니다. 지금은 평소 게임할 때처럼 이야기하고 있습니다. 작은 말소리와 문장 끝까지 자연스럽게 들리는지 확인합니다.”
- 마지막 5초, 키보드를 누르며: “지금은 키보드를 누르면서 말하고 있습니다. 목소리가 또렷하게 들리면 좋겠습니다.”

대사를 시간에 억지로 맞추기보다 평소 말투를 유지한다. 정밀 비교가 필요하면 조용함, 타건만, 말만, 말과 타건을 각각 별도 녹음한다.

## EQ와 음색 미리듣기 {#tone}

가까운 녹음의 3~15초 구간으로 기본 톤과 가벼운 EQ 보정본을 만들었다. 낮은 대역 정리와 상부 중역 보강은 음성 명료도를 조절하는 일반적인 방법이다. 아래 수치는 이번 비교를 위한 후보이며 C10 제조사 권장값이나 검증된 최종값이 아니다. [Shure의 주파수 응답 설명](https://www.shure.com/en-US/insights/mic-basics-frequency-response)

| 필터 | 후보값 |
| --- | --- |
| 하이패스 | 80 Hz, 2차, Q 0.707 |
| 낮은 중역 피킹 EQ | 250 Hz, -2 dB, Q 0.9 |
| 명료도 피킹 EQ | 3,000 Hz, +1.8 dB, Q 0.7 |

두 12초 비교본의 전체 RMS를 -22.123 dBFS로 맞췄다. 기본 톤의 피크는 -2.698 dBFS, 보정본은 -1.500 dBFS이며 클리핑 표본은 없다. RMS 일치는 지각 음량이 완전히 같다는 뜻은 아니다. 보정 과정에는 추가 소음 억제를 넣지 않았다.

이 EQ는 녹음 파일에만 적용한 미리듣기이며 시스템이나 Discord에 설치·적용하지 않았다. 재시도 시에는 목소리가 얇아지거나 타건음·숨소리가 도드라지는지 함께 평가해야 한다.

가벼운 EQ의 차이는 청취에서 뚜렷하게 느껴지지 않아 채택하지 않았다. EQ 보정과 목소리 변조의 차이를 비교하기 위해 음높이를 +2반음 올리고 포먼트도 함께 이동한 후보를 추가했다. Rubber Band 필터에서 템포 1, 피치 배율 1.122462048, 포먼트 shifted를 사용했다. 기본 8초 → 0.75초 무음 → 변조 8초의 비교본이며 각 구간 RMS는 -22.123 dBFS, 피크는 각각 -3.162 / -2.859 dBFS로 클리핑이 없다. 이 변조도 파일 미리듣기만 수행했으며 실시간 통화에 적용하지 않았다. 변조 후보의 최종 선호는 확인하지 않았다.

## 중단 당시 실행·미실행 구분 {#final-state}

| 항목 | 확인 상태 |
| --- | --- |
| 입과 마이크 거리 | 약 35~40 cm와 10~15 cm 요청 후 조건을 비교; 장시간 사용 편의는 미검증 |
| Windows 입력 음량 | 실측 당시 100%; 변경하지 않음. 가까운 녹음에서도 클리핑 없음 |
| Discord 입력 / 출력 | 앱에서 선택된 장치는 확인하지 않음 |
| Discord 소음 억제 | ‘없음’으로 비교하는 안을 제시했으나 최종 선택은 미확인 |
| Discord 에코 제거 | 스피커 사용 시 켜는 안을 제시했으나 최종 선택은 미확인 |
| Discord 자동 증폭 조절 | 상태 미확인; 변경하지 않음 |
| 추가 APO, RNNoise, EQ, 컴프레서 | 시스템 적용 없음; 녹음 파일의 EQ·피치 후보만 생성 |
| 게임 소리가 켜진 조건 | 녹음·청취하지 않음 |
| Windows 통신용 캡처 | Communications + Default를 명시하는 20초 녹음 도구의 문법·타입 검사만 완료. 실제 초기화·녹음은 실행하지 않음 |
| C10 사용 | 추가 설정 중단, 헤드셋 마이크 사용으로 전환 결정 |
| 최종 채택값 | 없음 |

스피커 게임 소리가 커질수록 입력에 유입될 가능성이 커진다. 특히 게임 속 사람 목소리까지 일반 소음 억제가 제거한다고 가정하지 않는다. Discord는 Krisp를 사람 목소리 외의 배경 소음을 줄이는 기능으로 설명한다. [Discord Krisp FAQ](https://support.discord.com/hc/en-us/articles/360040843952-Krisp-FAQ)

Discord 마이크 테스트는 입력을 선택한 출력으로 되들려준다. 스피커로 들으면 그 재생음이 다시 마이크에 들어갈 수 있으므로 정상 통화와 같은 조건으로 해석하지 않는다. 녹음 후 게임 소리를 멈추고 재생하는 검사와 실제 통화 결과를 구분한다. [Discord 마이크 테스트](https://support.discord.com/hc/en-us/articles/360020641332-Mic-Testing)

자동으로 수행한 범위는 장치·설치 흔적 조사, 기존 설정 보관, Windows 음량·형식·효과 조회, DirectShow 거리 비교 녹음 2회, 수치 분석, 녹음 파일의 음량·EQ·피치 미리듣기 생성과 이 기록 작성이다. Windows 음량·기본 장치·시스템 효과나 Discord 데스크톱 설정은 직접 변경하지 않았다.

## 2026-09-06 설정 재개와 통신용 녹음 {#resumed-session}

사용 조건을 스피커와 입에서 약 35~40cm 거리로 정하고 다시 진행했다. Windows에서는 C10이 `데스크톱 마이크(2- MATA STUDIO C10)`이라는 새 입력 엔드포인트로 인식됐다. 기본 일반·통신 입력은 모두 C10, 입력 음량은 100%, 공유 믹스 형식은 48kHz였다. 입력 장치의 이름·식별자가 달라질 수 있으므로 과거 식별자를 고정한 녹음 도구는 다시 확인해야 한다.

### 녹음 방식과 신호

이번에는 Windows MediaCapture에서 `Communications + AudioProcessing.Default`를 명시했다. 최초 실행은 PowerShell의 `IAsyncAction` 형식 변환 오류로 녹음 전에 중단됐다. 정확한 `AsTask(IAsyncAction)` 오버로드를 호출하도록 수정하고, 마이크를 사용하지 않는 실제 Windows 비동기 파일 작업으로 변환·완료 대기를 검증했다.

화면 문장만으로는 녹음 시점을 맞추기 어려워, 말소리가 거의 없는 한 회차는 음질 비교에서 제외했다. 이후부터 녹음 초기화가 끝난 뒤 실제 스피커 신호로 순서를 알리도록 바꿨다.

1. 준비음 세 번 후 녹음 시작: 키보드만 누른다.
2. 실제 녹음 시작 5초 뒤 높은 음 두 번: 키보드를 누르면서 대사를 읽는다.
3. 총 20초에 녹음을 멈추고 파일을 닫은 뒤 종료음을 낸다.

대사 시작음은 녹음 구간 안에 들어가므로, 수치 비교에서는 신호가 있는 5초대 구간을 제외했다. 미리듣기는 녹음이 끝난 뒤 재생한다.

### 실제 캡처 경로의 효과

이전의 장치·용도별 목록 조회와 달리 이번에는 초기화한 `MediaCapture.AudioDeviceController`의 효과 목록을 읽었다.

| 효과 | 상태 | 이 효과 객체의 상태 변경 지원 |
| --- | --- | --- |
| AcousticEchoCancellation | On | false |
| NoiseSuppression | On | false |
| AutomaticGainControl | On | false |
| DeepNoiseSuppression | On | true |
| BeamForming | Off | false |

이 표는 이번 MediaCapture 녹음 인스턴스에서 확인한 결과다. 별도 프로그램인 Discord의 캡처 경로를 직접 조회한 결과는 아니다. 효과의 상태 변경 메서드는 호출하지 않았다.

### 35~40cm에서의 타건 비교 결과

게임 소리는 멈춘 상태에서 약 20초를 녹음했다. 파일은 48kHz·모노·PCM 16비트, 실제 길이 20.01초다.

| 구간·지표 | 확인값 |
| --- | ---: |
| 전체 RMS | -27.70 dBFS |
| 전체 피크 | -6.62 dBFS |
| 처음 4.8초, 타건만 하도록 한 구간의 RMS | -92.62 dBFS |
| 6초 이후, 발화와 타건 구간의 RMS | -26.15 dBFS |
| 클리핑 표본 | 0 |

청취에서는 키보드 소리가 크게 줄고 목소리도 수용 가능한 결과를 얻었다. 조용한 구간의 작은 수치는 처리 후 신호를 뜻하며, 별도의 무처리 동시 녹음이 없으므로 소음 감소량이나 마이크 자체의 신호 대 잡음비로 해석하지 않는다. 미리듣기 파일에는 음량을 약 2.43dB 낮춘 것 외에 추가 EQ·소음 억제를 적용하지 않았다.

이 결과를 다음 비교의 기준으로 삼았다. Discord 소음 억제 선택은 ‘없음’으로 확인했다.

### 스피커 영상 소리와 타건을 함께 넣은 결과

같은 35~40cm 거리에서 Razer Leviathan V2 X 스피커로 영상을 재생하고, 처음 5초는 타건만, 이후 15초는 타건하면서 말하는 조건으로 녹음했다. 영상 선택 중에 진행된 회차는 비교에서 제외하고, 재준비 후 완료한 20.01초 녹음을 평가했다.

이번 녹음에서는 활성 AEC 객체의 `SetEchoCancellationRenderEndpoint`에 Razer 출력 식별자를 전달했고 요청이 정상 수락됐다. 이 호출은 스피커 재생음을 에코 제거의 참조로 지정한다. 요청 성공을 기록한 것이며, 실제 참조 장치를 별도 getter로 재조회한 결과는 아니다. [Microsoft AEC 참조 출력 API](https://learn.microsoft.com/en-us/uwp/api/windows.media.effects.acousticechocancellationconfiguration.setechocancellationrenderendpoint?view=winrt-26100)

| 구간·지표 | 확인값 |
| --- | ---: |
| 전체 피크 | -9.50 dBFS |
| 처음 4.8초, 영상과 타건만 하도록 한 구간의 RMS | -86.54 dBFS |
| 6초 이후, 발화·영상·타건 구간의 RMS | -29.01 dBFS |
| 클리핑 표본 | 0 |

사용자 청취에서는 영상 소리가 거의 들리지 않고 목소리도 수용 가능했다. 미리듣기는 음량을 약 0.52dB 높였으며 추가 EQ·소음 억제를 적용하지 않았다. 무처리 동시 녹음이 없어 제거량을 dB 단위로 계산할 수는 없다. 결과는 이번 영상과 재생 음량에 해당하며, 모든 게임 소리·음량에서 같은 성능을 보장하지 않는다.

35~40cm·스피커 조건에서 사용할 수 있는 Windows 통신용 녹음 경로는 확인했다. Discord가 이 경로와 같은 효과를 쓰는지는 확인하지 않았으며, 아래 마이크 테스트와 실제 통화 결과는 구분해서 평가한다. Razer 참조 지정도 이번 MediaCapture 녹음 인스턴스에 대한 요청이며 Discord 설정을 변경한 것은 아니다.

### Discord 마이크 테스트의 다시 듣기

Discord 마이크 테스트에서는 실행 중 자기 목소리가 Razer 스피커로 되돌아오는 것을 확인했다. 테스트가 끝난 뒤 비교 청취할 파일을 남기기 위해 Windows의 프로세스별 오디오 루프백을 사용했다. Discord 프로세스와 자식 프로세스의 재생음만 포함하므로, 별도 앱에서 재생하는 영상 원음은 이 파일에 직접 섞이지 않는다. 영상 소리가 마이크를 거쳐 Discord 출력에 남으면 함께 기록된다. [Microsoft 프로세스별 루프백 예제](https://learn.microsoft.com/en-us/samples/microsoft/windows-classic-samples/applicationloopbackaudio-sample/)

녹음 도구는 NAudio.Wasapi 3.0.1을 작업 임시 폴더에서 사용한다. 마이크를 별도로 열거나 시스템 입력 경로를 바꾸지 않고 Discord가 재생한 소리를 WAV에 저장한다. 자기 프로세스의 합성음으로 저장 동작을 먼저 검증한 뒤 실제 테스트를 진행했다.

| 구간·지표 | 확인값 |
| --- | ---: |
| 저장 파일 길이 | 27.99초 |
| 파일 형식 | 48kHz·스테레오·PCM 16비트 |
| 전체 RMS | -25.98 dBFS |
| 전체 피크 | -3.47 dBFS |
| 클리핑 표본 | 0 |

재청취 파일에는 약 -4.27dB의 음량 조절만 적용했다. 추가 EQ·소음 억제는 넣지 않았다. 첫 시도는 녹음 시작 전 로그 파일 공유 오류로 WAV가 만들어지지 않았다. 다음 시도는 파일 저장이 완료됐지만 종료 상태 판정 오류로 종료음이 재생되지 않아, 저장 완료 로그와 WAV를 별도로 확인했다.

이 파일은 Discord 마이크 테스트의 되듣기 출력이다. 스피커에서 나온 자기 목소리가 다시 마이크에 들어갈 수 있으므로, 상대방이 받는 실제 통화 음성과 동일하다고 단정하지 않는다. 소음 억제 ‘없음’ 상태의 재청취에서는 Windows 통신용 녹음보다 목소리 품질이 떨어지고 키보드 소리가 일부 남았다. 영상 소리는 거의 들리지 않았다. 이 테스트의 설정은 사용자 확인 기준으로 에코 제거 켬, 자동 증폭 조절 켬이었다. 이 결과만으로 특정 효과가 음질 저하의 원인이라고 단정하지 않는다.

종료음 문제는 Windows PowerShell 5.1에서 종료된 자식 프로세스의 종료 코드가 `null`로 조회되는 현상으로 재현했다. 시작 직후 프로세스 핸들을 보존하도록 수정했으며, 마이크를 사용하지 않는 성공·실패 자식 프로세스로 종료 코드 0과 7을 각각 정상 구분하는 것을 검증했다.

### 자동 증폭 조절 비교의 조건 차이

에코 제거 켬·소음 억제 ‘없음’을 유지하고 자동 증폭 조절만 끈 27.99초 녹음을 추가했다. 녹음과 종료 절차는 정상 완료됐다. 그러나 이전보다 스피커 재생음이 크게 들렸다는 보고가 있어, 이 회차를 자동 증폭 조절 켬·끔의 통제된 비교에서 제외했다. 재생음이 커진 정도는 청취 보고이며 측정한 음압 배율이 아니다.

녹음 후 조회한 Windows의 Razer 출력 음량은 10%였다. 녹음 중 값은 측정하지 않았으므로 이 값을 해당 회차의 음량으로 소급해서 기록하지 않는다. 이 회차만으로는 자동 증폭 조절을 끄면 음질이 개선된다는 결론을 내리지 않고, 영상 앱의 음량과 재생 구간을 맞춘 재비교로 넘어갔다.

### 같은 음량으로 비교한 Discord 설정

재생 음량을 다시 맞춘 뒤 자동 증폭 끔·소음 억제 ‘없음’으로 재녹음했다. 이어 에코 억제 켬·자동 증폭 끔을 유지한 채 소음 억제만 Krisp로 바꿔 비교했다. 두 회차 모두 Windows의 Razer 출력은 녹음 전후 10%였다.

| 설정 | 사용자 청취 평가 | 이후 선택 |
| --- | --- | --- |
| 소음 억제 없음, 에코 켬, 자동 증폭 끔 | 이전보다 목소리가 개선됨. 작은 타건음과 아주 작은 영상 소리가 남으나 타건음은 수용 가능한 수준 | 비교 기준으로 유지 |
| Krisp, 에코 켬, 자동 증폭 끔 | 잡음은 줄었으나 목소리가 먹먹하거나 끊김 | 제외, ‘없음’으로 복귀 확인 |

두 원본의 길이는 각각 27.99초다. 전체 피크는 소음 억제 ‘없음’에서 -14.52dBFS, Krisp에서 -16.79dBFS이며 클리핑 표본은 모두 0이다. 청취용 파일은 각각 약 +7.52dB, +7.25dB 조절했다. 이 보정은 파일 재생용이며 실제 Discord 송신 음량을 올린 것이 아니다. 실제 통화에서 전달되는 음량은 별도로 확인해야 한다.

### 스피커 음량을 맞춘 Windows 재검증

앞서 좋은 평가를 받은 Windows 통신용 녹음의 스피커 음량이 후속 Discord 시험과 같았는지 확인되지 않아 Windows도 다시 녹음했다. 디스코드 마이크 테스트는 끄고 같은 영상·거리 조건을 사용했으며, Razer 출력은 녹음 전후 10%였다. 타건 5초와 발화 20초로 사용자 동작 시간을 맞췄다. Windows 파일에는 녹음 전 준비음 시간이 포함되지 않으므로 파일 길이는 Discord 재생음 파일보다 약 3초 짧다.

MediaCapture의 Communications·Default 설정과 Razer AEC 참조 요청을 사용했다. 실제 효과 목록은 AEC·NoiseSuppression·AGC·DeepNoiseSuppression 켬, BeamForming 끔으로 이전과 같았으며 AEC 참조 요청도 정상 수락됐다.

| 지표 | 확인값 |
| --- | ---: |
| 파일 길이 | 25.03초 |
| 전체 RMS | -28.30 dBFS |
| 전체 피크 | -4.21 dBFS |
| 처음 4.8초, 타건과 영상 구간의 RMS | -89.48 dBFS |
| 6초 이후, 발화 구간의 RMS | -27.11 dBFS |
| 클리핑 표본 | 0 |

청취본은 약 -1.47dB 조절해 Discord 비교본과 발화 음량을 대략 맞췄다. 이 비교는 각각의 캡처 경로 전체 결과를 비교한다. Discord에는 스피커 자기 목소리 모니터링이 포함되고 Windows에는 없으므로, 특정 소음 억제 효과 하나의 우열을 분리해 증명하는 시험은 아니다. 같은 음량으로 재청취한 결과 Windows 녹음이 확실히 좋다는 평가를 얻었다. Discord도 목소리의 자연스러움은 수용 가능했으나, 타건음이 겨우 거슬리지 않을 정도로 남았다. 따라서 마이크 거리와 스피커 음량만으로 이번 차이를 설명하지 않고, 처리 경로와 자기 목소리 모니터링 조건을 구분해서 본다.

### APO 설치 전의 Windows 기본 장치와 상주 프로그램 검토

최종 확인에서 Windows의 일반·통신 기본 입력은 모두 C10이었다. 일반 기본 출력은 Razer였으나 통신 기본 출력은 C10 헤드폰으로 남아 있어, 통신 기본 출력도 Razer로 변경했다. 변경 전 상태를 보관하고 AudioDeviceCmdlets의 `CommunicationOnly` 동작으로 해당 역할만 변경했으며, 기존 CoreAudio 조회 도구로 일반·통신 입력과 출력이 모두 의도한 장치를 가리키는 것을 별도로 검증했다. C10 입력 음량 100%·음소거 해제·48kHz도 확인했다.

장치 선택용 도구는 설정 때만 실행되며 이후 마이크 사용에 필요하지 않다. 녹음·다시 듣기 도구와 라이브러리는 작업 임시 폴더에 있고, 자동 시작 작업이나 상주 음성 중계 프로그램을 등록하지 않았다.

좋은 Windows 녹음은 캡처 도구가 Communications와 Default 처리를 요청한 결과다. Windows에서 앱이 요청하는 오디오 범주와 드라이버의 처리 모드가 연결되므로, C10을 기본 입력으로 지정하는 것만으로 모든 앱에 같은 처리를 강제하지는 못한다. 특히 Raw 캡처는 가변 소음 억제·에코 제거·자동 증폭을 포함하지 않는 것이 규칙이다. 이 단계에서는 기존 Windows 처리 기능을 사용하는 기본 상태였으며, 모든 게임의 송신 음질이 동일하다고 확인한 상태는 아니었다. [Microsoft 오디오 처리 모드](https://learn.microsoft.com/en-us/windows-hardware/drivers/audio/audio-signal-processing-modes)

Windows 처리 결과를 먼저 만든 뒤 가상 마이크로 전달하는 구성도 검토했다. 이 방식의 중계 프로그램은 마이크를 사용하는 동안 실행돼야 하며, VB-CABLE 자체는 입력 소리를 출력으로 전달할 뿐 소음 억제를 제공하지 않는다. 관리 부담과 실제 사용 앱의 장치 선택을 고려해 VB-CABLE 설치와 상주 중계 도입은 보류했다. [VB-CABLE 공식 설명](https://vb-audio.com/Cable/)

Discord의 자동 입력 감도는 자동 증폭과 별개로, 음성을 전송할 문턱을 정하는 기능이다. 조용할 때의 타건에 반응하거나 작은 목소리·말끝이 끊기는 문제와 관련될 수 있지만, 말하는 동안 함께 들어오는 타건음을 분리해 제거하는 기능은 아니다. 이번에는 사용자 선택에 따라 자동 감도를 켠 상태로 유지하고 수동 조정을 진행하지 않았다. 마이크 테스트가 이 문턱을 실제 송신과 동일하게 반영하는지도 확인하지 않았다. [Discord 입력 감도 안내](https://support.discord.com/hc/en-us/articles/211376518-Voice-Input-Modes-101-Push-to-Talk-Voice-Activated)
