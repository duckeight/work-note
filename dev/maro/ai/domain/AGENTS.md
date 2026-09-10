# Maro Domain AI 작업 지침

## 적용 범위

이 파일은 `maro-domain/` 아래의 모든 작업에 적용한다.

`io.vizend.maro.domain.blueprint` 패키지를 생성·수정·리뷰하는 작업에서는 다음 문서를 작업 전에 처음부터 끝까지 반드시 읽는다.

- [`BLUEPRINT_IMPLEMENTATION_GUIDE.md`](./BLUEPRINT_IMPLEMENTATION_GUIDE.md)

이 문서와 실제 코드가 충돌하면 임의로 한쪽을 맞추지 않는다. 차이를 사용자에게 보고하고 어느 쪽을 기준으로 할지 확인한다. 사용자의 현재 요청이 이 문서보다 우선한다.

## Blueprint 작업의 필수 제약

1. Blueprint는 Pit을 만들기 위한 선행 설계도다. Pit, Pr 또는 이미 생성된 Pi 모델이 존재한다고 가정해서 설계하지 않는다.
2. `io.vizend.maro.domain.blueprint..`에서는 다음 패키지를 import하지 않는다.
   - `io.vizend.maro.domain.geno..`
   - Pit 또는 Pr을 정의하는 모든 패키지
3. 의존 방향은 `blueprint <- 생성/적용 영역`이어야 한다. `AggregateBlueprintMaterializer`는 Blueprint를 참조할 수 있지만 Blueprint가 Materializer나 Pi 모델을 참조해서는 안 된다.
4. `AggregateBlueprint`에는 업무별 이름, 주문·결제 같은 도메인 용어, 업무 Entity 구조 또는 업무별 이벤트 결합 경로를 넣지 않는다.
5. 업무별 내용은 `AggregateBlueprintBinding.inputBindings`와 해석 결과에 둔다. 버전 고정 시스템 표준 schema와 Blueprint 추가 `inputDefinitions.properties`로 입력 구조를 정의하고 Resolver가 표준 의미 키로 내부 업무 설계를 조립하며 별도 `businessSpecification` 입력·저장 경로는 두지 않는다.
6. `BlueprintProfile`은 독립 `StageEntity`다. Blueprint의 하위 객체로 만들거나 Blueprint ID를 Profile의 소유 키로 추가하지 않는다.
7. 독립 `StageEntity` 사이의 객체 탐색 관계는 `transient`로 선언한다. ID·논리 키·버전 스냅샷이 영속성과 재현성의 기준이다.
8. Binding이 소유하는 입력값과 해석 결과는 영속 설계값이므로 일반 필드로 유지한다. Resolver 내부 DTO인 `AggregateBusinessSpecification`을 Binding 필드로 추가하지 않는다.
9. `AggregateDataEventPolicy`는 Blueprint의 공통 허용 기준이고, `AggregateDataEventDefinition`은 Binding별로 확정된 이벤트 계약이다. 두 책임을 합치지 않는다.
10. `ResolvedAggregateModel`만 Pi 모델 생성의 입력으로 사용한다. 원본 업무 문장이나 Profile을 Materializer에서 다시 추론하지 않는다.
11. 버전이 지정된 Blueprint와 Profile을 현재 활성 버전으로 암묵 치환하지 않는다.
12. 구체적인 Spec, Resolver, 검증 규칙과 테스트가 없는 후보 필드를 활성화하지 않는다.
13. 주석 처리된 필드, 사용되지 않는 임시 필드, 미해결 `TODO`를 완성 코드에 남기지 않는다.
14. 기존 사용자 변경과 무관한 파일을 수정하지 않는다.
15. Blueprint 및 Binding의 해석 결과에는 Pi의 최종 `lineageId`나 lineage 패턴을 넣지 않는다. Blueprint 내부 설계 참조는 자체 논리 키로 연결한다.
16. Pi CDO를 만드는 Materializer는 lineage를 지정하지 않는다. 실제 부모가 존재하는 Geno 등록 시점에서 `LineageKeyBuilder`로 발급한다.
17. Pi 모델은 Blueprint Binding 출처를 보관하지 않는다. Blueprint domain이 Pit/Pi 클래스를 import하지 않으며 Binding의 현재 생성 모델 참조만 문자열 `piAggregateId`로 보관한다.
18. Blueprint/Profile은 공용이고 Binding은 `edificeId`가 필수인 Edifice 소유 `StageEntity`다. PR 복사 시 같은 Binding ID를 유지하고 실제 복사 ID 맵으로 현재 생성 모델 참조만 갱신한다. edificeId는 수정할 수 없으며 PR/Pit/Drama 소유 필드를 중복 저장하지 않는다.
19. ID·Version·SDO 자동 생성은 Resolver의 공통 규칙이며 Blueprint에 별도 생성 규칙 필드를 두지 않는다. 명시 입력을 우선하고 기술·정책 입력 기본값은 inputDefinitions/Profile에서 공급한다.
20. domain Logic·Store는 Vista 생성 CRUD·조회·이벤트 패턴을 유지한다. 추가 업무 동작은 feature Action에 구현하고 generated 메서드에 끼워 넣지 않는다.
21. 업무 설계 변경은 같은 Binding의 변경 가능한 설계 필드를 수정한다. `blueprintId/key/version`과 `aggregateName`은 Binding 정체성이므로 수정하지 않는다.
22. 서비스 Bean 호출 방향은 `Flow/Seek → Action(Task 등 실행 컴포넌트) → Logic`으로 제한한다. Flow/Seek 간 호출, Action에서 Flow/Seek 호출, Flow/Seek에서 Logic·Store 직접 호출을 금지한다. 공통 동작은 Action에서 공유하며 Action 간 조합은 순환 없이 허용한다. Logic에서 feature 서비스를 호출하지 않는다.

