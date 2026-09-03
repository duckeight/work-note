# Maro Repository AI 작업 지침

## 적용 범위

이 파일은 `maro-back/` 저장소 전체에 적용한다.

일반 작업은 각 모듈의 기존 구조와 사용자 요청을 따른다. 다만 어떤 모듈에서든 Blueprint 관련 작업을 수행할 때는 아래의 Blueprint 구현 계약을 추가로 반드시 따른다.

## Blueprint 문서 라우팅

다음 중 하나라도 해당하면 파일을 읽거나 수정하기 전에 아래 두 문서를 처음부터 끝까지 읽는다.

- 요청에 Blueprint, Aggregate Blueprint, Blueprint Binding 또는 Blueprint Profile이 언급된다.
- 코드가 `io.vizend.maro.domain.blueprint..`를 import하거나 새로 import한다.
- `AggregateBlueprint`, `AggregateBlueprintBinding`, `BlueprintProfile`을 조회·생성·변경한다.
- `AggregateBusinessSpecification`, `ResolvedAggregateModel`, `AggregateDataEventDefinition`을 입력 또는 출력으로 사용한다.
- Blueprint를 PiAggregate, PiEntity, 데이터 객체, Store, 이벤트 모델 또는 코드로 변환한다.
- Blueprint Resolver, Validator, Materializer, Application Service, API, Store, 테스트, 프롬프트 또는 문서를 만든다.
- Blueprint와 관련된 작업이 `maro-feature`, `maro-boot`, `maro-code-gen`, `maro-mcp`, HTTP 예제 또는 다른 모듈에서 수행된다.

필수 문서:

1. [`maro-domain/AGENTS.md`](./maro-domain/AGENTS.md)
2. [`maro-domain/BLUEPRINT_IMPLEMENTATION_GUIDE.md`](./maro-domain/BLUEPRINT_IMPLEMENTATION_GUIDE.md)

두 문서는 단순 참고 자료가 아니라 Blueprint 작업의 모델 계약과 완료 조건이다. 작업 대상이 `maro-domain` 밖에 있어도 동일하게 적용한다.

## 모든 모듈에 적용되는 Blueprint 제약

1. `io.vizend.maro.domain.blueprint`가 Blueprint 모델의 유일한 정의다. 다른 모듈에 같은 의미의 Blueprint 도메인 모델을 중복 정의하지 않는다.
2. 실제 Java 클래스명은 `ResolvedAggregateModel`이다. 편의를 위해 별도의 `ResolvedModel` 클래스를 만들지 않는다.
3. Blueprint는 Pit, Pr 또는 Pi 모델에 의존하지 않는다. 다른 모듈이 Blueprint를 소비하는 방향만 허용한다.
4. 공통 Aggregate 설계 기준은 `AggregateBlueprint`, 업무별 내용은 `AggregateBlueprintBinding`과 `AggregateBusinessSpecification`에 둔다.
5. `BlueprintProfile`은 독립 `StageEntity`다. 특정 Blueprint의 하위 객체로 저장하지 않는다.
6. Blueprint의 `AggregateDataEventPolicy`와 Binding의 `AggregateDataEventDefinition` 책임을 합치지 않는다.
7. 생성기와 실행 모듈은 검증된 `ResolvedAggregateModel`을 사용한다. 원본 업무 문장이나 Profile을 각 모듈에서 독자적으로 재해석하지 않는다.
8. Blueprint와 Profile의 ID·논리 키·버전 고정을 유지한다. 최신 버전으로 암묵 치환하지 않는다.
9. 다른 모듈 전용 DTO가 필요하면 전송 책임만 표현한다. Blueprint 핵심 의미, 검증 규칙 또는 버전 규칙을 DTO에 다시 정의하지 않는다.
10. 새로운 Blueprint 필드나 확장 개념을 소비 모듈에서 먼저 만들어 역으로 도메인 모델에 강요하지 않는다. 필요한 경우 구현 가이드의 변경 통제 절차를 따른다.
11. Blueprint와 `ResolvedAggregateModel`에는 최종 `lineageId` 또는 lineage 패턴을 두지 않는다. Blueprint 내부 참조는 `aggregateKey`, `entityKey`, `fieldKey`, `objectKey`를 사용한다.
12. Pi 모델의 최종 `lineageId`는 Geno 등록 시점에 실제 부모 모델의 lineage와 이름·경로로 생성한다. Materializer는 Pi CDO의 lineage를 비워 둔다.
13. Blueprint와 Binding은 PR에 소유되지 않는 독립 설계 자원이다. Blueprint와 Binding에 `prId`, `pitId`, `dramaId` 같은 runtime 소유 키를 추가하지 않는다.
14. Blueprint로 Pit IR을 동기화하면 `Pit.sourceBlueprintBindingId`에 참조한 Binding ID를 기록한다. PR snapshot은 이 값을 그대로 보존하며 새 PR을 이유로 새 Binding을 만들거나 source ID를 교체하지 않는다.
15. 새 PR에서 업무 설계를 변경하면 동일한 Binding의 업무 명세·입력·Profile 선택·해석 결과를 수정하고, 수정 직전과 직후의 해석 결과를 비교하여 해당 활성 Pit을 한 트랜잭션으로 동기화한다.
16. Binding 수정으로 `blueprintId/key/version` 또는 `aggregateName`을 교체하지 않는다. 공통 Blueprint 규칙의 새 버전은 별도 자원이며 기존 Binding에 암묵 적용하지 않는다.

