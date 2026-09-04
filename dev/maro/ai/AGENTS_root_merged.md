# Maro Repository Blueprint Binding 및 VM3 Materialization AI 작업 지침

## 적용 범위와 문서 우선순위

이 파일은 `maro-back/` 저장소 전체에 적용한다.

일반 작업은 사용자 요청과 각 모듈의 기존 구조를 따른다. 어떤 모듈에서든 Blueprint, BlueprintBinding, VM3 모델 또는 관련 Materializer를 설계하거나 구현할 때는 이 문서를 추가로 적용한다.

이 문서는 기존 저장소 공통 규칙과 BlueprintBinding 파이프라인 규칙을 통합한 지침이다. 두 규칙이 겹치거나 충돌하면 다음 원칙을 우선한다.

1. 기존 Maro 단계 순서를 유지한다.
2. 완료된 Binding revision은 불변 스냅샷으로 취급한다.
3. 변경 중인 상태는 DesignWork, Candidate 또는 AuthoringSession에 둔다.
4. 업무 변경은 완료 Binding을 직접 수정하지 않고 새 revision으로 확정한다.
5. 다음 단계는 Binding이 아니라 Materialize된 기존 VM3를 소비한다.

### Blueprint 문서 라우팅

다음 중 하나라도 해당하면 파일을 읽거나 수정하기 전에 아래 필수 문서를 처음부터 끝까지 읽는다.

- 요청에 Blueprint, Aggregate Blueprint, Blueprint Binding 또는 Blueprint Profile이 언급된다.
- 코드가 `io.vizend.maro.domain.blueprint..`를 import하거나 새로 import한다.
- `AggregateBlueprint`, `AggregateBlueprintBinding`, `BlueprintProfile`을 조회·생성·변경한다.
- `AggregateBusinessSpecification`, `ResolvedAggregateModel`, `AggregateDataEventDefinition`을 입력 또는 출력으로 사용한다.
- Blueprint를 PiAggregate, PiEntity, 데이터 객체, Store, 이벤트 모델 또는 코드로 변환한다.
- Blueprint Resolver, Validator, Materializer, Application Service, API, Store, 테스트, 프롬프트 또는 문서를 만든다.
- 관련 작업이 `maro-feature`, `maro-boot`, `maro-code-gen`, `maro-mcp`, HTTP 예제 또는 다른 모듈에서 수행된다.

필수 문서:

1. [`maro-domain/AGENTS.md`](./maro-domain/AGENTS.md)
2. [`maro-domain/BLUEPRINT_IMPLEMENTATION_GUIDE.md`](./maro-domain/BLUEPRINT_IMPLEMENTATION_GUIDE.md)

두 문서는 단순 참고 자료가 아니라 Blueprint 작업의 모델 계약과 완료 조건이다. 작업 대상이 `maro-domain` 밖에 있어도 동일하게 적용한다.

## 1. 목표

기존 Maro 작업 순서를 유지하면서 각 단계의 완료 산출물을 BlueprintBinding으로 먼저 확정하고, 그 Binding으로부터 기존 Maro Meta Model인 VM3를 생성한다.

```text
단계별 사용자 작업
→ 완료된 BlueprintBinding
→ VM3 Materialization
→ 기존 VM3 모델
→ 다음 Maro 단계
```

다음 단계는 앞 단계의 BlueprintBinding을 직접 소비하지 않는다. 다음 단계는 기존과 동일하게 Materialize된 VM3를 소비한다.

예:

```text
Geno 작업 완료
→ GenoBlueprintBindingSet
→ Pit/Pi* VM3 생성
→ Moti가 Pit/Pi*를 입력으로 사용
→ TrackBlueprintBinding 생성
→ WiTrack/WiBeat/WiPulse/WiArchive VM3 생성
```

## 2. 핵심 용어

### Blueprint

재사용 가능한 생성 규칙이다. 특정 Scene, Aggregate, Feature 또는 API의 실제 설계값을 직접 소유하지 않는다.

### BlueprintBinding

특정 업무에 Blueprint를 적용한 완료된 설계 결정의 불변 스냅샷이다. 입력, Profile, Logic, 대상 Contract, 검증 결과와 버전을 가진다.

