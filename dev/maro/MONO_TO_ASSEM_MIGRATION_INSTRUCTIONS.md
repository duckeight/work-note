# Mono → Assem 작성·생성 책임 이전 작업 지시서

## 1. 작업 목적과 사용자 결정

기존 Mono가 담당하던 데이터 해석, LLM 상세화, 생성 실행을 Assem으로 이전한다.
Mono는 Assem이 구체화한 데이터의 validation을 담당한다.

사용자의 요청은 다음과 같다.

> 기존 Mono의 데이터 해석 및 generation을 Assem이 맡고, Assem에 LLM을 도입한다.
> Mono는 Assem이 구체화한 데이터의 validation을 담당하도록 변경한다.
> Domain Entity, Logic, Store 생성은 기존 기능을 최대한 재사용하여 이전한다.

이 문서를 받은 작업자는 실제 코드를 확인한 후 이 책임 이전을 구현하고 검증한다.
분석이나 계획만 작성하고 종료하지 않는다. 다만 아래의 추가 개발 범위와 이전 완료 범위를 구분한다.

### 기준과 사용 방법

- 작성일: 2026-09-28
- 분석 저장소: `maro-back`
- 지시서 작성 시 브랜치/HEAD: `main` / `c089ea193`
- 이 지시서 이전 조사에서는 소스 변경, 실제 생성, 빌드·테스트를 실행하지 않았다.
- 다른 PC에서는 현재 checkout과 이 기준의 차이를 먼저 확인한다. 기준 커밋으로 강제 되돌리지 않는다.
- 모든 경로는 `maro-back` 루트 기준이다. 원래 PC의 절대 경로는 사용하지 않는다.
- 적용되는 `AGENTS.md`와 저장소 지침을 먼저 읽고 사용자의 기존 변경을 보존한다.
- 외부 HTML 문서가 없어도 이 파일로 작업을 진행할 수 있도록 필요한 결정을 포함했다.
- 같은 PC에 별도 `maro-domain`, `maro-front` 저장소가 있다면 실제 모듈 연결·작업 지침을 확인한다. 동일 소스를 추정하여 복사하거나 동기화하지 않는다.

## 2. 구현할 책임 경계

| 영역 | 변경 후 책임 |
|---|---|
| Assem | Pillar/PR 문맥 확보, 사용자 입력·대화, LLM 해석, 초안 작성, 보정·재시도, 참조 후보 선택, 업무 로직 상세화, 생성 실행과 결과 추적 |
| Mono | 의미·타입·참조·규칙·생성 준비 상태 검사, 오류/미해결 항목 반환, 검증 결과와 대상 버전 추적 |
| Geno/Moti/Arc | 각각의 실제 모델과 등록·조회 기능, 모델 자체의 무결성 보장 |
| 기존 코드 생성기 | 확정 모델을 Entity·Logic·Store·API 등의 실제 소스 파일로 출력 |

목표 흐름:

```text
Assem: 업무 의도 + Pillar/PR 문맥
  → LLM/기존 패턴으로 구체화된 초안 작성
  → Entity/타입/참조/API/업무 본문 및 생성 계획 확정
Mono: 해당 후보의 의미·참조·타입·지원 여부 검증
  → 실패: Assem이 오류에 해당하는 부분 수정 후 재검증
  → 통과: 검증 대상 버전/내용과 참조 기준선 고정
Assem: 검증한 결과의 등록·투영 실행
  → Geno/Moti/Arc의 기존 등록 기능 호출
  → 기존 코드 생성기로 소스 출력
  → 빌드·계약 테스트 결과 기록
```

- Assem이 생성 책임을 가진다는 것은 생성 라이브러리와 Geno 모델을 모두 Assem 패키지로 복사한다는 뜻이 아니다.
- Mono 검증은 작성 내용을 조용히 수정하거나 LLM을 호출하지 않는다. 수정은 Assem에서 수행한다.
- Geno 등록 단계의 PR 범위 검사, 중복·충돌 검사와 DB 무결성 검사는 유지한다. 모든 방어 코드를 Mono로 몰아넣지 않는다.
- 검증 이후에는 LLM이 업무 의미를 새로 해석하거나 새 본문을 생성하면 안 된다. 변경이 필요하면 새 후보를 만들어 다시 검증한다.
- 검증 결과 저장과 승인 이력은 Mono에 남길 수 있다. 순수 검사 자체와 검증 기록 저장을 구분한다.
- 실제 코드 생성과 외부 저장소 게시·병합은 별도 행동이다. 이번 작업을 검증하기 위해 기존 publish/complete 경로를 실행하지 않는다.

