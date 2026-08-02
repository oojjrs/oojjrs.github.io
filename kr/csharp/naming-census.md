---
layout: page
title: "네이밍 전수조사"
lang: ko-KR
category: "C# NAMING DATA"
description: "실제 Unity·ASP.NET C# 코드에서 관찰된 Entity와 UI 이름 축을 출처 식별자 없이 최근과 과거로 나눈 전수조사표입니다."
permalink: /kr/csharp/naming-census/
toc_items:
  - id: scope
    label: 조사 기준
  - id: entity-current
    label: 최근 Entity
  - id: ui-current
    label: 최근 UI
  - id: entity-candidate
    label: Entity 경계 후보
  - id: entity-legacy
    label: 과거 Entity
  - id: ui-legacy
    label: 과거 UI
  - id: review
    label: 해석 메모
---

<p class="article-backlink"><a href="{{ "/kr/" | relative_url }}">← 문서 목록</a></p>

<p class="article-lead">이 문서는 명명 규칙을 새로 선언하지 않는다. 실제 Unity·ASP.NET C# 코드에서 관찰된 이름을 <a href="{{ "/kr/csharp/semantic-layer-naming/" | relative_url }}">의미 계층</a> 단위로 모아, 지금 살아 있는 이름 축과 과거에만 남은 이름 축을 비교하기 위한 직접 출처 식별자 제거 조사 데이터다.</p>

<div class="article-principle">
  <p><code>EntityRecord</code> 같은 자리표시자는 이 표의 키가 아니다. 첫 열에는 <code>Archive</code>, <code>Quest</code>, <code>User</code>처럼 코드에서 실제로 관찰된 의미 축만 놓고, 둘째 열에 그 축에서 발견된 정확한 선언 이름을 모두 보존한다.</p>
</div>

<div class="article-note naming-census-privacy">
  <p><strong>공개 범위.</strong> 조사 결과의 이름과 날짜만 합쳐 싣는다. 프로젝트명, 저장소명, 파일 경로, 커밋 식별자, 프로젝트별 통계처럼 출처를 역추적할 수 있는 직접 식별 정보는 의도적으로 공개하지 않는다. 다만 정확한 선언 이름의 집합 자체가 코드베이스의 특성을 드러낼 수 있으므로 익명화 자료라고 간주하지 않는다.</p>
</div>

<div class="naming-census-stats" aria-label="네이밍 조사 요약">
  <span><strong>67</strong> 최근 Entity</span>
  <span><strong>117</strong> 최근 UI</span>
  <span><strong>248</strong> 과거 Entity</span>
  <span><strong>526</strong> 과거 UI</span>
  <span><strong>54</strong> Entity 경계 후보</span>
</div>

## 조사 기준 {#scope}

- 스냅샷은 2026-08-02이며, 2024-08-02 이후의 마지막 의미 관찰일이 확인된 축을 최근으로 분류했다.
- 조사 대상은 first-party Unity·ASP.NET C# 선언이다. 외부 패키지, 샘플, 생성 코드, 마이그레이션, 디자이너 파일은 제외했다.
- 날짜는 이름이 남아 있는 파일의 최신 의미 변경을 비교하기 위한 값이다. 줄바꿈 일괄 변경, 엔진 버전 갱신, 단순 이동은 의미 사용일로 세지 않았다.
- 신뢰할 수 있는 변경 이력이 없는 보관 코드의 파일 시각은 사용일로 간주하지 않고 <code>날짜 불명</code>으로 두었다.
- 직접 출처 식별자를 제거한 뒤 같은 레이어의 같은 축은 전역으로 합쳐 정확한 선언 이름을 중복 제거했다. 마지막 관찰일은 그 축에서 확인된 신뢰 가능한 날짜 중 가장 최신 값이다. 이 병합은 이름 인벤토리를 위한 합집합일 뿐, 서로 다른 코드 묶음의 동명 축이 같은 도메인임을 뜻하지 않는다.
- Entity 표의 첫 열은 실제 도메인 축이다. <code>Record</code>, <code>Manager</code>, <code>Memory</code>, <code>Cache</code>, <code>Secret</code>, <code>Keeper</code>는 검색과 선언 병합에만 사용한 역할어다.
- UI 표의 첫 열은 실제 구조의 시작 축이다. 둘째 열에는 <code>TitleMenuSingleplayerButton</code>처럼 중간 경계와 말단 역할을 생략하지 않은 정확한 이름을 싣는다.
- 중첩 타입은 소유자를 포함한 한정 이름으로 보존한다. 언어 제약으로 소유자 표면어가 반복되어도 새 의미 계층으로 세지 않는다.

## 최근 Entity 이름 {#entity-current}

최근 2년 안에 직접적인 모델·레코드·관리·상태 선언이 확인된 실제 도메인 축이다. 둘째 열은 대표 예가 아니라 조사 범위에서 수집한 정확한 선언 이름의 합집합이다.

| 실제 이름 축 | 관찰된 정확한 선언 이름 | 마지막 관찰일 |
| --- | --- | ---: |
| <code>Actor</code> | <span class="naming-census-name-list"><code>ActorCache</code><code>ActorFinder</code><code>ActorManager</code><code>ActorMemory</code><code>ActorModel</code><code>ActorRecord</code></span> | 2026-04-25 |
| <code>Animal</code> | <span class="naming-census-name-list"><code>AnimalData</code><code>AnimalFinder</code><code>AnimalManager</code><code>AnimalModel</code><code>AnimalRecord</code><code>DbAnimal</code><code>DbAnimalMapper</code><code>DbAnimalRecord</code></span> | 2024-09-13 |
| <code>Archive</code> | <span class="naming-census-name-list"><code>ArchiveData</code><code>ArchiveDataCache</code><code>ArchiveFinder</code><code>ArchiveManager</code><code>ArchiveModel</code><code>ArchiveRecord</code></span> | 2026-04-25 |
| <code>Base</code> | <span class="naming-census-name-list"><code>BaseProperty</code></span> | 2025-01-25 |
| <code>Basestat</code> | <span class="naming-census-name-list"><code>BasestatData</code></span> | 2025-04-09 |
| <code>Bot</code> | <span class="naming-census-name-list"><code>BotData</code><code>BotFinder</code><code>BotManager</code><code>BotRecord</code></span> | 2026-04-25 |
| <code>Buff</code> | <span class="naming-census-name-list"><code>Buff</code><code>BuffCache</code><code>BuffData</code><code>BuffManager</code><code>BuffMemory</code><code>BuffModel</code><code>BuffProperty</code><code>BuffRecord</code></span> | 2026-04-25 |
| <code>Bunker</code> | <span class="naming-census-name-list"><code>BunkerProperty</code></span> | 2026-04-25 |
| <code>Cell</code> | <span class="naming-census-name-list"><code>CellData</code><code>CellFinder</code><code>CellManager</code><code>CellModel</code><code>CellRecord</code><code>CellReference</code><code>CellReferenceTable</code></span> | 2026-08-01 |
| <code>Character</code> | <span class="naming-census-name-list"><code>Character</code><code>CharacterCenter</code><code>CharacterData</code><code>CharacterDataRecord</code><code>CharacterDataServerInstance</code><code>CharacterDataServerInstanceManager</code><code>CharacterFinder</code><code>CharacterManager</code><code>CharacterModel</code><code>CharacterRecord</code><code>CharacterReference</code><code>DbCharacter</code><code>DbCharacterMapper</code><code>DbCharacterRecord</code></span> | 2026-04-25 |
| <code>Connector</code> | <span class="naming-census-name-list"><code>ConnectorProperty</code></span> | 2026-04-25 |
| <code>Currency</code> | <span class="naming-census-name-list"><code>CurrencyData</code><code>CurrencyFinder</code><code>CurrencyManager</code><code>CurrencyRecord</code><code>DbCurrency</code><code>DbCurrencyMapper</code><code>DbCurrencyRecord</code></span> | 2026-04-25 |
| <code>Deltastat</code> | <span class="naming-census-name-list"><code>DeltastatCache</code><code>DeltastatMemory</code></span> | 2026-04-25 |
| <code>Effect</code> | <span class="naming-census-name-list"><code>EffectReference</code><code>EffectReferenceTable</code></span> | 2026-08-01 |
| <code>Enricher</code> | <span class="naming-census-name-list"><code>EnricherFinder</code><code>EnricherManager</code><code>EnricherRecord</code></span> | 2026-04-25 |
| <code>Entitlement</code> | <span class="naming-census-name-list"><code>DbEntitlement</code><code>DbEntitlementMapper</code><code>DbEntitlementRecord</code><code>EntitlementManager</code><code>EntitlementRecord</code></span> | 2026-04-25 |
| <code>Facility</code> | <span class="naming-census-name-list"><code>Facility</code><code>FacilityData</code><code>FacilityDataCache</code><code>FacilityDataEqualityComparer</code><code>FacilityFinder</code><code>FacilityIdHolder</code><code>FacilityManager</code><code>FacilityProperty</code><code>FacilityRecord</code><code>FacilityStatCenter</code><code>FacilityStatHolder</code><code>FacilityTeamCenter</code><code>FacilityTechCenter</code><code>FacilityUserCenter</code></span> | 2025-01-25 |
| <code>Fixture</code> | <span class="naming-census-name-list"><code>FixtureManager</code><code>FixtureRecord</code></span> | 2026-04-25 |
| <code>Foley</code> | <span class="naming-census-name-list"><code>FoleyCache</code><code>FoleyMemory</code><code>FoleyModel</code></span> | 2026-04-25 |
| <code>Game</code> | <span class="naming-census-name-list"><code>DbGame</code><code>DbGameMapper</code><code>DbGameRecord</code><code>Game</code><code>GameDataRecord</code><code>GameFinder</code><code>GameManager</code><code>GameMapCenter</code><code>GameRecord</code><code>GameTeamCenter</code><code>GameUserCenter</code></span> | 2026-07-15 |
| <code>Hitbox</code> | <span class="naming-census-name-list"><code>HitboxReference</code></span> | 2025-05-08 |
| <code>Item</code> | <span class="naming-census-name-list"><code>DbItem</code><code>DbItemMapper</code><code>DbItemRecord</code><code>Item</code><code>ItemData</code><code>ItemDataAdapter</code><code>ItemDataAdapterParser</code><code>ItemDataCache</code><code>ItemDataEqualityComparer</code><code>ItemDataRecord</code><code>ItemDataServerInstance</code><code>ItemDataServerInstanceManager</code><code>ItemDefinesParser</code><code>ItemFinder</code><code>ItemManager</code><code>ItemModelPartType</code><code>ItemModelPartTypeParser</code><code>ItemRecord</code><code>ItemReference</code><code>ItemSkillCenter</code><code>ItemTags</code><code>ItemTagsParser</code><code>ItemUnitCenter</code></span> | 2026-04-27 |
| <code>Landmine</code> | <span class="naming-census-name-list"><code>LandmineFinder</code><code>LandmineManager</code><code>LandmineModel</code><code>LandmineRecord</code></span> | 2026-04-25 |
| <code>Lobby</code> | <span class="naming-census-name-list"><code>LobbyCache</code><code>LobbyData</code><code>LobbyFinder</code><code>LobbyMemory</code><code>LobbyReference</code></span> | 2026-04-25 |
| <code>Map</code> | <span class="naming-census-name-list"><code>DbMap</code><code>DbMapMapper</code><code>DbMapRecord</code><code>Map</code><code>MapCategoryType</code><code>MapCountCenter</code><code>MapData</code><code>MapDataCache</code><code>MapDataEqualityComparer</code><code>MapFinder</code><code>MapGameCenter</code><code>MapManager</code><code>MapMissionCenter</code><code>MapObjectiveFinder</code><code>MapPriceCenter</code><code>MapQuestCenter</code><code>MapRecord</code><code>MapTroopCenter</code><code>MapWaveCenter</code></span> | 2026-07-26 |
| <code>Module</code> | <span class="naming-census-name-list"><code>ModuleData</code><code>ModuleDataCache</code><code>ModuleFinder</code><code>ModuleManager</code><code>ModuleModel</code><code>ModuleRecord</code></span> | 2026-04-25 |
| <code>Monster</code> | <span class="naming-census-name-list"><code>MonsterCache</code><code>MonsterData</code><code>MonsterFinder</code><code>MonsterMemory</code><code>MonsterReference</code></span> | 2026-04-25 |
| <code>Mover</code> | <span class="naming-census-name-list"><code>MoverCache</code><code>MoverMemory</code><code>MoverModel</code></span> | 2026-04-25 |
| <code>Npc</code> | <span class="naming-census-name-list"><code>NpcCache</code><code>NpcData</code><code>NpcFinder</code><code>NpcMemory</code><code>NpcModel</code><code>NpcReference</code></span> | 2026-04-25 |
| <code>Offer</code> | <span class="naming-census-name-list"><code>OfferFinder</code><code>OfferManager</code><code>OfferRecord</code></span> | 2026-04-25 |
| <code>Outpost</code> | <span class="naming-census-name-list"><code>Outpost</code><code>OutpostData</code><code>OutpostDataCache</code><code>OutpostDataRecord</code><code>OutpostFinder</code><code>OutpostManager</code><code>OutpostRecord</code></span> | 2026-04-25 |
| <code>Party</code> | <span class="naming-census-name-list"><code>DbParty</code><code>DbPartyMapper</code><code>DbPartyRecord</code><code>PartyFinder</code><code>PartyManager</code><code>PartyRecord</code></span> | 2026-04-25 |
| <code>Player</code> | <span class="naming-census-name-list"><code>PlayerCache</code><code>PlayerFinder</code><code>PlayerMemory</code></span> | 2026-08-01 |
| <code>Pose</code> | <span class="naming-census-name-list"><code>PoseFinder</code><code>PoseManager</code><code>PoseModel</code><code>PoseRecord</code></span> | 2026-04-25 |
| <code>Pulse</code> | <span class="naming-census-name-list"><code>PulseCache</code><code>PulseMemory</code></span> | 2026-04-25 |
| <code>Quest</code> | <span class="naming-census-name-list"><code>Quest</code><code>QuestCategoryType</code><code>QuestData</code><code>QuestDataCache</code><code>QuestDataEqualityComparer</code><code>QuestDataRecord</code><code>QuestDataServerInstance</code><code>QuestDataServerInstanceManager</code><code>QuestFinder</code><code>QuestManager</code><code>QuestMapCenter</code><code>QuestRecord</code><code>QuestRewardFinder</code><code>QuestSquadCenter</code><code>QuestTroopCenter</code></span> | 2026-04-25 |
| <code>QuestArmory</code> | <span class="naming-census-name-list"><code>QuestArmoryProperty</code></span> | 2026-04-25 |
| <code>QuestBomb</code> | <span class="naming-census-name-list"><code>QuestBombProperty</code></span> | 2026-04-25 |
| <code>QuestResearch</code> | <span class="naming-census-name-list"><code>QuestResearchProperty</code></span> | 2026-04-25 |
| <code>QuestTower</code> | <span class="naming-census-name-list"><code>QuestTowerProperty</code></span> | 2026-04-25 |
| <code>Refinery</code> | <span class="naming-census-name-list"><code>RefineryProperty</code></span> | 2026-04-25 |
| <code>Region</code> | <span class="naming-census-name-list"><code>RegionData</code><code>RegionFinder</code><code>RegionManager</code><code>RegionModel</code><code>RegionModelTable</code><code>RegionRecord</code></span> | 2026-08-01 |
| <code>Relation</code> | <span class="naming-census-name-list"><code>RelationFinder</code><code>RelationManager</code><code>RelationRecord</code></span> | 2026-04-25 |
| <code>Resource</code> | <span class="naming-census-name-list"><code>Resource</code><code>ResourceData</code><code>ResourceDataCache</code><code>ResourceDataEqualityComparer</code><code>ResourceFinder</code><code>ResourceKeys</code><code>ResourceManager</code><code>ResourceModel</code><code>ResourceRecord</code><code>ResourceUserCenter</code></span> | 2026-04-25 |
| <code>Rimcryst</code> | <span class="naming-census-name-list"><code>RimcrystData</code><code>RimcrystReference</code></span> | 2025-07-08 |
| <code>Skill</code> | <span class="naming-census-name-list"><code>Skill</code><code>SkillBuffCenter</code><code>SkillCache</code><code>SkillData</code><code>SkillDataCache</code><code>SkillDataEqualityComparer</code><code>SkillFinder</code><code>SkillItemCenter</code><code>SkillManager</code><code>SkillMemory</code><code>SkillRecord</code><code>SkillReference</code><code>SkillTags</code><code>SkillTagsParser</code><code>SkillUnitCenter</code></span> | 2026-04-25 |
| <code>Stage</code> | <span class="naming-census-name-list"><code>Stage</code><code>StageCache</code><code>StageData</code><code>StageDataRecord</code><code>StageManager</code><code>StageMemory</code></span> | 2026-04-25 |
| <code>Stat</code> | <span class="naming-census-name-list"><code>Stat</code><code>StatCache</code><code>StatConverter</code><code>StatData</code><code>StatDataCache</code><code>StatDataEqualityComparer</code><code>StatDefinesParser</code><code>StatEmpty</code><code>StatFinder</code><code>StatKeys</code><code>StatManager</code><code>StatMemory</code><code>StatMerger</code><code>StatRecord</code><code>StatUnitCenter</code></span> | 2026-04-25 |
| <code>Storage</code> | <span class="naming-census-name-list"><code>StorageProperty</code></span> | 2026-04-25 |
| <code>SubStateOfUser</code> | <span class="naming-census-name-list"><code>SubStateOfUserMapper</code><code>SubStateOfUserRecord</code></span> | 2026-04-25 |
| <code>Target</code> | <span class="naming-census-name-list"><code>TargetManager</code><code>TargetRecord</code></span> | 2026-04-25 |
| <code>Team</code> | <span class="naming-census-name-list"><code>Team</code><code>TeamArsenalCenter</code><code>TeamBlueprintCenter</code><code>TeamCampCenter</code><code>TeamFacilityCenter</code><code>TeamFinder</code><code>TeamGameCenter</code><code>TeamHallCenter</code><code>TeamHospitalCenter</code><code>TeamHouseCenter</code><code>TeamLandmarkCenter</code><code>TeamManager</code><code>TeamMarketCenter</code><code>TeamMillCenter</code><code>TeamNames</code><code>TeamRecord</code><code>TeamSquadCenter</code><code>TeamUnitCenter</code><code>TeamUserCenter</code><code>TeamWorkshopCenter</code></span> | 2026-04-25 |
| <code>Tile</code> | <span class="naming-census-name-list"><code>DbTile</code><code>DbTileMapper</code><code>DbTileRecord</code><code>TileData</code><code>TileFinder</code><code>TileManager</code><code>TileModel</code><code>TileRecord</code></span> | 2024-09-13 |
| <code>Town</code> | <span class="naming-census-name-list"><code>DbTown</code><code>DbTownMapper</code><code>DbTownRecord</code><code>TownData</code><code>TownManager</code><code>TownRecord</code></span> | 2026-04-25 |
| <code>Trace</code> | <span class="naming-census-name-list"><code>Trace</code><code>TraceManager</code><code>TraceRecord</code></span> | 2026-04-25 |
| <code>Trait</code> | <span class="naming-census-name-list"><code>DbTrait</code><code>DbTraitMapper</code><code>DbTraitRecord</code><code>TraitData</code><code>TraitFinder</code><code>TraitManager</code><code>TraitRecord</code><code>TraitReference</code></span> | 2026-04-25 |
| <code>Unit</code> | <span class="naming-census-name-list"><code>Unit</code><code>UnitBuffCenter</code><code>UnitCategoryType</code><code>UnitCategoryTypeParser</code><code>UnitData</code><code>UnitDataAdapter</code><code>UnitDataAdapterArrayParser</code><code>UnitDataAdapterCache</code><code>UnitDataAdapterFinder</code><code>UnitDataAdapterParser</code><code>UnitDataCache</code><code>UnitDataEqualityComparer</code><code>UnitDataRecord</code><code>UnitFinder</code><code>UnitIdHolder</code><code>UnitItemCenter</code><code>UnitManager</code><code>UnitMillCenter</code><code>UnitModel</code><code>UnitPocketCenter</code><code>UnitRecord</code><code>UnitScheduleCenter</code><code>UnitSkillCenter</code><code>UnitSquadCenter</code><code>UnitStatCenter</code><code>UnitStatHolder</code><code>UnitTags</code><code>UnitTagsParser</code><code>UnitTeamCenter</code><code>UnitTraceCenter</code><code>UnitUserCenter</code><code>UnitWaveCenter</code><code>UnitWorkCenter</code></span> | 2026-04-25 |
| <code>User</code> | <span class="naming-census-name-list"><code>DbUser</code><code>DbUserMapper</code><code>DbUserRecord</code><code>User</code><code>UserArsenalCenter</code><code>UserBlueprintCenter</code><code>UserBuildingCenter</code><code>UserCampCenter</code><code>UserCategoryType</code><code>UserCenter</code><code>UserCountCenter</code><code>UserData</code><code>UserDataRecord</code><code>UserDataServerInstance</code><code>UserDataServerInstanceManager</code><code>UserFacilityCenter</code><code>UserFinder</code><code>UserGameCenter</code><code>UserHallCenter</code><code>UserHospitalCenter</code><code>UserHouseCenter</code><code>UserItemCenter</code><code>UserLandmarkCenter</code><code>UserManager</code><code>UserMarketCenter</code><code>UserMillCenter</code><code>UserRecipeCenter</code><code>UserRecord</code><code>UserResourceCenter</code><code>UserSquadCenter</code><code>UserSyncer</code><code>UserTacticCenter</code><code>UserTeamCenter</code><code>UserTechCenter</code><code>UserUnitCenter</code><code>UserWeaponCenter</code><code>UserWorkshopCenter</code></span> | 2026-07-22 |
| <code>UserAssoc</code> | <span class="naming-census-name-list"><code>UserAssocKeeper</code></span> | 2026-04-25 |
| <code>UserCaptain</code> | <span class="naming-census-name-list"><code>UserCaptainKeeper</code></span> | 2026-04-25 |
| <code>UserModule</code> | <span class="naming-census-name-list"><code>UserModuleKeeper</code></span> | 2026-04-25 |
| <code>UserPlanet</code> | <span class="naming-census-name-list"><code>UserPlanetKeeper</code></span> | 2026-04-25 |
| <code>UserStage</code> | <span class="naming-census-name-list"><code>UserStageKeeper</code></span> | 2026-04-25 |
| <code>UserTech</code> | <span class="naming-census-name-list"><code>UserTechKeeper</code></span> | 2026-04-25 |
| <code>Wave</code> | <span class="naming-census-name-list"><code>Wave</code><code>WaveCampCenter</code><code>WaveData</code><code>WaveDataCache</code><code>WaveDataEqualityComparer</code><code>WaveFinder</code><code>WaveManager</code><code>WaveMapCenter</code><code>WaveRecord</code><code>WaveTargetCenter</code><code>WaveTroopCenter</code><code>WaveUnitCenter</code></span> | 2026-04-25 |
| <code>Weapon</code> | <span class="naming-census-name-list"><code>Weapon</code><code>WeaponData</code><code>WeaponDataCache</code><code>WeaponDataEqualityComparer</code><code>WeaponDefinesParser</code><code>WeaponFinder</code><code>WeaponManager</code><code>WeaponRecord</code><code>WeaponReference</code><code>WeaponStatCenter</code><code>WeaponUserCenter</code></span> | 2026-04-27 |
| <code>World</code> | <span class="naming-census-name-list"><code>DbWorld</code><code>DbWorldMapper</code><code>DbWorldRecord</code><code>WorldData</code><code>WorldManager</code><code>WorldRecord</code></span> | 2026-04-25 |
{:.naming-census-table}

## 최근 UI 이름 {#ui-current}

UI는 구조의 첫 축으로 행을 묶고 전체 선언을 그대로 펼쳤다. 따라서 <code>Title</code> 행의 <code>TitleMenuSingleplayerButton</code>처럼 실제 구조 경로와 역할 열을 한 셀에서 함께 비교할 수 있다.