### DesignWork 또는 AuthoringSession

사용자와 AI가 설계 중인 변경 가능한 작업 상태이다. 미해결 질문, 후보 Entity, 후보 Operation, 임시 API와 검증 오류를 보관한다.

### VM3

기존 Maro Meta Model이다. 예를 들면 `Pit`, `PiAggregate`, `PiEntity`, `PiFeature`, `PiFacade`, `WiTrack`, `AtScene` 등이 있다.

### Materialization

완료된 BlueprintBinding을 기존 VM3 엔티티로 변환하는 과정이다. VM3는 Binding의 파생 결과이며 다음 단계와 기존 코드의 호환 인터페이스다.

## 3. 절대 규칙

1. 기존 Maro 단계 순서를 변경하지 않는다.
2. Blueprint 정의와 BlueprintBinding을 혼동하지 않는다.
3. 사용자 작업 중인 상태를 정식 BlueprintBinding에 저장하지 않는다.
4. 정식 Binding은 resolve 및 validation이 끝난 뒤 생성한다.
5. AggregateBinding이 FacadeBinding, FeatureBinding 또는 MoveBinding을 소유하게 하지 않는다.
6. Geno 완료 시 관련 Binding을 하나의 논리적 묶음으로 함께 확정한다.
7. 단계 간 전달은 기존 VM3를 통해 수행한다.
8. 모든 VM3 산출물은 원본 Binding과 Materialization을 역추적할 수 있어야 한다.
9. Materializer는 동일 Binding 버전에 대해 멱등적이어야 한다.
10. 화면 필드나 API 필드를 무조건 Entity 필드로 만들지 않는다.
11. Facade가 Move, Store 또는 Aggregate를 직접 호출하게 만들지 않는다.
12. Move가 Aggregate 내부 필드를 직접 변경하게 만들지 않는다. 공개된 Aggregate Operation Contract만 호출한다.
13. Feature에 HTTP, REST, MCP, Broker 같은 외부 Protocol 정보를 넣지 않는다.
14. Aggregate에 Scene, Track, URL, Role별 화면 권한 같은 외부 표현 정보를 넣지 않는다.
15. `io.vizend.maro.domain.blueprint`를 Blueprint 도메인 모델의 유일한 정의로 사용한다. 다른 모듈에 같은 의미의 모델을 중복 정의하지 않는다.
16. 실제 Java 클래스명은 `ResolvedAggregateModel`이다. 편의를 위한 별도 `ResolvedModel` 클래스를 만들지 않는다.
17. Blueprint 도메인 모델은 Pit, Pr 또는 Pi 모델에 의존하지 않는다. 소비 모듈이 Blueprint를 의존하는 단방향만 허용한다.
18. 공통 Aggregate 설계 기준은 `AggregateBlueprint`, 업무별 내용은 `AggregateBlueprintBinding`과 `AggregateBusinessSpecification`에 둔다.
19. `BlueprintProfile`은 독립 `StageEntity`다. 특정 Blueprint의 하위 객체로 저장하지 않는다.
20. `AggregateDataEventPolicy`와 `AggregateDataEventDefinition`의 책임을 합치지 않는다.
21. 생성기와 실행 모듈은 검증된 `ResolvedAggregateModel`을 사용한다. 원본 업무 문장이나 Profile을 각 모듈에서 독자적으로 다시 해석하지 않는다.
22. Blueprint와 Profile의 ID, 논리 키와 버전을 명시적으로 고정한다. 최신 버전으로 암묵 치환하지 않는다.
23. 전송 전용 DTO에 Blueprint의 핵심 의미, 검증 규칙 또는 버전 규칙을 다시 정의하지 않는다.
24. 새로운 Blueprint 필드나 확장 개념을 소비 모듈에서 먼저 만들어 도메인 모델에 역으로 강요하지 않는다.
25. Blueprint, Binding과 `ResolvedAggregateModel`에 최종 `lineageId` 또는 lineage 패턴을 두지 않는다. 내부 참조에는 `aggregateKey`, `entityKey`, `fieldKey`, `objectKey` 같은 의미 키를 사용한다.
26. Blueprint와 Binding은 PR에 소유되지 않는 독립 설계 자원이다. `prId`, `pitId`, `dramaId` 같은 runtime 소유 키를 추가하지 않는다. 적용 Context의 논리 참조는 소유 키와 구분한다.
27. Pit 생성 시 `Pit.sourceBlueprintBindingId`에 실제 사용한 Binding revision의 ID를 기록하고 snapshot과 projection에서 보존한다.
28. 완료된 Binding revision을 수정하지 않는다. 업무 변경은 같은 논리 Binding 계보의 새 revision으로 확정하며, 업무 변경이 없으면 새 PR에서도 기존 revision을 그대로 재사용한다.
29. 새 revision 생성으로 `blueprintId`, Blueprint key/version 또는 `aggregateName`을 몰래 교체하지 않는다. 공통 Blueprint의 새 버전은 별도 자원이며 명시적으로 선택한다.