## 3. 현재 구현과 재사용 위치

아래 내용은 기준 코드에서 확인한 사실이다. 다른 PC의 코드가 다르면 해당 부분의 호출자를 다시 추적한다.

### 3.1 LLM 작성과 대화

- `maro-feature/src/main/java/io/vizend/maro/feature/mono/semanticgeneration/MonoSemanticGenerationService.java`
  - `LlmClientRouter`를 사용한다.
  - Domain → Behavior → ExperienceComposition → Review 단계가 있다.
  - 단계 소유 필드 patch 병합, 정규화, 검증 실패 시 LLM 보정 기능이 있다.
- `maro-feature/src/main/java/io/vizend/maro/feature/mono/authoring/action/MonoSemanticAuthoringAction.java`
  - 대화 실행, 생성 호출, 세션 기록, 확정 Revision 등록을 묶는다.
- `maro-feature/src/main/java/io/vizend/maro/feature/mono/authoring/action/MonoAuthoringContextResolver.java`
  - 활성 PR, Pillar, 기존 Semantic Model 문맥을 해석한다.
- `maro-feature/src/main/java/io/vizend/maro/feature/mono/authoring/action/MonoAuthoringSessionAction.java`
  - 대화 상태, 만료, producer, 확정 Revision 연결을 저장한다.

위 작성 책임을 Assem으로 이전한다. 기존 LLM 연동·설정·단계별 patch 기능을 재사용한다.

### 3.2 생성 오케스트레이션과 Entity 등록

- `maro-feature/src/main/java/io/vizend/maro/feature/mono/projectionrequest/flow/MonoProjectionExecutionAppFlow.java`
  - 검증, 대상 준비, Domain 생성, Entity 기본 API 준비, Behavior 생성, 화면 구성, 결과 기록을 함께 수행한다.
  - Revision content hash 확인, 완료 결과 재사용, 트랜잭션 경계를 갖는다.
- `maro-feature/src/main/java/io/vizend/maro/feature/mono/projectionrequest/action/geno/ProjectionGenoTargetEnsureAction.java`
  - Pit, Domain, Aggregate, 역할, Feature, Flow/Seek/Load와 Facade를 준비한다.
  - 이름에 `ensure`가 있는 단계는 실제 등록을 수행할 수 있다. 순수 검증으로 취급하지 않는다.
- `maro-feature/src/main/java/io/vizend/maro/feature/mono/projectionrequest/action/geno/GenoProjectionAction.java`
  - `executeDomain()`: VO → Entity → Field → Entity CDO 생성.
  - `executeBehavior()`: 기존 API 재사용 또는 Feature SDO/RDO와 Request 생성.
  - 검사와 쓰기가 같은 클래스에 있으므로 분리 지점을 확인한다.
- `maro-feature/src/main/java/io/vizend/maro/feature/mono/projectionrequest/action/geno/GenoProjectionRegistrationAction.java`
  - 활성 PR, lineage, 기존 모델 충돌을 확인하고 Geno 모델을 등록한다.
- `maro-feature/src/main/java/io/vizend/maro/feature/mono/projectionrequest/action/EntityArchetypePulsePreparation.java`
  - Entity Archetype 요구에 맞는 기본 API/Pulse 준비를 담당한다.

현재 Entity 생성은 `CommandModel`·`StageEntity`를 사용한다. 일부 제약과 불변조건은 설명 문자열에 남는다.
이전만으로 모든 도메인 규칙이 실행 코드가 된다고 간주하지 않는다.

### 3.3 기본 Domain Logic과 업무 Feature Logic

기본 Entity CRUD Logic과 업무 API의 Flow/Seek/Load 본문을 구분한다.

