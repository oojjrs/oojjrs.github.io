---
name: oojjrs-game-studio-sprite-pipeline
description: Game Studio 요청으로 2D 애니메이션의 모든 프레임을 한 장씩 그린다. 완성된 개별 프레임으로 시트와 GIF를 조립하고, 비교는 요청할 때만 수행한다.
---

- Game Studio의 `sprite-pipeline`과 연결 문서를 읽고, 프레임별 직접 제작 규칙을 우선한다. 문서가 없으면 중단한다.
- 승인 원본을 참조하여 ImageGen 호출당 완전한 프레임 한 장을 새로 그린다. 중간 프레임도 각각 그린다.
- 전체 스트립 일괄 생성이나 기존 그림·분리한 부위의 변형, 리깅, 보간으로 동작을 만들지 않는다.
- 완성된 개별 프레임으로만 투명 시트·GIF를 조립하고 형태·정렬·동작·루프·투명도를 확인한다.
- `$oojjrs-2d-sprite-animation`의 제작·Unity 설치 규칙을 따르며, 비교 요청 때만 조건을 맞춰 결과를 보존하고 비교한다.
