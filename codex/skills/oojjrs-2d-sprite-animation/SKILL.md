---
name: oojjrs-2d-sprite-animation
description: 2D 스프라이트 애니 제작·재작업·보정. 대기/idle·이동·공격·사망·성장/변태, 키포즈·프레임·시트·루프, 흔들림·찢어짐·파츠 분리 요청에 사용한다. Unity 클립/컨트롤러 설정, 3D·영상·CSS 애니는 제외한다.
---

# oojjrs 2D Sprite Animation

계획·원화 생성·애니메이션 및 보정 코드 작성 전에 이 본문 전체를 읽고 적용한다. 현재 작업에서 이미 읽은 내용은 재사용하고, 새 대화·문맥 복구·지침 갱신 후에는 다시 읽는다. 설명 목록·호출 프롬프트·이전 결과만으로 본문을 읽었다고 판단하지 않는다. 작화 수와 구간별 기법, 파츠·기준점·검증 경로를 이번 동작에 맞춰 정한 뒤 제작하며, 같은 애니메이션의 후속 수정에도 본 스킬을 제작 기준으로 유지한다.

## Required Rigging Reference

Before creating or revising any bone/mesh rig, read [the rigging playbook](references/rigging-playbook.md). Follow its concrete part inventory, coordinate/bind-pose example, bone hierarchy, mesh/weight construction, FK/IK, occlusion, hybrid handoff, and defect-repair steps. Apply it only to the phases using rigs; it does not force rigging on drawn-only phases.

## Core Rule

Follow this sequence: establish the target appearance and motion → divide the action into phases → choose and combine methods per phase and part → construct or redraw the required sources → inspect actual playback → repair until the requested quality is achieved.

Own the production decisions within the authorized scope. Do not ask the user to choose routine technique, part, or phase boundaries. Use `$imagegen` / built-in `image_gen` for new or revised artwork, including complete key poses or every frame when necessary. Reusing original pixels, minimizing redraws, or finishing a rig is not the acceptance criterion; judge the actual appearance and motion. Honor explicit method, budget, and scope constraints.

1. 작화 키프레임은 목표 동작에 필요한 자세·시점·형태를 그림으로 확보하기 위해 사용한다. 기준 원화 한 장과 리깅으로 전체 동작을 표현할 수 있으면, 작화 키프레임 한 장으로 모든 애니메이션 프레임을 만든다. 필요한 경우에는 모든 프레임을 직접 그리며, 이때는 전체 프레임이 작화 키프레임이 된다. 그 사이에서는 구간·부위별로 새 작화와 리깅을 자유롭게 조합한다. 작화 수와 제작 방법은 미리 고정하지 않고, 목표 동작의 자연스러움과 외형 일관성을 기준으로 결정한다.
2. 최신 승인 원화와 현재 적용 경로를 먼저 확인한다. 재작업 대상과 승인된 외형·동작을 구분하고, 이미 통과한 부분을 임의로 다시 만들지 않는다.
3. 공통 캔버스·배율·피벗으로 프레임을 대조한다. 전체 위치뿐 아니라 몸통의 크기·윤곽·질감과 부위별 기준점도 확인하며, 형태가 흔들리는 원화를 위치 보정만으로 통과시키지 않는다.
4. 움직이는 파츠에서 주변 고정 픽셀을 분리하고, 가려진 면·관절 겹침·앞뒤 순서를 완성한다. 들리는 귀·갓·꼬리와 몸통의 연결을 동작 전 구간에서 확인한다.
5. 동작은 대상의 구조와 기능에 맞춰 설계한다. 전용 공격·사망·변태를 기본 동작 복제나 단순 확대·교체로 대신하지 않으며, 효과만 요청한 경우 몸체 변형을 추가하지 않는다.
6. 반복된 결함은 대표 구간에서 먼저 해결한 뒤 나머지로 확대한다. 성장·변태는 정해진 중심·단계·시간을 유지하고, 단계 사이의 중간 자세를 자연스럽게 연결한다.
7. 제작 시험과 완성본을 구분한다. 실제 출력의 전체 구간을 재생하고 원본과 인코딩 결함을 분리하며, 게임 적용을 요청받았다면 실제 사용 경로와 요청된 선택·속성 조합까지 확인한다. 새 원화는 내장 imagegen을 사용하고 외부 생성기로 임의 전환하지 않는다.

8. 캐릭터·파츠·포즈를 페이드인·페이드아웃·크로스페이드로 교체하거나, 시간 가중 알파 혼합으로 등장·퇴장·성장·변태·포즈 전환 등 동작을 대신하는 방식은 금지한다. 필요한 동작과 형태 변화는 실제 작화·파츠 움직임·리깅으로 표현한다. 광원·발광·반짝임 등 시각 효과의 강도를 조절하는 불투명도 애니메이션은 허용한다. 투명 배경·안티앨리어싱·가림 마스크와 효과용 알파를 일괄 금지하지 않는다.

Choose methods by the actual motion and switch when the result warrants it:

- Simple articulation: build complete separate part layers with meaningful pivots, bone hierarchy, meshes, and weights; use rigid transforms for hard parts and deformation for flexible parts.
- When rigging or local repair cannot reproduce the intended shape, perspective, overlap, or rhythm, redraw the required phase or the entire frame sequence. Do not force the original texture or topology to survive every pose.
- Use registration, masks, compositing, warping, interpolation, timing edits, and other available production tools where they improve the result. Draw missing surfaces and poses rather than hiding defects with blending; no tool's name establishes quality.

Whole-image wobble, clipped joints, rubbery rigid objects, doubled outlines, ghosting, and arbitrary scale changes are defects unless explicitly part of the intended action. Treat these as result criteria, not blanket bans on transforms, meshes, drawing, interpolation, or compositing.

## Workflow

1. Establish the reference and motion contract.
   - Keep the original approved design as the authority for silhouette, anatomy, palette, lighting, outline, camera, and proportions; identify separately which motion, rhythm, or amplitude is currently approved.
   - Preserve frame size, cell geometry, pivots, timing contracts, document previews, and existing Unity references. Declare intentional growth, squash, root motion, or airborne trajectories.
   - Keep the last valid approved version recoverable. A superseded approval or a version under rework is not a validated success or a new design authority.
   - Preserve the approved design and motion intent, not an obligation to reuse its pixels. Redraw complete assets or all frames when that is needed within the requested revision; keep earlier sources recoverable.
   - Never hand-edit Unity YAML or `.meta` text; use the official Unity CLI and importer for Unity-side changes.

2. Design the phases, key poses, trajectories, and timing.
   - Establish neutral, anticipation, contact or peak, and return or final poses.
   - Check silhouettes, anatomy, proportions, joint angles, part lengths, overlaps, and root or foot landmarks. Design motion arcs, acceleration and deceleration, holds, and delayed follow-through.
   - Choose drawn, rigged, or mixed construction independently for each interval and moving part. Add a new drawing, replacement part set, or local rig whenever the existing source cannot reach the next pose faithfully.
   - For an unfamiliar motion, establish a short representative interval at the intended display size before producing a batch. Keep confirmed artwork and motion properties recoverable; a checked key pose alone is not approval of the complete sequence.

3. When using bone/mesh animation, prepare complete layered parts.
   - Separate all independently articulated or occluding body regions into appropriate source layers and rig attachments, subdividing further wherever the required motion needs separate control. A complete character image on one layer is not a substitute for this part rig.
   - Keep a flexible surface continuous within its own part where a mesh is appropriate. Draw each part's hidden contour, underside, and the surface behind it; redraw the full part set if clean separation of the original is insufficient.
   - Provide overlap at joints, clean alpha edges, and sufficient texture padding. Separate foreground occluders and specify draw order, masks or clipping, pivots, and fixed versus moving regions.
   - Reassemble each rig's reference pose at the required scale and position. Check seams, outlines, shading, anatomy, and landmarks before animating. Texture atlas packing may place multiple parts in one image; their source layers and attachments must remain independently controllable.

4. Rig only the intervals and parts it can represent faithfully.
   - Establish root and parent relationships, joint pivots, bone lengths, local axes, and grounded contacts. Keep hard parts rigid; put bending controls and mesh vertices along the intended curvature.
   - Bind weights to the intended parts and test the required extreme poses. Correct texture stretch, collapsing volume, disconnected joints, unintended influence on fixed areas, and occlusion errors before expanding the animation.
   - A single mesh may deform one continuous part; build separate attachments and occlusion structure for independently moving regions. Do not describe a whole-image mesh as a completed layered cutout rig.
   - Keep rig controls, textures, weights, and timelines editable. Check available authoring/export tools before choosing Spine or another format; do not assume the editor or runtime is installed.
   - Sample the local rig into as many frames as the motion requires. A generated key drawing may supply a rigged interval, followed by another drawn pose or interval with different sources; do not require one unchanged rig for the entire animation.

5. Draw and combine as much artwork as the result needs.
   - Use imagegen for complete key poses, replacement parts, expressions, alternate views, newly exposed surfaces, or full drawn sequences. There is no limit to local redrawing when full-frame or whole-sequence reconstruction is needed within the authorized scope.
   - For drawn sequences, supply the locked original and nearest accepted poses on both sides; preserve accepted files and draw the missing local interval. Choose individual frames or small groups for continuity without imposing a strip preference or one-call-per-frame rule.
   - Match the scale, landmarks, contours, palette, shading, camera, and occlusion at every drawn/rigged handoff. Draw bridge poses or rebuild the local rig when a swap pops. Do not use fades, crossfades, or opacity blending to replace character/part poses or substitute for motion. Opacity animation for light, glow, and other visual-effect intensity is allowed.
   - Fix design drift in artwork and mechanical defects in rigging or timing. Keep the accepted concept, rhythm, amplitude, and endpoints while replacing whatever source material is necessary to meet them.