- `maro-feature/src/main/java/io/vizend/maro/feature/shared/action/RequestPulsePipeline.java`
  - Request/Pulse 등록과 메소드 연결을 처리한다.
  - `mergeFlowMethod`, `mergeSeekMethod`, `mergeLoadMethod`에서 본문 생성기를 호출한다.
- `maro-feature/src/main/java/io/vizend/maro/feature/geno/pifeaturemethod/flow/GenoPiFeatureMethodBodyAppFlow.java`
  - 정적 패턴으로 생성하고 지원되지 않으면 LLM으로 본문을 생성한다.
- `maro-feature/src/main/java/io/vizend/maro/feature/geno/pifeaturemethod/PiFeatureMethodBodyLogicGenerator.java`
  - 기존 CRUD 패턴 생성 기능이다.
- `maro-feature/src/main/java/io/vizend/maro/feature/geno/pifeaturemethod/PiFeatureMethodBodyLlmGenerator.java`
  - Java 본문과 import를 생성한다.
  - 저장된 Entity·SDO·RDO 정보를 조회하여 생성 문맥을 만든다.
- `maro-domain/src/main/java/io/vizend/maro/domain/mono/cm/entity/vo/MonoBehaviorSemantics.java`
  - 입력·출력·전제조건·효과 등의 의미 모델이다.
  - 문서의 완전한 typed Logic Plan AST를 구현한 모델은 아니다.

현재는 의미 모델 검증 후 Request 등록 중에 다시 LLM이 본문을 만든다.
이 부분을 그대로 두면 책임 이전이 완료되지 않는다.

### 3.4 기본 Store와 커스텀 Store

- `maro-code-gen/src/main/java/io/vizend/maro/codegen/DramaJavaBuilder.java`
  - `createBackendCodesByEntity()`에서 기본 Logic, Store 인터페이스, JPA/Mongo 관련 코드를 생성한다.
- `maro-code-gen/src/main/java/io/vizend/maro/codegen/backside/DramaJavaCreator.java`
  - Logic/Store/JPO/Repository 템플릿 출력을 담당한다.
  - 커스텀 메소드를 기존 소스에서 읽는 경로와 `PiOptionStore` 사용 TODO가 남아 있다.
- `maro-feature/src/main/java/io/vizend/maro/feature/geno/pit/action/PitPublishAction.java`
  - Geno 모델을 모아 기존 코드 생성기를 호출하는 경로이다.
- `maro-feature/src/main/java/io/vizend/maro/feature/assem/pr/action/PrCompletePublishAction.java`
  - Assem이 이미 PR 범위의 Geno/Moti/Arc 생성·게시를 조정한다.
  - 외부 push/merge가 연결되므로 테스트 실행 대상으로 사용하지 않는다.
- `maro-domain/src/main/java/io/vizend/maro/domain/geno/cm/entity/PiOptionStore.java`
- `maro-feature/src/main/java/io/vizend/maro/feature/geno/pioptionstore/flow/GenoPiOptionStoreAppFlow.java`
  - 커스텀 Store 모델과 등록 기능은 존재한다.
- `maro-feature/src/main/java/io/vizend/maro/feature/geno/pifeaturemethod/LlmPrompts.java`
  - 없는 커스텀 연산을 지어내지 않고 `OPTION_STORE_REQUIRED`로 알리는 규칙이 있다.

기본 Store 생성기는 유지한다. 커스텀 Store가 없으면 명확한 미해결 결과를 반환하고 준비 완료로 표시하지 않는다.

### 3.5 Mono에 유지할 검증

- `maro-feature/src/main/java/io/vizend/maro/feature/mono/semanticmodel/action/TypedMonoSemanticValidator.java`
  - 순수 의미 모델 검사와 Domain/Behavior 단계별 검사를 제공한다.
- `maro-feature/src/main/java/io/vizend/maro/feature/mono/projectionrequest/action/ProjectionPreflightAction.java`
  - 생성 지원 범위, 승인 상태, 화면·타입 계약 등을 검사한다.