## 4. 기존 Maro 단계와 Blueprint 매핑

### 4.1 Arc의 Scene 설계

기존 입력 및 VM3:

- `Kollex`
- `AtEpisode`
- `AtEpisodeRole`
- `AtAct`
- `AtScene`
- `AtScenePage`
- `AtGroundBay`
- `AtDramaBay`

적용 BlueprintBinding:

```text
SceneBlueprintBinding
├─ contextBinding
├─ pageBindings[]
├─ bayBindings[]
├─ trackArchetypeBindings[]
├─ roleMappingBindings[]
├─ capabilityRequirements[]
├─ navigationBindings[]
├─ stateBindings[]
└─ eventRouteBindings[]
```

`Kollex`, `AtEpisode`, `AtEpisodeRole`, `AtAct`는 기본적으로 Scene Blueprint의 상위 Context다. SceneBinding이 이들 전체를 소유하거나 다시 정의하게 만들지 않는다.

Scene이 먼저 만들어져 아직 Geno/Moti 산출물이 없다면 물리 VM3 ID 대신 안정적인 `capabilityKey`, `roleKey`, `trackRequirementKey` 또는 lineage 기반 논리 참조를 사용한다.

### 4.2 Drama 설정

`Drama`와 `DramaRole`은 여러 Blueprint가 공유하는 적용 Context다.

```text
Drama
├─ AggregateBinding 적용 대상
├─ FacadeBinding 서비스 경계
├─ SceneBinding targetDramaRef
└─ TrackBinding targetDramaRef

DramaRole
├─ EpisodeRole과 매핑
└─ Facade audience/authorization 입력
```

별도 명세 없이 `Drama`와 `DramaRole`을 AggregateBlueprintBinding에 포함하지 않는다.

### 4.3 Geno의 Pit 설계

Geno 사용자 작업이 끝나면 다음 Binding들을 한 번에 확정한다.

```text
GenoBlueprintBindingSet
├─ aggregateBindings[]
├─ facadeBindings[]
├─ featureBindings[]
├─ moveBindings[]
├─ queryModelBindings[]   // 필요한 경우
├─ historyBindings[]      // 필요한 경우
├─ eventBindings[]        // 필요한 경우
├─ validationResult
└─ materializationPlan
```

`GenoBlueprintBindingSet`은 원자적인 작업 결과와 교차 검증 경계다. 각 Binding의 책임을 합친 거대한 Binding으로 구현하지 않는다.

### 4.4 Moti의 Track 설계

Moti는 Materialize된 Geno VM3를 기존과 동일하게 사용한다.

```text
Moti 입력
├─ Pit
├─ PiEntity
├─ PiFeature
├─ PiFacade
├─ PiCommandRequest
├─ PiFetchRequest
└─ PiQueryRequest
```

Moti 작업 완료 산출물은 다음과 같이 표현한다.

```text
TrackBlueprintBinding
├─ targetPitRef
├─ targetEntityRefs[]
├─ targetFeatureRefs[]
├─ facadeContractRefs[]
├─ archetypeRef
├─ compositionTemplateRef
├─ propertyBindings[]
├─ beatBindings[]
├─ pulseBindings[]
├─ presentationBinding
├─ eventContracts[]
└─ generatedSources[]
```

