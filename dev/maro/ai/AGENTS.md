# Maro Domain 작업 지침

이 모듈은 [루트 AGENTS](../AGENTS.md)를 따른다. 공통 흐름·PR 격리·경량 AI 위임 규칙은 중복 정의하지 않는다.
Blueprint 관련 작업에서는 [구현 가이드](BLUEPRINT_IMPLEMENTATION_GUIDE.md)를 끝까지 읽는다.

## 모델 제약

- Blueprint 모델의 유일한 정의는 `io.vizend.maro.domain.blueprint`다. 소비 모듈에 같은 의미의 Entity/VO/Enum을 만들지 않는다.
- Blueprint 패키지는 Geno/Pit/Pr 클래스를 import하지 않는다. 생성·적용 영역이 Blueprint를 의존하는 단방향을 유지한다.
- Blueprint/Binding/BindingSet에는 PR/Pit/Drama 소유 키를 넣지 않는다. Pit에서 Set ID를 출처로 참조한다.
- 독립 StageEntity 탐색 관계는 ID + transient 객체로 표현한다. Set의 타입별 ID 목록은 영속 구성원 참조이며 `aggregateBindings`는 조회용 transient 관계다. 미래 Facade/Feature/Move 탐색 관계도 해당 모델 구현 후 transient로 추가한다.
- `resolvedAggregateModel`과 `resolvedDataEventContract`는 현재 Binding/JPO의 영속 설계 결과다. 원본 `businessSpecification`을 해석 결과로 덮어쓰지 않는다.
- 최종 클래스명은 `ResolvedAggregateModel`이다. 별도 ResolvedModel이나 Context/Materialization 모델을 추가하지 않는다.
- `BlueprintProfile`은 독립 StageEntity이며 `ProfileSelection` 사용을 유지한다. Blueprint와 Profile 모두 공통 VO인 BlueprintInputDefinition으로 입력을 정의한다. Profile은 Blueprint에 없는 구현·운영 입력 키도 추가할 수 있다.
- ProfileInputDefault는 Blueprint 또는 선택한 Profile이 정의한 키에 제공하는 기본값이며 입력 정의 자체가 아니다. Profile inputDefinitions는 Entity/CDO/JPO에서 함께 보존한다.
- `inputBindings`는 두 종류의 입력 정의에 사용자 값·Profile 파라미터·기본값을 결합한 결과다. 출처는 `valueSource/resolvedBy`로 구분한다. 입력값을 업무 Entity 필드로 자동 승격하지 않는다.
- `BlueprintValueSource`는 Fixed/Selected/Inferred/Defaulted/Computed를 사용한다. 삭제한 Migrated를 코드·예제에 다시 추가하지 않는다.
- `AggregateDataEventPolicy`는 공통 허용 기준, `AggregateDataEventDefinition`은 해석 이벤트 계약이다. 두 책임을 합치지 않는다.
- Blueprint/Binding/Resolved 모델에는 runtime lineage나 패턴을 넣지 않는다. 내부 참조는 의미 키, 최종 lineage 발급은 실제 부모가 존재하는 Geno 등록 흐름의 책임이다.
- domain Entity에 Repository 접근·코드 생성·외부 호출을 넣지 않는다. 새 필드/확장은 책임·검증·생성 영향이 정의된 경우에만 추가한다.

## 변경과 검증

- 기존 필드·주석과 Entity/CDO/Validator/JPO를 함께 확인한다. 형제 `../maro-domain/maro-domain`은 요청 없이 수정하지 않는다.
- 코드 변경 시 `gradle :maro-domain:compileJava :maro-domain:test`와 영향받는 모듈의 관련 테스트를 실행한다.
- 입력/Profile 해석, BindingSet 검증·조회·JPO round-trip, Pit 출처 보존, 같은 Binding 수정과 PR 격리를 변경 범위에 맞게 검증한다.
- 금지 import, 깨진 참조, 무관한 변경을 확인한다. NO-SOURCE와 실제 실행 테스트를 구분한다.
