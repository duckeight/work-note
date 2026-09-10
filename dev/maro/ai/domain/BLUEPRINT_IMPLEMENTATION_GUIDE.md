# Blueprint 구현 가이드

[루트 지침](../AGENTS.md)의 Binding 흐름과 [domain 제약](AGENTS.md)을 전제로 한다.
정확한 필드·타입은 현재 Entity/CDO/Validator/Resolver/JPO에서 확인한다.

## 1. 입력과 해석

1. 선택한 Blueprint의 ID/key/version과 실행 가능한 입력·해석 규칙을 검증한다. 최신 버전으로 암묵 치환하지 않는다.
2. ProfileSelection의 ID/key/version·활성·적용 범위를 검증한다. 현재 Aggregate Resolver는 Aggregate Profile을 지원한다.
3. `AggregateBlueprint.standardInputVersion`의 서버 표준 schema, `AggregateBlueprint.inputDefinitions`의 추가 정의와 선택된 `BlueprintProfile.inputDefinitions`를 합성해 입력 계약으로 삼는다. Profile은 Blueprint에 없는 새 키를 정의할 수 있다. Binding의 inputBindings에는 확정된 값을 보존하며 최초 공급 경로를 저장하지 않는다.
4. 우선순위는 고정값 → 사용자 입력 → Profile 값 → Blueprint 기본값 → 계산값이다. 같은 Profile에서는 parameter가 default보다 우선하며 Profile 간 priority 동률의 상이한 값은 실패시킨다.
5. inputDefault/parameter/직접 입력은 합성된 계약에 선언된 키여야 한다. 선택하지 않은 Profile의 정의는 포함하지 않는다. 같은 키를 여러 소유자가 재정의하면 오류로 처리하며, 기본값 변경은 inputDefaults로 표현한다. Profile 전용 입력에도 필수값·타입·cardinality·출처 검증을 동일하게 적용한다.
6. unknown/중복 키, 누락, 타입, cardinality와 validation rule을 검증한다. Resolver가 자동으로 공급하는 값은 allowedSources도 검증하지만, Binding으로 제출된 확정값은 출처를 재분류하지 않는다.
7. 표준 의미 키를 해석하고, 명시 입력이 없는 ID·Version·SDO는 Resolver 공통 규칙으로 생성한다. 기본 ID는 id/String 및 UUID 전략, 버전은 entityVersion/long이다. 입력한 식별자·버전·SDO 설계가 우선하며 Blueprint별 생성 템플릿은 두지 않는다.
8. Root 유일성, Child 소유 관계/순환, ID/Version, 의미 키 유일성, Operation/Field/SDO/상태 전이/불변식 및 이벤트 계약을 검증한다.
9. 검증된 ResolvedAggregateModel과 이벤트 계약을 Binding에 저장하고 Materializer에 전달한다. Materializer가 업무 문장/Profile을 다시 해석하지 않는다.

업무 입력은 `inputBindings`로만 받는다. `inputDefinitions`는 String/Integer/Boolean/Object와 재귀 properties로 구조를 정의하며 Many로 반복한다. 도메인 Java 클래스명을 valueType으로 등록하거나 별도 businessSpecification/businessInputMappings를 두지 않는다. 하위 입력의 required/type/cardinality/allowedValues/default/fixed를 검증한다. 수정 요청은 저장된 기본값·고정값을 포함해 그대로 제출하며, 다른 기본값을 적용하려면 해당 입력을 명시적으로 생략해 재해석한다. 표준 업무 설계 입력은 시스템 schema가 선언하며 Profile parameter/default로 공급하지 않는다.

SDO는 cdoDefinitions/udoDefinitions/ddoDefinitions/rdoDefinitions/fdoDefinitions로 지정한다. 생략/null은 Resolver 기본 생성, 명시 목록은 Aggregate 전체의 해당 역할 교체, 빈 목록은 생성 안 함이다. entityRef로 연결하며 inline과 별도 목록의 동일 속성 중복은 거부한다.