Materialization 결과는 `Wings`, `WiTrack`, `WiBeat`, `WiPulse`, `WiArchive`다. 문서의 Wings 용어를 엄격히 적용해야 하는 문맥에서는 `TrackArchetypeBinding`이라는 이름도 검토한다.

## 5. Geno Binding별 기존 VM3 매핑

### 5.1 AggregateBlueprintBinding

다음 기존 VM3를 책임진다.

```text
Pit의 Domain 영역
├─ PiDomain
├─ PiAggregate
├─ PiEntity
├─ PiField
├─ PiEntityVo
├─ PiEntityCdo
├─ PiEntityUdo
├─ PiEntityDdo
├─ PiEntityFdo
├─ PiEntityRdo
└─ PiOptionStore
```

Aggregate 하나당 `AggregateBlueprintBinding` 하나를 만든다. 하나의 Pit에 여러 Aggregate가 있으면 여러 Binding을 만든다.

AggregateBinding은 다음 Contract를 출력해야 한다.

- Current Truth 모델
- Aggregate Root와 Child Entity 구조
- Value Object와 Enum
- ID, 소유 관계와 Version
- Aggregate Operation Contract
- Invariant와 State Transition
- CDO, UDO, DDO 계약
- Store와 Persistence 계약
- Data Event Contract

### 5.2 FacadeBlueprintBinding

다음 기존 VM3를 책임진다.

```text
PiFacade
├─ PiCommandRequest
├─ PiFetchRequest
└─ PiQueryRequest
```

Facade Operation의 입력은 Channel, Audience, Role, 요청 유형, 외부 계약과 Feature Operation 참조다.

```text
Command Request → Command Facade Operation
Fetch Request   → Fetch Facade Operation
Query Request   → Query Facade Operation
```

Facade Operation 하나는 Feature Operation 하나만 호출한다.

### 5.3 FeatureBlueprintBinding

다음 기존 VM3를 책임진다.

```text
PiFeature
├─ PiFlow
├─ PiSeek
├─ PiLoad
├─ PiFeatureMethod
├─ PiFeatureCdo/Udo/Ddo/Fdo/Rdo/Sdo
└─ PiFeatureVo
```

매핑 규칙:

```text
COMMAND → Flow Feature
FETCH   → Seek Feature
QUERY   → Load Feature
EVENT   → Grab Feature
```

Feature는 UseCase 목적, 의미 기반 입력/출력, Transaction, Context, 실패 및 보상 정책과 MoveComposition을 가진다.

### 5.4 MoveBlueprintBinding

기존 VM3에는 독립적인 Move 엔티티가 없다. 다음 기존 정보를 명시적 Move로 승격한다.

```text
PiFeatureMethod.body
PiFeatureMethod.description
PiFeatureMethod.relatedEntity
Logic 호출 순서
조건문과 분기
외부 호출
결과 변환 및 조립
```

단순 CRUD 메서드는 최초 전환 시 하나의 Action Move로 만들 수 있다.

```text
return productLogic.registerProduct(productCdo);

→ RegisterProductActionMoveBinding
  ├─ input = ProductCdo
  ├─ output = String
  ├─ targetAggregateRef = Product
  ├─ targetOperationRef = registerProduct
  └─ effectType = WRITE
```

여러 호출, 조건, 변환이 있으면 하나의 Move로 숨기지 않고 MoveComposition으로 분리한다.

```text
FeatureOperationBinding
└─ MoveComposition
   ├─ OwnershipCheckMove
   ├─ AvailabilityCheckMove
   ├─ ActionMove
   └─ ResponseAssembleMove
```

## 6. Geno 완료 시 생성 순서

사용자에게 보이는 기존 설계 순서를 유지한다. 정식 Binding은 Geno 완료 시점에 작업 모델 전체로부터 함께 만든다.

```text
GenoDesignWork
├─ UseCase와 Role
├─ API 요구
├─ Feature와 Flow/Seek/Load 설계
├─ Logic 설명
├─ Entity/Field/VO 설계
└─ Store 및 정책
        ↓ 완료 요청
Binding Candidate들을 메모리에서 구성
        ↓
결정적 ID와 ContractRef 할당
        ↓
Aggregate Contract resolve
        ↓
Move target resolve
        ↓
Feature MoveComposition resolve
        ↓
Facade featureOperationRef resolve
        ↓
교차 검증
        ↓
GenoBlueprintBindingSet 원자적 저장
        ↓
VM3 Materialization
```