23. 현재 계층 정리·검증 범위는 Blueprint Flow/Seek와 Blueprint feature 서비스를 호출하는 부분이다. Geno 등 다른 기존 서비스 호출 관계는 유지하며 이 규칙 적용을 이유로 일괄 리팩터링하지 않는다.

## 변경 절차

Blueprint 관련 변경은 다음 순서로 수행한다.

1. `git status --short`로 기존 변경을 확인한다.
2. 저장소 루트 기준 `../maro-domain/maro-domain`이 존재하면 그곳의 Blueprint 모델을 구조 기준선으로 비교한다.
3. 구현 가이드의 핵심 모델 필드 화이트리스트와 금지 의존성을 확인한다.
4. 변경 사항을 공통 설계 기준, 업무별 Binding, Profile, 해석 결과, 생성 어댑터 중 하나로 분류한다.
5. Entity 필드를 변경하면 대응 CDO, 생성자 복사, 검증기와 테스트를 함께 확인한다.
6. 참조 키를 추가하면 대상 존재성, 버전 고정, 중복과 순환 참조 검증을 추가한다.
7. 해석 결과를 변경하면 `AggregateBlueprintValidator`와 `AggregateBlueprintMaterializer`의 영향을 확인한다.
8. 아래 검증 명령을 실행하고 실패 원인을 해결한다.
9. 변경 파일, 설계 결정, 검증 결과와 남은 위험을 사용자에게 보고한다.

## 완료 조건

다음 조건을 모두 만족하기 전에는 작업을 완료했다고 보고하지 않는다.

- Blueprint 패키지에서 Geno, Pit, Pr 의존성이 검출되지 않는다.
- 핵심 StageEntity의 관계 필드와 식별자 필드가 구현 가이드의 계약과 일치한다.
- 업무별 값이 `AggregateBlueprint`나 `BlueprintProfile`에 새어 들어가지 않는다.
- Binding 입력 검증과 최종 설계 검증이 분리되어 실행된다.
- 동일한 버전 고정 입력에 대해 생성 결과가 결정적이다.
- Blueprint 모델과 해석 결과에 runtime lineage 필드가 없다.
- 주석 처리된 필드와 미해결 `TODO`가 없다.
- `gradle :maro-domain:compileJava`가 성공한다.
- Blueprint 모델 또는 Materializer를 변경했다면 `gradle :maro-domain:test`가 성공한다.

## 필수 검증 명령

```bash
rg -n "io\.vizend\.maro\.domain\.geno|import .*\.Pit;|import .*\.Pr;" \
  maro-domain/src/main/java/io/vizend/maro/domain/blueprint

rg -n "^\s*//\s*(private|protected|public|transient).*;|TODO|FIXME" \
  maro-domain/src/main/java/io/vizend/maro/domain/blueprint \
  maro-feature/src/main/java/io/vizend/maro/feature/blueprint/action/AggregateBlueprintMaterializer.java

gradle :maro-domain:compileJava
gradle :maro-domain:test
gradle :maro-feature:test --tests io.vizend.maro.feature.blueprint.aggregate.action.AggregateBlueprintMaterializerTest
```

첫 번째와 두 번째 `rg` 명령은 검색 결과가 없어야 정상이다.

24. AggregateBlueprint는 불변 standardInputVersion을 저장한다. 공통 입력 정의는 버전별 classpath JSON에 한 번만 선언하며 inputDefinitions에는 추가 키만 저장한다. AggregateBlueprintInputSchema.compose가 표준·추가·선택 Profile 입력을 합성하고 중복을 거부한다. 표준 schema는 Binding 값이나 Blueprint DB row에 복제하지 않는다.