기술 입력은 aggregateModelVersion/entityType/modelType/storeType 표준 키로 읽는다. 잠금·트랜잭션·이벤트 payload/발행 시점·삭제 정책 기본값은 inputDefinitions.defaultValue 또는 선택한 Profile에서 공급한다. 기본 SDO는 CDO, UDO, DDO, 단건·목록 RDO/FDO이며 명시 SDO 목록의 우선순위를 유지한다. Resolver 기본 규칙 변경은 모든 Blueprint의 재해석에 영향을 주며, 이미 생성한 Pi는 명시적 재적용 전까지 유지한다.

Binding은 필수·불변 edificeId를 가진다. piAggregateId는 서버가 생성·복사·삭제 시 관리하는 nullable 물리 ID다. Blueprint/Profile은 Edifice·PR과 독립적으로 재사용한다.

Binding 상태는 Draft/Validated/Resolved/Failed다. VM3 생성에는 검증을 통과한 Resolved Binding만 사용한다.
Blueprint의 입력 schema와 업무별 해석 결과를 혼동하지 않는다. Binding에 저장된 현재 해석 결과는 별도 PR별 snapshot이나 변경 이력이 아니다.

### 생성 패키지

생성 코드의 루트 패키지는 프로젝트 설정의 `groupId`와 Drama 이름으로 결정한다. 이는 Aggregate별 업무 입력이 아니므로 Blueprint/Profile Input Definition, Binding, ResolvedAggregateModel 및 PiAggregate/PiFeature에 `packagePath`를 두지 않는다.

### Aggregate와 Profile의 책임

- Aggregate Blueprint는 경계·Root/Child·Value Object/Group·식별/소유·상태 전이·불변식·CUD/업무 행위·CDO/UDO/DDO·Operation/Logic 확장점·Store/Persistence·Aggregate/Entity Version·내부 Data Event·History/Query/Event용 변경 Source·모델/코드 생성 계획을 정의하는 계약이다. 업무별 실제 설계값은 Binding에 결합한다.
- Profile은 Structure, Command Input, Persistence, Versioning, Context, Data Event 등 반복되는 구현·운영 정책과 필요한 입력을 제공한다. 업무 경계·상태 전이·불변식을 결정하지 않는다.
- History Blueprint를 쓰는 Aggregate는 TransactionalDataEventProfile + HistoryCompatibleDataEventProfile을 기본 적용 대상으로 설계한다. 실제 Profile 자원·History 생성기 존재 여부는 별도로 확인하며 이름만으로 자동 구현되었다고 가정하지 않는다.
- Profile 입력 추가만으로 Entity 필드나 새 정책 실행 로직을 만들지 않는다. 현재 Resolver의 지원 정책 경로·리터럴 값 범위를 지키고, 미지원 정책/표현식은 오류로 처리한다.

domain Logic·Store는 다른 패키지의 Vista 생성 CRUD·단건/목록/페이지 조회·이벤트 발행 패턴을 그대로 유지하며 custom 업무 동작을 추가하지 않는다. 서비스 Bean 호출 방향은 `Flow/Seek → Action(Task 등 실행 컴포넌트) → Logic`으로 제한한다. Flow/Seek 간 호출, Action에서 Flow/Seek 호출, Flow/Seek에서 Logic·Store 직접 호출을 금지한다. 공통 동작은 Action에서 공유하며 Action 간 조합은 순환 없이 허용한다. Logic에서 feature 서비스를 호출하지 않는다. BlueprintAggregateAppFlow/AppSeek는 Action을 호출하는 API 진입점이다. 참조 삭제 제한·해석·동기화 조합은 BlueprintAggregateAction, Binding 등록 검증·수정·생성 모델 연결/해제·PR 복사 매핑은 BlueprintAggregateBindingAction, Edifice 범위 조회는 BlueprintAggregateQueryAction에 둔다. Blueprint 생성기의 기존 Geno Flow 호출은 유지해 등록 검증과 lineage 발급을 재사용한다. 현재 계층 정리·검증 범위는 Blueprint Flow/Seek와 Blueprint feature 서비스를 호출하는 부분이다. Geno 등 다른 기존 서비스 호출 관계는 유지하며 이 규칙 적용을 이유로 일괄 리팩터링하지 않는다. PiAggregate 삭제 시 Action에서 먼저 연결을 해제하며 생성 PiAggregateLogic에는 Blueprint 의존을 추가하지 않는다.

