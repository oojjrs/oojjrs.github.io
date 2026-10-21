---
name: oojjrs-game-studio-sprite-pipeline
description: Game Studio의 sprite-pipeline으로 2D 애니메이션을 만들거나 레이어 방식과 비교한다.
---

- Game Studio의 `sprite-pipeline`과 연결 문서를 읽고 따르며, 없으면 중단한다.
- 승인 원본으로 ImageGen 한 번에 전체 스트립을 만들고 공식 스크립트로 정규화한다.
- 실제 프레임으로 투명 시트·GIF를 만들고 형태·정렬·동작·루프·투명도를 확인한다.
- 비교 요청 때만 원본·동작·크기·프레임 수·시간을 맞춰 두 결과를 보존하고 비교한다.
- `oojjrs-2d-sprite-animation`의 Unity Installation 절만 재사용한다.