| 실제 이름 축 | 관찰된 정확한 선언 이름 | 마지막 관찰일 |
| --- | --- | ---: |
| <code>Actor</code> | <span class="naming-census-name-list"><code>ActorView</code></span> | 2026-04-21 |
| <code>Animal</code> | <span class="naming-census-name-list"><code>AnimalView</code></span> | 2024-11-27 |
| <code>App</code> | <span class="naming-census-name-list"><code>AppEnvironmentInfoText</code></span> | 2025-09-23 |
| <code>Archive</code> | <span class="naming-census-name-list"><code>Archive</code><code>ArchiveDetailAuthorText</code><code>ArchiveDetailContentText</code><code>ArchiveDetailDateText</code><code>ArchiveDetailPortrait</code><code>ArchiveDetailTech</code><code>ArchiveDetailTechButton</code><code>ArchiveDetailTitleText</code><code>ArchiveEntry</code><code>ArchiveEntryAuthorText</code><code>ArchiveEntryNew</code><code>ArchiveEntryPortrait</code><code>ArchiveEntryTitleText</code><code>ArchiveEntryToggle</code><code>ArchiveFinderFromSelector</code><code>ArchiveList</code><code>ArchiveSelector</code><code>ArchiveStatus</code><code>ArchiveStatusButton</code><code>ArchiveStatusCategoryDisplayNameText</code><code>ArchiveStatusPortrait</code></span> | 2026-04-25 |
| <code>Arsenal</code> | <span class="naming-census-name-list"><code>Arsenal</code><code>ArsenalActiveProductEntry</code><code>ArsenalActiveProductEntryProgressImage</code><code>ArsenalActiveProductListBox</code><code>ArsenalCategoryList</code><code>ArsenalCategoryListEntry</code><code>ArsenalCategoryListEntryImage</code><code>ArsenalCategoryListEntrySelector</code><code>ArsenalCategoryListEntrySwapper</code><code>ArsenalDestroyButton</code><code>ArsenalEntry</code><code>ArsenalItemList</code><code>ArsenalItemListEntry</code><code>ArsenalItemListEntryItemIconImage</code><code>ArsenalItemListEntryItemNameText</code><code>ArsenalItemListEntrySkillDescriptionText</code><code>ArsenalItemListEntrySkillIconImage</code><code>ArsenalItemListEntrySwapper</code><code>ArsenalListBox</code><code>ArsenalPanel</code><code>ArsenalSlaveSelector</code><code>ArsenalTacticEntry</code><code>ArsenalTacticListBox</code><code>ArsenalWaitingProductEntry</code><code>ArsenalWaitingQueueListBox</code></span> | 2026-04-25 |
| <code>Asker</code> | <span class="naming-census-name-list"><code>Asker</code><code>AskerNoButton</code><code>AskerPopup</code><code>AskerText</code><code>AskerYesButton</code></span> | 2026-04-22 |
| <code>Back</code> | <span class="naming-census-name-list"><code>BackButton</code></span> | 2026-04-25 |
| <code>Bar</code> | <span class="naming-census-name-list"><code>Bar</code><code>BarArmory</code><code>BarCrew</code><code>BarHp</code><code>BarLandmine</code><code>BarShield</code><code>BarTime</code></span> | 2026-04-25 |
| <code>Base</code> | <span class="naming-census-name-list"><code>Base</code><code>BaseDeployTutorial</code><code>BaseDomainLayout</code><code>BaseGroup</code><code>BaseIcon</code><code>BaseSelectLastButton</code><code>BaseSelectMaxButton</code><code>BaseSelectMinButton</code><code>BaseSelectTutorial</code><code>BaseSelector</code></span> | 2026-04-25 |
| <code>Basez</code> | <span class="naming-census-name-list"><code>Basez</code><code>BasezIconHpText</code><code>BasezMaxText</code><code>BasezMinText</code><code>BasezPortrait</code><code>BasezRepairText</code><code>BasezTitleText</code></span> | 2026-04-25 |
| <code>Boss</code> | <span class="naming-census-name-list"><code>BossStatus</code><code>BossStatusHpBar</code><code>BossStatusNameText</code></span> | 2025-04-04 |
| <code>Bot</code> | <span class="naming-census-name-list"><code>BotStubFinderFromListEntry</code><code>BotView</code></span> | 2026-04-15 |
| <code>Buff</code> | <span class="naming-census-name-list"><code>BuffEntry</code><code>BuffEntryIconImage</code><code>BuffList</code><code>BuffStatus</code><code>BuffView</code></span> | 2025-04-08 |
| <code>Bunker</code> | <span class="naming-census-name-list"><code>BunkerCrew</code><code>BunkerCrewPortrait</code><code>BunkerStatus</code><code>BunkerStatusCounter</code><code>BunkerStatusMemberEntry</code><code>BunkerStatusMemberEntryBar</code><code>BunkerStatusMemberEntryPortrait</code><code>BunkerStatusMemberList</code></span> | 2026-04-25 |
| <code>Campaign</code> | <span class="naming-census-name-list"><code>Campaign</code><code>CampaignDifficultyContinueButton</code><code>CampaignDifficultyIconImage</code><code>CampaignDifficultyLastStage</code><code>CampaignDifficultyNewButton</code><code>CampaignDifficultySelectButton</code><code>CampaignMenuTab</code></span> | 2026-04-25 |
| <code>Canvas</code> | <span class="naming-census-name-list"><code>Canvas</code></span> | 2025-02-24 |
| <code>Cell</code> | <span class="naming-census-name-list"><code>CellView</code></span> | 2026-07-26 |
| <code>Character</code> | <span class="naming-census-name-list"><code>CharacterCreateButton</code><code>CharacterList</code><code>CharacterNameText</code><code>CharacterSelector</code><code>CharacterSelectorEntry</code><code>CharacterSelectorPanel</code><code>CharacterStatus</code><code>CharacterStatusHpBar</code><code>CharacterStubFinderFromListEntry</code><code>CharacterView</code></span> | 2026-04-16 |
| <code>Cheater</code> | <span class="naming-census-name-list"><code>CheaterCloseButton</code><code>CheaterCommandCharacterButton</code><code>CheaterCommandTownButton</code><code>CheaterCommandWeaponButton</code><code>CheaterGameExitButton</code><code>CheaterGameLoseButton</code><code>CheaterGameStartButton</code><code>CheaterGameStopButton</code><code>CheaterGameWinButton</code><code>CheaterLobbyList</code><code>CheaterLobbyListEntry</code><code>CheaterLobbyListEntryButton</code><code>CheaterLobbyListEntryButtonText</code><code>CheaterLookDevLobby</code><code>CheaterMenuCharacterButton</code><code>CheaterMenuEscapeButton</code><code>CheaterMenuHomeButton</code><code>CheaterMenuLobbyButton</code><code>CheaterMenuStageButton</code><code>CheaterMenuStepperButton</code><code>CheaterMenuTownButton</code><code>CheaterMenuWeaponButton</code><code>CheaterOpenButton</code><code>CheaterSelector</code><code>CheaterStageList</code><code>CheaterStageListEntry</code><code>CheaterStageListEntryButton</code><code>CheaterStageListEntryButtonText</code><code>CheaterSubmenuSelector</code></span> | 2026-04-25 |
| <code>Chrono</code> | <span class="naming-census-name-list"><code>ChronoText</code></span> | 2025-06-16 |
| <code>Common</code> | <span class="naming-census-name-list"><code>CommonAsker</code><code>CommonPopup</code><code>CommonSettingsDptypeList</code><code>CommonSettingsDptypeListEntry</code><code>CommonSettingsDptypeListEntryButton</code><code>CommonSettingsDptypeListEntryText</code><code>CommonSettingsLanguageList</code><code>CommonSettingsLanguageListEntry</code><code>CommonSettingsLanguageListEntryButton</code><code>CommonSettingsLanguageListEntryImage</code><code>CommonSettingsLanguageListEntryText</code><code>CommonSettingsMasterSlider</code><code>CommonSettingsMusicSlider</code><code>CommonSettingsResolutionList</code><code>CommonSettingsResolutionListEntry</code><code>CommonSettingsResolutionListEntryButton</code><code>CommonSettingsResolutionListEntryText</code><code>CommonSettingsSoundSlider</code><code>CommonSettingsSoundToggle</code></span> | 2026-08-01 |
| <code>Crewz</code> | <span class="naming-census-name-list"><code>Crewz</code><code>CrewzArmorStatBackSelector</code><code>CrewzArmorText</code><code>CrewzBioText</code><code>CrewzCategoryImage</code><code>CrewzCategoryText</code><code>CrewzCategoryTooltip</code><code>CrewzDamageStatBackSelector</code><code>CrewzDamageText</code><code>CrewzDisplayNameText</code><code>CrewzEffectRangeStatBackSelector</code><code>CrewzEffectRangeText</code><code>CrewzGatherSelector</code><code>CrewzGatherStatBackSelector</code><code>CrewzGatherText</code><code>CrewzHpStatBackSelector</code><code>CrewzHpText</code><code>CrewzMovementStatBackSelector</code><code>CrewzMovementText</code><code>CrewzPortrait</code><code>CrewzRangeStatBackSelector</code><code>CrewzRangeText</code><code>CrewzRecoveryStatBackSelector</code><code>CrewzRecoveryText</code><code>CrewzRepairSelector</code><code>CrewzRepairStatBackSelector</code><code>CrewzRepairText</code><code>CrewzShieldStatBackSelector</code><code>CrewzShieldText</code><code>CrewzSkillImage</code><code>CrewzSkillText</code><code>CrewzSkillTooltip</code><code>CrewzStatDetailButton</code><code>CrewzStatList</code><code>CrewzStatSelector</code><code>CrewzStatSimpleButton</code><code>CrewzTagsStatBackSelector</code><code>CrewzTagsText</code><code>CrewzTraitText</code></span> | 2026-04-25 |
| <code>Currency</code> | <span class="naming-census-name-list"><code>CurrencyView</code></span> | 2025-02-24 |
| <code>Current</code> | <span class="naming-census-name-list"><code>CurrentAssocText</code><code>CurrentBaseButton</code><code>CurrentGameObjectSelector</code><code>CurrentLevelText</code><code>CurrentMinimapImage</code><code>CurrentPlanetText</code><code>CurrentRewardText</code><code>CurrentSolidiumText</code><code>CurrentTitleText</code><code>CurrentUraniumText</code></span> | 2026-04-25 |
| <code>Debug</code> | <span class="naming-census-name-list"><code>DebugDetector</code></span> | 2025-02-24 |
| <code>Deltastat</code> | <span class="naming-census-name-list"><code>DeltastatView</code></span> | 2025-04-08 |
| <code>Dev</code> | <span class="naming-census-name-list"><code>DevCharacterBlueButton</code><code>DevCharacterList</code><code>DevCharacterListEntry</code><code>DevCharacterListEntryPortrait</code><code>DevCharacterListEntrySwapper</code><code>DevCharacterRedButton</code><code>DevCommandStartButton</code><code>DevToolWindow</code></span> | 2026-07-18 |
| <code>Device</code> | <span class="naming-census-name-list"><code>DeviceDetector</code></span> | 2026-07-19 |
| <code>Diagnostics</code> | <span class="naming-census-name-list"><code>Diagnostics</code><code>DiagnosticsKeyloggerList</code><code>DiagnosticsKeyloggerListEntry</code><code>DiagnosticsKeyloggerListEntryImage</code></span> | 2026-08-01 |
| <code>Dialog</code> | <span class="naming-census-name-list"><code>Dialog</code><code>DialogButton</code><code>DialogCloser</code><code>DialogPanel</code><code>DialogPortrait</code><code>DialogPortraitImage</code><code>DialogTerminatorButton</code><code>DialogText</code><code>DialogTimer</code><code>DialogUi</code></span> | 2026-04-25 |
| <code>Downloader</code> | <span class="naming-census-name-list"><code>DownloaderProgress</code></span> | 2024-11-27 |
| <code>Dptype</code> | <span class="naming-census-name-list"><code>DptypeFinderFromListEntry</code></span> | 2026-08-01 |
| <code>Entitlement</code> | <span class="naming-census-name-list"><code>EntitlementView</code></span> | 2025-03-12 |
| <code>Ex</code> | <span class="naming-census-name-list"><code>ExCrew</code><code>ExCrewCategoryImage</code><code>ExCrewCategoryTooltip</code><code>ExCrewPortrait</code><code>ExCrewTech</code><code>ExCrewTechImage</code><code>ExModuleBasePortrait</code></span> | 2026-04-25 |
| <code>Exit</code> | <span class="naming-census-name-list"><code>ExitButton</code></span> | 2026-01-25 |
| <code>Facilityz</code> | <span class="naming-census-name-list"><code>Facilityz</code><code>FacilityzDamage</code><code>FacilityzDamageText</code><code>FacilityzDescriptionText</code><code>FacilityzEffectRange</code><code>FacilityzEffectRangeText</code><code>FacilityzHp</code><code>FacilityzIconHpText</code><code>FacilityzIconImage</code><code>FacilityzIconOccupation</code><code>FacilityzIconOccupationText</code><code>FacilityzLockText</code><code>FacilityzOccupation</code><code>FacilityzRange</code><code>FacilityzRangeText</code><code>FacilityzTags</code><code>FacilityzTagsText</code><code>FacilityzTitleText</code></span> | 2026-04-25 |
| <code>Floater</code> | <span class="naming-census-name-list"><code>FloaterCanvas</code></span> | 2025-03-15 |
| <code>Foley</code> | <span class="naming-census-name-list"><code>FoleyView</code></span> | 2025-07-22 |
| <code>Game</code> | <span class="naming-census-name-list"><code>GamePauseButton</code><code>GamePlayState</code><code>GameResumeButton</code><code>GameSlotEntry</code><code>GameSlotWindow</code><code>GameState</code><code>GameStateToggle</code><code>GameStateToggleTutorial</code><code>GameStateToggleTutorialHideButton</code><code>GameStatusDisplay</code><code>GameTimeText</code><code>GameView</code></span> | 2026-04-25 |
| <code>Gateway</code> | <span class="naming-census-name-list"><code>Gateway</code><code>GatewayCloseButton</code><code>GatewayDetailsButton</code><code>GatewayLobbyList</code><code>GatewayLobbyListEntry</code><code>GatewayLobbyListEntrySwapper</code><code>GatewayLobbyListEntryTitleText</code><code>GatewayLobbyTitleText</code><code>GatewayMemberList</code><code>GatewayMemberListEntry</code><code>GatewayMemberListEntryNameText</code><code>GatewayMonsterNameLongText</code><code>GatewayMonsterPortraitImage</code><code>GatewayPartyList</code><code>GatewayPartyListEntry</code><code>GatewayPartyListEntryTitleText</code><code>GatewayPartySelector</code><code>GatewayStartButton</code></span> | 2026-06-06 |
| <code>Host</code> | <span class="naming-census-name-list"><code>HostMissionChangeButton</code><code>HostRoomDifficultySwitch</code><code>HostRoomSwitch</code><code>HostSelector</code><code>HostStartButton</code><code>HostStartTooltip</code></span> | 2026-04-25 |
| <code>Hotkey</code> | <span class="naming-census-name-list"><code>HotkeyReceiverUi</code><code>HotkeyToImage</code></span> | 2026-07-26 |
| <code>Ingame</code> | <span class="naming-census-name-list"><code>IngameCashButton</code><code>IngameCashText</code><code>IngameControlMenuButton</code><code>IngameDefeatRestartButton</code><code>IngameGoldButton</code><code>IngameGoldText</code><code>IngameLevelButton</code><code>IngameLevelText</code><code>IngameLifeText</code><code>IngameMenu</code><code>IngameMenuExitButton</code><code>IngameMenuRestartButton</code><code>IngameMenuSettingsButton</code><code>IngameMenuTitleButton</code><code>IngameMineText</code><code>IngameTimeText</code><code>IngameVictoryRestartButton</code></span> | 2026-08-01 |
| <code>Input</code> | <span class="naming-census-name-list"><code>Input</code><code>InputDetector</code><code>InputReceiverUi</code></span> | 2026-08-01 |
| <code>Inroom</code> | <span class="naming-census-name-list"><code>Inroom</code><code>InroomExitButton</code><code>InroomOptionsList</code><code>InroomOptionsPrivateButton</code><code>InroomOptionsPublicButton</code><code>InroomPlayerEntry</code><code>InroomPlayerEntryKickButton</code><code>InroomPlayerEntryNameText</code><code>InroomPlayerEntryObserveButton</code><code>InroomPlayerEntryPlayButton</code><code>InroomPlayerEntryStateText</code><code>InroomPlayerList</code><code>InroomReadyButton</code><code>InroomStartButton</code><code>InroomUnreadyButton</code></span> | 2026-08-01 |
| <code>Invitation</code> | <span class="naming-census-name-list"><code>InvitationList</code><code>InvitationListEntry</code><code>InvitationListEntryAcceptButton</code><code>InvitationListEntryDeclineButton</code><code>InvitationListEntryText</code></span> | 2026-04-25 |
| <code>Item</code> | <span class="naming-census-name-list"><code>ItemEntry</code><code>ItemFinderFromListEntry</code><code>ItemIcon</code><code>ItemIconImage</code><code>ItemSlot</code><code>ItemTagHubEntry</code><code>ItemView</code></span> | 2026-04-22 |
| <code>Key</code> | <span class="naming-census-name-list"><code>KeyToImage</code></span> | 2026-05-25 |
| <code>Keylogger</code> | <span class="naming-census-name-list"><code>KeyloggerEntry</code><code>KeyloggerEntryImage</code><code>KeyloggerFinderFromListEntry</code><code>KeyloggerList</code></span> | 2026-08-01 |
| <code>Language</code> | <span class="naming-census-name-list"><code>LanguageEntry</code><code>LanguageFinderFromListEntry</code></span> | 2026-08-01 |
| <code>Launcher</code> | <span class="naming-census-name-list"><code>Launcher</code><code>LauncherButton</code><code>LauncherRetryButton</code></span> | 2026-04-25 |
| <code>Lobby</code> | <span class="naming-census-name-list"><code>LobbyBridgeFinderFromListEntry</code><code>LobbyCloseButton</code><code>LobbyCreateButton</code><code>LobbyFinderFromListEntry</code><code>LobbyJoinButton</code><code>LobbyLeaveButton</code><code>LobbyRefreshButton</code><code>LobbyRegionText</code><code>LobbyRoomEntry</code><code>LobbyRoomList</code><code>LobbyRoomListBox</code><code>LobbyRoomListEntry</code><code>LobbyRoomListEntryHostText</code><code>LobbyRoomListEntryJoinButton</code><code>LobbyRoomListEntryModeText</code><code>LobbyRoomListEntrySlotText</code><code>LobbyRoomListEntryTitleText</code><code>LobbyRoomPlayerEntry</code><code>LobbyRoomPlayerListBox</code><code>LobbyView</code></span> | 2026-08-01 |
| <code>Map</code> | <span class="naming-census-name-list"><code>MapButton</code><code>MapEntry</code><code>MapEntryAssocButton</code><code>MapEntryAssocImage</code><code>MapEntryLevelText</code><code>MapEntryLockTooltip</code><code>MapEntryPortraitImage</code><code>MapEntryRewardText</code><code>MapEntrySelector</code><code>MapEntrySolidiumText</code><code>MapEntryTitleText</code><code>MapEntryToggle</code><code>MapEntryUraniumText</code><code>MapInfo</code><code>MapInfoDifficultySelector</code><code>MapList</code><code>MapListBox</code><code>MapSupplyMark</code><code>MapSupplyMarkTutorial</code><code>MapTitleText</code><code>MapView</code></span> | 2024-11-25 |
| <code>Menu</code> | <span class="naming-census-name-list"><code>MenuContinueButton</code><code>MenuExitButton</code><code>MenuNetworkButton</code><code>MenuNewButton</code><code>MenuPlayButton</code><code>MenuSettingsButton</code><code>MenuSkirmishButton</code></span> | 2026-04-25 |
| <code>Minimap</code> | <span class="naming-census-name-list"><code>MinimapAlertEntry</code><code>MinimapAlertList</code><code>MinimapArchiveEntry</code><code>MinimapArchiveList</code><code>MinimapCameraFrameSizeFitter</code><code>MinimapDraggingAreaSizeFitter</code><code>MinimapFieldFrameSizeFitter</code><code>MinimapImage</code><code>MinimapModuleEntry</code><code>MinimapModuleList</code><code>MinimapResourceEntry</code><code>MinimapResourceList</code><code>MinimapScroller</code><code>MinimapUnitEntry</code><code>MinimapUnitList</code><code>MinimapWaveEntry</code><code>MinimapWaveEntryPath</code><code>MinimapWaveEntryWarning</code><code>MinimapWaveList</code></span> | 2026-04-25 |
| <code>Mission</code> | <span class="naming-census-name-list"><code>MissionCancelButton</code><code>MissionEntry</code><code>MissionEntryTimeText</code><code>MissionListBox</code><code>MissionOkButton</code></span> | 2026-04-25 |
| <code>Model</code> | <span class="naming-census-name-list"><code>ModelSlaveSelector</code><code>ModelStatusBar</code></span> | 2026-04-25 |
| <code>Module</code> | <span class="naming-census-name-list"><code>ModuleControlGuideSwitch</code><code>ModuleFacilityPortraitIconImage</code><code>ModuleStatus</code><code>ModuleStatusButton</code><code>ModuleStatusDisplayNameText</code><code>ModuleStatusKindEntry</code><code>ModuleStatusKindEntryTooltipViewer</code><code>ModuleStatusKindList</code><code>ModuleStatusPortrait</code></span> | 2026-04-25 |
| <code>Monster</code> | <span class="naming-census-name-list"><code>MonsterView</code></span> | 2025-04-04 |
| <code>Mouse</code> | <span class="naming-census-name-list"><code>MouseCheckerBottom</code><code>MouseCheckerLeft</code><code>MouseCheckerLeftBottom</code><code>MouseCheckerLeftTop</code><code>MouseCheckerRight</code><code>MouseCheckerRightBottom</code><code>MouseCheckerRightTop</code><code>MouseCheckerTop</code><code>MouseGuide</code><code>MouseGuideAni</code><code>MouseGuideUpdater</code></span> | 2024-11-21 |
| <code>Mover</code> | <span class="naming-census-name-list"><code>MoverView</code></span> | 2025-06-04 |
| <code>My</code> | <span class="naming-census-name-list"><code>MyAsker</code><code>MyAsker.MyAskerArguments</code><code>MyAskerNoButton</code><code>MyAskerOkButton</code><code>MyAskerYesButton</code><code>MyBar</code><code>MyButton</code><code>MyControl</code><code>MyControl.Audio</code><code>MyControl.Image</code><code>MyCurrentGameObjectDetector</code><code>MyCurrentGameObjectSelector</code><code>MyDevToolWindow</code><code>MyDropdown</code><code>MyEventUpwardsClick</code><code>MyEventUpwardsDrag</code><code>MyImage</code><code>MyInput</code><code>MyInputField</code><code>MyList</code><code>MyList.Data</code><code>MyListEntry</code><code>MyPopup</code><code>MyPopupCloseButton</code><code>MyPortrait</code><code>MyRadialSlider</code><code>MyRadio</code><code>MyRadio.State</code><code>MyRadioGroup</code><code>MySelectable</code><code>MySelector</code><code>MySelectorToggle</code><code>MySelectorToggleButton</code><code>MySlider</code><code>MySwapper</code><code>MySwapperButton</code><code>MySwitchToggle</code><code>MySwitcherButton</code><code>MyTab</code><code>MyText</code><code>MyToggle</code></span> | 2026-07-19 |
| <code>Net</code> | <span class="naming-census-name-list"><code>NetHostButton</code><code>NetJoinButton</code><code>NetOwner</code><code>NetOwnerSelector</code></span> | 2026-04-25 |
| <code>New</code> | <span class="naming-census-name-list"><code>NewDeliveryImage</code><code>NewIconImage</code><code>NewRoomOkButton</code><code>NewRoomTitleInputField</code></span> | 2026-04-25 |
| <code>Npc</code> | <span class="naming-census-name-list"><code>NpcView</code></span> | 2025-06-05 |
| <code>Objective</code> | <span class="naming-census-name-list"><code>ObjectiveEntry</code><code>ObjectiveEntrySummaryText</code><code>ObjectiveEntryTitleText</code><code>ObjectiveList</code><code>ObjectiveListBox</code><code>ObjectivePanel</code></span> | 2026-04-25 |
| <code>Offer</code> | <span class="naming-census-name-list"><code>OfferFinderFromListEntry</code><code>OfferView</code></span> | 2025-02-28 |
| <code>Order</code> | <span class="naming-census-name-list"><code>Order</code><code>OrderEntity</code><code>OrderEntityButton</code><code>OrderEntityCountText</code><code>OrderEntitySelector</code><code>OrderInfo</code><code>OrderInfoActiveHoverTooltipViewer</code><code>OrderInfoDeactiveHoverTooltipViewer</code><code>OrderInfoIconImage</code><code>OrderInfoSelector</code><code>OrderInterfaceFinderFromSelector</code><code>OrderModule</code><code>OrderModuleDescText</code></span> | 2026-04-25 |
| <code>Page</code> | <span class="naming-census-name-list"><code>Page</code></span> | 2026-07-28 |
| <code>Panel</code> | <span class="naming-census-name-list"><code>Panel</code><code>PanelSwitch</code></span> | 2026-07-28 |
| <code>Party</code> | <span class="naming-census-name-list"><code>PartyFinderFromListEntry</code><code>PartyMemberList</code><code>PartyMemberListEntry</code><code>PartyMemberListEntryNameText</code><code>PartyMemberListEntryReadyText</code><code>PartyView</code></span> | 2025-05-13 |
| <code>Pauser</code> | <span class="naming-census-name-list"><code>Pauser</code><code>PauserContinueButton</code><code>PauserExitButton</code><code>PauserMenu</code><code>PauserSettingsButton</code><code>PauserStopButton</code><code>PauserTitleButton</code></span> | 2025-06-29 |
| <code>Planet</code> | <span class="naming-census-name-list"><code>PlanetStage</code><code>PlanetStageQuestEntry</code><code>PlanetStageQuestEntryButton</code><code>PlanetStageQuestEntryIconImage</code><code>PlanetStageQuestEntrySelector</code><code>PlanetStageQuestList</code><code>PlanetStageSelectButton</code><code>PlanetStageSelectButtonTutorial</code></span> | 2026-04-25 |
| <code>Player</code> | <span class="naming-census-name-list"><code>PlayerEntry</code><code>PlayerEntryCommandToggle</code><code>PlayerEntryKickButton</code><code>PlayerEntryNameText</code><code>PlayerEntryStateText</code><code>PlayerFinderFromListEntry</code><code>PlayerIndicator</code><code>PlayerList</code><code>PlayerNameText</code><code>PlayerProfile</code><code>PlayerView</code></span> | 2026-08-01 |
| <code>Playing</code> | <span class="naming-census-name-list"><code>PlayingCrewEntry</code><code>PlayingCrewEntryBar</code><code>PlayingCrewEntryButton</code><code>PlayingCrewEntryHitCover</code><code>PlayingCrewEntryStatus</code><code>PlayingCrewList</code></span> | 2026-04-25 |
| <code>Pose</code> | <span class="naming-census-name-list"><code>PoseView</code></span> | 2026-04-19 |
| <code>Profile</code> | <span class="naming-census-name-list"><code>ProfileEntry</code><code>ProfileEntryLastTimeText</code><code>ProfileEntryLevel</code><code>ProfileEntryLevelText</code><code>ProfileEntryModifyButton</code><code>ProfileEntryNameText</code><code>ProfileEntryRemoveButton</code><code>ProfileEntryToggle</code><code>ProfileForm</code><code>ProfileFormNewButton</code><code>ProfileFormStartButton</code><code>ProfileList</code><code>ProfileNameInputbox</code><code>ProfileNameInputboxCancelButton</code><code>ProfileNameInputboxInputField</code><code>ProfileNameInputboxOkButton</code><code>ProfileNameText</code></span> | 2026-04-25 |
| <code>Pulse</code> | <span class="naming-census-name-list"><code>PulseView</code></span> | 2025-06-05 |
| <code>Questz</code> | <span class="naming-census-name-list"><code>Questz</code><code>QuestzAssocBar</code><code>QuestzAssocNameText</code><code>QuestzAssocRelationText</code><code>QuestzAssocRewardEntry</code><code>QuestzAssocRewardEntryButton</code><code>QuestzAssocRewardEntryIconImage</code><code>QuestzAssocRewardEntryQuantityText</code><code>QuestzAssocRewardEntrySelector</code><code>QuestzAssocRewardEntryText</code><code>QuestzAssocRewardList</code><code>QuestzAssocSolidiumButton</code><code>QuestzAssocUraniumButton</code><code>QuestzBuffDisplayNameText</code><code>QuestzBuffPortraitImage</code><code>QuestzBuffText</code><code>QuestzDetailText</code><code>QuestzMarkImage</code><code>QuestzModuleDisplayNameText</code><code>QuestzModulePortraitImage</code><code>QuestzModuleText</code><code>QuestzPartition</code><code>QuestzProgressText</code><code>QuestzRewardCashText</code><code>QuestzTargetDisplayNameText</code><code>QuestzTargetPortraitImage</code><code>QuestzTargetText</code><code>QuestzText</code></span> | 2026-04-25 |
| <code>Region</code> | <span class="naming-census-name-list"><code>RegionView</code></span> | 2024-11-25 |
| <code>Relation</code> | <span class="naming-census-name-list"><code>RelationView</code></span> | 2026-04-16 |
| <code>Report</code> | <span class="naming-census-name-list"><code>ReportButton</code><code>ReportFormBackButton</code><code>ReportFormCaptureImage</code><code>ReportFormSendButton</code></span> | 2026-04-25 |
| <code>Reset</code> | <span class="naming-census-name-list"><code>ResetButton</code></span> | 2026-04-25 |
| <code>Resolution</code> | <span class="naming-census-name-list"><code>ResolutionFinderFromListEntry</code></span> | 2026-08-01 |
| <code>Resource</code> | <span class="naming-census-name-list"><code>ResourceFinderFromInput</code><code>ResourceFinderFromSelector</code><code>ResourceIngredientEntry</code><code>ResourcePanel</code><code>ResourceQuantityText</code><code>ResourceServantLockInfoWindow</code><code>ResourceServantSlotInfoWindow</code><code>ResourceStatus</code><code>ResourceStatusButton</code><code>ResourceStatusDisplayNameText</code><code>ResourceStatusHarvesterText</code><code>ResourceStatusPortrait</code><code>ResourceStatusQuantityText</code></span> | 2026-04-25 |
| <code>Retry</code> | <span class="naming-census-name-list"><code>RetryButton</code><code>RetryUi</code></span> | 2026-01-25 |
| <code>Robot</code> | <span class="naming-census-name-list"><code>Robot</code><code>RobotDescriptionText</code></span> | 2026-04-25 |
| <code>Room</code> | <span class="naming-census-name-list"><code>RoomChatEntry</code><code>RoomChatInputField</code><code>RoomChatListBox</code><code>RoomEntry</code><code>RoomEntryDifficultyText</code><code>RoomEntryHostText</code><code>RoomEntryMissionText</code><code>RoomEntryPlayerText</code><code>RoomEntryTitleText</code><code>RoomEntryToggle</code><code>RoomFinderFromListEntry</code><code>RoomLeaveButton</code><code>RoomList</code><code>RoomMapCloseButton</code><code>RoomMapSelectButton</code><code>RoomMessageEntry</code><code>RoomMessageEntrySelector</code><code>RoomMessageInputField</code><code>RoomMessageList</code><code>RoomPlayerEntry</code><code>RoomPlayerEntryKickButton</code><code>RoomPlayerEntryObservingToggle</code><code>RoomPlayerEntryReadyToggle</code><code>RoomPlayerListBox</code><code>RoomReadyButton</code><code>RoomTickText</code><code>RoomVisibleToggle</code></span> | 2026-08-01 |
| <code>Savefile</code> | <span class="naming-census-name-list"><code>SavefileFinderFromListEntry</code><code>SavefileSelector</code><code>SavefileSelectorList</code><code>SavefileSelectorListEntry</code><code>SavefileSelectorListEntrySwapper</code></span> | 2025-08-01 |
| <code>Selected</code> | <span class="naming-census-name-list"><code>SelectedRoomCountText</code><code>SelectedRoomCountToggle</code><code>SelectedRoomDifficultyText</code><code>SelectedRoomDifficultyToggle</code><code>SelectedRoomPlayerEntry</code><code>SelectedRoomPlayerEntryNameText</code><code>SelectedRoomPlayerList</code><code>SelectedRoomTitleText</code></span> | 2026-04-25 |
| <code>Selector</code> | <span class="naming-census-name-list"><code>Selector</code><code>SelectorImage</code></span> | 2026-04-25 |
| <code>Settings</code> | <span class="naming-census-name-list"><code>Settings</code><code>SettingsClickSlider</code><code>SettingsCursorToggle</code><code>SettingsDataMigrationButton</code><code>SettingsDialogToggle</code><code>SettingsDisplayModeDropdown</code><code>SettingsDragScrollInverterToggle</code><code>SettingsDragScrollSpeedSlider</code><code>SettingsGuideAToggle</code><code>SettingsGuideBToggle</code><code>SettingsGuideCToggle</code><code>SettingsHapticSwitcher</code><code>SettingsKeyEntry</code><code>SettingsKeyEntryCancelButton</code><code>SettingsKeyEntryChangeButton</code><code>SettingsKeyEntryResetButton</code><code>SettingsKeyList</code><code>SettingsKeyListBox</code><code>SettingsKeyboardScrollSpeedSlider</code><code>SettingsLanguageDropdown</code><code>SettingsMasterSlider</code><code>SettingsMouseScrollSpeedSlider</code><code>SettingsMusicSlider</code><code>SettingsNotificationSwitcher</code><code>SettingsPanel</code><code>SettingsQualitySwitch</code><code>SettingsQualitySwitchToggle</code><code>SettingsReportingToggle</code><code>SettingsResolutionDropdown</code><code>SettingsSoundSlider</code><code>SettingsSoundToggle</code><code>SettingsTutorialResetButton</code></span> | 2026-04-25 |
| <code>Shop</code> | <span class="naming-census-name-list"><code>Shop</code><code>ShopBackButton</code><code>ShopNpcPortraitImage</code><code>ShopNpcTalkText</code><code>ShopProductAnyEntryBuyButton</code><code>ShopProductAnyEntryIngredientList</code><code>ShopProductAnyEntryLockHover</code><code>ShopProductAnyEntryPortraitImage</code><code>ShopProductAnyEntryQuantityText</code><code>ShopProductAnyEntrySelector</code><code>ShopProductAnyEntryTitleText</code><code>ShopProductBaseEntry</code><code>ShopProductBaseEntryTitleText</code><code>ShopProductBaseEntryToggle</code><code>ShopProductBaseList</code><code>ShopProductCrewEntry</code><code>ShopProductCrewEntryCategoryHover</code><code>ShopProductCrewEntryDisplayNameText</code><code>ShopProductCrewEntryPortrait</code><code>ShopProductCrewEntryToggle</code><code>ShopProductCrewList</code><code>ShopProductFacilityEntry</code><code>ShopProductFacilityEntryToggle</code><code>ShopProductFacilityList</code><code>ShopProductTechEntry</code><code>ShopProductTechEntryEquipButton</code><code>ShopProductTechEntryHover</code><code>ShopProductTechEntryImage</code><code>ShopProductTechEntryNameText</code><code>ShopProductTechEntrySelector</code><code>ShopProductTechEntryUnequipButton</code><code>ShopProductTechList</code><code>ShopProductTechSelector</code><code>ShopTab</code><code>ShopTabTechToggle</code><code>ShopTabTechToggleTutorial</code><code>ShopUserBaseEntry</code><code>ShopUserBaseEntryToggle</code><code>ShopUserBaseList</code><code>ShopUserCrewEntry</code><code>ShopUserCrewEntryNameText</code><code>ShopUserCrewEntryStateToggle</code><code>ShopUserCrewEntryTypeSelector</code><code>ShopUserCrewList</code><code>ShopUserFacilityEntry</code><code>ShopUserFacilityEntryQuantityText</code><code>ShopUserFacilityList</code><code>ShopUserTechEntry</code><code>ShopUserTechEntryMark</code><code>ShopUserTechEntryPortraitImage</code><code>ShopUserTechEntrySelector</code><code>ShopUserTechEntryToggle</code><code>ShopUserTechList</code><code>ShopWindow</code></span> | 2026-04-25 |
| <code>Skill</code> | <span class="naming-census-name-list"><code>SkillButton</code><code>SkillIcon</code><code>SkillPanel</code><code>SkillUi</code><code>SkillView</code></span> | 2025-03-23 |
| <code>Skirmish</code> | <span class="naming-census-name-list"><code>Skirmish</code><code>SkirmishAdditionalSelector</code><code>SkirmishBackButton</code><code>SkirmishButtonSelector</code><code>SkirmishCaptainEntry</code><code>SkirmishCaptainEntryDetailButton</code><code>SkirmishCaptainEntryNameText</code><code>SkirmishCaptainEntrySolidiumText</code><code>SkirmishCaptainEntryToggle</code><code>SkirmishCaptainEntryUraniumText</code><code>SkirmishCaptainList</code><code>SkirmishCommanderChangeButton</code><code>SkirmishHostedButtonSelector</code><code>SkirmishLaunchButtonSelector</code><code>SkirmishListSelector</code><code>SkirmishLobbySelector</code><code>SkirmishMemberButtonSelector</code><code>SkirmishMultiReadyButton</code><code>SkirmishMultiReadyButtonTooltip</code><code>SkirmishMultiReadySelector</code><code>SkirmishMultiStartButton</code><code>SkirmishMultiUnreadyButton</code><code>SkirmishPlayerEntry</code><code>SkirmishPlayerEntrySelector</code><code>SkirmishPlayerList</code><code>SkirmishPlayerSelector</code><code>SkirmishStartButton</code><code>SkirmishSupplyMark</code><code>SkirmishUserButton</code><code>SkirmishUserLevelText</code><code>SkirmishUserNameText</code></span> | 2026-04-25 |
| <code>Stage</code> | <span class="naming-census-name-list"><code>StageAchievementEntry</code><code>StageAchievementListBox</code><code>StageAttackButton</code><code>StageBlueHp</code><code>StageBridgeFinderFromListEntry</code><code>StageBuildingEntry</code><code>StageBuildingListBox</code><code>StageButton</code><code>StageCardList</code><code>StageCargoCost</code><code>StageCargoCostText</code><code>StageCargoExpandButton</code><code>StageDescriptionText</code><code>StageDesignEntry</code><code>StageDesignListBox</code><code>StageInfo</code><code>StageLeft</code><code>StageLeftText</code><code>StageMoney</code><code>StageMoneyText</code><code>StageNameText</code><code>StageObjectiveText</code><code>StagePanel</code><code>StagePoint</code><code>StageRedHp</code><code>StageResource</code><code>StageResourceGroup</code><code>StageResultText</code><code>StageRight</code><code>StageRightText</code><code>StageStartButton</code><code>StageTacticEntry</code><code>StageTacticEntryAddButton</code><code>StageTacticEntryCountText</code><code>StageTacticEntryIconImage</code><code>StageTacticEntryRemoveButton</code><code>StageTacticListBox</code><code>StageTechCategory</code><code>StageTechCost</code><code>StageTechCostText</code><code>StageTechEntry</code><code>StageTechEntryCost</code><code>StageTechEntryCostText</code><code>StageTechEntryDescriptionText</code><code>StageTechEntryIconImage</code><code>StageTechListBox</code><code>StageText</code><code>StageTitleText</code><code>StageView</code></span> | 2026-02-14 |
| <code>Stat</code> | <span class="naming-census-name-list"><code>StatEntry</code><code>StatView</code></span> | 2025-04-08 |
| <code>Strategy</code> | <span class="naming-census-name-list"><code>Strategy</code><code>StrategyBaseSelector</code><code>StrategyLayout</code><code>StrategyView</code></span> | 2026-04-25 |
| <code>Techlab</code> | <span class="naming-census-name-list"><code>Techlab</code><code>TechlabBackButton</code><code>TechlabButton</code><code>TechlabCrewEntry</code><code>TechlabCrewEntryEquipButton</code><code>TechlabCrewEntryHover</code><code>TechlabCrewEntryImage</code><code>TechlabCrewEntryNameText</code><code>TechlabCrewEntrySelector</code><code>TechlabCrewEntryUnequipButton</code><code>TechlabCrewList</code><code>TechlabCrewSelector</code><code>TechlabTechEntry</code><code>TechlabTechEntryMark</code><code>TechlabTechEntryPortraitImage</code><code>TechlabTechEntrySelector</code><code>TechlabTechEntryToggle</code><code>TechlabTechList</code></span> | 2026-04-25 |
| <code>Techz</code> | <span class="naming-census-name-list"><code>Techz</code><code>TechzBioText</code><code>TechzCategoryText</code><code>TechzIconImage</code><code>TechzLocation</code><code>TechzLocationText</code><code>TechzText</code><code>TechzTitleText</code></span> | 2026-04-25 |
| <code>Terminator</code> | <span class="naming-census-name-list"><code>TerminatorPanel</code><code>TerminatorTimeProgressBar</code><code>TerminatorTimeText</code></span> | 2026-04-25 |
| <code>Timeline</code> | <span class="naming-census-name-list"><code>TimelineSolidiumMarker</code><code>TimelineStarlightMarker</code><code>TimelineTerminatorMarker</code><code>TimelineUraniumMarker</code></span> | 2026-04-25 |
| <code>Timer</code> | <span class="naming-census-name-list"><code>TimerText</code></span> | 2026-01-25 |
| <code>Title</code> | <span class="naming-census-name-list"><code>TitleHubEntry</code><code>TitleMenu</code><code>TitleMenuDevButton</code><code>TitleMenuExitButton</code><code>TitleMenuMultiButton</code><code>TitleMenuMultiplayerButton</code><code>TitleMenuQuickStartButton</code><code>TitleMenuSettingsButton</code><code>TitleMenuSingleButton</code><code>TitleMenuSingleplayerButton</code><code>TitleSingle</code><code>TitleSingleStartButton</code><code>TitleSingleSwapper</code><code>TitleText</code><code>TitleUi</code></span> | 2026-07-28 |
| <code>Titlehud</code> | <span class="naming-census-name-list"><code>TitlehudSettingsButton</code><code>TitlehudStartButton</code><code>TitlehudVersionText</code></span> | 2025-05-06 |
| <code>Town</code> | <span class="naming-census-name-list"><code>TownView</code></span> | 2025-02-24 |
| <code>Trait</code> | <span class="naming-census-name-list"><code>TraitFinderFromListEntry</code><code>TraitSelector</code><code>TraitSelectorList</code><code>TraitSelectorListEntry</code><code>TraitSelectorListEntryDescriptionText</code><code>TraitSelectorListEntryDetailText</code><code>TraitSelectorListEntryIconImage</code><code>TraitSelectorListEntryNameText</code><code>TraitSelectorListEntrySwapper</code><code>TraitView</code></span> | 2025-08-08 |
| <code>Tutorial</code> | <span class="naming-census-name-list"><code>Tutorial</code><code>TutorialToggle</code></span> | 2026-01-25 |
| <code>Ui</code> | <span class="naming-census-name-list"><code>Ui</code><code>UiBaseDomainLayout</code><code>UiBaseDomainTile</code><code>UiSelector</code><code>UiSingleton</code></span> | 2026-07-28 |
| <code>Unit</code> | <span class="naming-census-name-list"><code>UnitAction</code><code>UnitActionItemButton</code><code>UnitActionMainCombatantButton</code><code>UnitActionMainRecruitButton</code><code>UnitActionMainSquadButton</code><code>UnitActionMainWorkerButton</code><code>UnitActionSquadButton</code><code>UnitActionSub</code><code>UnitBalloonImage</code><code>UnitBar</code><code>UnitCategory</code><code>UnitCategoryImage</code><code>UnitCounterEntry</code><code>UnitCounterListBox</code><code>UnitCounterTitleText</code><code>UnitDescription</code><code>UnitDescriptionText</code><code>UnitFinderFromSelector</code><code>UnitHpBarImage</code><code>UnitHpValueText</code><code>UnitItem</code><code>UnitItemCandidate</code><code>UnitItemCandidateEntry</code><code>UnitItemCandidateListBox</code><code>UnitItemInventoryButton</code><code>UnitItemLoadageImage</code><code>UnitMpBarImage</code><code>UnitMpValueText</code><code>UnitNameText</code><code>UnitPanel</code><code>UnitPropertyText</code><code>UnitSkill</code><code>UnitSkillCooldownImage</code><code>UnitSkillIconImage</code><code>UnitSkillProgressImage</code><code>UnitSlaveDebugSpeedBar</code><code>UnitSlaveSelector</code><code>UnitStatListBox</code><code>UnitStateDebugger</code><code>UnitStateDebuggerBar</code><code>UnitStateDebuggerText</code><code>UnitStatus</code><code>UnitStatusButton</code><code>UnitStatusDisplayNameText</code><code>UnitStatusKindEntry</code><code>UnitStatusKindEntryTooltipViewer</code><code>UnitStatusKindList</code><code>UnitStatusPortrait</code><code>UnitStatusTech</code><code>UnitStatusTechImage</code><code>UnitStatusTechTooltipViewer</code><code>UnitStatusText</code><code>UnitTargetIndicator</code><code>UnitTotalPowerText</code></span> | 2026-04-25 |
| <code>User</code> | <span class="naming-census-name-list"><code>UserCaptainEntry</code><code>UserCaptainEntryButton</code><code>UserCaptainList</code><code>UserFinderFromListEntry</code><code>UserView</code></span> | 2026-04-15 |
| <code>Victory</code> | <span class="naming-census-name-list"><code>VictoryCaptainPortrait</code><code>VictoryCashText</code><code>VictoryOkButton</code><code>VictoryPhase</code><code>VictoryPhase_1</code><code>VictoryQuestEntry</code><code>VictoryQuestEntryAssocRewardIconImage</code><code>VictoryQuestEntryResultText</code><code>VictoryQuestEntryReward</code><code>VictoryQuestEntryRewardCashText</code><code>VictoryQuestEntryRewardReputationText</code><code>VictoryQuestEntryTitleText</code><code>VictoryQuestList</code><code>VictoryReputationText</code><code>VictoryReward</code><code>VictoryRewardGiftButton</code><code>VictoryRewardGiftImage</code><code>VictoryRewardTraitButton</code><code>VictoryRewardTraitImage</code><code>VictorySolidiumText</code><code>VictoryUraniumText</code></span> | 2026-04-25 |
| <code>View</code> | <span class="naming-census-name-list"><code>View</code><code>ViewTypeEnum</code></span> | 2026-04-25 |
| <code>Weapon</code> | <span class="naming-census-name-list"><code>WeaponButton</code><code>WeaponFinderFromListEntry</code><code>WeaponPreview</code></span> | 2025-06-11 |
| <code>Win</code> | <span class="naming-census-name-list"><code>WinPanel</code><code>WinScreenReturnButton</code><code>WinUi</code></span> | 2026-01-25 |
| <code>Window</code> | <span class="naming-census-name-list"><code>Window</code><code>WindowCloseButton</code><code>WindowSizeDetector</code></span> | 2026-07-18 |
| <code>World</code> | <span class="naming-census-name-list"><code>WorldView</code></span> | 2025-02-24 |
{:.naming-census-table}

