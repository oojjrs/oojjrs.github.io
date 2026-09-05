---
layout: reference
title: "C10 마이크 설정 실험 기록"
lang: ko-KR
category: "PERSONAL NOTES"
description: "마타스튜디오 C10의 이전 설정 복기, Windows 입력 경로 조사, 거리·EQ·음색 비교와 중단 당시 상태를 정리한 기록."
permalink: /kr/notes/mata-studio-c10/
status: "보관 · 최종 설정 미채택"
last_updated: "2026-09-06"
summary: "거리 비교와 파일 미리듣기까지 진행한 뒤 C10 추가 설정을 중단했다. EQ·목소리 변조를 실시간 입력에 적용하지 않았으며, 헤드셋 마이크를 사용하기로 했다."
toc_items:
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
---

## 중단 당시 결론 {#conclusion}

2026-09-05~06에 게임·Discord용 C10 설정을 다시 조사했다. 기존 설정 복기, Windows 입력 경로 확인, 두 거리에서의 녹음과 EQ·음색 비교까지 진행한 뒤 추가 설정을 중단했다. 이후에는 헤드셋 마이크를 사용하기로 했다.

목소리 톤은 두 거리 모두 수용 가능했지만 타건음이 크게 남았다. 스피커 게임 소리가 함께 나는 조건과 실제 Discord 송신 결과는 검증하지 않았다. 이 기록에는 실측값과 미리듣기 후보가 있으며, 최종 채택한 마이크 프리셋은 없다.

**이번 작업에서 Windows 입력 음량·기본 장치, 시스템 EQ·피치·APO 설정은 변경하지 않았다.** EQ와 목소리 변조는 녹음 파일에만 적용했다. 2026-09-06 재확인에서도 기존 APO 설정 파일의 모든 필터 행은 비활성 상태였다. 이번에 만든 C10 보정이 헤드셋 입력에 연결된 상태는 아니다.

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