앞에서 설계된 API와 Feature가 Entity 구조를 그대로 결정하게 만들지 않는다. 모든 사용자 입력을 함께 분석한 후 Aggregate 경계와 현재 상태를 확정한다.

## 7. BlueprintBinding 상태 규칙

정식 Binding은 편집 중인 객체가 아니다. 기본적으로 `DRAFT` 상태를 추가하지 않는다.

```text
GenoDesignWork.status
├─ EDITING
├─ READY_FOR_VALIDATION
├─ VALIDATION_FAILED
└─ COMPLETED

AggregateBlueprintBinding
└─ 완료된 불변 스냅샷
```

부분 저장이 반드시 필요하다면 정식 Binding이 아니라 다음처럼 별도 이름을 사용한다.

- `AggregateBlueprintBindingDraft`
- `GenoBindingCandidate`
- `BlueprintAuthoringSession`

완료된 Binding과 작업 중인 Candidate가 동일 Repository와 조회 API에서 섞이지 않게 한다.

Binding 생성과 VM3 생성 상태도 분리한다.

```text
Vm3Materialization
├─ PENDING
├─ RUNNING
├─ SUCCEEDED
└─ FAILED
```

Materialization이 실패해도 확정 Binding은 보존하고 동일 Binding 버전으로 재시도할 수 있어야 한다.

## 8. VM3 Materialization 규칙

### 8.1 Materialization 단위

AggregateBinding 하나가 Pit 전체를 소유하지 않는다. Pit은 여러 Binding 결과를 묶는 Container다.

```text
PitMaterializationPlan
├─ pitIdentity
├─ aggregateBindingRefs[]
├─ facadeBindingRefs[]
├─ featureBindingRefs[]
├─ moveBindingRefs[]
├─ optionalBlueprintBindingRefs[]
└─ generationOptions
```

### 8.2 권장 VM3 생성 순서

외래 참조와 기존 Geno 규약을 고려해 다음 순서를 기본으로 한다.

```text
Pit
→ PiDomain
→ PiAggregate[]
→ PiEntity/PiEntityVo/PiField
→ PiEntity CDO/UDO/DDO/FDO/RDO/OptionStore
→ PiFeature
→ PiFlow/PiSeek/PiLoad
→ PiFacade
→ PiCommand/PiFetch/PiQueryRequest
→ PiFeature SDO/VO 및 Method
→ lineage 및 교차 참조 검증
```

구현상 더 안전한 순서가 확인되면 내부 순서는 조정할 수 있지만 외부 단계 순서와 결과 의미는 변경하지 않는다.

### 8.3 출처 추적

모든 Materialization은 다음 정보를 기록한다.

```text
BlueprintMaterialization
├─ materializationId
├─ bindingSetId
├─ bindingId
├─ bindingVersion
├─ blueprintVersion
├─ generatorVersion
├─ generatedEntries[]
├─ status
└─ error

BlueprintMaterializationEntry
├─ materializationId
├─ bindingId
├─ vm3Type
├─ vm3Id
└─ lineageId
```

기존 VM3 엔티티에 출처 필드를 직접 추가하기 어렵다면 별도 매핑 Entity를 사용한다.

`BlueprintMaterializationEntry.lineageId`는 생성된 VM3 결과를 역추적하기 위한 값이다. 이를 Blueprint, Binding 또는 `ResolvedAggregateModel`의 입력이나 소유 필드로 역전파하지 않는다.

Pi 모델의 최종 `lineageId`는 기존 Geno 등록 흐름에서 실제 부모 모델의 lineage와 이름·경로를 기준으로 발급한다. Materializer는 Pi CDO의 lineage를 비워 두고, 등록 결과를 `BlueprintMaterializationEntry`에 기록한다.

### 8.4 재생성