- `maro-feature/src/main/java/io/vizend/maro/feature/mono/semanticrevision/flow/MonoSemanticRevisionAppFlow.java`
  - Revision 등록·수정 시 검증하고 finding을 저장한다.
- `maro-feature/src/main/java/io/vizend/maro/feature/mono/projectionrequest/action/geno/GenoProjectionReuseValidator.java`
  - 재사용 계약 검사 외에 수정 메소드도 있는지 확인하고 쓰기 부분을 분리한다.

현재 검증기가 Java 본문의 컴파일 성공이나 업무 정확성까지 보장하지는 않는다.
의미 검증, 생성 준비, 실제 생성, 컴파일·실행 검증을 같은 성공 상태로 합치지 않는다.

## 4. 구현 순서

### 단계 A — 현재 동작과 호출 경로 확인

1. 작업 트리, 적용 지침, 모듈 의존성, 현재 HEAD를 확인한다.
2. 위 클래스들의 모든 호출자와 REST/MCP/클라이언트 진입점을 `rg`로 찾는다.
3. 작성, 검증, DB 등록, 실제 파일 생성, 외부 게시 경계를 표시한다.
4. 생성기 이전 전에 관련 기존 테스트를 실행하여 기준 결과를 확보한다.

### 단계 B — Assem 작성 흐름 도입

1. 기존 Mono authoring·semanticgeneration의 실행 책임을 Assem으로 옮긴다.
2. 단계별 patch, 기존 사용자 결정 보존, 세션 재개·만료, 활성 PR 검사를 유지한다.
3. 검증 실패는 Mono finding을 받아 Assem이 수정·재시도한다. 검증 규칙을 Assem에 복제하지 않는다.
4. 기존 Semantic Revision DTO/저장 구조는 초기 이전에서 재사용한다. Assem 전용 복제 스키마를 만들지 않는다.
5. 작성 서비스 이름·producer ID를 바꿀 경우 기존 세션을 읽거나 명확하게 종료할 수 있도록 호환성을 처리한다.

### 단계 C — 본문 생성과 등록 분리

1. 기존 정적 패턴 및 LLM 생성 기능을 후보 생성 단계에서 사용할 수 있도록 추출·재사용한다.
2. 저장 전 Entity/SDO/RDO 초안으로 생성 문맥을 구성할 수 있도록 입력을 보완한다.
   기존 저장 자산을 읽는 경로와 초안 경로가 동일한 타입 의미를 사용하게 한다.
3. 생성된 본문·import·시그니처·관련 Entity·참조 정보를 후보에 연결하고 검증 대상에 포함한다.
4. `RequestPulsePipeline`에 확정된 생성 결과를 등록하는 경로를 만든다.
   Assem 이전 경로에서는 이 등록 단계가 LLM fallback을 호출하지 않도록 한다.
5. 기존 Geno 직접 편집·본문 재생성 기능의 호출자를 확인한다.
   기존 API가 필요하면 Assem 생성 흐름에 위임하도록 유지하고 공유 파이프라인의 다른 호출자를 깨뜨리지 않는다.
6. 이 시점에 전체 DSL 컴파일러를 새로 만들지 않는다. 기존 본문 경로의 한계와 실제 검증 범위를 명시한다.

### 단계 D — Mono 검증과 생성 실행의 경계 확정

1. 의미·참조·재사용 적합성 검사를 생성 로직에서 분리하여 Mono가 수행하게 한다.
2. 검사 입력을 수정하지 않는다. 기본값 결정, 정규화, 바인딩 선택은 Assem 작성 단계에서 완료한다.
3. `ensure`처럼 실제 DB에 쓰는 기능을 Mono 검사에서 호출하지 않는다.
4. 신규 Entity는 후보 내 semantic key로 검증하고, 기존 자산은 정확한 ID/범위/버전으로 확인한다.
   참조할 기존 Entity가 없거나 후보가 모호하면 생성하지 말고 미해결 finding을 반환한다.
5. 생성 직전 검증한 후보와 실행할 후보가 같은지 확인한다.
   의미 모델만이 아니라 생성 본문·선택 바인딩·관련 참조 기준선의 변경도 감지해야 한다.