## Entity 경계 후보 {#entity-candidate}

다음 이름은 <code>Finder</code>나 <code>Syncer</code> 같은 관계·동기화 선언으로는 관찰되었지만, 같은 축의 직접 모델이나 레코드가 조사 범위에서 확인되지 않았다. 실제 Entity 축으로 확정하지 않고 후보 데이터로 분리한다.

### 최근 후보

| 실제 이름 축 | 관찰된 정확한 선언 이름 | 마지막 관찰일 |
| --- | --- | ---: |
| <code>BotStub</code> | <span class="naming-census-name-list"><code>BotStubFinder</code></span> | 2026-04-15 |
| <code>CharacterStub</code> | <span class="naming-census-name-list"><code>CharacterStubFinder</code></span> | 2026-03-02 |
| <code>Dptype</code> | <span class="naming-census-name-list"><code>DptypeFinder</code></span> | 2026-08-01 |
| <code>Keylogger</code> | <span class="naming-census-name-list"><code>KeyloggerFinder</code></span> | 2026-08-01 |
| <code>Language</code> | <span class="naming-census-name-list"><code>LanguageFinder</code></span> | 2026-08-01 |
| <code>LobbyBridge</code> | <span class="naming-census-name-list"><code>LobbyBridgeFinder</code></span> | 2025-03-11 |
| <code>Room</code> | <span class="naming-census-name-list"><code>RoomFinder</code></span> | 2026-08-01 |
| <code>Savefile</code> | <span class="naming-census-name-list"><code>SavefileFinder</code></span> | 2025-08-01 |
| <code>StageNext</code> | <span class="naming-census-name-list"><code>StageNextSyncer</code></span> | 2025-02-24 |
{:.naming-census-table}

### 과거 후보

| 실제 이름 축 | 관찰된 정확한 선언 이름 | 마지막 관찰일 |
| --- | --- | ---: |
| <code>Alert</code> | <span class="naming-census-name-list"><code>AlertFinder</code></span> | 2022-12-28 |
| <code>BaseDeploy</code> | <span class="naming-census-name-list"><code>BaseDeploySyncer</code></span> | 2024-05-04 |
| <code>BaseRedeploy</code> | <span class="naming-census-name-list"><code>BaseRedeploySyncer</code></span> | 2024-05-04 |
| <code>BaseRemove</code> | <span class="naming-census-name-list"><code>BaseRemoveSyncer</code></span> | 2024-05-04 |
| <code>CrewAdd</code> | <span class="naming-census-name-list"><code>CrewAddSyncer</code></span> | 2024-05-04 |
| <code>CrewRemove</code> | <span class="naming-census-name-list"><code>CrewRemoveSyncer</code></span> | 2024-05-04 |
| <code>EntityProvider</code> | <span class="naming-census-name-list"><code>EntityProviderFinder</code></span> | 2023-09-27 |
| <code>ExArchive</code> | <span class="naming-census-name-list"><code>ExArchiveFinder</code></span> | 2023-03-14 |
| <code>ExCaptain</code> | <span class="naming-census-name-list"><code>ExCaptainFinder</code></span> | 2023-09-26 |
| <code>ExGalaxy</code> | <span class="naming-census-name-list"><code>ExGalaxyFinder</code></span> | 2023-02-15 |
| <code>ExMap</code> | <span class="naming-census-name-list"><code>ExMapFinder</code></span> | 2022-12-10 |
| <code>ExModule</code> | <span class="naming-census-name-list"><code>ExModuleFinder</code></span> | 2022-12-10 |
| <code>ExPlanet</code> | <span class="naming-census-name-list"><code>ExPlanetFinder</code><code>ExPlanetFinderFromData</code></span> | 2023-11-19 |
| <code>ExQuest</code> | <span class="naming-census-name-list"><code>ExQuestFinder</code></span> | 2022-12-18 |
| <code>ExResource</code> | <span class="naming-census-name-list"><code>ExResourceFinder</code></span> | 2023-02-17 |
| <code>ExStat</code> | <span class="naming-census-name-list"><code>ExStatFinder</code></span> | 2023-03-23 |
| <code>ExTech</code> | <span class="naming-census-name-list"><code>ExTechFinder</code></span> | 2023-06-05 |
| <code>ExUnit</code> | <span class="naming-census-name-list"><code>ExUnitFinder</code></span> | 2022-12-10 |
| <code>ExUser</code> | <span class="naming-census-name-list"><code>ExUserFinder</code></span> | 2023-09-26 |
| <code>ExWave</code> | <span class="naming-census-name-list"><code>ExWaveFinder</code></span> | 2023-01-13 |
| <code>FacilityDeploy</code> | <span class="naming-census-name-list"><code>FacilityDeploySyncer</code></span> | 2024-05-04 |
| <code>FacilityRedeploy</code> | <span class="naming-census-name-list"><code>FacilityRedeploySyncer</code></span> | 2024-05-04 |
| <code>Gift</code> | <span class="naming-census-name-list"><code>GiftFinder</code></span> | 2023-10-13 |
| <code>InfoboxInterface</code> | <span class="naming-census-name-list"><code>InfoboxInterfaceFinder</code></span> | 2023-09-06 |
| <code>Ingredient</code> | <span class="naming-census-name-list"><code>IngredientFinder</code></span> | 2022-11-09 |
| <code>InputActionWrapper</code> | <span class="naming-census-name-list"><code>InputActionWrapperFinder</code></span> | 2022-09-29 |
| <code>Integer</code> | <span class="naming-census-name-list"><code>IntegerFinder</code></span> | 2022-09-29 |
| <code>Kind</code> | <span class="naming-census-name-list"><code>KindFinder</code></span> | 2022-12-22 |
| <code>Message</code> | <span class="naming-census-name-list"><code>MessageFinder</code></span> | 2022-11-24 |
| <code>Missile</code> | <span class="naming-census-name-list"><code>MissileFinder</code></span> | 2022-11-25 |
| <code>ModelInterface</code> | <span class="naming-census-name-list"><code>ModelInterfaceFinder</code></span> | 2022-12-06 |
| <code>NetPlayerInterface</code> | <span class="naming-census-name-list"><code>NetPlayerInterfaceFinder</code></span> | 2023-10-31 |
| <code>NetRoomInterface</code> | <span class="naming-census-name-list"><code>NetRoomInterfaceFinder</code></span> | 2023-10-31 |
| <code>ObjectiveInterface</code> | <span class="naming-census-name-list"><code>ObjectiveInterfaceFinder</code></span> | 2024-03-09 |
| <code>ObjectiveInterfaceEx</code> | <span class="naming-census-name-list"><code>ObjectiveInterfaceExFinder</code></span> | 2024-03-09 |
| <code>OrderInterface</code> | <span class="naming-census-name-list"><code>OrderInterfaceFinder</code></span> | 2023-01-14 |
| <code>Product</code> | <span class="naming-census-name-list"><code>ProductFinder</code></span> | 2022-11-10 |
| <code>QuestAdd</code> | <span class="naming-census-name-list"><code>QuestAddSyncer</code></span> | 2024-05-04 |
| <code>QuestRemove</code> | <span class="naming-census-name-list"><code>QuestRemoveSyncer</code></span> | 2024-05-04 |
| <code>Reward</code> | <span class="naming-census-name-list"><code>RewardFinder</code></span> | 2023-10-10 |
| <code>ServerMain</code> | <span class="naming-census-name-list"><code>ServerMainFinder</code></span> | 2022-10-01 |
| <code>StrategyPing</code> | <span class="naming-census-name-list"><code>StrategyPingSyncer</code></span> | 2024-05-04 |
| <code>String</code> | <span class="naming-census-name-list"><code>StringFinder</code></span> | 2022-11-23 |
| <code>Stuff</code> | <span class="naming-census-name-list"><code>StuffFinder</code></span> | 2023-10-11 |
| <code>UserAssocKeeper</code> | <span class="naming-census-name-list"><code>UserAssocKeeperFinder</code></span> | 2023-11-19 |
{:.naming-census-table}

## 과거 Entity 이름 {#entity-legacy}

최근 2년 안에 의미 있는 사용 근거가 확인되지 않은 실제 도메인 축이다. 최근 축과 섞지 않되, 현재 이름을 개선할 때 계보와 충돌을 확인할 수 있도록 정확한 선언을 보관한다.

