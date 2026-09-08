# Blueprint 구현 가이드

[루트 지침](../AGENTS.md)의 BindingSet 흐름과 [domain 제약](AGENTS.md)을 전제로 한다.
정확한 필드·타입은 현재 Entity/CDO/Validator/Resolver/JPO에서 확인한다.

## 1. 입력과 해석

1. 선택한 Blueprint의 ID/key/version과 실행 가능한 입력·해석 규칙을 검증한다. 최신 버전으로 암묵 치환하지 않는다.
2. ProfileSelection의 ID/key/version·활성·적용 범위를 검증한다. 현재 Aggregate Resolver는 Aggregate Profile을 지원한다.
3. `AggregateBlueprint.inputDefinitions`와 선택된 `BlueprintProfile.inputDefinitions`를 합성해 입력 계약으로 삼는다. Profile은 Blueprint에 없는 새 키를 정의할 수 있다. Binding의 inputBindings에는 직접 입력·Profile 파라미터·기본값·계산값을 모두 보존한다.
4. 우선순위는 고정값 → 사용자 입력 → Profile 값 → Blueprint 기본값 → 계산값이다. 같은 Profile에서는 parameter가 default보다 우선하며 Profile 간 priority 동률의 상이한 값은 실패시킨다.
5. inputDefault/parameter/직접 입력은 합성된 계약에 선언된 키여야 한다. 선택하지 않은 Profile의 정의는 포함하지 않는다. 같은 키를 여러 소유자가 재정의하면 오류로 처리하며, 기본값 변경은 inputDefaults로 표현한다. Profile 전용 입력에도 필수값·타입·cardinality·출처 검증을 동일하게 적용한다.
6. unknown/중복 키, 누락, 타입, cardinality, allowedSources와 validation rule을 검증한다. 클라이언트 직접 입력은 Selected 또는 출처 생략만 허용하며 Migrated는 지원하지 않는다.
7. resolutionDefinition의 매핑·Entity ID/Version 규칙·SDO 템플릿으로 해석한다. Blueprint key별 코드 분기나 임의 템플릿으로 규칙 누락을 숨기지 않는다.
8. Root 유일성, Child 소유 관계/순환, ID/Version, 의미 키 유일성, Operation/Field/SDO/상태 전이/불변식 및 이벤트 계약을 검증한다.
9. 검증된 ResolvedAggregateModel과 이벤트 계약을 Binding에 저장하고 Materializer에 전달한다. Materializer가 업무 문장/Profile을 다시 해석하지 않는다.

Binding 상태는 Draft/Validated/Resolved/Failed다. VM3 생성에는 검증을 통과한 Resolved Binding만 사용한다.
Blueprint의 입력 schema와 업무별 해석 결과를 혼동하지 않는다. Binding에 저장된 현재 해석 결과는 별도 PR별 snapshot이나 변경 이력이 아니다.

### Aggregate와 Profile의 책임

- Aggregate Blueprint는 경계·Root/Child·Value Object/Group·식별/소유·상태 전이·불변식·CUD/업무 행위·CDO/UDO/DDO·Operation/Logic 확장점·Store/Persistence·Aggregate/Entity Version·내부 Data Event·History/Query/Event용 변경 Source·모델/코드 생성 계획을 정의하는 계약이다. 업무별 실제 설계값은 Binding에 결합한다.
- Profile은 Structure, Command Input, Persistence, Versioning, Context, Data Event 등 반복되는 구현·운영 정책과 필요한 입력을 제공한다. 업무 경계·상태 전이·불변식을 결정하지 않는다.
- History Blueprint를 쓰는 Aggregate는 TransactionalDataEventProfile + HistoryCompatibleDataEventProfile을 기본 적용 대상으로 설계한다. 실제 Profile 자원·History 생성기 존재 여부는 별도로 확인하며 이름만으로 자동 구현되었다고 가정하지 않는다.
- Profile 입력 추가만으로 Entity 필드나 새 정책 실행 로직을 만들지 않는다. 현재 Resolver의 지원 정책 경로·리터럴 값 범위를 지키고, 미지원 정책/표현식은 오류로 처리한다.

## 2. BindingSet과 조회

- MsBlueprintBindingSet은 bindingSetKey, Aggregate/Move/Feature/Facade/QueryModel/History/Event Binding ID 목록, validationResult와 status를 보관한다.
- 구성원은 ID로 참조하며 Aggregate 목록은 조회 시 transient aggregateBindings로 해석한다. 다른 종류의 모델·생성기는 현재 미구현이므로 목록만 보고 구현 완료로 간주하지 않는다.
- 현재 MsBlueprintBindingSetLogic은 Aggregate 구성원의 존재·Resolved 상태·설계 유효성을 검증한다. 미래 종류가 추가되면 공개 ContractRef의 교차 검증도 구현한다.
- 개별 Aggregate 생성 API도 속한 Set을 찾거나 최초 Aggregate-only Set을 만든 뒤 Set Flow에 위임한다. 개별 Binding으로 Pit Materializer를 직접 호출하지 않는다.
- Binding이 여러 Set에 속하면 단일 Set을 추측하지 않는다. 현재 단일 API는 모호성을 오류로 처리한다.
- 미적용 Binding은 Binding ID/카탈로그로 조회·수정한다. 생성 후 Pit 조회는 sourceMsBlueprintBindingSetId → Set → Binding을 따른다. Aggregate가 여러 개인 Set을 단일 Binding으로 임의 축약하지 않는다.
- Set 참조가 있는 Binding은 삭제할 수 없지만 같은 ID의 설계 수정은 가능하다. 별도 Context·적용 이력 Entity/API를 만들지 않는다.