## 2. Binding 조회

- Aggregate Binding은 필수 `edificeId`로 조회하며, Binding 자체가 검증 결과와 상태를 보관한다.
- `findAggregateBlueprintBindingsByPit`은 해당 Pit의 실제 PiAggregate ID 목록으로 Binding의 `piAggregateId`를 역조회한다. 일치하는 Binding이 없으면 빈 목록을 반환한다.
- 여러 Aggregate Binding은 같은 Pit에서 서로 다른 PiAggregate를 만든다. UI는 조회된 Binding을 선택하며 직접 Binding ID 조회도 유지한다.
- Binding의 `piAggregateId`가 있을 때만 삭제를 거부한다. 별도 출처·적용 이력 자원은 만들지 않는다.

## 3. 생성·수정·트랜잭션

1. 선택 PR의 활성 상태와 Drama의 PR 소속, Binding의 `edificeId` 일치를 확인한다.
2. 현재 생성기는 Aggregate Binding을 처리한다. Move/Feature/Facade 등의 생성은 미지원 오류로 중단한다.
3. Pit → PiDomain → PiAggregate → Entity/Field/VO/SDO/Store를 기존 Geno 등록 흐름으로 생성한다. Pi CDO lineage는 비워 두고 실제 부모를 기준으로 발급한다.
   - StageEntity/DomainEntity에서 상속되는 `id`, `entityVersion`, 감사 필드 및 StageEntity의 `requesterKey/stageId/pavilionId`는 PiField로 중복 생성하지 않는다. Blueprint의 설계 필드·ID/버전 참조와 SDO 입력은 보존하며, 대상 Entity 타입의 실제 상속 필드 이름으로만 제외한다. CustomEntity/DataEntity의 동명 필드나 업무별 ID/버전 이름을 역할만으로 제거하지 않는다.
4. 생성·동기화는 Binding의 `piAggregateId`와 선택한 실제 PiAggregate ID가 일치할 때만 기존 모델을 채택한다. 수동 모델이나 다른 Aggregate를 채택하지 않는다.
5. reviseBindingAndSynchronizePitIr은 수정 전 해석 모델을 메모리에 보관하고 Binding 수정과 선택 Pit 동기화를 한 트랜잭션으로 처리한다. AppFlow의 생성 API는 `generatePitIr(bindingId, prId, dramaId)`, 동기화 API는 `reviseBindingAndSynchronizePitIr(...)`다. 내부 생성기는 `BlueprintPitIrGenerationAction.generate(binding, prId, dramaId)`와 `synchronize(binding, previousModel, prId, dramaId)`를 사용한다. 카탈로그 modifyBinding은 같은 Binding 설계만 갱신한다.
6. 생성·동기화는 PR/Pit 및 부모 물리 ID로 범위를 제한한다. 유지 대상 ID/lineage, 수동 모델과 사용자 구현을 보존하며 동일 입력 반복 적용으로 중복 생성하지 않는다.
7. 실패 시 트랜잭션을 롤백하고 불완전 VM3를 완료로 노출하지 않는다. 별도 성공/실패 이력 저장이 구현됐다고 주장하지 않는다.

현재 수정 전·후 해석 모델 비교 방식의 한계를 숨기지 않는다. 카탈로그 수정 후 나중에 적용하는 경우처럼 실제 Pit과 비교 기준이 달라질 수 있는 변경은 별도 검증 없이 안전하다고 단정하지 않는다.

## 4. PR 이월과 단계 경계

