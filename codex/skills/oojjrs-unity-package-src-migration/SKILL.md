---
name: oojjrs-unity-package-src-migration
description: Assets 아래에 있던 Unity 패키지를 Packages/src 루트 패키지로 정리하고, Unity 패키지 관례에 맞춰 Runtime, Editor, Tests, Samples~, Documentation~를 구성한다. package.json, .meta, asmdef, 에디터 코드, 포함/제외할 에셋 판단, 경로/문서/버전 갱신, 선택적 stage/commit/push가 필요한 작업에 사용한다.
---

# oojjrs Unity Package Src Migration

## Text File Discipline

For existing text files, preserve the current encoding and line endings exactly; do not normalize to CRLF unless the file already used CRLF or the user explicitly asks.

이 스킬은 Unity 패키지가 `Assets` 아래에 들어 있어 실제 패키지 루트를 `Packages/src`로 정리하는 절차를 다룬다. 이 사용자의 로컬 개발 규칙에서는 `com.oojjrs.*` 같은 패키지명 폴더 대신 `src`를 패키지 루트 폴더명으로 사용한다.

Unity 패키지 관례상 패키지 루트 아래에 `package.json`이 있고, 공유 코드와 에셋은 루트 내부의 `Runtime` 폴더에 둔다. 따라서 기본 구조는 `Packages/src/package.json`, `Packages/src/Runtime`, `Packages/src/Documentation~`이다.

## 작업 원칙

- Windows 기반 명령을 사용한다.
- 이동 전에 현재 구조, 참조 지점, 패키지 포함 대상과 제외 대상을 읽고 판단한다.
- 코드와 `.meta`는 항상 함께 이동해서 Unity GUID를 유지한다.
- 패키지 루트는 `Packages/src` 자체이고, `package.json`은 `Packages/src/package.json`에 둔다.
- 공유 코드와 공유 에셋은 `Packages/src/Runtime` 아래에 둔다.
- 문서 폴더는 `Packages/src/Documentation~`를 만든다. `~`로 끝나는 폴더에는 Unity가 `.meta`를 만들지 않는 것이 정상이다.
- 에디터 전용 코드가 필요하면 `Packages/src/Editor` 아래에 둔다.
- 테스트 코드는 패키지 테스트로 유지할 때만 `Packages/src/Tests/Editor` 또는 `Packages/src/Tests/Runtime` 아래에 둔다.
- 실제 판단 기준은 `package.json`, asmdef, `Editor` 분리, `.meta` 유지, 기존 참조 경로 검증, 패키지 배포 대상 여부다.
- `Library`, `Temp`, `obj`, `Logs` 같은 생성 산출물은 조사 대상에서 제외한다.
- 문서, 로그, 커밋 메시지는 한국어 기준으로 작성한다.
- 검증하지 않은 설치 방법은 문서에 적지 않는다.
- 커밋과 푸시는 사용자가 요청했을 때만 진행한다.

## 포함 대상 판단

- 패키지 사용자에게 필요한 공유 스크립트, asmdef, 프리팹, UI 에셋, 머티리얼, 텍스처 등은 `Runtime` 아래에 포함한다.
- 에디터 전용 코드는 `Editor` 폴더와 `.meta`를 함께 패키지 루트 아래 적절한 위치로 이동한다.
- 테스트용 또는 개발 확인용 로컬 샌드박스, 임시 실험 에셋, 데모가 아닌 개인 검증용 에셋은 패키지에 포함하지 않는다.
- 샘플로 배포할 가치가 있는 예제 에셋은 공유 폴더에 두지 말고, 사용자가 원할 때만 `Samples~`로 분리한다.
- 이동 중 `Scenes`, `Tests`, `Test`, `Demo`, `Sample`, `Sandbox`, `Temp`, `Experimental` 같은 이름의 폴더는 그 파일의 의도를 반드시 확인한다.
- 제외하기로 판단한 에셋은 원래 `Assets` 위치에 남기거나 되돌리고, 해당 `.meta`도 함께 유지한다.

## 기본 절차

1. 현재 상태를 읽는다.
- `Assets`, `Packages`, `Packages/src` 존재 여부를 확인한다.
- `Assets/package.json`, `Assets/*.asmdef`, `Assets/Editor`, `Assets/Sources`, 테스트나 샘플 폴더 존재 여부를 확인한다.
- `git status --short`로 작업 트리 상태를 확인한다.

2. 이전 경로 참조를 찾는다.
- `Assets/package.json`, `Assets/Editor`, `Assets/*.asmdef`, `Assets/Sources` 같은 경로를 프로젝트 안에서 검색한다.
- 검색 범위에서는 `Library`, `Temp`, `obj`, `Logs`를 제외한다.
- 참조가 없으면 그대로 진행하고, 참조가 있으면 프로젝트 파일, 문서, 설정까지 함께 정리한다.