6. Inspect actual playback and repair the demonstrated defect.
   - Play the actual rig or exported sequence at intended size and speed, then inspect enlarged joints and phase boundaries. Check loop continuity, scale, anchors, contacts, silhouettes, palette, seams, clipping, and attachment visibility.
   - Separate source-art, part extraction, rig/weight, timing, export, and encoding defects. Repair the responsible layer; a fixed-region pixel check alone does not prove natural movement or correct occlusion.
   - Use common output scaling and fixed canvas/pivot registration. Do not fit each frame to its own tight bounds, stretch rigid parts to hide drift, or pin intentional airborne motion to the ground.
   - Compare source-resolution overlays and landmarks when unintended size, contour, or placement differences remain. Repeat drawing, registration, part/weight correction, and compositing until required pixel-level consistency is achieved; intentional pose, perspective, growth, or squash must remain intact.
   - Stationary reused regions may retain identical pixels; redrawn regions must match the required appearance and registration, not an unrelated byte-identity target. Preserve the last valid version until comparison shows improvement.
   - Do not accept visible defects because a method was followed, a frame count was reached, or more drawing would take effort. Switch or combine methods when the current approach stalls; if an explicit budget or tool limit prevents completion, report the remaining defect instead of calling it complete.

## Spine And Tool Verification

- For Spine meshes, weights, attachments, and export behavior, use the current official [meshes](https://esotericsoftware.com/spine-meshes), [weights](https://esotericsoftware.com/spine-weights), [attachments](https://esotericsoftware.com/spine-attachments), and [export](https://esotericsoftware.com/spine-export) documentation.
- When Spine data is part of the deliverable or Spine compatibility is claimed, keep the authoring source or importable rig, source parts, and timelines; verify loading and playback with the target editor or official runtime and match export/runtime versions.
- Hand-authored Spine-style JSON and a custom renderer are not evidence of Spine import or runtime compatibility. Report each verified surface precisely; do not silently replace unavailable authoring tools with an unverified compatibility claim.

## Output Preparation

- Deliver the source drawings, layered parts, and local rigs actually used, plus the runtime output required by the project. Baking rigged intervals and combining them with drawn frames in a PNG/WebP sequence or sheet is allowed; describe the hybrid construction accurately.
- Build contact sheets and previews from the actual source drawings or rendered rig frames. No preview-only imagegen calls; use a stable GIF palette and compare with PNG/WebP if encoding appears to flicker.
- Preserve the runtime contract for canvas, pivots, timing, transparency, and sheet geometry. Verify exported output as well as the authoring preview when export can change the result.

## Unity Installation

1. Keep frame construction and sheet packing outside the Unity project until the accepted output is ready to install.
2. Use `$unity-cli` for import, save, reimport, and every Unity-side serialized or importer change. Pass `--caller plugin --skill oojjrs-2d-sprite-animation` on `unity command` calls.
3. Use `$sprite-editor` for sprite rectangles, names, pivots, borders, slicing, and internal IDs. Set an actual sheet to `SpriteImportMode.Multiple`; set a non-sheet sprite to `Single`.
4. When the asset belongs to a SpriteAtlas, use `$manage-sprite-atlas` to inspect and set both source and atlas output settings. Default generated atlas sprites to uncompressed with Crunch disabled unless an existing preset, platform rule, or explicit request requires another setting.
5. Let Unity create or update `.meta` files. Include the Unity-generated in-scope companion, and treat unexpected GUID churn on an existing asset as a failure.
6. Route `.anim`, AnimatorController, override-controller, curve, state, transition, or binding work to `$oojjrs-unity-animation-asset-workflow` as a separate phase. Do not hand-author those YAML files.

## Validation

- 최종 재생과 사용한 리그·합성 설정에서 캐릭터·파츠·포즈를 페이드나 시간 가중 알파 혼합으로 교체해 동작을 대신하는 구간이 없는지 확인한다. 그런 결과는 완료로 인정하지 않으며, 광원·발광 등 효과용 불투명도 애니메이션은 유지할 수 있다.

- Identify the reference, redrawn poses, layered parts and hidden surfaces, local rigs/weights, and timelines actually used. Check only artifacts required by the chosen methods, including boundaries where methods or sources change; metadata labels do not prove the method.
- Inspect actual playback against the current accepted reference, including motion readability, phase and loop boundaries, contacts, scale, palette, occlusion, clipping, and joint continuity. A static sheet or superseded approval does not establish success.
- Check dimensions, frame count, sheet layout, transparency, and timing against the runtime contract. Verify fixed regions only where declared and editor/runtime compatibility only on the actual target toolchain.
- For Unity installation, read back importer mode, compression, sprite rects/internal IDs, atlas settings, generated `.meta` GUID, and animation references through Unity; stop Git completion if an expected companion is absent.

## Quality Rules

- Choose and combine methods autonomously by visual outcome; simple articulation uses proper part rigs, complex motion can combine newly drawn keys and local rigs, and all frames may be redrawn when necessary.
- Judge appearance consistency and motion quality separately. A stable texture, more bones, more frames, or more generation calls does not establish natural animation.
- Use only currently valid approval evidence for the same version and property; preserve explicitly retained design or rhythm without presenting an unfinished animation as a proven workflow.