- 새 PR은 직전 최신 PR의 Pit/Pi를 새 물리 ID로 복사하고 실제 복사 ID map으로 Binding의 현재 `piAggregateId`만 갱신한다. Pi에는 출처 필드를 추가하지 않는다.
- Blueprint/Binding을 PR별로 복제하지 않으며 같은 ID를 재사용한다. 새 PR 생성만으로 Binding을 재해석하지 않는다.
- 같은 PR 수정·재적용은 허용하며 새 PR 적용은 해당 복사본만 바꾼다. 이전 PR의 VM3 데이터는 유지한다.
- Moti는 생성된 Pit/PiEntity/PiFeature/PiFacade 등 VM3를 소비한다. 앞 단계 Binding을 직접 읽는 파이프라인으로 바꾸지 않는다.
- 향후 Geno 계약 해석 순서는 Aggregate → Move → Feature → Facade다. Facade는 Feature 하나, Feature는 MoveComposition, Move는 공개 Aggregate Operation을 참조한다.

## 5. 완료 검증

변경 범위에 맞춰 다음을 확인한다.

- Blueprint/Profile 입력 합성·우선순위·출처·타입·unknown/누락 거부.
- Profile 전용 키의 직접 입력/파라미터/기본값·선택 입력 null·목록값, 미선택 Profile 거부·정의 중복 거부, Profile 입력 정의 JPO round-trip.
- Binding JSON 및 JPO round-trip의 ProfileSelection·해석 결과 보존.
- Aggregate Binding 생성·미지원 종류 거부.
- 같은 Binding 수정, 선택 Pit 동기화, 반복 적용 멱등성과 실패 롤백.
- Pit 생성·JPO·projection·PR 복사에서 Binding의 현재 piAggregateId 연결과 이전 PR 데이터 격리.
- 기존 Geno 및 다음 단계 VM3 소비 호환성.

domain 테스트와 영향받은 feature/facade/store-jpa 테스트를 실행한다. NO-SOURCE, 미실행 DB 통합 테스트·migration·History 연동은 구분해 보고한다.
기존 DB 자료는 승인 없이 삭제하거나 변환하지 않는다.
Profile 입력 정의 저장에는 BLUEPRINT_PROFILE의 inputDefinitionsJson에 대응하는 TEXT 컬럼이 필요하다. 기존 DB의 컬럼명 규칙과 schema 관리 방식을 확인하고 배포 시 별도로 반영한다.
구 계약 호환 분기나 데이터 이관을 추가하지 않는다.

## 6. 표준 Aggregate 입력 schema

- `standardInputVersion`은 Blueprint에 저장하는 불변 계약 버전이며 생성 기본값은 1이다. 미지원 버전은 거부한다. Blueprint의 업무별 버전과 별개이며 Binding은 선택 Blueprint를 통해 같은 표준 계약을 따른다.
- `maro-domain/src/main/resources/blueprint/aggregate-inputs-v1.json`이 공통 39개 입력의 단일 정본이다. 이미 발행한 버전은 수정하지 않고 새 버전을 추가한다.
- `inputDefinitions`에는 표준에 없는 추가 입력만 둔다. null/빈 목록 모두 추가 입력 없음이며 표준 입력은 항상 제공된다. 표준 키·Blueprint 추가 키·선택 Profile 키 간 중복 선언은 거부한다.
- `AggregateBlueprintInputSchema.compose`를 조회 API와 Resolver가 함께 호출한다. 클라이언트는 합성 계약으로 폼을 구성하고 전체 schema를 Blueprint 생성 입력에 다시 보내지 않는다.
- 공통 입력 제공은 모든 값의 입력 의무가 아니다. 선택 입력이 생략되고 기본값도 없으면 Binding에 빈 값을 추가하지 않는다. 명시 null과 빈 목록은 보존하며 SDO 역할의 생략/null(기본 생성)과 [](생성 안 함)을 구분한다. 기본값과 고정값은 기존 우선순위에 따라 해석·저장한다.
- Aggregate 생성에 필수인 aggregateName/aggregateRootRef/entityDefinitions와 명시한 중첩 항목 내부의 필수값 검증은 유지한다.
- 영속성에 AGGREGATE_BLUEPRINT.standardInputVersion 정수 컬럼이 필요하다. SQL seed는 standard_input_version=1, input_definitions_json=[]로 등록한다. 기존 DB 수정·호환 변환은 자동 수행하지 않는다.