- 완료된 Binding은 수정하지 않는다.
- 변경 시 새로운 `bindingVersion`을 만든다.
- 이전 Materialization과 새 Binding을 비교하여 Create, Update, Remove 계획을 만든다.
- 자동 생성 영역과 사용자 구현 영역을 구분한다.
- 사용자 Move 및 확장 Logic은 재생성 시 보존한다.
- Materialize된 VM3의 직접 수정은 원칙적으로 금지한다.
- 기존 API가 VM3 직접 수정을 요구하면 변경을 Binding revision으로 역투영하거나 명시적인 호환 모드로 격리한다.

### 8.5 PR과 Binding revision

PR은 Blueprint 또는 Binding의 소유자가 아니다. PR은 특정 시점에 선택된 Binding revision으로 생성한 Pit snapshot을 소비한다.

```text
새 PR + 업무 설계 변경 없음
→ 기존 Binding revision 재사용
→ 기존 sourceBlueprintBindingId 보존

새 PR + 업무 설계 변경 있음
→ DesignWork에서 변경
→ 이전/신규 ResolvedAggregateModel diff
→ 같은 논리 Binding 계보의 새 revision 확정
→ 활성 Pit을 한 트랜잭션으로 동기화
→ 새 sourceBlueprintBindingId 기록
```

Aggregate의 정체성이나 Blueprint 선택 자체가 바뀌는 변경은 단순 revision으로 숨기지 않는다. 새 논리 Binding이 필요한지 명시적으로 판단한다.

## 9. 참조 규칙

단계가 아직 생성되지 않은 대상을 참조해야 하면 물리 ID를 추측하지 않는다. 결정적인 논리 키를 사용한다.

```text
capability://{drama}/{role}/{purpose}/{requestType}
feature://{drama}/{feature}/{role}/{operation}
move://{drama}/{feature}/{operation}/{movePurpose}
aggregate://{drama}/{aggregate}
aggregate-operation://{drama}/{aggregate}/{operation}
track://{wings}/{subject}/{archetype}
```

같은 입력은 같은 논리 키를 만들어야 한다. 실제 Binding ID와 VM3 ID는 별도 Resolver와 Materialization mapping으로 연결한다.

순환 소유 관계를 만들지 않는다.

```text
FacadeOperationBinding → FeatureOperationBinding
FeatureOperationBinding → MoveComposition
MoveBlueprintBinding    → 공개 Domain Contract
History/Query/Event     → Aggregate DataEventContract
TrackBlueprintBinding   → Materialize된 Geno VM3 또는 공개 Facade Contract
```

AggregateBinding은 자신을 소비하는 Facade, Feature, Query, History, Event 또는 Track을 알지 않는다.

## 10. 필드 배치 규칙

Scene, API 또는 Feature 입력에 등장하는 필드를 다음 기준으로 분류한다.

| 의미 | 배치 대상 |
|---|---|
| 현재 업무 상태로 저장되고 불변식에 사용 | Aggregate Entity |
| Entity 식별값 | Aggregate/Entity ID |
| 함께 불변성을 갖는 값 묶음 | Value Object |
| 생성·변경·삭제 입력 | CDO/UDO/DDO |
| 요청 제어용 임시값 | Facade Request 또는 Feature SDO |
| 화면 표시 전용 조합값 | Feature RDO 또는 Query Model |
| 검색·정렬·통계·Projection 값 | Query Model |
| Actor/Tenant/Stage/Trace | Context |
| 외부 호출 권한 | Facade Authorization 또는 Check Move |
| 계산·변환 결과 | Calculate/Transform/Assemble Move |
| 변경 추적 | Data Event 및 History |

`pageSize`, `sortDirection`, `selectedTab`, `confirmPassword` 같은 값을 화면에 존재한다는 이유만으로 Entity 필드로 생성하지 않는다.

## 11. Role 책임 규칙

```text
EpisodeRole
→ Scene 접근 및 화면 권한

EpisodeRole-DramaRole Mapping
→ 프런트 역할을 백엔드 역할로 변환

DramaRole
→ Facade Operation 호출 권한

Feature.roleContext
→ Role에 따라 업무 흐름 자체가 달라질 때만 사용

Aggregate
→ 원칙적으로 화면 Role을 모름
```