| 실제 이름 축 | 관찰된 정확한 선언 이름 | 마지막 관찰일 |
| --- | --- | ---: |
| <code>Academy</code> | <span class="naming-census-name-list"><code>Academy</code><code>AcademyDataRecord</code></span> | 2020-07-17 |
| <code>Achievement</code> | <span class="naming-census-name-list"><code>AchievementData</code><code>AchievementDataCache</code><code>AchievementDataEqualityComparer</code></span> | 2022-07-06 |
| <code>Action</code> | <span class="naming-census-name-list"><code>ActionData</code><code>ActionDataCache</code><code>ActionDataEqualityComparer</code><code>ActionEntity</code><code>ActionKeysParser</code></span> | 2022-07-14 |
| <code>ActionEntity</code> | <span class="naming-census-name-list"><code>ActionEntityDataServerInstance</code><code>ActionEntityDataServerInstanceManager</code><code>ActionEntityManager</code><code>ActionEntityRecord</code></span> | 날짜 불명 |
| <code>ActionJournal</code> | <span class="naming-census-name-list"><code>ActionJournal</code><code>ActionJournalDataRecord</code></span> | 2020-08-20 |
| <code>ActionPoint</code> | <span class="naming-census-name-list"><code>ActionPoint</code><code>ActionPointDataRecord</code></span> | 2020-08-20 |
| <code>Alliance</code> | <span class="naming-census-name-list"><code>Alliance</code><code>AllianceDataRecord</code></span> | 2021-02-22 |
| <code>AllianceBoxNormalReceive</code> | <span class="naming-census-name-list"><code>AllianceBoxNormalReceive</code></span> | 2021-01-13 |
| <code>AllianceBoxPoint</code> | <span class="naming-census-name-list"><code>AllianceBoxPoint</code><code>AllianceBoxPointDataRecord</code></span> | 2021-01-22 |
| <code>AllianceBoxPremium</code> | <span class="naming-census-name-list"><code>AllianceBoxPremium</code></span> | 2021-02-08 |
| <code>AllianceBoxPremiumReceive</code> | <span class="naming-census-name-list"><code>AllianceBoxPremiumReceive</code></span> | 2021-01-13 |
| <code>AllianceBoxPresentReceive</code> | <span class="naming-census-name-list"><code>AllianceBoxPresentReceive</code><code>AllianceBoxPresentReceiveDataRecord</code></span> | 2021-01-13 |
| <code>AllianceBoxReceive</code> | <span class="naming-census-name-list"><code>AllianceBoxReceiveDataRecord</code></span> | 2021-01-13 |
| <code>AllianceBuilding</code> | <span class="naming-census-name-list"><code>AllianceBuilding</code><code>AllianceBuildingDataRecord</code></span> | 2020-12-26 |
| <code>AllianceDonationExpRank</code> | <span class="naming-census-name-list"><code>AllianceDonationExpRank</code></span> | 2020-07-27 |
| <code>AllianceEvent</code> | <span class="naming-census-name-list"><code>AllianceEvent</code><code>AllianceEventDataRecord</code></span> | 2020-10-07 |
| <code>AllianceInvitation</code> | <span class="naming-census-name-list"><code>AllianceInvitation</code><code>AllianceInvitationDataRecord</code></span> | 2020-10-07 |
| <code>AllianceKillCountRank</code> | <span class="naming-census-name-list"><code>AllianceKillCountRank</code></span> | 2021-02-02 |
| <code>AllianceMark</code> | <span class="naming-census-name-list"><code>AllianceMark</code><code>AllianceMarkDataRecord</code></span> | 2020-07-08 |
| <code>AllianceMember</code> | <span class="naming-census-name-list"><code>AllianceMember</code><code>AllianceMemberDataRecord</code></span> | 2021-01-14 |
| <code>AllianceNotice</code> | <span class="naming-census-name-list"><code>AllianceNotice</code><code>AllianceNoticeDataRecord</code></span> | 2021-02-24 |
| <code>AlliancePoints</code> | <span class="naming-census-name-list"><code>AlliancePoints</code></span> | 2020-12-25 |
| <code>AlliancePowerRank</code> | <span class="naming-census-name-list"><code>AlliancePowerRank</code></span> | 2021-02-02 |
| <code>AllianceRank</code> | <span class="naming-census-name-list"><code>AllianceRankDataRecord</code></span> | 2020-08-05 |
| <code>AllianceRecord</code> | <span class="naming-census-name-list"><code>AllianceRecord</code><code>AllianceRecordDataRecord</code></span> | 2020-08-31 |
| <code>AllianceShopHistory</code> | <span class="naming-census-name-list"><code>AllianceShopHistory</code></span> | 2020-10-07 |
| <code>AllianceShopStock</code> | <span class="naming-census-name-list"><code>AllianceShopStockDataRecord</code></span> | 2020-10-08 |
| <code>AllianceTimerHelp</code> | <span class="naming-census-name-list"><code>AllianceTimerHelp</code><code>AllianceTimerHelpDataRecord</code></span> | 2020-11-18 |
| <code>Answer</code> | <span class="naming-census-name-list"><code>AnswerKeeper</code><code>AnswerSecret</code></span> | 날짜 불명 |
| <code>Arsenal</code> | <span class="naming-census-name-list"><code>Arsenal</code><code>ArsenalData</code><code>ArsenalDataCache</code><code>ArsenalDataEqualityComparer</code><code>ArsenalFinder</code><code>ArsenalIdHolder</code><code>ArsenalManager</code><code>ArsenalRecord</code><code>ArsenalStatCenter</code><code>ArsenalStatHolder</code><code>ArsenalTeamCenter</code><code>ArsenalUserCenter</code></span> | 2022-09-02 |
| <code>Assoc</code> | <span class="naming-census-name-list"><code>AssocData</code><code>AssocDataCache</code><code>AssocFinder</code><code>AssocFinderFromKeeper</code></span> | 2023-11-28 |
| <code>BannedUser</code> | <span class="naming-census-name-list"><code>BannedUser</code><code>BannedUserDataRecord</code></span> | 2020-10-07 |
| <code>BarterStock</code> | <span class="naming-census-name-list"><code>BarterStockDataRecord</code></span> | 2020-10-14 |
| <code>BarterStockRecord</code> | <span class="naming-census-name-list"><code>BarterStockRecord</code></span> | 2020-09-29 |
| <code>Battle</code> | <span class="naming-census-name-list"><code>Battle</code><code>BattleDataRecord</code></span> | 2020-08-20 |
| <code>BattlePower</code> | <span class="naming-census-name-list"><code>BattlePowerRecord</code></span> | 2020-01-23 |
| <code>BattleResult</code> | <span class="naming-census-name-list"><code>BattleResult</code><code>BattleResultDataRecord</code></span> | 2020-08-20 |
| <code>BattleResultHero</code> | <span class="naming-census-name-list"><code>BattleResultHeroDataRecord</code></span> | 2020-01-23 |
| <code>BattleRoom</code> | <span class="naming-census-name-list"><code>BattleRoomDataServerInstance</code></span> | 날짜 불명 |
| <code>BlackBlade</code> | <span class="naming-census-name-list"><code>BlackBladeObjective</code></span> | 2024-03-23 |
| <code>Blacksmith</code> | <span class="naming-census-name-list"><code>Blacksmith</code><code>BlacksmithDataRecord</code></span> | 2020-07-31 |
| <code>BlockList</code> | <span class="naming-census-name-list"><code>BlockListDataServerInstance</code><code>BlockListDataServerInstanceManager</code></span> | 날짜 불명 |
| <code>Blueprint</code> | <span class="naming-census-name-list"><code>Blueprint</code><code>BlueprintData</code><code>BlueprintDataCache</code><code>BlueprintDataEqualityComparer</code><code>BlueprintFinder</code><code>BlueprintIdHolder</code><code>BlueprintManager</code><code>BlueprintRecord</code><code>BlueprintResultDefineParser</code><code>BlueprintStatCenter</code><code>BlueprintStatHolder</code><code>BlueprintTeamCenter</code><code>BlueprintUserCenter</code></span> | 2022-07-19 |
| <code>Bookmark</code> | <span class="naming-census-name-list"><code>Bookmark</code></span> | 2020-08-20 |
| <code>BookmarkPage</code> | <span class="naming-census-name-list"><code>BookmarkPageRecord</code></span> | 2020-11-10 |
| <code>BookmarkRow</code> | <span class="naming-census-name-list"><code>BookmarkRowRecord</code></span> | 2020-03-04 |
| <code>BossMonsterA</code> | <span class="naming-census-name-list"><code>BossMonsterA</code><code>BossMonsterADataRecord</code></span> | 2020-12-26 |
| <code>BossMonsterAMinion</code> | <span class="naming-census-name-list"><code>BossMonsterAMinion</code><code>BossMonsterAMinionDataRecord</code></span> | 2020-07-31 |
| <code>Building</code> | <span class="naming-census-name-list"><code>Building</code><code>BuildingDataRecord</code><code>BuildingTags</code><code>BuildingTagsParser</code></span> | 2022-07-21 |
| <code>Camp</code> | <span class="naming-census-name-list"><code>Camp</code><code>CampData</code><code>CampDataCache</code><code>CampDataEqualityComparer</code><code>CampFinder</code><code>CampIdHolder</code><code>CampManager</code><code>CampMapCenter</code><code>CampMissionCenter</code><code>CampRecord</code><code>CampStatCenter</code><code>CampStatHolder</code><code>CampTeamCenter</code><code>CampUserCenter</code><code>CampWaveCenter</code></span> | 2022-09-07 |
| <code>Captain</code> | <span class="naming-census-name-list"><code>CaptainData</code><code>CaptainDataCache</code></span> | 2023-10-11 |
| <code>Card</code> | <span class="naming-census-name-list"><code>Card</code><code>CardCache</code><code>CardFinder</code><code>CardPack</code></span> | 2022-08-25 |
| <code>Castle</code> | <span class="naming-census-name-list"><code>Castle</code><code>CastleDataRecord</code></span> | 2020-11-20 |
| <code>CastleBuffStackableInformation</code> | <span class="naming-census-name-list"><code>CastleBuffStackableInformation</code><code>CastleBuffStackableInformationDataRecord</code></span> | 2020-09-08 |
| <code>CharacterActionEntity</code> | <span class="naming-census-name-list"><code>CharacterActionEntityCenter</code></span> | 날짜 불명 |
| <code>CharacterBuff</code> | <span class="naming-census-name-list"><code>CharacterBuffCenter</code></span> | 날짜 불명 |
| <code>CharacterCounter</code> | <span class="naming-census-name-list"><code>CharacterCounterCenter</code></span> | 2018-06-06 |
| <code>CharacterDeliveryQuest</code> | <span class="naming-census-name-list"><code>CharacterDeliveryQuestCenter</code></span> | 2018-07-07 |
| <code>CharacterGame</code> | <span class="naming-census-name-list"><code>CharacterGameData</code></span> | 날짜 불명 |
| <code>CharacterItemSlot</code> | <span class="naming-census-name-list"><code>CharacterItemSlotCenter</code></span> | 날짜 불명 |
| <code>CharacterQuest</code> | <span class="naming-census-name-list"><code>CharacterQuestCenter</code></span> | 날짜 불명 |
| <code>CharacterRecipe</code> | <span class="naming-census-name-list"><code>CharacterRecipeCenter</code></span> | 2018-11-10 |
| <code>CharacterResearch</code> | <span class="naming-census-name-list"><code>CharacterResearchCenter</code></span> | 2018-03-02 |
| <code>CharacterReward</code> | <span class="naming-census-name-list"><code>CharacterRewardCenter</code></span> | 날짜 불명 |
| <code>CharacterScene</code> | <span class="naming-census-name-list"><code>CharacterSceneCenter</code></span> | 날짜 불명 |
| <code>CharacterSceneClearCount</code> | <span class="naming-census-name-list"><code>CharacterSceneClearCountCenter</code></span> | 날짜 불명 |
| <code>CharacterServant</code> | <span class="naming-census-name-list"><code>CharacterServantCenter</code></span> | 2018-07-15 |
| <code>CharacterSkillPage</code> | <span class="naming-census-name-list"><code>CharacterSkillPageCenter</code></span> | 날짜 불명 |
| <code>Chat</code> | <span class="naming-census-name-list"><code>ChatDataRecord</code></span> | 2020-02-10 |
| <code>ChatMember</code> | <span class="naming-census-name-list"><code>ChatMember</code><code>ChatMemberDataRecord</code></span> | 2020-08-20 |
| <code>ChatMessage</code> | <span class="naming-census-name-list"><code>ChatMessage</code><code>ChatMessageDataRecord</code></span> | 2020-09-07 |
| <code>ChatRoom</code> | <span class="naming-census-name-list"><code>ChatRoom</code><code>ChatRoomDataRecord</code></span> | 2020-08-20 |
| <code>Collider</code> | <span class="naming-census-name-list"><code>ColliderEntity</code></span> | 날짜 불명 |
| <code>CombatSquad</code> | <span class="naming-census-name-list"><code>CombatSquad</code><code>CombatSquadDataRecord</code></span> | 2020-08-20 |
| <code>ConstructionWorker</code> | <span class="naming-census-name-list"><code>ConstructionWorker</code><code>ConstructionWorkerDataRecord</code></span> | 2020-08-24 |
| <code>Contract</code> | <span class="naming-census-name-list"><code>Contract</code><code>ContractFinder</code><code>ContractManager</code><code>ContractRecord</code><code>ContractTargetCenter</code><code>ContractUserCenter</code></span> | 2022-07-01 |
| <code>Count</code> | <span class="naming-census-name-list"><code>Count</code><code>CountKeys</code><code>CountManager</code><code>CountRecord</code></span> | 2022-07-01 |
| <code>Counter</code> | <span class="naming-census-name-list"><code>Counter</code><code>CounterManager</code></span> | 2018-11-11 |
| <code>CurrentUnit</code> | <span class="naming-census-name-list"><code>CurrentUnitData</code></span> | 날짜 불명 |
| <code>DailyClaim</code> | <span class="naming-census-name-list"><code>DailyClaim</code><code>DailyClaimDataRecord</code></span> | 2020-10-12 |
| <code>DailyQuest</code> | <span class="naming-census-name-list"><code>DailyQuest</code><code>DailyQuestDataRecord</code></span> | 2020-07-31 |
| <code>Damage</code> | <span class="naming-census-name-list"><code>Damage</code><code>DamageFinder</code><code>DamageManager</code><code>DamageRecord</code></span> | 2022-07-01 |
| <code>DefenseQuest</code> | <span class="naming-census-name-list"><code>DefenseQuest</code><code>DefenseQuestDataRecord</code><code>DefenseQuestManager</code></span> | 2019-01-10 |
| <code>DeliveryQuest</code> | <span class="naming-census-name-list"><code>DeliveryQuest</code><code>DeliveryQuestDataRecord</code><code>DeliveryQuestManager</code></span> | 2019-01-10 |
| <code>Dialog</code> | <span class="naming-census-name-list"><code>DialogData</code><code>DialogDataCache</code><code>DialogDataEqualityComparer</code><code>DialogFinder</code></span> | 2023-04-13 |
| <code>Difficulty</code> | <span class="naming-census-name-list"><code>DifficultyType</code></span> | 2022-02-23 |
| <code>Division</code> | <span class="naming-census-name-list"><code>Division</code><code>DivisionDataRecord</code></span> | 2020-11-10 |
| <code>DreamTower</code> | <span class="naming-census-name-list"><code>DreamTowerObjective</code></span> | 2024-03-23 |
| <code>ExtraSolidium</code> | <span class="naming-census-name-list"><code>ExtraSolidiumObjective</code></span> | 2024-03-23 |
| <code>ExtraUranium</code> | <span class="naming-census-name-list"><code>ExtraUraniumObjective</code></span> | 2024-03-23 |
| <code>Festival</code> | <span class="naming-census-name-list"><code>Festival</code><code>FestivalDataRecord</code></span> | 2020-10-08 |
| <code>Festival1PartialRank</code> | <span class="naming-census-name-list"><code>Festival1PartialRank</code></span> | 2020-07-08 |
| <code>Festival1Rank</code> | <span class="naming-census-name-list"><code>Festival1Rank</code></span> | 2020-07-09 |
| <code>FieldStart</code> | <span class="naming-census-name-list"><code>FieldStartData</code></span> | 날짜 불명 |
| <code>FieldState</code> | <span class="naming-census-name-list"><code>FieldStateData</code></span> | 날짜 불명 |
| <code>FieldUnit</code> | <span class="naming-census-name-list"><code>FieldUnitData</code></span> | 날짜 불명 |
| <code>Friend</code> | <span class="naming-census-name-list"><code>Friend</code><code>FriendDataRecord</code></span> | 2020-10-26 |
| <code>Galaxy</code> | <span class="naming-census-name-list"><code>GalaxyData</code><code>GalaxyDataCache</code></span> | 2023-09-25 |
| <code>GameServerInstance</code> | <span class="naming-census-name-list"><code>GameServerInstanceManager</code></span> | 날짜 불명 |
| <code>Gem</code> | <span class="naming-census-name-list"><code>Gem</code><code>GemDataRecord</code></span> | 2020-07-31 |
| <code>GemRecipe</code> | <span class="naming-census-name-list"><code>GemRecipe</code><code>GemRecipeDataRecord</code></span> | 2020-10-08 |
| <code>GlobalEnvironment</code> | <span class="naming-census-name-list"><code>GlobalEnvironmentKeeper</code></span> | 2023-11-19 |
| <code>GlobalKey</code> | <span class="naming-census-name-list"><code>GlobalKeyKeeper</code></span> | 2023-11-19 |
| <code>GlobalSettings</code> | <span class="naming-census-name-list"><code>GlobalSettingsKeeper</code></span> | 2024-04-05 |
| <code>GlobalUser</code> | <span class="naming-census-name-list"><code>GlobalUserKeeper</code></span> | 2024-05-02 |
| <code>GoldPass</code> | <span class="naming-census-name-list"><code>GoldPass</code><code>GoldPassDataRecord</code></span> | 2020-10-08 |
| <code>Goods</code> | <span class="naming-census-name-list"><code>GoodsData</code><code>GoodsDataCache</code><code>GoodsDataServerInstance</code><code>GoodsDataServerInstanceManager</code><code>GoodsManager</code><code>GoodsRecord</code></span> | 날짜 불명 |
| <code>Guardian</code> | <span class="naming-census-name-list"><code>Guardian</code><code>GuardianDataRecord</code></span> | 2020-10-08 |
| <code>GuardianConsumedMaterials</code> | <span class="naming-census-name-list"><code>GuardianConsumedMaterials</code><code>GuardianConsumedMaterialsDataRecord</code></span> | 2020-08-20 |
| <code>GuardianLevelRank</code> | <span class="naming-census-name-list"><code>GuardianLevelRank</code></span> | 2020-07-08 |
| <code>GuardianSkill</code> | <span class="naming-census-name-list"><code>GuardianSkill</code><code>GuardianSkillDataRecord</code></span> | 2020-08-05 |
| <code>Hall</code> | <span class="naming-census-name-list"><code>Hall</code><code>HallData</code><code>HallDataCache</code><code>HallDataEqualityComparer</code><code>HallFinder</code><code>HallIdHolder</code><code>HallManager</code><code>HallRecord</code><code>HallStatCenter</code><code>HallStatHolder</code><code>HallTeamCenter</code><code>HallUserCenter</code></span> | 2022-07-19 |
| <code>HallOfGlory</code> | <span class="naming-census-name-list"><code>HallOfGloryDataRecord</code></span> | 2020-04-17 |
| <code>Hammerworks</code> | <span class="naming-census-name-list"><code>HammerworksObjective</code></span> | 2024-03-23 |
| <code>Hero</code> | <span class="naming-census-name-list"><code>Hero</code><code>HeroDataRecord</code></span> | 2020-09-18 |
| <code>HeroRoadChapter</code> | <span class="naming-census-name-list"><code>HeroRoadChapter</code><code>HeroRoadChapterDataRecord</code></span> | 2020-08-03 |
| <code>HeroRoadCurrentInfo</code> | <span class="naming-census-name-list"><code>HeroRoadCurrentInfo</code><code>HeroRoadCurrentInfoDataRecord</code></span> | 2020-08-03 |
| <code>HeroRoadStage</code> | <span class="naming-census-name-list"><code>HeroRoadStage</code><code>HeroRoadStageDataRecord</code></span> | 2020-09-18 |
| <code>HeroesGradeRank</code> | <span class="naming-census-name-list"><code>HeroesGradeRank</code></span> | 2020-07-08 |
| <code>Hospital</code> | <span class="naming-census-name-list"><code>Hospital</code><code>HospitalData</code><code>HospitalDataCache</code><code>HospitalDataEqualityComparer</code><code>HospitalFinder</code><code>HospitalIdHolder</code><code>HospitalManager</code><code>HospitalRecord</code><code>HospitalStatCenter</code><code>HospitalStatHolder</code><code>HospitalTeamCenter</code><code>HospitalUserCenter</code></span> | 2022-07-19 |
| <code>House</code> | <span class="naming-census-name-list"><code>House</code><code>HouseData</code><code>HouseDataCache</code><code>HouseDataEqualityComparer</code><code>HouseFinder</code><code>HouseIdHolder</code><code>HouseManager</code><code>HouseRecord</code><code>HouseStatCenter</code><code>HouseStatHolder</code><code>HouseTeamCenter</code><code>HouseUserCenter</code></span> | 2022-07-19 |
| <code>IServerInstance</code> | <span class="naming-census-name-list"><code>IServerInstanceManager</code></span> | 날짜 불명 |
| <code>Ingredient</code> | <span class="naming-census-name-list"><code>Ingredient</code><code>IngredientCache</code><code>IngredientDefinesParser</code><code>IngredientFinder</code><code>IngredientPack</code></span> | 2022-08-10 |
| <code>ItemEnchant</code> | <span class="naming-census-name-list"><code>ItemEnchantData</code><code>ItemEnchantDataCache</code></span> | 날짜 불명 |
| <code>ItemEnchantOption</code> | <span class="naming-census-name-list"><code>ItemEnchantOptionData</code><code>ItemEnchantOptionDataCache</code></span> | 날짜 불명 |
| <code>ItemPrice</code> | <span class="naming-census-name-list"><code>ItemPrice</code><code>ItemPriceDataRecord</code><code>ItemPriceManager</code></span> | 2018-06-13 |
| <code>ItemSlot</code> | <span class="naming-census-name-list"><code>ItemSlotData</code><code>ItemSlotDataRecord</code><code>ItemSlotDataServerInstance</code><code>ItemSlotDataServerInstanceManager</code><code>ItemSlotManager</code></span> | 날짜 불명 |
| <code>KillCountRank</code> | <span class="naming-census-name-list"><code>KillCountRank</code></span> | 2020-07-08 |
| <code>Landmark</code> | <span class="naming-census-name-list"><code>Landmark</code><code>LandmarkData</code><code>LandmarkDataCache</code><code>LandmarkDataEqualityComparer</code><code>LandmarkFinder</code><code>LandmarkIdHolder</code><code>LandmarkManager</code><code>LandmarkMissionCenter</code><code>LandmarkRecord</code><code>LandmarkStatCenter</code><code>LandmarkStatHolder</code><code>LandmarkTeamCenter</code><code>LandmarkUserCenter</code></span> | 2022-07-19 |
| <code>LocaleString</code> | <span class="naming-census-name-list"><code>LocaleStringTable</code></span> | 2022-10-11 |
| <code>Location</code> | <span class="naming-census-name-list"><code>Location</code></span> | 2020-12-28 |
| <code>LocationCandidateGroup1</code> | <span class="naming-census-name-list"><code>LocationCandidateGroup1</code></span> | 2021-01-13 |
| <code>LoginInfo</code> | <span class="naming-census-name-list"><code>LoginInfoDataRecord</code></span> | 2020-04-14 |
| <code>Lord</code> | <span class="naming-census-name-list"><code>Lord</code><code>LordDataRecord</code></span> | 2020-10-23 |
| <code>LordGearAbility</code> | <span class="naming-census-name-list"><code>LordGearAbilityDataRecord</code></span> | 2020-01-23 |
| <code>LordGearPreset</code> | <span class="naming-census-name-list"><code>LordGearPreset</code><code>LordGearPresetDataRecord</code></span> | 2020-11-10 |
| <code>LordGearRecipeHistory</code> | <span class="naming-census-name-list"><code>LordGearRecipeHistory</code></span> | 2020-08-04 |
| <code>LordLevelRank</code> | <span class="naming-census-name-list"><code>LordLevelRank</code></span> | 2020-07-08 |
| <code>LordSkill</code> | <span class="naming-census-name-list"><code>LordSkill</code><code>LordSkillDataRecord</code></span> | 2020-10-13 |
| <code>LordTalent</code> | <span class="naming-census-name-list"><code>LordTalent</code><code>LordTalentDataRecord</code></span> | 2020-08-04 |
| <code>LordTalentPage</code> | <span class="naming-census-name-list"><code>LordTalentPage</code><code>LordTalentPageDataRecord</code></span> | 2020-07-16 |
| <code>LossCondition</code> | <span class="naming-census-name-list"><code>LossConditionType</code></span> | 2022-01-11 |
| <code>MadMan</code> | <span class="naming-census-name-list"><code>MadManObjective</code></span> | 2024-03-23 |
| <code>MailHeader</code> | <span class="naming-census-name-list"><code>MailHeaderData</code></span> | 날짜 불명 |
| <code>MainQuest</code> | <span class="naming-census-name-list"><code>MainQuest</code><code>MainQuestDataRecord</code></span> | 2020-08-04 |
| <code>MainSolidium</code> | <span class="naming-census-name-list"><code>MainSolidiumObjective</code></span> | 2024-04-07 |
| <code>MainUranium</code> | <span class="naming-census-name-list"><code>MainUraniumObjective</code></span> | 2024-03-23 |
| <code>Market</code> | <span class="naming-census-name-list"><code>Market</code><code>MarketContractCenter</code><code>MarketData</code><code>MarketDataCache</code><code>MarketDataEqualityComparer</code><code>MarketFinder</code><code>MarketIdHolder</code><code>MarketManager</code><code>MarketRecord</code><code>MarketStatCenter</code><code>MarketStatHolder</code><code>MarketTeamCenter</code><code>MarketUserCenter</code></span> | 2022-07-19 |
| <code>Message</code> | <span class="naming-census-name-list"><code>Message</code><code>MessageDataRecord</code><code>MessageManager</code></span> | 2018-11-25 |
| <code>Mill</code> | <span class="naming-census-name-list"><code>Mill</code><code>MillData</code><code>MillDataCache</code><code>MillDataEqualityComparer</code><code>MillFinder</code><code>MillIdHolder</code><code>MillManager</code><code>MillRecord</code><code>MillResourceCenter</code><code>MillStatCenter</code><code>MillStatHolder</code><code>MillTeamCenter</code><code>MillTechCenter</code><code>MillUnitCenter</code><code>MillUserCenter</code></span> | 2022-08-20 |
| <code>Mission</code> | <span class="naming-census-name-list"><code>Mission</code><code>MissionCampCenter</code><code>MissionCategoryType</code><code>MissionData</code><code>MissionDataCache</code><code>MissionDataEqualityComparer</code><code>MissionFinder</code><code>MissionLandmarkCenter</code><code>MissionManager</code><code>MissionMapCenter</code><code>MissionRecord</code><code>MissionSquadCenter</code><code>MissionTroopCenter</code></span> | 2022-08-30 |
| <code>MonsterSquad</code> | <span class="naming-census-name-list"><code>MonsterSquad</code><code>MonsterSquadDataRecord</code></span> | 2020-08-04 |
| <code>MovableBuilding</code> | <span class="naming-census-name-list"><code>MovableBuildingDataRecord</code></span> | 2019-11-06 |
| <code>MovableBuildingSlot</code> | <span class="naming-census-name-list"><code>MovableBuildingSlotDataRecord</code></span> | 2019-11-14 |
| <code>MovableBuildingSlotGroup</code> | <span class="naming-census-name-list"><code>MovableBuildingSlotGroup</code><code>MovableBuildingSlotGroupDataRecord</code></span> | 2020-10-08 |
| <code>MovableHealingWard</code> | <span class="naming-census-name-list"><code>MovableHealingWard</code><code>MovableHealingWardDataRecord</code></span> | 2020-10-08 |
| <code>MovableMilitaryCamp</code> | <span class="naming-census-name-list"><code>MovableMilitaryCamp</code><code>MovableMilitaryCampDataRecord</code></span> | 2020-10-08 |
| <code>MovableResource</code> | <span class="naming-census-name-list"><code>MovableResource</code><code>MovableResourceDataRecord</code></span> | 2020-10-08 |
| <code>MuzzlePoint</code> | <span class="naming-census-name-list"><code>MuzzlePointType</code></span> | 2022-07-12 |
| <code>PartyMember</code> | <span class="naming-census-name-list"><code>PartyMember</code><code>PartyMemberDataRecord</code></span> | 2020-10-12 |
| <code>Path</code> | <span class="naming-census-name-list"><code>PathType</code></span> | 2022-06-09 |
| <code>Planet</code> | <span class="naming-census-name-list"><code>PlanetData</code><code>PlanetDataCache</code></span> | 2024-03-23 |
| <code>Pocket</code> | <span class="naming-census-name-list"><code>Pocket</code><code>PocketManager</code><code>PocketRecord</code><code>PocketStatCenter</code></span> | 2022-07-19 |
| <code>Point</code> | <span class="naming-census-name-list"><code>Point</code><code>PointDataRecord</code></span> | 2020-07-17 |
| <code>PointFestivalPartialRank</code> | <span class="naming-census-name-list"><code>PointFestivalPartialRank</code></span> | 2020-07-08 |
| <code>Power</code> | <span class="naming-census-name-list"><code>Power</code><code>PowerDataRecord</code></span> | 2021-01-19 |
| <code>PowerHistory</code> | <span class="naming-census-name-list"><code>PowerHistory</code><code>PowerHistoryDataRecord</code></span> | 2020-08-20 |
| <code>PowerRank</code> | <span class="naming-census-name-list"><code>PowerRank</code></span> | 2020-07-08 |
| <code>PresetEntryPage</code> | <span class="naming-census-name-list"><code>PresetEntryPageRecord</code></span> | 2020-01-23 |
| <code>PresetEntryRow</code> | <span class="naming-census-name-list"><code>PresetEntryRowRecord</code></span> | 2020-01-23 |
| <code>Price</code> | <span class="naming-census-name-list"><code>Price</code><code>PriceManager</code><code>PriceMapCenter</code><code>PriceRecord</code></span> | 2022-07-01 |
| <code>Pub</code> | <span class="naming-census-name-list"><code>Pub</code><code>PubDataRecord</code></span> | 2021-01-30 |
| <code>QuestReward</code> | <span class="naming-census-name-list"><code>QuestRewardDataRecord</code></span> | 날짜 불명 |
| <code>Rally</code> | <span class="naming-census-name-list"><code>Rally</code><code>RallyDataRecord</code></span> | 2020-10-05 |
| <code>Rampart</code> | <span class="naming-census-name-list"><code>Rampart</code><code>RampartDataRecord</code></span> | 2020-07-08 |
| <code>Rank</code> | <span class="naming-census-name-list"><code>RankDataRecord</code></span> | 2021-03-03 |
| <code>Recipe</code> | <span class="naming-census-name-list"><code>Recipe</code><code>RecipeData</code><code>RecipeDataCache</code><code>RecipeDataEqualityComparer</code><code>RecipeDataRecord</code><code>RecipeFinder</code><code>RecipeKeysParser</code><code>RecipeManager</code><code>RecipeProductFinder</code><code>RecipeRecord</code><code>RecipeStatFinder</code><code>RecipeUserCenter</code></span> | 2022-07-06 |
| <code>RecipeLevel</code> | <span class="naming-census-name-list"><code>RecipeLevel</code><code>RecipeLevelDataRecord</code><code>RecipeLevelManager</code></span> | 2018-06-09 |
| <code>Repair</code> | <span class="naming-census-name-list"><code>Repair</code><code>RepairDataRecord</code><code>RepairManager</code></span> | 2019-01-10 |
| <code>Research</code> | <span class="naming-census-name-list"><code>Research</code><code>ResearchDataRecord</code><code>ResearchManager</code></span> | 2019-01-10 |
| <code>ResearchCategory</code> | <span class="naming-census-name-list"><code>ResearchCategory</code><code>ResearchCategoryDataRecord</code></span> | 2020-10-12 |
| <code>ResearchSkill</code> | <span class="naming-census-name-list"><code>ResearchSkill</code><code>ResearchSkillDataRecord</code></span> | 2020-10-12 |
| <code>Reward</code> | <span class="naming-census-name-list"><code>Reward</code><code>RewardData</code><code>RewardDataCache</code><code>RewardDataRecord</code><code>RewardDataServerInstance</code><code>RewardDefinesParser</code><code>RewardFinder</code><code>RewardManager</code></span> | 2022-09-02 |
| <code>RewardBucket</code> | <span class="naming-census-name-list"><code>RewardBucketData</code><code>RewardBucketDataRecord</code></span> | 날짜 불명 |
| <code>RewardFlag</code> | <span class="naming-census-name-list"><code>RewardFlag</code><code>RewardFlagDataRecord</code></span> | 2021-01-25 |
| <code>RewardItem</code> | <span class="naming-census-name-list"><code>RewardItemRecord</code></span> | 날짜 불명 |
| <code>RewardItemValueLevel</code> | <span class="naming-census-name-list"><code>RewardItemValueLevelData</code><code>RewardItemValueLevelDataCache</code></span> | 날짜 불명 |
| <code>SceneRewardLevel</code> | <span class="naming-census-name-list"><code>SceneRewardLevelData</code><code>SceneRewardLevelDataCache</code></span> | 날짜 불명 |
| <code>SceneRewardLevelWeight</code> | <span class="naming-census-name-list"><code>SceneRewardLevelWeightData</code><code>SceneRewardLevelWeightDataCache</code></span> | 날짜 불명 |
| <code>ScheduledTask</code> | <span class="naming-census-name-list"><code>ScheduledTask</code><code>ScheduledTaskManager</code></span> | 2017-10-11 |
| <code>SecretOperationInformation</code> | <span class="naming-census-name-list"><code>SecretOperationInformation</code><code>SecretOperationInformationDataRecord</code></span> | 2021-01-08 |
| <code>Section</code> | <span class="naming-census-name-list"><code>Section</code></span> | 2020-08-20 |
| <code>Servant</code> | <span class="naming-census-name-list"><code>Servant</code><code>ServantDataRecord</code><code>ServantEntity</code><code>ServantManager</code></span> | 2019-01-10 |
| <code>ServantCandidate</code> | <span class="naming-census-name-list"><code>ServantCandidateDataRecord</code></span> | 2018-07-05 |
| <code>ServerInstance</code> | <span class="naming-census-name-list"><code>ServerInstanceManager</code></span> | 날짜 불명 |
| <code>Shop</code> | <span class="naming-census-name-list"><code>ShopData</code><code>ShopDataCache</code><code>ShopManager</code></span> | 날짜 불명 |
| <code>SkillPage</code> | <span class="naming-census-name-list"><code>SkillPageDataServerInstance</code><code>SkillPageDataServerInstanceManager</code><code>SkillPageManager</code><code>SkillPageRecord</code></span> | 날짜 불명 |
| <code>SpawnInfo</code> | <span class="naming-census-name-list"><code>SpawnInfo</code></span> | 2020-11-20 |
| <code>Squad</code> | <span class="naming-census-name-list"><code>Squad</code><code>SquadFinder</code><code>SquadFinderFromUnit</code><code>SquadIdHolder</code><code>SquadManager</code><code>SquadRecord</code><code>SquadStatCenter</code><code>SquadTeamCenter</code><code>SquadTraceCenter</code><code>SquadUnitCenter</code><code>SquadUserCenter</code></span> | 2022-07-01 |
| <code>StarlightCollector</code> | <span class="naming-census-name-list"><code>StarlightCollectorObjective</code></span> | 2024-03-23 |
| <code>Statistics</code> | <span class="naming-census-name-list"><code>Statistics</code><code>StatisticsDataRecord</code></span> | 2020-08-20 |
| <code>Statistics2</code> | <span class="naming-census-name-list"><code>Statistics2</code></span> | 2021-03-08 |
| <code>Statistics3</code> | <span class="naming-census-name-list"><code>Statistics3</code></span> | 2021-03-08 |
| <code>SteamPack</code> | <span class="naming-census-name-list"><code>SteamPackData</code><code>SteamPackDataServerInstance</code><code>SteamPackManager</code></span> | 날짜 불명 |
| <code>SteamPackGroup</code> | <span class="naming-census-name-list"><code>SteamPackGroupData</code><code>SteamPackGroupDataCache</code></span> | 날짜 불명 |
| <code>Strike</code> | <span class="naming-census-name-list"><code>Strike</code><code>StrikeFinder</code><code>StrikeManager</code><code>StrikeOwnerCenter</code><code>StrikeRecord</code><code>StrikeStatHolder</code></span> | 2022-07-14 |
| <code>SubQuest</code> | <span class="naming-census-name-list"><code>SubQuest</code><code>SubQuestDataRecord</code></span> | 2020-10-12 |
| <code>Suspecter</code> | <span class="naming-census-name-list"><code>SuspecterManager</code></span> | 2017-10-06 |
| <code>Tactic</code> | <span class="naming-census-name-list"><code>Tactic</code><code>TacticData</code><code>TacticDataCache</code><code>TacticDataEqualityComparer</code><code>TacticFinder</code><code>TacticManager</code><code>TacticProductFinder</code><code>TacticRecord</code><code>TacticUserCenter</code></span> | 2022-08-12 |
| <code>TargetPriority</code> | <span class="naming-census-name-list"><code>TargetPriorityType</code></span> | 2022-06-14 |
| <code>Tech</code> | <span class="naming-census-name-list"><code>Tech</code><code>TechData</code><code>TechDataCache</code><code>TechDataEqualityComparer</code><code>TechFinder</code><code>TechKeys</code><code>TechManager</code><code>TechRecord</code><code>TechUserCenter</code></span> | 2023-06-08 |
| <code>TerraUniverse</code> | <span class="naming-census-name-list"><code>TerraUniverseObjective</code></span> | 2024-03-23 |
| <code>TheNetherGift</code> | <span class="naming-census-name-list"><code>TheNetherGiftObjective</code></span> | 2024-03-23 |
| <code>TheShadow</code> | <span class="naming-census-name-list"><code>TheShadowObjective</code></span> | 2024-03-23 |
| <code>TimeMachine</code> | <span class="naming-census-name-list"><code>TimeMachine</code><code>TimeMachineDataRecord</code><code>TimeMachineManager</code></span> | 2018-07-15 |
| <code>TodayTimerHelpHonorPoint</code> | <span class="naming-census-name-list"><code>TodayTimerHelpHonorPoint</code><code>TodayTimerHelpHonorPointDataRecord</code></span> | 2020-08-06 |
| <code>TradeShip</code> | <span class="naming-census-name-list"><code>TradeShip</code><code>TradeShipDataRecord</code></span> | 2021-01-21 |
| <code>TradingPost</code> | <span class="naming-census-name-list"><code>TradingPost</code><code>TradingPostDataRecord</code></span> | 2020-08-10 |
| <code>Treasure</code> | <span class="naming-census-name-list"><code>Treasure</code><code>TreasureDataRecord</code></span> | 2020-12-26 |
| <code>Treatment</code> | <span class="naming-census-name-list"><code>TreatmentRecord</code></span> | 2020-11-10 |
| <code>Troop</code> | <span class="naming-census-name-list"><code>Troop</code><code>TroopData</code><code>TroopDataAdapter</code><code>TroopDataAdapterCache</code><code>TroopDataCache</code><code>TroopDataEqualityComparer</code><code>TroopDataRecord</code><code>TroopDefinesParser</code></span> | 2023-04-12 |
| <code>UniqueAchievement</code> | <span class="naming-census-name-list"><code>UniqueAchievement</code><code>UniqueAchievementDataRecord</code></span> | 2020-10-12 |
| <code>UserArchive</code> | <span class="naming-census-name-list"><code>UserArchiveKeeper</code></span> | 2023-11-20 |
| <code>UserBase</code> | <span class="naming-census-name-list"><code>UserBaseKeeper</code></span> | 2023-11-19 |
| <code>UserBuff</code> | <span class="naming-census-name-list"><code>UserBuffCenter</code></span> | 날짜 불명 |
| <code>UserCrew</code> | <span class="naming-census-name-list"><code>UserCrewCenter</code></span> | 날짜 불명 |
| <code>UserGachaInformation</code> | <span class="naming-census-name-list"><code>UserGachaInformation</code><code>UserGachaInformationDataRecord</code></span> | 2021-01-04 |
| <code>UserGalaxy</code> | <span class="naming-census-name-list"><code>UserGalaxyKeeper</code></span> | 2023-11-19 |
| <code>UserGame</code> | <span class="naming-census-name-list"><code>UserGameData</code></span> | 날짜 불명 |
| <code>UserItem</code> | <span class="naming-census-name-list"><code>UserItemCenter</code></span> | 2018-07-29 |
| <code>UserMail</code> | <span class="naming-census-name-list"><code>UserMailCenter</code></span> | 날짜 불명 |
| <code>UserMailInformation</code> | <span class="naming-census-name-list"><code>UserMailInformation</code><code>UserMailInformationDataRecord</code></span> | 2021-02-24 |
| <code>UserNoticeMail</code> | <span class="naming-census-name-list"><code>UserNoticeMail</code></span> | 2020-11-04 |
| <code>UserNotification</code> | <span class="naming-census-name-list"><code>UserNotification</code><code>UserNotificationDataRecord</code></span> | 2020-08-14 |
| <code>UserPlayFlag</code> | <span class="naming-census-name-list"><code>UserPlayFlag</code><code>UserPlayFlagDataRecord</code></span> | 2020-11-10 |
| <code>UserProsperity</code> | <span class="naming-census-name-list"><code>UserProsperity</code><code>UserProsperityDataRecord</code></span> | 2020-08-06 |
| <code>UserQuest</code> | <span class="naming-census-name-list"><code>UserQuestCenter</code><code>UserQuestKeeper</code></span> | 2024-04-28 |
| <code>UserReward</code> | <span class="naming-census-name-list"><code>UserRewardCenter</code></span> | 날짜 불명 |
| <code>UserSalary</code> | <span class="naming-census-name-list"><code>UserSalary</code><code>UserSalaryDataRecord</code></span> | 2020-09-08 |
| <code>UserScene</code> | <span class="naming-census-name-list"><code>UserSceneCenter</code></span> | 날짜 불명 |
| <code>UserSection</code> | <span class="naming-census-name-list"><code>UserSection</code></span> | 2020-10-12 |
| <code>UserStatus</code> | <span class="naming-census-name-list"><code>UserStatusKeeper</code></span> | 2024-05-12 |
| <code>UserUnit</code> | <span class="naming-census-name-list"><code>UserUnitKeeper</code></span> | 2024-05-11 |
| <code>Vault</code> | <span class="naming-census-name-list"><code>Vault</code><code>VaultDataRecord</code></span> | 2020-10-12 |
| <code>VictoryCondition</code> | <span class="naming-census-name-list"><code>VictoryConditionType</code></span> | 2022-03-10 |
| <code>Voice</code> | <span class="naming-census-name-list"><code>VoiceCache</code><code>VoiceData</code><code>VoiceDataCache</code></span> | 2022-12-15 |
| <code>Warehouse</code> | <span class="naming-census-name-list"><code>WarehouseDataRecord</code></span> | 2020-04-17 |
| <code>Workshop</code> | <span class="naming-census-name-list"><code>Workshop</code><code>WorkshopData</code><code>WorkshopDataCache</code><code>WorkshopDataEqualityComparer</code><code>WorkshopFinder</code><code>WorkshopIdHolder</code><code>WorkshopManager</code><code>WorkshopRecipeCenter</code><code>WorkshopRecord</code><code>WorkshopStatCenter</code><code>WorkshopStatHolder</code><code>WorkshopTeamCenter</code><code>WorkshopUserCenter</code></span> | 2022-09-02 |
{:.naming-census-table}