## 3. 생성·수정·트랜잭션

1. 선택 PR의 활성 상태와 Drama의 PR 소속을 확인한다. Resolved Set과 구성원 검증을 통과한 뒤 생성한다.
2. 현재 생성기는 Aggregate-only Set을 처리한다. Move/Feature/Facade 등의 구성원이 있으면 미지원 오류로 중단한다.
3. Pit → PiDomain → PiAggregate → Entity/Field/VO/SDO/Store를 기존 Geno 등록 흐름으로 생성한다. Pi CDO lineage는 비워 두고 실제 부모를 기준으로 발급한다.
4. Pit의 sourceMsBlueprintBindingSetId를 기록한다. 다른 Set이 이미 출처인 Pit에 덮어쓰지 않는다.
5. 카탈로그 modifyBinding은 같은 Binding 설계만 갱신한다. reviseBindingAndSynchronizePitIr은 수정 전 ResolvedAggregateModel을 메모리에 보관하고 수정·선택 Pit 동기화를 한 트랜잭션으로 수행한다.
6. 생성·동기화는 PR/Pit 및 부모 물리 ID로 범위를 제한한다. 유지 대상 ID/lineage, 수동 모델과 사용자 구현을 보존하며 동일 입력 반복 적용으로 중복 생성하지 않는다.
7. 실패 시 트랜잭션을 롤백하고 불완전 VM3를 완료로 노출하지 않는다. 별도 성공/실패 이력 저장이 구현됐다고 주장하지 않는다.

현재 수정 전·후 해석 모델 비교 방식의 한계를 숨기지 않는다. 카탈로그 수정 후 나중에 적용하는 경우처럼 실제 Pit과 비교 기준이 달라질 수 있는 변경은 별도 검증 없이 안전하다고 단정하지 않는다.

## 4. PR 이월과 단계 경계

- 새 PR은 직전 최신 PR의 Pit/Pi를 새 물리 ID로 복사하고 lineage와 sourceMsBlueprintBindingSetId를 보존한다.
- Blueprint/Binding/Set을 PR별로 복제하지 않으며 같은 ID를 재사용한다. 새 PR 생성만으로 Binding을 재해석하지 않는다.
- 같은 PR 수정·재적용은 허용하며 새 PR 적용은 해당 복사본만 바꾼다. 이전 PR의 VM3 데이터는 유지한다.
- Moti는 생성된 Pit/PiEntity/PiFeature/PiFacade 등 VM3를 소비한다. 앞 단계 Binding을 직접 읽는 파이프라인으로 바꾸지 않는다.
- 향후 Geno 계약 해석 순서는 Aggregate → Move → Feature → Facade다. Facade는 Feature 하나, Feature는 MoveComposition, Move는 공개 Aggregate Operation을 참조한다.

## 5. 완료 검증

변경 범위에 맞춰 다음을 확인한다.

- Blueprint/Profile 입력 합성·우선순위·출처·타입·unknown/누락 거부.
- Profile 전용 키의 직접 입력/파라미터/기본값·선택 입력 null·목록값, 미선택 Profile 거부·정의 중복 거부, Profile 입력 정의 JPO round-trip.
- Binding JSON 및 JPO round-trip의 ProfileSelection·해석 결과 보존.
- Set 구성 검증·Aggregate-only 생성·미지원 종류 거부.
- 같은 Binding 수정, 선택 Pit 동기화, 반복 적용 멱등성과 실패 롤백.
- Pit 생성·JPO·projection·PR 복사에서 Set 출처 보존과 이전 PR 데이터 격리.
- 기존 Geno 및 다음 단계 VM3 소비 호환성.

domain 테스트와 영향받은 feature/facade/store-jpa 테스트를 실행한다. NO-SOURCE, 미실행 DB 통합 테스트·migration·History 연동은 구분해 보고한다.
기존 DB 자료는 승인 없이 삭제하거나 변환하지 않는다.
Profile 입력 정의 저장에는 BLUEPRINT_PROFILE의 inputDefinitionsJson에 대응하는 TEXT 컬럼이 필요하다. 기존 DB의 컬럼명 규칙과 schema 관리 방식을 확인하고 배포 시 별도로 반영한다.
기존 JSON/DB에 Migrated 입력 출처가 남아 있다면 배포 전에 확인한다. 의미 확인 없이 Selected 등으로 자동 치환하지 않는다.