인증 및 외부 접근 권한은 Facade에서 처리한다. 업무상 불변식은 Aggregate에서 처리한다. 업무 실행 가능 조건은 Check Move에서 처리한다.

## 12. Query, History, Event 생성 조건

### QueryModelBlueprintBinding

목록, 검색, 통계, 여러 Aggregate 조합 또는 Projection이 필요할 때 생성한다. `PiQueryRequest`가 있다는 이유만으로 무조건 별도 Query Model을 만들지 않는다.

### HistoryBlueprintBinding

Entity 변경 이력, 시점 조회, Lifecycle 또는 감사 추적이 필요할 때 생성한다. AggregateBinding의 DataEventContract를 참조한다.

### EventBlueprintBinding

업무 변화를 외부 Drama, Broker 또는 서비스에 발행해야 할 때 생성한다. 내부 Data Event와 외부 Domain Event를 구분한다.

## 13. 구현 규칙

### 13.1 모듈별 책임

- `maro-domain`: Blueprint Entity, CDO, ValueObject와 순수 검증 계약을 소유한다.
- `maro-feature`: Blueprint 조회, 선택, 해석, 검증과 적용 유스케이스를 조합한다. 도메인 모델을 복제하지 않는다.
- `maro-code-gen`: 검증된 해석 결과를 코드 산출물로 변환한다. 업무 명세를 다시 추론하지 않는다.
- `maro-boot`: API와 런타임 조립을 담당한다. Blueprint 규칙을 Controller나 설정에 중복 구현하지 않는다.
- `maro-mcp`: 도구 입출력을 Blueprint 계약에 연결한다. 임의 필드나 완화된 별도 스키마를 정본으로 만들지 않는다.
- 기타 모듈: Blueprint를 소비할 수 있지만 소유하거나 재정의하지 않는다.

### 13.2 공통 구현 원칙

- 기존 코드와 동일한 `StageEntity`, CDO, VO, Logic, Store 패턴을 우선 따른다.
- Blueprint domain entity에 코드 생성, Repository 접근 또는 외부 API 호출 로직을 넣지 않는다.
- 검증 규칙은 Validator 또는 Domain Policy로 분리한다.
- Materialization은 별도의 Application Flow/Action/Service에서 수행한다.
- 동일 의미의 Enum, VO, ValidationResult를 중복 생성하지 않는다.
- `maro-back`의 기존 Geno/Moti/Arc VM3 구조를 호환 대상의 기준으로 삼는다.
- 이름만 동일한 클래스를 자동으로 동일 Contract라고 판단하지 않는다. lineage, binding version과 semantic key를 확인한다.
- 기존 사용자 변경과 무관한 파일을 수정하지 않는다.
- 모델 변경 시 관련 CDO, Store, JPO, Repository, 테스트의 영향을 확인한다.
- 해석 전 입력과 해석 후 모델을 같은 계약처럼 혼용하지 않는다.
- 실패를 임의 기본값이나 최신 버전 대체로 숨기지 않는다.
- 입력 경계에서 ID, 논리 키, 버전과 필수값을 검증한다.

## 14. 필수 검증

### BindingSet 검증

- 모든 Facade Operation이 정확히 하나의 Feature Operation을 참조한다.
- 모든 Feature Operation이 유효한 MoveComposition을 가진다.
- 모든 Action Move가 존재하는 Aggregate Operation을 참조한다.
- Move 사이 Input/Output 타입이 호환된다.
- Read-only Feature에 WRITE Move가 없다.
- Aggregate마다 Root가 정확히 하나다.
- 모든 Child Entity가 하나의 Root에 소유된다.
- 모든 Entity가 ID를 가진다.
- 추적 대상 Entity의 Version을 결정할 수 있다.
- Role 및 Context 참조가 resolve된다.
- Scene capability requirement가 Facade Operation으로 충족된다.

### Materialization 검증