## 과거 UI 이름 {#ui-legacy}

최근 기준을 통과하지 않은 UI 구조 축이다. 현재 규칙의 정답으로 취급하지 않고, 구조 토큰의 수렴과 경계 드리프트를 비교하기 위한 아카이브로 읽는다.

| 실제 이름 축 | 관찰된 정확한 선언 이름 | 마지막 관찰일 |
| --- | --- | ---: |
| <code>Academy</code> | <span class="naming-census-name-list"><code>AcademyMenu</code></span> | 2021-01-28 |
| <code>AccountLink</code> | <span class="naming-census-name-list"><code>AccountLinkPopup</code></span> | 2020-12-30 |
| <code>AccountList</code> | <span class="naming-census-name-list"><code>AccountListPopup</code></span> | 2021-03-03 |
| <code>Achievement</code> | <span class="naming-census-name-list"><code>AchievementIcon</code></span> | 2020-07-31 |
| <code>AchievementRewardTooltip</code> | <span class="naming-census-name-list"><code>AchievementRewardTooltipEntry</code></span> | 2020-08-24 |
| <code>Action</code> | <span class="naming-census-name-list"><code>ActionButton</code><code>ActionEntity</code></span> | 날짜 불명 |
| <code>AddTroop</code> | <span class="naming-census-name-list"><code>AddTroopButton</code></span> | 2020-12-21 |
| <code>AgreementEu</code> | <span class="naming-census-name-list"><code>AgreementEuPopup</code></span> | 2021-02-04 |
| <code>Alliance</code> | <span class="naming-census-name-list"><code>AllianceIcon</code></span> | 2020-02-04 |
| <code>AllianceBox</code> | <span class="naming-census-name-list"><code>AllianceBoxEntry</code></span> | 2021-02-09 |
| <code>AllianceBoxPresentReward</code> | <span class="naming-census-name-list"><code>AllianceBoxPresentRewardPreview</code></span> | 2021-02-10 |
| <code>AllianceChatNotice</code> | <span class="naming-census-name-list"><code>AllianceChatNoticeEntry</code><code>AllianceChatNoticePopup</code></span> | 2021-03-05 |
| <code>AllianceDisband</code> | <span class="naming-census-name-list"><code>AllianceDisbandPopup</code></span> | 2020-09-23 |
| <code>AllianceHighMember</code> | <span class="naming-census-name-list"><code>AllianceHighMemberEntry</code></span> | 2020-12-16 |
| <code>AllianceInitial</code> | <span class="naming-census-name-list"><code>AllianceInitialPopup</code></span> | 2020-08-19 |
| <code>AllianceJoinApplicant</code> | <span class="naming-census-name-list"><code>AllianceJoinApplicantEntry</code></span> | 2020-05-04 |
| <code>AllianceJoinNotice</code> | <span class="naming-census-name-list"><code>AllianceJoinNoticePopup</code></span> | 2020-05-14 |
| <code>AllianceManagement</code> | <span class="naming-census-name-list"><code>AllianceManagementTab</code></span> | 2021-02-22 |
| <code>AllianceMarkSetting</code> | <span class="naming-census-name-list"><code>AllianceMarkSettingPopup</code></span> | 2020-07-13 |
| <code>AllianceMember</code> | <span class="naming-census-name-list"><code>AllianceMemberEntry</code><code>AllianceMemberPopup</code></span> | 2021-02-08 |
| <code>AllianceMemberGradeControl</code> | <span class="naming-census-name-list"><code>AllianceMemberGradeControlPopup</code></span> | 2020-09-16 |
| <code>AllianceNotice</code> | <span class="naming-census-name-list"><code>AllianceNoticePopup</code></span> | 2020-07-17 |
| <code>AlliancePointFestival</code> | <span class="naming-census-name-list"><code>AlliancePointFestivalPopup</code></span> | 2021-03-03 |
| <code>AllianceRank</code> | <span class="naming-census-name-list"><code>AllianceRankPopup</code></span> | 2021-02-03 |
| <code>AllianceRecord</code> | <span class="naming-census-name-list"><code>AllianceRecordEntry</code><code>AllianceRecordPopup</code></span> | 2021-02-19 |
| <code>AllianceReinforcementTroopByTierStatus</code> | <span class="naming-census-name-list"><code>AllianceReinforcementTroopByTierStatusWindow</code></span> | 2020-06-17 |
| <code>AllianceReinforcementTroopByTypeStatus</code> | <span class="naming-census-name-list"><code>AllianceReinforcementTroopByTypeStatusWindow</code></span> | 2020-06-17 |
| <code>AllianceResearch</code> | <span class="naming-census-name-list"><code>AllianceResearchEntry</code></span> | 2020-12-15 |
| <code>AllianceResearchCooperation</code> | <span class="naming-census-name-list"><code>AllianceResearchCooperationWindow</code></span> | 2020-11-16 |
| <code>AllianceResearchDonation</code> | <span class="naming-census-name-list"><code>AllianceResearchDonationPopup</code></span> | 2021-02-26 |
| <code>AllianceResearchGroup</code> | <span class="naming-census-name-list"><code>AllianceResearchGroupEntry</code></span> | 2020-11-16 |
| <code>AllianceResearchLocked</code> | <span class="naming-census-name-list"><code>AllianceResearchLockedPopup</code></span> | 2021-02-26 |
| <code>AllianceResearchMaster</code> | <span class="naming-census-name-list"><code>AllianceResearchMasterPopup</code></span> | 2021-02-26 |
| <code>AllianceResearchOptionInformation</code> | <span class="naming-census-name-list"><code>AllianceResearchOptionInformationEntry</code><code>AllianceResearchOptionInformationPopup</code></span> | 2020-06-26 |
| <code>AllianceResearchProgressing</code> | <span class="naming-census-name-list"><code>AllianceResearchProgressingPopup</code></span> | 2021-02-26 |
| <code>AllianceResearchRequest</code> | <span class="naming-census-name-list"><code>AllianceResearchRequestPopup</code></span> | 2021-02-26 |
| <code>AllianceResourceRequest</code> | <span class="naming-census-name-list"><code>AllianceResourceRequestPopup</code></span> | 2021-03-03 |
| <code>AllianceShop</code> | <span class="naming-census-name-list"><code>AllianceShopPopup</code></span> | 2020-10-17 |
| <code>AllianceShopPurchaseConfirm</code> | <span class="naming-census-name-list"><code>AllianceShopPurchaseConfirmPopup</code></span> | 2021-01-01 |
| <code>AllianceTimerHelp</code> | <span class="naming-census-name-list"><code>AllianceTimerHelpButton</code></span> | 2020-11-19 |
| <code>AllyRampartTowerReinforcement</code> | <span class="naming-census-name-list"><code>AllyRampartTowerReinforcementMark</code></span> | 2020-04-30 |
| <code>ArmoryGear</code> | <span class="naming-census-name-list"><code>ArmoryGearTab</code></span> | 2020-06-30 |
| <code>ArticleScoutOption</code> | <span class="naming-census-name-list"><code>ArticleScoutOptionEntry</code><code>ArticleScoutOptionGroup</code></span> | 2020-06-18 |
| <code>ArticleWarRewardItem</code> | <span class="naming-census-name-list"><code>ArticleWarRewardItemEntity</code></span> | 2020-06-12 |
| <code>Assoc</code> | <span class="naming-census-name-list"><code>AssocEntry</code><code>AssocEntryIntroButton</code><code>AssocEntryMarkImage</code><code>AssocEntryTooltipHover</code><code>AssocIconImage</code><code>AssocLevelText</code><code>AssocList</code></span> | 2024-02-11 |
| <code>AttendanceLastReward</code> | <span class="naming-census-name-list"><code>AttendanceLastRewardEntry</code></span> | 2020-12-14 |
| <code>AutoCombat</code> | <span class="naming-census-name-list"><code>AutoCombatButton</code></span> | 날짜 불명 |
| <code>Badge</code> | <span class="naming-census-name-list"><code>BadgeIcon</code></span> | 날짜 불명 |
| <code>BanInfo</code> | <span class="naming-census-name-list"><code>BanInfoPopup</code></span> | 2020-10-23 |
| <code>Bank</code> | <span class="naming-census-name-list"><code>BankMenu</code></span> | 2021-01-02 |
| <code>Banner</code> | <span class="naming-census-name-list"><code>BannerSlot</code></span> | 2020-05-29 |
| <code>BannerColor</code> | <span class="naming-census-name-list"><code>BannerColorSlot</code></span> | 2020-05-29 |
| <code>Barracks</code> | <span class="naming-census-name-list"><code>BarracksMenu</code></span> | 2021-02-02 |
| <code>BarracksLevelUpEffect</code> | <span class="naming-census-name-list"><code>BarracksLevelUpEffectEntry</code></span> | 2020-12-25 |
| <code>BaseBlur</code> | <span class="naming-census-name-list"><code>BaseBlurImage</code></span> | 2020-08-14 |
| <code>BaseHero</code> | <span class="naming-census-name-list"><code>BaseHeroSlot</code></span> | 2020-10-18 |
| <code>BaseQuantity</code> | <span class="naming-census-name-list"><code>BaseQuantitySlider</code></span> | 2020-12-29 |
| <code>BaseSkill</code> | <span class="naming-census-name-list"><code>BaseSkillEntry</code></span> | 2020-12-21 |
| <code>BaseStackable</code> | <span class="naming-census-name-list"><code>BaseStackableSlot</code></span> | 2021-02-10 |
| <code>BattleResult</code> | <span class="naming-census-name-list"><code>BattleResultPopup</code></span> | 날짜 불명 |
| <code>Billboard</code> | <span class="naming-census-name-list"><code>BillboardCanvas</code></span> | 2023-05-06 |
| <code>BiweeklyPointFestival</code> | <span class="naming-census-name-list"><code>BiweeklyPointFestivalPopup</code></span> | 2021-02-03 |
| <code>BiweeklyPointFestivalRanking</code> | <span class="naming-census-name-list"><code>BiweeklyPointFestivalRankingPopup</code></span> | 2020-11-20 |
| <code>BiweeklyPointFestivalRankingReward</code> | <span class="naming-census-name-list"><code>BiweeklyPointFestivalRankingRewardPopup</code></span> | 2020-09-22 |
| <code>Black</code> | <span class="naming-census-name-list"><code>Black</code></span> | 2024-04-28 |
| <code>Blacksmith</code> | <span class="naming-census-name-list"><code>BlacksmithMenu</code></span> | 2021-01-28 |
| <code>Blueprint</code> | <span class="naming-census-name-list"><code>BlueprintCancelButton</code><code>BlueprintPanel</code><code>BlueprintPreview</code><code>BlueprintProgressImage</code><code>BlueprintSlaveSelector</code><code>BlueprintTitleText</code></span> | 2022-09-01 |
| <code>Bookmark</code> | <span class="naming-census-name-list"><code>BookmarkPopup</code></span> | 2020-05-27 |
| <code>BookmarkModify</code> | <span class="naming-census-name-list"><code>BookmarkModifyPopup</code></span> | 2020-10-20 |
| <code>BookmarkRegister</code> | <span class="naming-census-name-list"><code>BookmarkRegisterPopup</code></span> | 2020-10-20 |
| <code>BossMonsterAMinionHeroSquad</code> | <span class="naming-census-name-list"><code>BossMonsterAMinionHeroSquadPopup</code></span> | 2020-05-26 |
| <code>BossMonsterAMinionInfo</code> | <span class="naming-census-name-list"><code>BossMonsterAMinionInfoPopup</code></span> | 2020-05-25 |
| <code>BossMonsterAParty</code> | <span class="naming-census-name-list"><code>BossMonsterAPartyButton</code><code>BossMonsterAPartyPanel</code></span> | 2020-10-28 |
| <code>BossMonsterAStatus</code> | <span class="naming-census-name-list"><code>BossMonsterAStatusPopup</code></span> | 2020-09-18 |
| <code>BossRaidPointFestival</code> | <span class="naming-census-name-list"><code>BossRaidPointFestivalPopup</code></span> | 2020-06-05 |
| <code>Bottom</code> | <span class="naming-census-name-list"><code>BottomPanel</code></span> | 2024-04-28 |
| <code>BottomMenu</code> | <span class="naming-census-name-list"><code>BottomMenuPanel</code></span> | 날짜 불명 |
| <code>Bucket</code> | <span class="naming-census-name-list"><code>BucketUnitCategoryToggle</code><code>BucketUnitHpBarImage</code><code>BucketUnitHpValueText</code><code>BucketUnitMpBarImage</code><code>BucketUnitMpValueText</code><code>BucketUnitSlotEntry</code><code>BucketUnitSlotListBox</code></span> | 2022-04-29 |
| <code>BuffItemList</code> | <span class="naming-census-name-list"><code>BuffItemListEntry</code></span> | 2020-09-17 |
| <code>BuffList</code> | <span class="naming-census-name-list"><code>BuffListEntry</code></span> | 2021-02-07 |
| <code>Build</code> | <span class="naming-census-name-list"><code>BuildButton</code><code>BuildStatus</code></span> | 2022-05-03 |
| <code>BuildingCurLevelInfo</code> | <span class="naming-census-name-list"><code>BuildingCurLevelInfoEntry</code></span> | 2020-12-25 |
| <code>BuildingLevelUpBuilding</code> | <span class="naming-census-name-list"><code>BuildingLevelUpBuildingEntry</code></span> | 2020-04-09 |
| <code>BuildingLevelUpEffect</code> | <span class="naming-census-name-list"><code>BuildingLevelUpEffectEntry</code></span> | 2020-06-12 |
| <code>BuildingLevelUpLord</code> | <span class="naming-census-name-list"><code>BuildingLevelUpLordEntry</code></span> | 2020-06-12 |
| <code>BuildingLevelUpResource</code> | <span class="naming-census-name-list"><code>BuildingLevelUpResourceEntry</code></span> | 2020-06-10 |
| <code>BuildingLevelupStakable</code> | <span class="naming-census-name-list"><code>BuildingLevelupStakableEntry</code></span> | 2020-10-22 |
| <code>BuildingLock</code> | <span class="naming-census-name-list"><code>BuildingLockIcon</code></span> | 2021-01-26 |
| <code>ButtonEventFor</code> | <span class="naming-census-name-list"><code>ButtonEventForSelector</code></span> | 날짜 불명 |
| <code>Camp</code> | <span class="naming-census-name-list"><code>CampPanel</code><code>CampSlaveSelector</code><code>CampUnitEntry</code><code>CampUnitEntryCounterListBox</code><code>CampUnitListBox</code></span> | 2022-09-01 |
| <code>Captain</code> | <span class="naming-census-name-list"><code>CaptainLevelText</code><code>CaptainPortrait</code></span> | 2023-11-19 |
| <code>Captainz</code> | <span class="naming-census-name-list"><code>Captainz</code><code>CaptainzAssocEntry</code><code>CaptainzAssocEntryButton</code><code>CaptainzAssocList</code><code>CaptainzCashSolidiumText</code><code>CaptainzCashUraniumText</code><code>CaptainzDescText</code><code>CaptainzExpBar</code><code>CaptainzNameText</code><code>CaptainzPortrait</code><code>CaptainzStuffEntry</code><code>CaptainzStuffEntryDetailButton</code><code>CaptainzStuffEntryFacilitySelector</code><code>CaptainzStuffEntryNameText</code><code>CaptainzStuffEntryQuantityText</code><code>CaptainzStuffEntrySelector</code><code>CaptainzStuffList</code><code>CaptainzTraitEntry</code><code>CaptainzTraitEntryAbilityButton</code><code>CaptainzTraitEntryAbilityImage</code><code>CaptainzTraitEntryAbilityToggle</code><code>CaptainzTraitEntryAcquisitionButton</code><code>CaptainzTraitEntryAcquisitionImage</code><code>CaptainzTraitEntryLevelText</code><code>CaptainzTraitEntrySelector</code><code>CaptainzTraitList</code></span> | 2024-04-28 |
| <code>Card</code> | <span class="naming-census-name-list"><code>CardSlot</code></span> | 2021-02-03 |
| <code>Cash</code> | <span class="naming-census-name-list"><code>CashCashText</code><code>CashDisplay</code><code>CashSolidiumText</code><code>CashUraniumText</code></span> | 2023-10-06 |
| <code>CashRecommandItemIn</code> | <span class="naming-census-name-list"><code>CashRecommandItemInPopup</code></span> | 2021-02-01 |
| <code>CashShop</code> | <span class="naming-census-name-list"><code>CashShopWindow</code></span> | 2021-02-28 |
| <code>CashShopWindow</code> | <span class="naming-census-name-list"><code>CashShopWindowTab</code></span> | 2021-01-26 |
| <code>CashShopWindowDailyClaim</code> | <span class="naming-census-name-list"><code>CashShopWindowDailyClaimEntry</code></span> | 2021-02-28 |
| <code>CashShopWindowDayshop</code> | <span class="naming-census-name-list"><code>CashShopWindowDayshopEntry</code></span> | 2021-02-09 |
| <code>CashShopWindowGold</code> | <span class="naming-census-name-list"><code>CashShopWindowGoldEntry</code></span> | 2021-02-09 |
| <code>CashShopWindowPageDay</code> | <span class="naming-census-name-list"><code>CashShopWindowPageDayshop</code></span> | 2021-02-03 |
| <code>CastleLocationCashConfirm</code> | <span class="naming-census-name-list"><code>CastleLocationCashConfirmPopup</code></span> | 2020-12-04 |
| <code>CastleLocationConfirm</code> | <span class="naming-census-name-list"><code>CastleLocationConfirmPopup</code></span> | 2020-09-22 |
| <code>CharacterInfo</code> | <span class="naming-census-name-list"><code>CharacterInfoPanel</code></span> | 날짜 불명 |
| <code>CharacterInfoFor</code> | <span class="naming-census-name-list"><code>CharacterInfoForSelector</code></span> | 날짜 불명 |
| <code>CharacterMenu</code> | <span class="naming-census-name-list"><code>CharacterMenuPanel</code></span> | 날짜 불명 |
| <code>CharacterName</code> | <span class="naming-census-name-list"><code>CharacterNameSelector</code></span> | 날짜 불명 |
| <code>CharacterSelection</code> | <span class="naming-census-name-list"><code>CharacterSelectionPanel</code></span> | 날짜 불명 |
| <code>Chat</code> | <span class="naming-census-name-list"><code>Chat</code><code>ChatBox</code><code>ChatInputField</code><code>ChatPopup</code><code>ChatUi</code><code>ChatWindow</code></span> | 2024-04-28 |
| <code>ChatDate</code> | <span class="naming-census-name-list"><code>ChatDateEntry</code></span> | 2020-03-17 |
| <code>ChatGroupOption</code> | <span class="naming-census-name-list"><code>ChatGroupOptionPopup</code></span> | 2020-12-02 |
| <code>ChatManagement</code> | <span class="naming-census-name-list"><code>ChatManagementPopup</code></span> | 2020-08-27 |
| <code>ChatMemberButtonList</code> | <span class="naming-census-name-list"><code>ChatMemberButtonListEntry</code></span> | 2021-01-27 |
| <code>ChatMemberInvite</code> | <span class="naming-census-name-list"><code>ChatMemberInvitePopup</code></span> | 2021-01-26 |
| <code>ChatMemberList</code> | <span class="naming-census-name-list"><code>ChatMemberListEntry</code></span> | 2020-12-07 |
| <code>ChatMessageMy</code> | <span class="naming-census-name-list"><code>ChatMessageMyEntry</code></span> | 2021-02-24 |
| <code>ChatMessageNoti</code> | <span class="naming-census-name-list"><code>ChatMessageNotiEntry</code></span> | 2021-02-16 |
| <code>ChatMessageOther</code> | <span class="naming-census-name-list"><code>ChatMessageOtherEntry</code></span> | 2021-02-24 |
| <code>ChatNoticeColor</code> | <span class="naming-census-name-list"><code>ChatNoticeColorEntry</code></span> | 2021-03-03 |
| <code>ChatNoticeUpdate</code> | <span class="naming-census-name-list"><code>ChatNoticeUpdatePopup</code></span> | 2021-03-04 |
| <code>ChatPopup</code> | <span class="naming-census-name-list"><code>ChatPopupMenu</code></span> | 2021-01-27 |
| <code>ChatPrivateOption</code> | <span class="naming-census-name-list"><code>ChatPrivateOptionPopup</code></span> | 2020-12-02 |
| <code>ChatRoomCreate</code> | <span class="naming-census-name-list"><code>ChatRoomCreatePopup</code></span> | 2021-01-21 |
| <code>ChatRoomList</code> | <span class="naming-census-name-list"><code>ChatRoomListEntry</code></span> | 2020-05-04 |
| <code>ChatRoomSetting</code> | <span class="naming-census-name-list"><code>ChatRoomSettingPopup</code></span> | 2020-12-02 |
| <code>ChatSearch</code> | <span class="naming-census-name-list"><code>ChatSearchPopup</code></span> | 2021-02-16 |
| <code>ChatShareMail</code> | <span class="naming-census-name-list"><code>ChatShareMailPopup</code></span> | 2020-10-20 |
| <code>ChatShareSelect</code> | <span class="naming-census-name-list"><code>ChatShareSelectPopup</code></span> | 2021-02-17 |
| <code>ChatUser</code> | <span class="naming-census-name-list"><code>ChatUserEntry</code></span> | 2021-01-31 |
| <code>ChatUserListCategory</code> | <span class="naming-census-name-list"><code>ChatUserListCategoryEntry</code></span> | 2021-01-21 |
| <code>ChatUserUnblock</code> | <span class="naming-census-name-list"><code>ChatUserUnblockPopup</code></span> | 2020-10-26 |
| <code>CityBuffEffectInformation</code> | <span class="naming-census-name-list"><code>CityBuffEffectInformationPopup</code></span> | 2020-12-22 |
| <code>CityInfo</code> | <span class="naming-census-name-list"><code>CityInfoEntry</code></span> | 2020-09-05 |
| <code>CityInfoOption</code> | <span class="naming-census-name-list"><code>CityInfoOptionEntry</code></span> | 2020-08-03 |
| <code>ClientOlympiadMingook</code> | <span class="naming-census-name-list"><code>ClientOlympiadMingookEntity</code></span> | 2020-12-28 |
| <code>ClientOlympiadSample</code> | <span class="naming-census-name-list"><code>ClientOlympiadSampleEntity</code></span> | 2021-02-08 |
| <code>ComboNumber</code> | <span class="naming-census-name-list"><code>ComboNumberPopup</code></span> | 날짜 불명 |
| <code>CommonInventory</code> | <span class="naming-census-name-list"><code>CommonInventoryUi</code></span> | 날짜 불명 |
| <code>CommonReceiveItem</code> | <span class="naming-census-name-list"><code>CommonReceiveItemEntry</code></span> | 2020-02-20 |
| <code>CompanyTest</code> | <span class="naming-census-name-list"><code>CompanyTestEntry</code><code>CompanyTestPopup</code></span> | 2020-10-13 |
| <code>Condition</code> | <span class="naming-census-name-list"><code>ConditionBar</code></span> | 날짜 불명 |
| <code>ConstructionWorkerStackableUse</code> | <span class="naming-census-name-list"><code>ConstructionWorkerStackableUsePopup</code></span> | 2020-08-19 |
| <code>Convert</code> | <span class="naming-census-name-list"><code>ConvertServantLockInfoWindow</code><code>ConvertServantSlotInfoWindow</code><code>ConvertUI</code></span> | 2018-07-09 |
| <code>CraftRecipe</code> | <span class="naming-census-name-list"><code>CraftRecipeList</code></span> | 2021-01-01 |
| <code>Crafting</code> | <span class="naming-census-name-list"><code>CraftingButton</code><code>CraftingExpProgressBar</code><code>CraftingTechPointText</code></span> | 2022-09-12 |
| <code>CraftingImmediateComplete</code> | <span class="naming-census-name-list"><code>CraftingImmediateCompletePopup</code></span> | 2021-01-29 |
| <code>Crew</code> | <span class="naming-census-name-list"><code>Crew</code><code>CrewCategoryImage</code><code>CrewCountText</code><code>CrewEntry</code><code>CrewEntryDetailButton</code><code>CrewEntryDisplayNameText</code><code>CrewEntryStateToggle</code><code>CrewEntryTypeSelector</code><code>CrewList</code><code>CrewPortraitImage</code><code>CrewSelector</code></span> | 2024-04-28 |
| <code>DailyDungeon</code> | <span class="naming-census-name-list"><code>DailyDungeonUi</code></span> | 날짜 불명 |
| <code>DailyMission</code> | <span class="naming-census-name-list"><code>DailyMissionBox</code><code>DailyMissionEntry</code></span> | 2021-01-22 |
| <code>Debuff</code> | <span class="naming-census-name-list"><code>DebuffStatus</code></span> | 2018-11-10 |
| <code>Default</code> | <span class="naming-census-name-list"><code>DefaultEntry</code></span> | 2022-04-11 |
| <code>Defeat</code> | <span class="naming-census-name-list"><code>DefeatCaptainPortrait</code><code>DefeatOkButton</code><code>DefeatPhase_1</code><code>DefeatPhase_6</code><code>DefeatQuestList</code></span> | 2024-03-01 |
| <code>Defense</code> | <span class="naming-census-name-list"><code>DefenseQuestIconSlider</code><code>DefenseQuestPointSlider</code></span> | 2018-04-11 |
| <code>Delivery</code> | <span class="naming-census-name-list"><code>DeliveryChangeButton</code><code>DeliveryEntry</code></span> | 2018-07-29 |
| <code>Describer</code> | <span class="naming-census-name-list"><code>Describer</code></span> | 2022-09-12 |
| <code>Detachment</code> | <span class="naming-census-name-list"><code>DetachmentAutoButton</code><code>DetachmentConfirmButton</code><code>DetachmentFullButton</code><code>DetachmentPanel</code><code>DetachmentResetButton</code><code>DetachmentTruncateButton</code><code>DetachmentUnitEntry</code><code>DetachmentUnitListBox</code><code>DetachmentUnitState</code></span> | 2022-08-29 |
| <code>DisplaySprite</code> | <span class="naming-census-name-list"><code>DisplaySpriteGauge</code></span> | 날짜 불명 |
| <code>Double</code> | <span class="naming-census-name-list"><code>DoubleClickDetector</code></span> | 2022-01-13 |
| <code>DungeonParty</code> | <span class="naming-census-name-list"><code>DungeonPartyUi</code></span> | 날짜 불명 |
| <code>EffectReplaceNotice</code> | <span class="naming-census-name-list"><code>EffectReplaceNoticePopup</code></span> | 2020-09-14 |
| <code>EmblemColor</code> | <span class="naming-census-name-list"><code>EmblemColorSlot</code></span> | 2020-05-29 |
| <code>Emoticon</code> | <span class="naming-census-name-list"><code>EmoticonEntry</code></span> | 2021-01-31 |
| <code>Empty</code> | <span class="naming-census-name-list"><code>EmptyButton</code></span> | 2024-02-26 |
| <code>Enemy</code> | <span class="naming-census-name-list"><code>EnemyEntry</code><code>EnemyEntryDetailButton</code><code>EnemyEntryPortraitImage</code><code>EnemyEntrySelector</code><code>EnemyList</code></span> | 2024-04-28 |
| <code>EnemyRampartTowerReinforcement</code> | <span class="naming-census-name-list"><code>EnemyRampartTowerReinforcementMark</code></span> | 2020-02-06 |
| <code>Entity</code> | <span class="naming-census-name-list"><code>EntityProviderFinderFromUi</code></span> | 2023-10-09 |
| <code>Episode</code> | <span class="naming-census-name-list"><code>EpisodeButton</code></span> | 날짜 불명 |
| <code>EquipSlot</code> | <span class="naming-census-name-list"><code>EquipSlotButton</code></span> | 날짜 불명 |
| <code>Esc</code> | <span class="naming-census-name-list"><code>EscMenu</code><code>EscMenuRetryButton</code><code>EscMenuReturnButton</code></span> | 2022-09-02 |
| <code>EventButtonBanner</code> | <span class="naming-census-name-list"><code>EventButtonBannerEntry</code></span> | 2021-02-03 |
| <code>Explain</code> | <span class="naming-census-name-list"><code>ExplainButton</code></span> | 2018-07-22 |
| <code>Facebook</code> | <span class="naming-census-name-list"><code>FacebookSettingButton</code></span> | 2018-12-23 |
| <code>Facility</code> | <span class="naming-census-name-list"><code>FacilityActiveTechListBox</code><code>FacilityCardEntry</code><code>FacilityCardEntryTechEntry</code><code>FacilityCardEntryTechEntryEnemyListBox</code><code>FacilityCardEntryTechEntryIconImage</code><code>FacilityCardEntryTechEntrySelectButton</code><code>FacilityCardEntryTechListBox</code><code>FacilityCardListBox</code><code>FacilityCategoryTab</code><code>FacilityCategoryToggle</code><code>FacilityDescriptionText</code><code>FacilityDestroyButton</code><code>FacilityDomainLayout</code><code>FacilityEntry</code><code>FacilityEntryButton</code><code>FacilityEntryDescriptionText</code><code>FacilityEntryDetailButton</code><code>FacilityEntryDisplayNameText</code><code>FacilityEntryQuantityText</code><code>FacilityEntryTutorial</code><code>FacilityList</code><code>FacilityListBox</code><code>FacilityMilitaryPanel</code><code>FacilityOpenTechIconImage</code><code>FacilityPanel</code><code>FacilityPortraitSelector</code><code>FacilitySlaveSelector</code><code>FacilityTechListBox</code><code>FacilityTitleText</code><code>FacilityWaitingTechListBox</code></span> | 2024-05-02 |
| <code>FestivalCalendar</code> | <span class="naming-census-name-list"><code>FestivalCalendarWindow</code></span> | 2021-03-03 |
| <code>FestivalCalendarProgressBar</code> | <span class="naming-census-name-list"><code>FestivalCalendarProgressBarEntry</code></span> | 2021-02-03 |
| <code>FestivalCategory</code> | <span class="naming-census-name-list"><code>FestivalCategoryEntry</code></span> | 2020-03-24 |
| <code>FestivalDesc</code> | <span class="naming-census-name-list"><code>FestivalDescPopup</code></span> | 2020-04-14 |
| <code>FestivalScheduleDesc</code> | <span class="naming-census-name-list"><code>FestivalScheduleDescPopup</code></span> | 2021-02-03 |
| <code>FieldAlliance</code> | <span class="naming-census-name-list"><code>FieldAllianceMark</code></span> | 2020-08-25 |
| <code>FieldHover</code> | <span class="naming-census-name-list"><code>FieldHoverIcon</code></span> | 2021-02-09 |
| <code>FieldSearch</code> | <span class="naming-census-name-list"><code>FieldSearchIndicator</code></span> | 2020-07-08 |
| <code>FieldTactics</code> | <span class="naming-census-name-list"><code>FieldTacticsButton</code><code>FieldTacticsMenu</code></span> | 2020-12-28 |
| <code>Finder</code> | <span class="naming-census-name-list"><code>FinderButton</code></span> | 2021-01-03 |
| <code>First</code> | <span class="naming-census-name-list"><code>FirstIntro</code></span> | 2022-09-02 |
| <code>Follower</code> | <span class="naming-census-name-list"><code>FollowerEntry</code><code>FollowerEntryItem</code><code>FollowerListBox</code></span> | 2022-04-11 |
| <code>Force</code> | <span class="naming-census-name-list"><code>ForceEntry</code><code>ForceEntryBadgeButton</code><code>ForceEntryMoveButton</code><code>ForceEntryPowerProgressBar</code><code>ForceEntrySquadButton</code><code>ForceEntryTimeProgressBar</code><code>ForceEntryTimeText</code><code>ForceEntryUnitEntry</code><code>ForceEntryUnitListBox</code><code>ForceListBox</code></span> | 2022-07-08 |
| <code>ForgeDismantleWarning</code> | <span class="naming-census-name-list"><code>ForgeDismantleWarningPopup</code></span> | 2020-09-01 |
| <code>ForgeGearCraft</code> | <span class="naming-census-name-list"><code>ForgeGearCraftButton</code></span> | 2021-02-03 |
| <code>ForgeGearCrafting</code> | <span class="naming-census-name-list"><code>ForgeGearCraftingButton</code></span> | 2021-01-28 |
| <code>ForgeGearEnhance</code> | <span class="naming-census-name-list"><code>ForgeGearEnhanceButton</code></span> | 2020-11-25 |
| <code>ForgeGearOption</code> | <span class="naming-census-name-list"><code>ForgeGearOptionEntry</code></span> | 2021-03-03 |
| <code>ForgeGearTakeoff</code> | <span class="naming-census-name-list"><code>ForgeGearTakeoffButton</code></span> | 2021-01-01 |
| <code>FriendList</code> | <span class="naming-census-name-list"><code>FriendListEntry</code></span> | 2021-01-26 |
| <code>Fx</code> | <span class="naming-census-name-list"><code>FxSoundToggle</code></span> | 2017-10-09 |
| <code>Galaxy</code> | <span class="naming-census-name-list"><code>GalaxyBackButton</code><code>GalaxyDisplayNameText</code><code>GalaxyPanelSelector</code><code>GalaxyPlanetDesc</code><code>GalaxyPlanetDescText</code></span> | 2024-01-06 |
| <code>Gather</code> | <span class="naming-census-name-list"><code>GatherButton</code><code>GatherStatus</code></span> | 2022-01-12 |
| <code>GatheringWithdraw</code> | <span class="naming-census-name-list"><code>GatheringWithdrawPopup</code></span> | 2020-05-27 |
| <code>GearCube</code> | <span class="naming-census-name-list"><code>GearCubePanel</code></span> | 날짜 불명 |
| <code>GearCubeIcon</code> | <span class="naming-census-name-list"><code>GearCubeIconUi</code></span> | 날짜 불명 |
| <code>Gem</code> | <span class="naming-census-name-list"><code>GemEntry</code><code>GemShop</code></span> | 2020-12-09 |
| <code>GemBookGroup</code> | <span class="naming-census-name-list"><code>GemBookGroupEntry</code></span> | 2020-07-13 |
| <code>GemBookTierButton</code> | <span class="naming-census-name-list"><code>GemBookTierButtonEntry</code></span> | 2020-06-12 |
| <code>GemCraftDeficientMaterial</code> | <span class="naming-census-name-list"><code>GemCraftDeficientMaterialPopup</code></span> | 2020-12-09 |
| <code>GemDismantle</code> | <span class="naming-census-name-list"><code>GemDismantleEntry</code><code>GemDismantlePopup</code></span> | 2020-05-14 |
| <code>GemDismantleSelected</code> | <span class="naming-census-name-list"><code>GemDismantleSelectedEntry</code></span> | 2020-03-18 |
| <code>GemEffect</code> | <span class="naming-census-name-list"><code>GemEffectPopup</code></span> | 2020-09-01 |
| <code>GemEnhance</code> | <span class="naming-census-name-list"><code>GemEnhancePopup</code></span> | 2020-07-13 |
| <code>GemEnhanceResult</code> | <span class="naming-census-name-list"><code>GemEnhanceResultPopup</code></span> | 2020-05-14 |
| <code>GemLordGear</code> | <span class="naming-census-name-list"><code>GemLordGearEntry</code></span> | 2020-01-03 |
| <code>GemRecipe</code> | <span class="naming-census-name-list"><code>GemRecipeEntry</code></span> | 2019-11-19 |
| <code>GemSlot</code> | <span class="naming-census-name-list"><code>GemSlotEntry</code></span> | 2020-03-18 |
| <code>Global</code> | <span class="naming-census-name-list"><code>GlobalMenu</code><code>GlobalMenuCancelButton</code><code>GlobalMenuWeaponButtons</code></span> | 2022-07-21 |
| <code>Gold</code> | <span class="naming-census-name-list"><code>GoldDisplay</code></span> | 날짜 불명 |
| <code>Goods</code> | <span class="naming-census-name-list"><code>GoodsSlot</code></span> | 날짜 불명 |
| <code>Google</code> | <span class="naming-census-name-list"><code>GoogleSettingButton</code></span> | 2018-12-23 |
| <code>GuardianOptionInformation</code> | <span class="naming-census-name-list"><code>GuardianOptionInformationEntry</code><code>GuardianOptionInformationPopup</code></span> | 2020-08-04 |
| <code>GuardianSkill</code> | <span class="naming-census-name-list"><code>GuardianSkillPopup</code><code>GuardianSkillTooltip</code></span> | 2021-01-02 |
| <code>GuardianSkillCategory</code> | <span class="naming-census-name-list"><code>GuardianSkillCategoryEntry</code></span> | 2020-12-15 |
| <code>GuardianSkillGradeReset</code> | <span class="naming-census-name-list"><code>GuardianSkillGradeResetEntry</code><code>GuardianSkillGradeResetPopup</code></span> | 2020-07-31 |
| <code>GuardianSkillGradeResetResult</code> | <span class="naming-census-name-list"><code>GuardianSkillGradeResetResultPopup</code></span> | 2020-07-31 |
| <code>GuardianSkillGradeUpResult</code> | <span class="naming-census-name-list"><code>GuardianSkillGradeUpResultPopup</code></span> | 2020-07-31 |
| <code>GuardianSkillMain</code> | <span class="naming-census-name-list"><code>GuardianSkillMainEntry</code></span> | 2020-09-21 |
| <code>GuardianSkillOptionInformation</code> | <span class="naming-census-name-list"><code>GuardianSkillOptionInformationEntry</code><code>GuardianSkillOptionInformationPopup</code></span> | 2020-08-07 |
| <code>GuardianSkillUnlock</code> | <span class="naming-census-name-list"><code>GuardianSkillUnlockEntry</code><code>GuardianSkillUnlockPopup</code></span> | 2020-12-21 |
| <code>GuardianStackableAcquire</code> | <span class="naming-census-name-list"><code>GuardianStackableAcquirePopup</code></span> | 2020-08-20 |
| <code>Hall</code> | <span class="naming-census-name-list"><code>HallOrderAAutoToggle</code><code>HallOrderAButton</code><code>HallOrderAText</code><code>HallOrderBAutoToggle</code><code>HallOrderBButton</code><code>HallOrderBText</code><code>HallOrderCAutoToggle</code><code>HallOrderCButton</code><code>HallOrderCText</code><code>HallOrderDAutoToggle</code><code>HallOrderDButton</code><code>HallOrderDText</code><code>HallPanel</code><code>HallResourceCoalButton</code><code>HallResourceFiberButton</code><code>HallResourceHideButton</code><code>HallResourceIronButton</code><code>HallResourceStoneButton</code><code>HallResourceSulfurButton</code><code>HallResourceWoodButton</code><code>HallSlaveSelector</code></span> | 2022-08-29 |
| <code>HallOfAlliance</code> | <span class="naming-census-name-list"><code>HallOfAllianceMenu</code></span> | 2021-01-26 |
| <code>HallOfHeroes</code> | <span class="naming-census-name-list"><code>HallOfHeroesMenu</code></span> | 2021-01-06 |
| <code>HallOfWar</code> | <span class="naming-census-name-list"><code>HallOfWarMenu</code></span> | 2021-01-26 |
| <code>Hero</code> | <span class="naming-census-name-list"><code>HeroEntity</code><code>HeroPanel</code></span> | 2020-05-07 |
| <code>HeroBuilder</code> | <span class="naming-census-name-list"><code>HeroBuilderPopup</code></span> | 2021-01-20 |
| <code>HeroCollectionSetBook</code> | <span class="naming-census-name-list"><code>HeroCollectionSetBookPopup</code></span> | 2020-09-04 |
| <code>HeroCollectionSetEffect</code> | <span class="naming-census-name-list"><code>HeroCollectionSetEffectEntry</code><code>HeroCollectionSetEffectPopup</code></span> | 2020-08-27 |
| <code>HeroInfoDeficientMaterial</code> | <span class="naming-census-name-list"><code>HeroInfoDeficientMaterialPopup</code></span> | 2020-05-14 |
| <code>HeroInfoLevelUp</code> | <span class="naming-census-name-list"><code>HeroInfoLevelUpPopup</code></span> | 2021-01-29 |
| <code>HeroPieceGetLink</code> | <span class="naming-census-name-list"><code>HeroPieceGetLinkEntry</code></span> | 2019-10-08 |
| <code>HeroRoadBarter</code> | <span class="naming-census-name-list"><code>HeroRoadBarterPopup</code></span> | 2020-12-07 |
| <code>HeroRoadMain</code> | <span class="naming-census-name-list"><code>HeroRoadMainEntity</code></span> | 2020-09-20 |
| <code>HeroRoadShop</code> | <span class="naming-census-name-list"><code>HeroRoadShopPopup</code></span> | 2020-06-29 |
| <code>HeroSetList</code> | <span class="naming-census-name-list"><code>HeroSetListEntry</code><code>HeroSetListPopup</code></span> | 2021-01-01 |
| <code>HeroSkill</code> | <span class="naming-census-name-list"><code>HeroSkillPopup</code></span> | 2021-02-15 |
| <code>HeroSkillList</code> | <span class="naming-census-name-list"><code>HeroSkillListEntry</code></span> | 2021-02-15 |
| <code>HeroSquadBuilderOption</code> | <span class="naming-census-name-list"><code>HeroSquadBuilderOptionPopup</code></span> | 2020-05-14 |
| <code>HeroSquadFocus</code> | <span class="naming-census-name-list"><code>HeroSquadFocusMenu</code></span> | 2021-03-08 |
| <code>HeroSquadReturn</code> | <span class="naming-census-name-list"><code>HeroSquadReturnMenu</code></span> | 2021-03-08 |
| <code>Home</code> | <span class="naming-census-name-list"><code>HomeWindow</code></span> | 2018-07-08 |
| <code>Hospital</code> | <span class="naming-census-name-list"><code>HospitalDestroyButton</code><code>HospitalPanel</code><code>HospitalProgressImage</code><code>HospitalRemainingText</code><code>HospitalSlaveSelector</code><code>HospitalState</code></span> | 2022-06-30 |
| <code>Hot</code> | <span class="naming-census-name-list"><code>HotKeyToImage</code></span> | 2022-09-01 |
| <code>House</code> | <span class="naming-census-name-list"><code>HouseDestroyButton</code><code>HousePanel</code><code>HouseSlaveSelector</code></span> | 2022-06-30 |
| <code>Hp</code> | <span class="naming-census-name-list"><code>HpBarImage</code><code>HpValueText</code></span> | 2022-01-03 |
| <code>Hq</code> | <span class="naming-census-name-list"><code>HqForm</code><code>HqFormBaseEntry</code><code>HqFormBaseEntryDetailButton</code><code>HqFormBaseEntryDisplayNameText</code><code>HqFormBaseEntrySelectButton</code><code>HqFormBaseList</code></span> | 2024-04-28 |
| <code>Hud</code> | <span class="naming-census-name-list"><code>Hud</code><code>HudCloserWorker</code></span> | 2022-09-02 |
| <code>Implant</code> | <span class="naming-census-name-list"><code>ImplantUi</code></span> | 날짜 불명 |
| <code>InGame</code> | <span class="naming-census-name-list"><code>InGameUi</code></span> | 날짜 불명 |
| <code>Income</code> | <span class="naming-census-name-list"><code>IncomeEntity</code><code>IncomeGroup</code></span> | 2022-05-03 |
| <code>InfinityInventory</code> | <span class="naming-census-name-list"><code>InfinityInventoryPopup</code></span> | 2021-03-03 |
| <code>Info</code> | <span class="naming-census-name-list"><code>InfoHud</code></span> | 2022-01-12 |
| <code>Infobox</code> | <span class="naming-census-name-list"><code>InfoboxInterfaceFinderFromSelector</code></span> | 2023-09-06 |
| <code>Ingredient</code> | <span class="naming-census-name-list"><code>IngredientEntry</code><code>IngredientEntryIconImage</code><code>IngredientEntryQuantityText</code></span> | 2023-10-06 |
| <code>InstanceChatCreation</code> | <span class="naming-census-name-list"><code>InstanceChatCreationEntry</code></span> | 2021-01-27 |
| <code>Intermission</code> | <span class="naming-census-name-list"><code>Intermission</code><code>IntermissionBackButton</code><code>IntermissionButton</code><code>IntermissionMenuGroup</code><code>IntermissionRestrategizeButton</code><code>IntermissionResumeButton</code><code>IntermissionReturnButton</code><code>IntermissionTutorialRestartButton</code><code>IntermissionTutorialSkipButton</code></span> | 2024-04-28 |
| <code>Intro</code> | <span class="naming-census-name-list"><code>IntroSkip</code><code>IntroSkipButton</code><code>IntroSkipGauge</code></span> | 2022-12-03 |
| <code>Inventory</code> | <span class="naming-census-name-list"><code>InventoryActor</code><code>InventoryButton</code><code>InventoryEmpty</code><code>InventoryItemListBox</code><code>InventoryPanel</code><code>InventoryPopup</code><code>InventoryWorkshopOpenButton</code></span> | 2022-04-11 |
| <code>InventoryBackground</code> | <span class="naming-census-name-list"><code>InventoryBackgroundPanel</code></span> | 날짜 불명 |
| <code>ItemBox</code> | <span class="naming-census-name-list"><code>ItemBoxPopup</code></span> | 날짜 불명 |
| <code>ItemInfoScroll</code> | <span class="naming-census-name-list"><code>ItemInfoScrollView</code></span> | 날짜 불명 |
| <code>ItemResult</code> | <span class="naming-census-name-list"><code>ItemResultPanel</code></span> | 날짜 불명 |
| <code>ItemRewardListPopup</code> | <span class="naming-census-name-list"><code>ItemRewardListPopupUi</code></span> | 날짜 불명 |
| <code>ItemUpgrade</code> | <span class="naming-census-name-list"><code>ItemUpgradePanel</code></span> | 날짜 불명 |
| <code>Judgement</code> | <span class="naming-census-name-list"><code>JudgementText</code></span> | 날짜 불명 |
| <code>KingdomMapKingdomList</code> | <span class="naming-census-name-list"><code>KingdomMapKingdomListPopup</code></span> | 2020-08-07 |
| <code>KingdomSelect</code> | <span class="naming-census-name-list"><code>KingdomSelectEntry</code></span> | 2020-12-29 |
| <code>KingdomTransfer</code> | <span class="naming-census-name-list"><code>KingdomTransferPopup</code></span> | 2021-02-01 |
| <code>Landmark</code> | <span class="naming-census-name-list"><code>LandmarkDescriptionText</code><code>LandmarkPanel</code><code>LandmarkSlaveSelector</code><code>LandmarkTitleText</code></span> | 2022-06-30 |
| <code>Leo</code> | <span class="naming-census-name-list"><code>LeoTooltip</code></span> | 날짜 불명 |
| <code>LeoMoveSlashSkill</code> | <span class="naming-census-name-list"><code>LeoMoveSlashSkillGauge</code></span> | 날짜 불명 |
| <code>Letter</code> | <span class="naming-census-name-list"><code>LetterBox</code></span> | 2021-09-03 |
| <code>LevelUpImmediateComplete</code> | <span class="naming-census-name-list"><code>LevelUpImmediateCompletePopup</code></span> | 2021-01-29 |
| <code>List</code> | <span class="naming-census-name-list"><code>ListBox</code></span> | 2022-08-30 |
| <code>Loader</code> | <span class="naming-census-name-list"><code>LoaderStartButton</code></span> | 2021-11-18 |
| <code>Loading</code> | <span class="naming-census-name-list"><code>LoadingScreen</code></span> | 2021-03-19 |
| <code>LobbyIn</code> | <span class="naming-census-name-list"><code>LobbyInButton</code></span> | 2020-12-28 |
| <code>LobbyTactics</code> | <span class="naming-census-name-list"><code>LobbyTacticsButton</code><code>LobbyTacticsMenu</code></span> | 2020-12-28 |
| <code>Locale</code> | <span class="naming-census-name-list"><code>LocaleStringText</code><code>LocaleStringWithTagsText</code></span> | 2022-02-24 |
| <code>Location</code> | <span class="naming-census-name-list"><code>LocationPanel</code></span> | 2021-02-01 |
| <code>Log</code> | <span class="naming-census-name-list"><code>LogBox</code><code>LogEntry</code><code>LogPopup</code></span> | 2020-08-07 |
| <code>Login</code> | <span class="naming-census-name-list"><code>LoginWindow</code></span> | 2019-01-10 |
| <code>LordGearDeficientMaterialNotice</code> | <span class="naming-census-name-list"><code>LordGearDeficientMaterialNoticePopup</code></span> | 2020-12-15 |
| <code>LordGearDismantle</code> | <span class="naming-census-name-list"><code>LordGearDismantlePopup</code></span> | 2020-07-13 |
| <code>LordGearEnhanceResult</code> | <span class="naming-census-name-list"><code>LordGearEnhanceResultPopup</code></span> | 2020-07-13 |
| <code>LordGearMaterialBuy</code> | <span class="naming-census-name-list"><code>LordGearMaterialBuyPopup</code></span> | 2020-11-25 |
| <code>LordGearPresetNotice</code> | <span class="naming-census-name-list"><code>LordGearPresetNoticePopup</code></span> | 2021-03-05 |
| <code>LordLevelup</code> | <span class="naming-census-name-list"><code>LordLevelupPopup</code></span> | 2020-07-08 |
| <code>LordNameChange</code> | <span class="naming-census-name-list"><code>LordNameChangePopup</code></span> | 2020-12-01 |
| <code>LordProfileAp</code> | <span class="naming-census-name-list"><code>LordProfileApEntry</code></span> | 2021-01-05 |
| <code>LordProfileStackable</code> | <span class="naming-census-name-list"><code>LordProfileStackableEntry</code></span> | 2020-09-25 |
| <code>LordRank</code> | <span class="naming-census-name-list"><code>LordRankPopup</code></span> | 2021-02-07 |
| <code>LordRankingButtonIn</code> | <span class="naming-census-name-list"><code>LordRankingButtonInPopup</code></span> | 2020-10-26 |
| <code>LordSkill</code> | <span class="naming-census-name-list"><code>LordSkillPopup</code></span> | 2020-10-15 |
| <code>LordSkillList</code> | <span class="naming-census-name-list"><code>LordSkillListEntry</code></span> | 2020-10-15 |
| <code>LordStatisticsInfo</code> | <span class="naming-census-name-list"><code>LordStatisticsInfoEntry</code><code>LordStatisticsInfoPopup</code></span> | 2021-02-17 |
| <code>LordStatisticsTooltip</code> | <span class="naming-census-name-list"><code>LordStatisticsTooltipEntry</code></span> | 2020-06-12 |
| <code>LordStatus</code> | <span class="naming-census-name-list"><code>LordStatusPanel</code><code>LordStatusPopup</code></span> | 2021-02-23 |
| <code>LordTalent</code> | <span class="naming-census-name-list"><code>LordTalentEntry</code></span> | 2020-10-21 |
| <code>LordTalentDetailInformation</code> | <span class="naming-census-name-list"><code>LordTalentDetailInformationEntry</code><code>LordTalentDetailInformationPopup</code></span> | 2020-09-17 |
| <code>LordTalentOption</code> | <span class="naming-census-name-list"><code>LordTalentOptionEntry</code></span> | 2020-09-10 |
| <code>LordTalentPointReset</code> | <span class="naming-census-name-list"><code>LordTalentPointResetPopup</code></span> | 2020-11-25 |
| <code>LordTalentQuickButton</code> | <span class="naming-census-name-list"><code>LordTalentQuickButtonEntry</code></span> | 2020-06-02 |
| <code>LordTalentRequire</code> | <span class="naming-census-name-list"><code>LordTalentRequireEntry</code></span> | 2020-10-07 |
| <code>LordTalentRequireInformation</code> | <span class="naming-census-name-list"><code>LordTalentRequireInformationPopup</code></span> | 2020-10-14 |
| <code>LordThumbnailSelect</code> | <span class="naming-census-name-list"><code>LordThumbnailSelectPanel</code></span> | 2021-03-02 |
| <code>Lose</code> | <span class="naming-census-name-list"><code>LosePanel</code><code>LoseScreenRestartButton</code></span> | 2022-09-01 |
| <code>Mail</code> | <span class="naming-census-name-list"><code>MailButton</code><code>MailPopup</code><code>MailUi</code></span> | 2021-02-24 |
| <code>MailBlockSingleParagraph</code> | <span class="naming-census-name-list"><code>MailBlockSingleParagraphBox</code></span> | 2020-06-12 |
| <code>MailBlockTitleHeader</code> | <span class="naming-census-name-list"><code>MailBlockTitleHeaderBox</code></span> | 2021-02-16 |
| <code>MailReward</code> | <span class="naming-census-name-list"><code>MailRewardEntity</code></span> | 2021-02-08 |
| <code>Mailbox</code> | <span class="naming-census-name-list"><code>MailboxUi</code></span> | 날짜 불명 |
| <code>Main</code> | <span class="naming-census-name-list"><code>MainButton</code><code>MainMenuCampaignButton</code><code>MainMenuExitButton</code><code>MainMenuMultiPlayButton</code><code>MainMenuSettingsButton</code><code>MainMenuSinglePlayButton</code><code>MainPanel</code><code>MainQuest</code><code>MainQuestDescText</code><code>MainQuestDetailButton</code><code>MainQuestReputationText</code><code>MainQuestTitleText</code></span> | 2024-04-28 |
| <code>MainBackground</code> | <span class="naming-census-name-list"><code>MainBackgroundPanel</code></span> | 날짜 불명 |
| <code>MainDetail</code> | <span class="naming-census-name-list"><code>MainDetailMenu</code></span> | 2021-03-03 |
| <code>MainUiSide</code> | <span class="naming-census-name-list"><code>MainUiSideBar</code></span> | 날짜 불명 |
| <code>MapLive</code> | <span class="naming-census-name-list"><code>MapLiveEntry</code></span> | 2020-10-30 |
| <code>MapNamed</code> | <span class="naming-census-name-list"><code>MapNamedEntry</code></span> | 2020-11-05 |
| <code>Market</code> | <span class="naming-census-name-list"><code>MarketActiveContractEntry</code><code>MarketActiveContractListBox</code><code>MarketDestroyButton</code><code>MarketEntry</code><code>MarketItemEntry</code><code>MarketItemEntryPriceText</code><code>MarketItemEntrySellButton</code><code>MarketItemListBox</code><code>MarketItems</code><code>MarketListBox</code><code>MarketPanel</code><code>MarketProgressImage</code><code>MarketResourcePriceText</code><code>MarketResourceTradeButton</code><code>MarketSlaveSelector</code><code>MarketWaitingContractEntry</code><code>MarketWaitingContractListBox</code></span> | 2022-06-30 |
| <code>Member</code> | <span class="naming-census-name-list"><code>MemberReadyButton</code><code>MemberUnreadyButton</code></span> | 2024-01-17 |
| <code>Message</code> | <span class="naming-census-name-list"><code>MessageBoxPanel</code><code>MessageEntry</code><code>MessageEntryText</code><code>MessageList</code><code>MessageListBox</code><code>MessagePanel</code></span> | 2023-10-01 |
| <code>Midcourse</code> | <span class="naming-census-name-list"><code>MidcourseUi</code></span> | 날짜 불명 |
| <code>MidcourseMenu</code> | <span class="naming-census-name-list"><code>MidcourseMenuUi</code></span> | 날짜 불명 |
| <code>Mill</code> | <span class="naming-census-name-list"><code>MillActiveTechListBox</code><code>MillCombatButton</code><code>MillDescriptionText</code><code>MillIconImage</code><code>MillOutputText</code><code>MillPanel</code><code>MillProgressImage</code><code>MillSlaveSelector</code><code>MillTechListBox</code><code>MillTitleText</code><code>MillToggle</code><code>MillUnitListBox</code><code>MillUnitState</code><code>MillWaitingTechListBox</code><code>MillWorkButton</code><code>MillWorkerText</code></span> | 2022-08-10 |
| <code>Mini</code> | <span class="naming-census-name-list"><code>MiniMapAlertEntry</code><code>MiniMapAlertListBox</code><code>MiniMapArsenalEntry</code><code>MiniMapArsenalListBox</code><code>MiniMapBlueprintEntry</code><code>MiniMapBlueprintListBox</code><code>MiniMapCampEntry</code><code>MiniMapCampEntryTarget</code><code>MiniMapCampEntryWarning</code><code>MiniMapCampListBox</code><code>MiniMapFacilityEntry</code><code>MiniMapFacilityListBox</code><code>MiniMapForceEntry</code><code>MiniMapForceListBox</code><code>MiniMapFrameImage</code><code>MiniMapHallEntry</code><code>MiniMapHallListBox</code><code>MiniMapHospitalEntry</code><code>MiniMapHospitalListBox</code><code>MiniMapHouseEntry</code><code>MiniMapHouseListBox</code><code>MiniMapLandmarkEntry</code><code>MiniMapLandmarkEntryTarget</code><code>MiniMapLandmarkListBox</code><code>MiniMapMarketEntry</code><code>MiniMapMarketListBox</code><code>MiniMapMillEntry</code><code>MiniMapMillListBox</code><code>MiniMapMissionEntry</code><code>MiniMapMissionListBox</code><code>MiniMapScrollRect</code><code>MiniMapSquadEntry</code><code>MiniMapSquadListBox</code><code>MiniMapUnitEntry</code><code>MiniMapUnitListBox</code><code>MiniMapWorkshopEntry</code><code>MiniMapWorkshopListBox</code></span> | 2022-08-25 |
| <code>Money</code> | <span class="naming-census-name-list"><code>MoneyGroup</code></span> | 2022-04-28 |
| <code>Motto</code> | <span class="naming-census-name-list"><code>MottoPopup</code></span> | 2019-10-10 |
| <code>MovableBuilding</code> | <span class="naming-census-name-list"><code>MovableBuildingEntry</code><code>MovableBuildingPopup</code></span> | 2021-01-07 |
| <code>MovableBuildingEffect</code> | <span class="naming-census-name-list"><code>MovableBuildingEffectEntry</code></span> | 2020-06-12 |
| <code>MovableBuildingReseource</code> | <span class="naming-census-name-list"><code>MovableBuildingReseourceEntry</code></span> | 2020-06-16 |
| <code>Multi</code> | <span class="naming-census-name-list"><code>MultiPlayerEntry</code><code>MultiPlayerListBox</code></span> | 2022-04-11 |
| <code>MultiImage</code> | <span class="naming-census-name-list"><code>MultiImageButton</code></span> | 2020-06-28 |
| <code>Music</code> | <span class="naming-census-name-list"><code>MusicToggle</code></span> | 2018-05-01 |
| <code>MyRampartTowerReinforcement</code> | <span class="naming-census-name-list"><code>MyRampartTowerReinforcementMark</code></span> | 2020-04-30 |
| <code>MyUiText</code> | <span class="naming-census-name-list"><code>MyUiTextList</code></span> | 날짜 불명 |
| <code>Netlog</code> | <span class="naming-census-name-list"><code>NetlogEntry</code><code>NetlogListBox</code></span> | 2022-08-31 |
| <code>Neutral</code> | <span class="naming-census-name-list"><code>NeutralField</code></span> | 날짜 불명 |
| <code>NextEpisode</code> | <span class="naming-census-name-list"><code>NextEpisodeButton</code></span> | 날짜 불명 |
| <code>NickName</code> | <span class="naming-census-name-list"><code>NickNameDisplay</code></span> | 날짜 불명 |
| <code>Nothing</code> | <span class="naming-census-name-list"><code>NothingPhaseButton</code></span> | 2022-04-11 |
| <code>Notice</code> | <span class="naming-census-name-list"><code>Notice</code><code>NoticeBoxPanel</code><code>NoticeConfirmButton</code><code>NoticeOkButton</code><code>NoticePopup</code><code>NoticeText</code><code>NoticeWindow</code></span> | 2022-11-10 |
| <code>NpcLevelUpBuff</code> | <span class="naming-census-name-list"><code>NpcLevelUpBuffText</code></span> | 2019-04-09 |
| <code>NutList</code> | <span class="naming-census-name-list"><code>NutListEntity</code></span> | 날짜 불명 |
| <code>Objectivez</code> | <span class="naming-census-name-list"><code>ObjectivezEntry</code><code>ObjectivezEntrySelector</code><code>ObjectivezEntryStateText</code><code>ObjectivezEntryTitleText</code><code>ObjectivezEntryTutorial</code><code>ObjectivezList</code></span> | 2024-03-18 |
| <code>Occupation</code> | <span class="naming-census-name-list"><code>OccupationFormSelector</code></span> | 2023-01-24 |
| <code>Option</code> | <span class="naming-census-name-list"><code>OptionEntry</code></span> | 2020-10-29 |
| <code>OptionListItem</code> | <span class="naming-census-name-list"><code>OptionListItemEntry</code></span> | 2020-07-13 |
| <code>Parent</code> | <span class="naming-census-name-list"><code>ParentHideButton</code></span> | 2024-04-28 |
| <code>PartyMember</code> | <span class="naming-census-name-list"><code>PartyMemberDisplay</code></span> | 날짜 불명 |
| <code>Patch</code> | <span class="naming-census-name-list"><code>PatchButton</code></span> | 2018-06-26 |
| <code>Pause</code> | <span class="naming-census-name-list"><code>PauseButton</code><code>PausePanel</code></span> | 2018-03-14 |
| <code>Payday</code> | <span class="naming-census-name-list"><code>PaydayPopup</code></span> | 2021-02-16 |
| <code>PaydayPopupRanking</code> | <span class="naming-census-name-list"><code>PaydayPopupRankingEntry</code></span> | 2020-09-09 |
| <code>PaydayRankingInfoReward</code> | <span class="naming-census-name-list"><code>PaydayRankingInfoRewardEntry</code></span> | 2020-09-04 |
| <code>Play</code> | <span class="naming-census-name-list"><code>PlayHubEntry</code></span> | 2022-04-11 |
| <code>Pod</code> | <span class="naming-census-name-list"><code>PodEntry</code><code>PodListBox</code></span> | 2022-04-11 |
| <code>PointFestival</code> | <span class="naming-census-name-list"><code>PointFestivalPopup</code></span> | 2021-02-03 |
| <code>PointFestivalRanking</code> | <span class="naming-census-name-list"><code>PointFestivalRankingPopup</code></span> | 2020-11-20 |
| <code>Population</code> | <span class="naming-census-name-list"><code>PopulationCountText</code><code>PopulationPanel</code></span> | 2022-09-07 |
| <code>Poster</code> | <span class="naming-census-name-list"><code>PosterDisplay</code></span> | 날짜 불명 |
| <code>Preparation</code> | <span class="naming-census-name-list"><code>Preparation</code><code>PreparationItemToggle_1</code><code>PreparationItemToggle_2</code><code>PreparationItemToggle_3</code><code>PreparationItemToggle_4</code><code>PreparationItemToggle_5</code><code>PreparationItemToggle_6</code></span> | 2024-04-10 |
| <code>Prepare</code> | <span class="naming-census-name-list"><code>PrepareAutoButton</code><code>PrepareGoButton</code><code>PreparePanel</code><code>PrepareQuestRewardListBox</code><code>PrepareTruncateButton</code><code>PrepareUnitCountText</code><code>PrepareUnitEntry</code><code>PrepareUnitEntryDistanceText</code><code>PrepareUnitListBox</code><code>PrepareUnitState</code></span> | 2022-07-21 |
| <code>PresetHero</code> | <span class="naming-census-name-list"><code>PresetHeroSelector</code></span> | 2019-08-02 |
| <code>PresetShortcut</code> | <span class="naming-census-name-list"><code>PresetShortcutEntry</code></span> | 2020-05-05 |
| <code>Pressed</code> | <span class="naming-census-name-list"><code>PressedButton</code></span> | 날짜 불명 |
| <code>PreviousUnit</code> | <span class="naming-census-name-list"><code>PreviousUnitButton</code></span> | 날짜 불명 |
| <code>Product</code> | <span class="naming-census-name-list"><code>ProductServantLockInfoWindow</code><code>ProductServantSlotInfoWindow</code></span> | 2018-07-22 |
| <code>Progress</code> | <span class="naming-census-name-list"><code>ProgressBar</code></span> | 2022-02-07 |
| <code>ProtectionItem</code> | <span class="naming-census-name-list"><code>ProtectionItemEntity</code></span> | 2020-03-18 |
| <code>ProviderSelector</code> | <span class="naming-census-name-list"><code>ProviderSelectorPopup</code></span> | 2021-01-06 |
| <code>ProviderSwitch</code> | <span class="naming-census-name-list"><code>ProviderSwitchPopup</code></span> | 2021-02-28 |
| <code>Pvp</code> | <span class="naming-census-name-list"><code>PvpPanel</code><code>PvpUi</code></span> | 날짜 불명 |
| <code>PvpEntry</code> | <span class="naming-census-name-list"><code>PvpEntryPanel</code><code>PvpEntryUi</code></span> | 날짜 불명 |
| <code>PvpMatch</code> | <span class="naming-census-name-list"><code>PvpMatchPanel</code><code>PvpMatchUi</code></span> | 날짜 불명 |
| <code>Quality</code> | <span class="naming-census-name-list"><code>QualityButton</code></span> | 날짜 불명 |
| <code>Quest</code> | <span class="naming-census-name-list"><code>QuestButton</code><code>QuestCountText</code><code>QuestEntry</code><code>QuestEntryAcceptButton</code><code>QuestEntryButtonToggle</code><code>QuestEntryCancelButton</code><code>QuestEntryClearToggle</code><code>QuestEntryDetailButton</code><code>QuestEntryDetailButtonTutorial</code><code>QuestEntryRewardCashText</code><code>QuestEntryRewardEntry</code><code>QuestEntryRewardListBox</code><code>QuestEntryRewardReputationText</code><code>QuestEntryRewardSelector</code><code>QuestEntrySquadUnitEntry</code><code>QuestEntrySquadUnitListBox</code><code>QuestEntryText</code><code>QuestEntryTitleText</code><code>QuestList</code><code>QuestListBox</code><code>QuestMark</code><code>QuestMarkTooltipViewer</code><code>QuestPanel</code><code>QuestPopup</code><code>QuestSupplyMark</code><code>QuestSupplyMarkTutorial</code><code>QuestTabText</code><code>QuestTabToggleTutorial</code></span> | 2024-04-28 |
| <code>QuestCompleting</code> | <span class="naming-census-name-list"><code>QuestCompletingUi</code></span> | 날짜 불명 |
| <code>QuestCrew</code> | <span class="naming-census-name-list"><code>QuestCrewPanel</code><code>QuestCrewUi</code></span> | 날짜 불명 |
| <code>QuestGuide</code> | <span class="naming-census-name-list"><code>QuestGuideIndicator</code></span> | 2020-05-14 |
| <code>QuestMenu</code> | <span class="naming-census-name-list"><code>QuestMenuEntity</code></span> | 2021-02-22 |
| <code>QuestPopup</code> | <span class="naming-census-name-list"><code>QuestPopupEntry</code></span> | 2021-02-02 |
| <code>QuestProgress</code> | <span class="naming-census-name-list"><code>QuestProgressUi</code></span> | 날짜 불명 |
| <code>QuestSlot</code> | <span class="naming-census-name-list"><code>QuestSlotButton</code></span> | 날짜 불명 |
| <code>QuestStart</code> | <span class="naming-census-name-list"><code>QuestStartUi</code></span> | 날짜 불명 |
| <code>Rally</code> | <span class="naming-census-name-list"><code>RallyButton</code><code>RallyPopup</code></span> | 2021-02-18 |
| <code>Random</code> | <span class="naming-census-name-list"><code>RandomFloatingText</code></span> | 2022-12-02 |
| <code>RandomBoxResult</code> | <span class="naming-census-name-list"><code>RandomBoxResultPopup</code></span> | 2020-06-04 |
| <code>Range</code> | <span class="naming-census-name-list"><code>RangeHover</code><code>RangeHoverTutorial</code></span> | 2024-02-11 |
| <code>Rank</code> | <span class="naming-census-name-list"><code>RankEntry</code></span> | 2021-02-07 |
| <code>Recipe</code> | <span class="naming-census-name-list"><code>RecipeEntry</code></span> | 2018-07-22 |
| <code>Recruit</code> | <span class="naming-census-name-list"><code>RecruitEntry</code><code>RecruitListBox</code></span> | 2022-04-22 |
| <code>Reentrance</code> | <span class="naming-census-name-list"><code>ReentranceButton</code></span> | 날짜 불명 |
| <code>ReinforcementTotal</code> | <span class="naming-census-name-list"><code>ReinforcementTotalPopup</code></span> | 2020-11-11 |
| <code>ReinforcementTroopByTier</code> | <span class="naming-census-name-list"><code>ReinforcementTroopByTierEntry</code></span> | 2020-07-13 |
| <code>Repair</code> | <span class="naming-census-name-list"><code>RepairEntry</code><code>RepairReinforceButton</code></span> | 2018-07-29 |
| <code>Reporter</code> | <span class="naming-census-name-list"><code>Reporter</code><code>ReporterInputField</code><code>ReporterOkButton</code><code>ReporterScreenshotImage</code><code>ReporterSendButton</code></span> | 2024-04-28 |
| <code>RescueCamp</code> | <span class="naming-census-name-list"><code>RescueCampPopup</code></span> | 2021-02-02 |
| <code>Research</code> | <span class="naming-census-name-list"><code>ResearchServantLockInfoWindow</code><code>ResearchServantSlotInfoWindow</code></span> | 2018-07-07 |
| <code>ResearchCategory</code> | <span class="naming-census-name-list"><code>ResearchCategoryEntry</code></span> | 2020-07-30 |
| <code>ResearchSkill</code> | <span class="naming-census-name-list"><code>ResearchSkillEntry</code><code>ResearchSkillMenu</code></span> | 2021-01-28 |
| <code>ResearchSkillLevelUpPoint</code> | <span class="naming-census-name-list"><code>ResearchSkillLevelUpPointEntry</code></span> | 2020-09-17 |
| <code>ResearchSkillLevelUpStakable</code> | <span class="naming-census-name-list"><code>ResearchSkillLevelUpStakableEntry</code></span> | 2020-06-10 |
| <code>ResearchSkillMaster</code> | <span class="naming-census-name-list"><code>ResearchSkillMasterPopup</code></span> | 2020-12-15 |
| <code>ResearchSkillOption</code> | <span class="naming-census-name-list"><code>ResearchSkillOptionEntry</code></span> | 2020-07-30 |
| <code>ResearchSkillRequireBuilding</code> | <span class="naming-census-name-list"><code>ResearchSkillRequireBuildingEntry</code></span> | 2021-02-23 |
| <code>ResearchSkillRequireSkill</code> | <span class="naming-census-name-list"><code>ResearchSkillRequireSkillEntry</code></span> | 2020-12-15 |
| <code>ResearchSkillResearching</code> | <span class="naming-census-name-list"><code>ResearchSkillResearchingPopup</code></span> | 2021-01-28 |
| <code>ResourceGain</code> | <span class="naming-census-name-list"><code>ResourceGainEntity</code><code>ResourceGainPopup</code></span> | 2021-01-01 |
| <code>ResourceGatherable</code> | <span class="naming-census-name-list"><code>ResourceGatherableIcon</code></span> | 2020-06-03 |
| <code>ResourceShortage</code> | <span class="naming-census-name-list"><code>ResourceShortagePopup</code></span> | 2020-06-05 |
| <code>ResourceStatus</code> | <span class="naming-census-name-list"><code>ResourceStatusPanel</code><code>ResourceStatusPopup</code></span> | 2020-11-25 |
| <code>Restart</code> | <span class="naming-census-name-list"><code>RestartButton</code></span> | 날짜 불명 |
| <code>Result</code> | <span class="naming-census-name-list"><code>ResultGroup</code><code>ResultRetryButton</code><code>ResultScreen</code><code>ResultScreenScore</code><code>ResultText_1</code><code>ResultText_2</code><code>ResultText_3</code><code>ResultTitleText</code></span> | 2024-03-01 |
| <code>Resume</code> | <span class="naming-census-name-list"><code>ResumeButton</code></span> | 2017-10-22 |
| <code>Resurrection</code> | <span class="naming-census-name-list"><code>ResurrectionButton</code></span> | 2017-08-20 |
| <code>Reward</code> | <span class="naming-census-name-list"><code>RewardEntity</code><code>RewardEntry</code><code>RewardListBox</code><code>RewardPanel</code><code>RewardText</code><code>RewardTutorial</code></span> | 2023-10-09 |
| <code>RewardCommon</code> | <span class="naming-census-name-list"><code>RewardCommonPopup</code></span> | 2020-11-15 |
| <code>RewardItem</code> | <span class="naming-census-name-list"><code>RewardItemSlot</code></span> | 날짜 불명 |
| <code>RewardParticle</code> | <span class="naming-census-name-list"><code>RewardParticleIcon</code></span> | 2021-03-10 |
| <code>Roll</code> | <span class="naming-census-name-list"><code>RollButton</code><code>RollCategoryToggle</code><code>RollPanel</code><code>RollUnitEntry</code><code>RollUnitEntryHpBarImage</code><code>RollUnitEntryItem</code><code>RollUnitEntryItemLoadageImage</code><code>RollUnitEntryLocationButton</code><code>RollUnitEntryMpBarImage</code><code>RollUnitEntryUnequipButton</code><code>RollUnitListBox</code></span> | 2022-04-22 |
| <code>Sanctuary</code> | <span class="naming-census-name-list"><code>SanctuaryPopup</code></span> | 2021-02-08 |
| <code>SanctumTreatmentProgressing</code> | <span class="naming-census-name-list"><code>SanctumTreatmentProgressingWindow</code></span> | 2021-02-03 |
| <code>SceneChoice</code> | <span class="naming-census-name-list"><code>SceneChoiceButton</code></span> | 날짜 불명 |
| <code>SceneDetail</code> | <span class="naming-census-name-list"><code>SceneDetailPanel</code></span> | 날짜 불명 |
| <code>Screen</code> | <span class="naming-census-name-list"><code>ScreenArchive</code><code>ScreenArchiveNew</code><code>ScreenBasicInfoArchiveButton</code><code>ScreenBasicInfoArchiveText</code><code>ScreenBasicShop</code><code>ScreenBasicShopButton</code><code>ScreenBasicShopButtonFocus</code><code>ScreenChangerButton</code><code>ScreenChangerLockerSelector</code><code>ScreenDisplayNameText</code><code>ScreenImage</code><code>ScreenMenuSelector</code><code>ScreenPlanetRequirementText</code><code>ScreenShop</code><code>ScreenShopTutorial</code></span> | 2024-06-14 |
| <code>SearchLocation</code> | <span class="naming-census-name-list"><code>SearchLocationPopup</code></span> | 2020-12-22 |
| <code>SecretOperation</code> | <span class="naming-census-name-list"><code>SecretOperationButton</code><code>SecretOperationEntry</code><code>SecretOperationWindow</code></span> | 2021-02-23 |
| <code>SecretOperationLevelResult</code> | <span class="naming-census-name-list"><code>SecretOperationLevelResultPopup</code></span> | 2021-01-26 |
| <code>SecretOperationOvercome</code> | <span class="naming-census-name-list"><code>SecretOperationOvercomePopup</code></span> | 2021-02-02 |
| <code>SelectStage</code> | <span class="naming-census-name-list"><code>SelectStageUi</code></span> | 날짜 불명 |
| <code>SetComponentItemName</code> | <span class="naming-census-name-list"><code>SetComponentItemNameEntry</code></span> | 2020-06-12 |
| <code>SetOption</code> | <span class="naming-census-name-list"><code>SetOptionEntry</code></span> | 2020-06-12 |
| <code>SettingContents</code> | <span class="naming-census-name-list"><code>SettingContentsEntry</code></span> | 2020-11-24 |
| <code>SettingToggle</code> | <span class="naming-census-name-list"><code>SettingToggleEntry</code></span> | 2020-09-09 |
| <code>ShopMoveCommon</code> | <span class="naming-census-name-list"><code>ShopMoveCommonPopup</code></span> | 2020-12-24 |
| <code>ShopTop</code> | <span class="naming-census-name-list"><code>ShopTopMenu</code></span> | 날짜 불명 |
| <code>Single</code> | <span class="naming-census-name-list"><code>SinglePlayDetail</code><code>SinglePlayStartButton</code><code>SingleStartButton</code><code>SingleStartButtonTooltip</code></span> | 2024-04-28 |
| <code>SkillDetailInfo</code> | <span class="naming-census-name-list"><code>SkillDetailInfoPanel</code></span> | 날짜 불명 |
| <code>SkillOption</code> | <span class="naming-census-name-list"><code>SkillOptionTooltip</code></span> | 2021-02-03 |
| <code>Slider</code> | <span class="naming-census-name-list"><code>Slider</code></span> | 2017-08-05 |
| <code>Sliding</code> | <span class="naming-census-name-list"><code>SlidingImage</code><code>SlidingLabel</code></span> | 2018-06-10 |
| <code>SmithEffect</code> | <span class="naming-census-name-list"><code>SmithEffectPopup</code></span> | 2021-01-01 |
| <code>SortHeroList</code> | <span class="naming-census-name-list"><code>SortHeroListButton</code></span> | 2020-06-12 |
| <code>Squad</code> | <span class="naming-census-name-list"><code>SquadButton</code><code>SquadEntry</code><code>SquadEntryBadges</code><code>SquadEntryCountText</code><code>SquadEntryDismissalButton</code><code>SquadEntryEditButton</code><code>SquadEntryHpBarImage</code><code>SquadEntryHpValueText</code><code>SquadEntryLocationButton</code><code>SquadEntryMpBarImage</code><code>SquadEntryMpValueText</code><code>SquadEntryRelocationButton</code><code>SquadListBox</code><code>SquadPanel</code><code>SquadSlavePreview</code></span> | 2022-12-06 |
| <code>StageResult</code> | <span class="naming-census-name-list"><code>StageResultUi</code></span> | 날짜 불명 |
| <code>Stamina</code> | <span class="naming-census-name-list"><code>StaminaDisplay</code></span> | 날짜 불명 |
| <code>StarterPackageBundle</code> | <span class="naming-census-name-list"><code>StarterPackageBundleEntry</code></span> | 2021-03-08 |
| <code>Station</code> | <span class="naming-census-name-list"><code>StationSelector</code></span> | 2023-11-19 |
| <code>Steam</code> | <span class="naming-census-name-list"><code>SteamNicknameText</code></span> | 2021-12-20 |
| <code>StrongholdRallyCommonReward</code> | <span class="naming-census-name-list"><code>StrongholdRallyCommonRewardEntry</code></span> | 2020-06-12 |
| <code>StrongholdRallyTroop</code> | <span class="naming-census-name-list"><code>StrongholdRallyTroopEntry</code></span> | 2020-09-01 |
| <code>SuperBuildingBuild</code> | <span class="naming-census-name-list"><code>SuperBuildingBuildMenu</code></span> | 2021-01-08 |
| <code>SuperBuildingTearDown</code> | <span class="naming-census-name-list"><code>SuperBuildingTearDownMenu</code></span> | 2021-01-28 |
| <code>Supply</code> | <span class="naming-census-name-list"><code>SupplyPanel</code></span> | 날짜 불명 |
| <code>Synthesize</code> | <span class="naming-census-name-list"><code>SynthesizePopup</code></span> | 2020-07-13 |
| <code>System</code> | <span class="naming-census-name-list"><code>SystemBackButton</code><code>SystemDiscordButton</code><code>SystemVersionText</code><code>SystemWishlistButton</code></span> | 2023-12-31 |
| <code>T2</code> | <span class="naming-census-name-list"><code>T2_MoreWorkshop</code><code>T2_Workshop</code></span> | 2022-03-26 |
| <code>T3</code> | <span class="naming-census-name-list"><code>T3_QuestList</code></span> | 2022-03-29 |
| <code>Tab</code> | <span class="naming-census-name-list"><code>Tab</code></span> | 2024-03-31 |
| <code>TacticsInfo</code> | <span class="naming-census-name-list"><code>TacticsInfoPopup</code></span> | 2020-05-14 |
| <code>TagComponentItemPart</code> | <span class="naming-census-name-list"><code>TagComponentItemPartEntry</code></span> | 2020-06-12 |
| <code>Talent</code> | <span class="naming-census-name-list"><code>TalentEntry</code></span> | 2018-07-29 |
| <code>Tech</code> | <span class="naming-census-name-list"><code>TechEnemyEntry</code><code>TechEntry</code><code>TechEntryActive</code><code>TechEntryActiveProgressImage</code><code>TechEntryCraftButton</code><code>TechEntryIconImage</code><code>TechEntryOff</code><code>TechEntryWaiting</code></span> | 2022-09-07 |
| <code>Tek</code> | <span class="naming-census-name-list"><code>TekEntry</code><code>TekEntryAddButton</code><code>TekEntryIconImage</code><code>TekEntryUnloadButton</code><code>TekListBox</code></span> | 2022-06-23 |
| <code>Test</code> | <span class="naming-census-name-list"><code>TestSettingsSelector</code></span> | 2023-03-14 |
| <code>Text</code> | <span class="naming-census-name-list"><code>Text</code></span> | 2024-04-05 |
| <code>Tip</code> | <span class="naming-census-name-list"><code>TipA</code><code>TipText</code></span> | 2024-03-23 |
| <code>Tooltips</code> | <span class="naming-census-name-list"><code>TooltipsBlueprint</code><code>TooltipsBlueprintBuildingTimeText</code><code>TooltipsBlueprintDescriptionText</code><code>TooltipsBlueprintIngredientListBox</code><code>TooltipsBlueprintTitleText</code><code>TooltipsItem</code><code>TooltipsItemText</code><code>TooltipsRecipe</code><code>TooltipsRecipeCraftingTimeText</code><code>TooltipsRecipeIngredientListBox</code><code>TooltipsRecipeText</code><code>TooltipsRecipeTitleText</code><code>TooltipsSkill</code><code>TooltipsSkillIconImage</code><code>TooltipsSkillText</code><code>TooltipsSkillTitleText</code><code>TooltipsTactic</code><code>TooltipsTacticCraftingTimeText</code><code>TooltipsTacticIngredientListBox</code><code>TooltipsTacticText</code><code>TooltipsTacticTitleText</code><code>TooltipsTech</code><code>TooltipsTechCraftingTimeText</code><code>TooltipsTechIngredientListBox</code><code>TooltipsTechText</code><code>TooltipsTechTitleText</code><code>TooltipsText</code><code>TooltipsTextText</code><code>TooltipsWeapon</code><code>TooltipsWeaponIconImage</code><code>TooltipsWeaponIngredientListBox</code><code>TooltipsWeaponText</code><code>TooltipsWeaponTitleText</code></span> | 2022-09-12 |
| <code>TopEffect</code> | <span class="naming-census-name-list"><code>TopEffectWindow</code></span> | 2021-02-21 |
| <code>TopMenu</code> | <span class="naming-census-name-list"><code>TopMenuPanel</code></span> | 날짜 불명 |
| <code>Tower</code> | <span class="naming-census-name-list"><code>TowerStateDebuggerText</code></span> | 2022-12-06 |
| <code>TradeShipReward</code> | <span class="naming-census-name-list"><code>TradeShipRewardPopup</code></span> | 2021-01-30 |
| <code>Tradingpost</code> | <span class="naming-census-name-list"><code>TradingpostEntry</code></span> | 2020-10-15 |
| <code>TradingpostExchange</code> | <span class="naming-census-name-list"><code>TradingpostExchangePopup</code></span> | 2020-07-01 |
| <code>TradingpostListUpdate</code> | <span class="naming-census-name-list"><code>TradingpostListUpdatePopup</code></span> | 2020-06-05 |
| <code>TrainingImmediateComplete</code> | <span class="naming-census-name-list"><code>TrainingImmediateCompletePopup</code></span> | 2021-02-02 |
| <code>TransportInfo</code> | <span class="naming-census-name-list"><code>TransportInfoEntry</code></span> | 2020-10-07 |
| <code>TrapSetup</code> | <span class="naming-census-name-list"><code>TrapSetupPopup</code></span> | 2021-03-03 |
| <code>TrapSetupImmediateComplete</code> | <span class="naming-census-name-list"><code>TrapSetupImmediateCompletePopup</code></span> | 2021-01-29 |
| <code>TrapTower</code> | <span class="naming-census-name-list"><code>TrapTowerMenu</code></span> | 2021-01-28 |
| <code>TreatmentImmediateComplete</code> | <span class="naming-census-name-list"><code>TreatmentImmediateCompletePopup</code></span> | 2021-02-02 |
| <code>TroopByTierInformation</code> | <span class="naming-census-name-list"><code>TroopByTierInformationEntry</code></span> | 2020-09-03 |
| <code>TroopField</code> | <span class="naming-census-name-list"><code>TroopFieldEntry</code></span> | 2020-11-04 |
| <code>TroopSchedule</code> | <span class="naming-census-name-list"><code>TroopScheduleEntry</code><code>TroopSchedulePanel</code></span> | 2021-03-05 |
| <code>TroopTierUpgradeCenterDetailInfo</code> | <span class="naming-census-name-list"><code>TroopTierUpgradeCenterDetailInfoWindow</code></span> | 2020-08-14 |
| <code>UiLocaleString</code> | <span class="naming-census-name-list"><code>UiLocaleStringText</code></span> | 2019-01-09 |
| <code>UiPropertyBossCondition</code> | <span class="naming-census-name-list"><code>UiPropertyBossConditionBar</code></span> | 날짜 불명 |
| <code>UiPropertyCharacterName</code> | <span class="naming-census-name-list"><code>UiPropertyCharacterNameSelector</code></span> | 날짜 불명 |
| <code>UiPropertyConvert</code> | <span class="naming-census-name-list"><code>UiPropertyConvertUi</code></span> | 날짜 불명 |
| <code>UiPropertyEnchant</code> | <span class="naming-census-name-list"><code>UiPropertyEnchantUi</code></span> | 날짜 불명 |
| <code>UiPropertyImplantNutAttaching</code> | <span class="naming-census-name-list"><code>UiPropertyImplantNutAttachingUi</code></span> | 날짜 불명 |
| <code>UiPropertyImplantNutDetaching</code> | <span class="naming-census-name-list"><code>UiPropertyImplantNutDetachingUi</code></span> | 날짜 불명 |
| <code>UiPropertyImplantSocketCreating</code> | <span class="naming-census-name-list"><code>UiPropertyImplantSocketCreatingUi</code></span> | 날짜 불명 |
| <code>UiPropertyItemSocketCreating</code> | <span class="naming-census-name-list"><code>UiPropertyItemSocketCreatingUi</code></span> | 날짜 불명 |
| <code>UiPropertyMidcourse</code> | <span class="naming-census-name-list"><code>UiPropertyMidcourseUi</code></span> | 날짜 불명 |
| <code>UiPropertyMidcourseMenu</code> | <span class="naming-census-name-list"><code>UiPropertyMidcourseMenuUi</code></span> | 날짜 불명 |
| <code>UiPropertyShop</code> | <span class="naming-census-name-list"><code>UiPropertyShopUi</code></span> | 날짜 불명 |
| <code>Upgrade</code> | <span class="naming-census-name-list"><code>UpgradeUi</code></span> | 날짜 불명 |
| <code>UserAchievement</code> | <span class="naming-census-name-list"><code>UserAchievementEntry</code><code>UserAchievementPopup</code></span> | 2021-02-08 |
| <code>Userz</code> | <span class="naming-census-name-list"><code>Userz</code><code>UserzExpBar</code><code>UserzGiftEntry</code><code>UserzGiftEntryButton</code><code>UserzGiftEntryQuantityText</code><code>UserzGiftEntrySelector</code><code>UserzGiftList</code><code>UserzLevelText</code></span> | 2024-04-28 |
| <code>Vault</code> | <span class="naming-census-name-list"><code>VaultPopup</code></span> | 2021-01-01 |
| <code>VaultDepositComplete</code> | <span class="naming-census-name-list"><code>VaultDepositCompletePopup</code></span> | 2020-09-02 |
| <code>VaultDepositProgress</code> | <span class="naming-census-name-list"><code>VaultDepositProgressPopup</code></span> | 2020-09-02 |
| <code>VaultDepositSetting</code> | <span class="naming-census-name-list"><code>VaultDepositSettingPopup</code></span> | 2021-02-17 |
| <code>Version</code> | <span class="naming-census-name-list"><code>VersionText</code></span> | 2022-08-31 |
| <code>Video</code> | <span class="naming-census-name-list"><code>VideoList</code></span> | 2020-07-08 |
| <code>VideoSkip</code> | <span class="naming-census-name-list"><code>VideoSkipButton</code></span> | 2020-05-14 |
| <code>VipBarter</code> | <span class="naming-census-name-list"><code>VipBarterPopup</code></span> | 2021-01-19 |
| <code>VipCheat</code> | <span class="naming-census-name-list"><code>VipCheatPopup</code></span> | 2020-03-16 |
| <code>VipPointShop</code> | <span class="naming-census-name-list"><code>VipPointShopPopup</code></span> | 2020-11-25 |
| <code>VipReward</code> | <span class="naming-census-name-list"><code>VipRewardPopup</code></span> | 2020-06-24 |
| <code>WarInfoRallyDetail</code> | <span class="naming-census-name-list"><code>WarInfoRallyDetailEntry</code><code>WarInfoRallyDetailPopup</code></span> | 2021-02-22 |
| <code>WarInfoRallyLordSlot</code> | <span class="naming-census-name-list"><code>WarInfoRallyLordSlotEntry</code></span> | 2020-06-18 |
| <code>Warehouse</code> | <span class="naming-census-name-list"><code>WarehouseButton</code></span> | 2017-10-05 |
| <code>Warzone</code> | <span class="naming-census-name-list"><code>WarzoneUI</code><code>WarzoneUi</code></span> | 날짜 불명 |
| <code>Watchtower</code> | <span class="naming-census-name-list"><code>WatchtowerEntry</code><code>WatchtowerMenu</code></span> | 2021-02-22 |
| <code>WatchtowerTroopInfo</code> | <span class="naming-census-name-list"><code>WatchtowerTroopInfoEntry</code></span> | 2021-03-03 |
| <code>Wave</code> | <span class="naming-census-name-list"><code>WavePlacerEnemyList</code></span> | 2023-10-01 |
| <code>Workshop</code> | <span class="naming-census-name-list"><code>Workshop</code><code>WorkshopActiveProductEntry</code><code>WorkshopActiveProductEntryProgressImage</code><code>WorkshopActiveProductListBox</code><code>WorkshopButton</code><code>WorkshopDestroyButton</code><code>WorkshopEntry</code><code>WorkshopListBox</code><code>WorkshopPanel</code><code>WorkshopRecipeCategory</code><code>WorkshopRecipeCategoryToggle</code><code>WorkshopRecipeEntry</code><code>WorkshopRecipeEntryCounter</code><code>WorkshopRecipeEntryCounterText</code><code>WorkshopRecipeListBox</code><code>WorkshopSlaveSelector</code><code>WorkshopWaitingProductEntry</code><code>WorkshopWaitingQueueListBox</code><code>WorkshopWindow</code></span> | 2022-08-20 |
| <code>WorldInfo</code> | <span class="naming-census-name-list"><code>WorldInfoPopup</code></span> | 2020-05-14 |
| <code>itemContentSubmit</code> | <span class="naming-census-name-list"><code>itemContentSubmitButton</code></span> | 날짜 불명 |
{:.naming-census-table}