## 모듈별 책임

- `maro-domain`: Blueprint Entity, CDO, ValueObject와 순수 검증 계약을 소유한다.
- `maro-feature`: Blueprint 조회·선택·해석·검증·적용 유스케이스를 조합할 수 있다. 도메인 모델을 복제하지 않는다.
- `maro-code-gen`: 검증된 해석 결과를 코드 산출물로 변환한다. 업무 명세를 다시 추론하지 않는다.
- `maro-boot`: API와 런타임 조립을 담당한다. Blueprint 규칙을 Controller나 설정에 중복 구현하지 않는다.
- `maro-mcp`: 도구 입출력을 Blueprint 계약에 연결한다. 임의 필드나 완화된 별도 스키마를 정본으로 만들지 않는다.
- 기타 모듈: Blueprint를 소비할 수 있지만 소유하거나 재정의하지 않는다.

## 다른 모듈 작업의 완료 조건

Blueprint를 사용하는 다른 모듈의 작업은 다음 조건을 모두 확인한다.

- 사용한 필드와 Enum이 `maro-domain`의 현재 Blueprint 모델에 실제로 존재한다.
- 입력 경계에서 ID·키·버전과 필수값을 검증한다.
- 업무별 값이 공통 Blueprint나 Profile에 저장되지 않는다.
- 해석 전 입력과 해석 후 모델을 혼용하지 않는다.
- 실패를 임의 기본값이나 최신 버전 대체로 숨기지 않는다.
- Blueprint 패키지로 향하는 의존만 추가했으며 역방향 의존은 만들지 않았다.
- Blueprint/Resolved 모델에 runtime lineage가 들어가지 않았고 Geno 등록 흐름에서 실제 부모 기반 lineage를 발급한다.
- Pit 생성·snapshot·projection에 `sourceBlueprintBindingId`가 보존되며 동일 Binding 수정·재동기화 경로가 동작한다.
- 관련 모듈 테스트와 `gradle :maro-domain:test`를 실행했다.

## 충돌 처리

사용자 요청, 현재 코드, 모듈별 구현과 Blueprint 문서가 충돌하면 추측으로 해결하지 않는다. 충돌하는 필드, 책임 또는 의존 방향을 구체적으로 제시하고 사용자에게 기준을 확인한다.