- 동일 Binding 버전 재실행 결과가 중복 생성되지 않는다.
- 생성된 모든 VM3가 Binding으로 역추적된다.
- 새 Binding 버전 적용 시 lineage가 유지된다.
- 실패 후 재시도가 가능하다.
- 일부 VM3만 생성된 상태가 외부에 완료로 노출되지 않는다.
- Moti가 생성된 Pit/Pi*를 기존 방식으로 조회할 수 있다.
- Track Materialization 후 Scene/Bay와 Facade 연결을 추적할 수 있다.

## 15. 테스트 요구사항

새 Blueprint 모델이나 Materializer를 구현할 때 최소한 다음 테스트를 추가한다.

1. BlueprintBinding 생성 및 JSON round-trip 테스트
2. 필수 입력 누락 검증 테스트
3. Aggregate-Facade-Feature-Move 교차 참조 테스트
4. 기존 Pi 모델로의 Materialization 테스트
5. Materializer 멱등성 테스트
6. Binding 버전 변경에 대한 diff 테스트
7. Materialization 실패 및 재시도 테스트
8. VM3에서 source Binding을 찾는 provenance 테스트
9. 기존 Geno 출력과의 호환성 테스트
10. 생성된 Pit을 입력으로 하는 Moti 연결 테스트
11. Blueprint/Resolved 모델에 runtime lineage가 들어가지 않는지 검증하는 테스트
12. Pit 생성, snapshot과 projection에서 `sourceBlueprintBindingId`가 보존되는지 검증하는 테스트

관련 범위에 맞는 모듈 테스트와 `gradle :maro-domain:test`를 실행한다. 실행할 수 없다면 그 이유와 미검증 범위를 결과에 명시한다.

## 16. AI 작업 완료 체크리스트

AI는 구현 또는 설계 변경을 완료하기 전에 다음 질문에 답해야 한다.

- 이 모델은 Blueprint 정의인가, 완료된 Binding인가, 작업 중인 DesignWork인가?
- 기존 Maro 단계 순서를 유지하는가?
- 다음 단계가 Binding이 아니라 Materialize된 VM3를 소비하는가?
- Aggregate, Facade, Feature, Move의 책임이 섞이지 않았는가?
- Geno 완료 결과가 하나의 BindingSet으로 교차 검증되는가?
- 기존 VM3와 새 Binding 사이의 매핑이 명확한가?
- 재생성과 버전 변경 시 사용자 구현이 보존되는가?
- 모든 산출물의 lineage와 source Binding을 추적할 수 있는가?
- 실패 시 Binding을 이용해 안전하게 재시도할 수 있는가?
- 업무 변경이 없는 새 PR이 기존 Binding revision을 재사용하는가?
- 업무 변경이 완료 Binding 수정이 아니라 새 revision으로 표현되는가?
- Blueprint와 Resolved 모델이 runtime lineage나 PR/Pit 소유 키를 갖지 않는가?
- 사용한 필드와 Enum이 `maro-domain`의 현재 계약에 실제로 존재하는가?

위 질문 중 하나라도 답할 수 없다면 코드를 생성하기 전에 설계를 보완한다.

## 17. 충돌 처리

이 문서가 이미 명시적으로 통합한 충돌은 완료 Binding 불변성과 revision 규칙을 따른다. 그 밖에 사용자 요청, 현재 코드, 모듈별 구현 또는 참조 문서가 충돌하면 추측으로 해결하지 않는다. 충돌하는 필드, 책임, 버전 또는 의존 방향을 구체적으로 제시하고 사용자에게 기준을 확인한다.

## 18. 참조 문서

- `/Users/nextree_kyj/develop/vizend/docs/maro/blueprint/VM3-Aggregate-Blueprint-Spec_260901.pdf`
- `/Users/nextree_kyj/develop/vizend/docs/maro/blueprint/VM3-Blueprint-And-Scene-Blueprint-Spec_260831.pdf`
- `/Users/nextree_kyj/develop/vizend/docs/maro/blueprint/VM3-Facade-Feature-Move-Blueprint-Spec_260831.pdf`
- 기존 호환 VM3 구현: `/Users/nextree_kyj/develop/vizend/maro/maro-back/maro-domain`
- Blueprint 구현 가이드: `/Users/nextree_kyj/develop/vizend/maro/maro-back/maro-domain/BLUEPRINT_IMPLEMENTATION_GUIDE.md`