6. 검증된 결과를 변경한 경우 이전 통과 결과를 사용하지 않고 재검증한다.

### 단계 E — Assem 생성 실행과 기존 생성기 연결

1. `MonoProjectionExecutionAppFlow`의 쓰기 오케스트레이션을 Assem으로 이전한다.
2. 기존 순서를 보존한다: 대상 준비 → VO/Entity/Field/CDO → Entity 기본 API → 추가 Behavior API → Moti/Arc 연결.
3. 생성 대상 준비 전 순수 검증을 수행하고, 실제 등록 시에도 PR/참조 무결성 검사를 유지한다.
4. 생성·등록은 기존 Geno 서비스와 코드 생성기를 사용한다. 같은 기능을 복사하여 두 벌로 관리하지 않는다.
5. Entity 기본 CRUD에서는 기존 Entity CDO/UDO/DDO 계약을 유지한다.
   Feature SDO로 무조건 통일하거나 Command의 타입 정책을 이번 이전 작업에서 임의 변경하지 않는다.
6. DB 등록의 트랜잭션·실패 롤백·lineage·중복 방지·완료 결과 재사용을 유지한다.
   LLM 호출은 가능한 한 DB 쓰기 트랜잭션 이전에 끝낸다.
7. 파일 출력·외부 게시를 DB 롤백으로 되돌릴 수 있다고 가정하지 않는다. 생성 검증은 임시 출력 디렉터리에서 수행한다.

### 단계 F — API와 호환 경로 정리

기존 주요 REST 진입점:

- `maro-facade/src/main/java/io/vizend/maro/facade/api/role/app/mono/semanticmodel/cm/rest/MonoSemanticModelAppFlowResource.java`
- `maro-facade/src/main/java/io/vizend/maro/facade/api/role/app/mono/projection/cm/rest/ProjectionAppFlowResource.java`

1. Assem 작성·생성 API를 기존 저장소 패턴에 맞춰 제공한다.
2. 사용 중인 Mono 작성·생성 API는 필요하면 잠시 위임 경로로 유지한다. 실제 처리는 Assem이 수행한다.
3. MCP tool과 로컬 클라이언트 호출도 검색하여 함께 연결한다.
4. 별도 프론트 저장소 변경이 필요하면 실제 사용 경로를 확인해 작업 범위를 명시한다.
   프론트를 수정하지 않았다면 새 API/기존 호환 경로와 필요한 후속 작업을 보고한다.
5. 완료 후 사용하지 않는 중복 구현만 제거한다. 전체 Mono 도메인/테이블 이름 변경은 강제하지 않는다.

## 5. 이번 이전과 별도인 추가 개발

다음은 현재 기능을 옮기는 것만으로 완성되지 않는다.

- typed Logic Plan AST와 전체 DSL 컴파일러
- 모든 불변조건·사후조건을 실행 코드로 변환하는 기능
- 커스텀 OptionStore 연산의 완전한 모델 기반 생성
- 미지원 요청 종류·반환 타입·새 Store 종류 확장
- 모든 API를 Domain SDO만 사용하도록 변경하는 정책

이번 작업에서는 기존 지원 범위를 보존하고 미지원 항목을 정확히 차단한다.
이미 지원하는 기능이 이전 과정에서 손실되면 반드시 복구한다.
추가 개발을 하지 않았는데 문서의 Full 계약 전체가 구현되었다고 보고하지 않는다.

특히 기준 코드의 `ProjectionPreflightAction`은 Command 결과에 String 계약을 요구한다.
새로운 DTO 반환을 조용히 String으로 바꿔 통과시키지 않는다.

## 6. 테스트와 완료 기준

Java 21과 저장소의 Gradle 환경을 사용한다. Nexus 등 사내 의존성 설정은 해당 PC의 기존 설정을 사용하고 비밀값을 문서·로그에 복사하지 않는다.
wrapper가 있으면 wrapper를 사용하고, 없으면 설치된 호환 Gradle을 사용한다.

기존 참고 테스트:

- `maro-feature/src/test/java/io/vizend/maro/feature/mono/semanticgeneration/MonoSemanticGenerationServiceSpec.java`
- `maro-feature/src/test/java/io/vizend/maro/feature/mono/authoring/action/MonoReviewConfirmationSpec.java`
- `maro-feature/src/test/java/io/vizend/maro/feature/mono/authoring/action/ProjectionPreflightSpec.java`
- `maro-feature/src/test/java/io/vizend/maro/feature/mono/projectionrequest/flow/MonoProjectionExecutionSpec.java`
- `maro-feature/src/test/java/io/vizend/maro/feature/shared/action/RequestPulsePipelineMethodLinkTest.java`
- `maro-feature/src/test/java/io/vizend/maro/feature/mono/semanticmodel/SemanticModelingContractTest.java`

이전 전 선택 실행 예시. 패키지를 옮긴 이후에는 테스트 위치를 갱신한다.

```sh
gradle :maro-feature:test \
  --tests '*MonoSemanticGenerationServiceSpec' \
  --tests '*MonoReviewConfirmationSpec' \
  --tests '*ProjectionPreflightSpec' \
  --tests '*MonoProjectionExecutionSpec' \
  --tests '*RequestPulsePipelineMethodLinkTest' \
  --tests '*SemanticModelingContractTest'

gradle :maro-feature:compileJava :maro-facade:compileJava
```

필요한 회귀 검증은 기존 테스트를 수정·확장한다. 실행되지 않는 새 테스트 설명만 남기지 않는다.

| 확인 항목 | 완료 기준 |
|---|---|
| Assem 작성 | LLM 호출, 단계별 작성, patch 병합, 세션 재개가 Assem 흐름에서 동작 |
| Mono 검사 | 유효/무효 후보를 검사하고, 검사 중 후보 변경·LLM 호출·Geno 모델 등록이 없음 |
| 실패 차단 | 검증 실패 시 Entity/API/본문 등 최종 모델 등록이 실행되지 않음 |
| 버전 일치 | 후보·본문·바인딩이 검증 이후 변경되면 이전 통과 결과로 실행 불가 |
| 본문 고정 | 검증된 본문이 저장되며 등록 단계에서 LLM을 추가 호출하지 않음 |
| Entity 참조 | 없는/모호한 ReferencedEntity를 임의 생성·선택하지 않고 오류 반환 |
| 등록 일관성 | lineage·PR 범위·재실행 중복 방지·실패 시 완료 기록 금지가 유지됨 |
| SDO/API 연결 | Entity CRUD 계약과 Feature SDO/RDO, Request/Method/Pulse 연결이 유지됨 |
| 기본 코드 생성 | 동일한 대표 입력으로 Entity·기본 Logic·Store 관련 산출물이 유지됨 |
| 커스텀 Store | 없는 연산은 미지원으로 판정하며 허위 성공·존재하지 않는 호출을 생성하지 않음 |
| 호환성 | 기존 진입점과 저장 세션/Revision을 깨뜨리지 않거나 명시적인 이전 처리를 제공 |

추가로 대표 Entity 한 개와 업무 API 한 개를 임시 디렉터리에 생성하여 결과를 확인한다.
가능한 환경에서는 생성된 코드의 컴파일과 핵심 계약 테스트까지 실행한다.
외부 LLM·DB·사내 의존성이 없어 실행하지 못한 검증은 모의 테스트와 구분하여 보고한다.
자동 테스트에서 실제 LLM 과금 호출이나 Git push/merge가 발생하지 않도록 기존 경계를 대체한다.

## 7. 최종 보고에 포함할 내용

1. Assem으로 이전한 기능과 Mono에 남긴 검사 목록.
2. 업무 본문 생성과 Request 등록을 어떻게 분리했는지.
3. 기존 Entity·Logic·Store 생성기를 어떻게 재사용했는지.
4. API/세션/Revision 호환 방식과 필요한 데이터 이전 여부.
5. 실제 실행한 테스트·생성·컴파일 결과, 실행하지 못한 검증과 이유.
6. 현재 지원하지 않는 Full Logic Plan·커스텀 Store 등 별도 개발 범위.

커밋·push·배포·기존 저장소 병합은 별도 지시가 없는 한 수행하지 않는다.