3. 패키지 포함/제외 대상을 결정한다.
- 공유에 필요한 스크립트와 에셋만 패키지 이동 대상으로 둔다.
- 테스트용, 개발 전용, 임시 에셋은 패키지 이동 대상에서 제외한다.
- 제외 대상이 이미 패키지 안으로 이동됐다면 `.meta`와 함께 원래 `Assets` 쪽으로 되돌린다.

4. 새 패키지 루트를 준비한다.
- `Packages/src`가 없으면 만든다.
- `Packages/src/Runtime`과 `Packages/src/Documentation~`를 만든다.
- 패키지 루트는 `Packages/src` 자체로 두고, 패키지명 폴더를 추가로 만들지 않는다.

5. 패키지 메타를 이동한다.
- `Assets/package.json`과 `Assets/package.json.meta`를 `Packages/src`로 이동한다.
- `package.json`에 `repository.url`이 있다면 `?path=/Packages/src` 기준으로 맞춘다.
- 구조 변경 규모가 크면 패치가 아닌 마이너 버전을 올린다.

6. 소스, asmdef, 에셋을 이동한다.
- 포함 대상으로 결정한 공유 스크립트와 관련 `.meta`를 `Packages/src/Runtime` 아래로 이동한다.
- `Assets`의 asmdef와 관련 `.meta`는 해당 코드가 놓인 위치에 맞춰 함께 이동한다.
- `Assets/Editor`와 `Assets/Editor.meta`는 패키지에 포함되어야 할 때만 `Packages/src/Editor`와 `Packages/src/Editor.meta`로 이동한다.
- 테스트용 파일과 개발 전용 에셋은 `Packages/src/Runtime` 아래로 섞지 않는다.
- 이동 후 패키지 안에 제외 대상이 남아 있지 않은지 다시 확인한다.

7. Unity 패키지 설정을 갱신한다.
- `Packages/manifest.json`에는 로컬 패키지를 `file:src`로 추가한다.
- `Packages/packages-lock.json`에 로컬 패키지가 생기면 `version: file:src`, `source: embedded`, `depth: 0` 기준으로 확인한다.
- 현재 솔루션이나 프로젝트 파일이 직접 경로를 들고 있으면 `Packages/src/Runtime` 기준으로 갱신하거나 Unity 재생성 대상인지 확인한다.

8. 문서를 정리한다.
- `Packages/src/Documentation~`에 패키지 사용자를 위한 문서를 둔다.
- 저장소 루트 `README.md`가 필요하면 GitHub 첫 화면 기준으로 소개, 구성, 개발 메모만 둔다.
- 설치 방법은 실제로 검증했을 때만 적고, 불확실하면 생략한다.

9. 변경 결과를 확인한다.
- `git status --short`에서 이동 결과가 의도대로 잡혔는지 확인한다.
- `package.json` 버전, repository path, `manifest.json`, `packages-lock.json`과 `Packages/src` 구조가 일치하는지 다시 읽는다.
- JSON 파일은 파싱 검증한다.
- 가능하면 현재 솔루션을 빌드하거나 Unity가 패키지를 정상 인식하는지 확인한다.

## 버전 정책

- 메타데이터만 소폭 수정하면 패치 버전 갱신을 검토한다.
- 패키지 루트 이동, 소스 재배치, 설치 구조 변경은 마이너 버전을 사용한다.
- 호환성이 깨지는 공개 API 변경이 명확하면 메이저 버전을 검토한다.

## 커밋 정책

- 커밋 전에 사용자가 요청한 버전 정책이 반영됐는지 다시 확인한다.
- 커밋 메시지는 반복적인 군더더기 없이 한국어로 짧게 작성한다.
- 예시: `패키지 구조를 Packages/src로 이동`
- README 후속 수정은 별도 커밋으로 분리할 수 있다.

## 푸시 정책

- 원격과 현재 브랜치를 확인하고, 사용자가 요청했을 때만 푸시한다.
- 푸시 전 `git status --short`가 의도한 변경만 담고 있는지 확인한다.

## 최종 보고 체크리스트

- `Packages/src`가 실제 패키지 루트인지
- `Packages/src/Runtime`과 `Packages/src/Documentation~`가 있는지
- `package.json`, `.meta`, asmdef, `Editor` 폴더가 의도한 구조로 이동됐는지
- 테스트용, 개발 전용, 샘플이 공유 패키지에 섞이지 않았는지
- 제외 대상이 `Assets` 쪽에 `.meta`와 함께 남아 있는지
- 버전이 의도대로 올라갔는지
- `manifest.json`과 `packages-lock.json`이 `file:src`를 반영하는지
- 빌드 또는 Unity 인식 검증을 수행했는지
- 커밋/푸시 수행 여부