## 해석 메모 {#review}

| 이름 | 해석 |
| --- | --- |
| <code>MyAsker.MyAskerArguments</code> | C# 중첩 타입의 이름 충돌을 피하기 위한 소유자 반복이다. <code>MyAsker → Arguments</code>로 읽고 반복된 표면어를 새 계층으로 세지 않는다. |
| <code>NicknameDisplay</code> / <code>NickNameDisplay</code> | 같은 개념이라면 원자 계층과 <code>Nick → Name</code> 분리가 충돌한다. 최신 구조의 의미를 확인한 뒤 한쪽으로 수렴할 대상이다. |
| <code>TitlehudStartButton</code> | 실제 구조가 <code>Title → Hud → Start → Button</code>이라면 <code>Titlehud</code>가 경계를 숨긴다. 리소스·프리팹 구조 확인이 먼저다. |
| <code>BarterStock</code> / <code>BarterStockRecord</code> | 두 이름이 각각 독립 선언으로 존재해 자동으로 한 축에 합치지 않았다. 같은 도메인 축인지 별도 역할 축인지 사람이 확인해야 한다. |
| <code>HeroEntity</code> 계열 | 과거 UI 트리의 좌표·표현 객체에서 쓰인 <code>Entity</code>이며 도메인 Entity 표로 옮기지 않았다. 레이어가 다르면 같은 종단어도 같은 역할로 합치지 않는다. |
| 숫자·문자 변형 축 | <code>Statistics2</code>, <code>Statistics3</code>, <code>BossMonsterA</code>처럼 실제 이름으로 남은 변형은 임의로 합치지 않았다. 숫자나 문자가 실제 리소스·스키마·변형 좌표인지 확인해야 한다. |
{:.naming-census-table}

이 표는 자동 개명 목록이 아니라 다음 개선을 위한 기준선이다. 이름을 바꾸기 전에는 직렬화, 프리팹, 데이터베이스, 네트워크 계약과 실제 소유 구조를 다시 추적해야 한다.
