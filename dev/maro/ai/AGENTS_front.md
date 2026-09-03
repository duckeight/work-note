# Maro Front AI 작업 지침

## Blueprint 작업

`maro-front`에서 Aggregate Blueprint, Blueprint Binding, Blueprint Profile 또는 Blueprint 기반 Pit 생성을 다루기 전에 다음 문서를 처음부터 끝까지 읽는다.

1. [`../maro-back/AGENTS.md`](../maro-back/AGENTS.md)
2. [`../maro-back/maro-domain/AGENTS.md`](../maro-back/maro-domain/AGENTS.md)
3. [`../maro-back/maro-domain/BLUEPRINT_IMPLEMENTATION_GUIDE.md`](../maro-back/maro-domain/BLUEPRINT_IMPLEMENTATION_GUIDE.md)

백엔드의 `io.vizend.maro.domain.blueprint`가 모델 의미와 검증 규칙의 정본이다. 프런트 TypeScript 인터페이스는 API 전송 계약을 표현할 뿐이며, 별도의 Blueprint 의미나 완화된 기본 규칙을 정의하면 안 된다.

다음 제약을 지킨다.

- Blueprint와 Profile의 `id`, 논리 키, 버전을 함께 전송하여 버전을 고정한다.
- 업무별 이름·Entity·Operation·규칙은 `AggregateBusinessSpecification`으로 입력한다.
- Profile은 Blueprint의 하위 항목으로 취급하지 않고 독립 선택 항목으로 제공한다.
- 클라이언트가 `ResolvedAggregateModel`이나 이벤트 계약을 만들어 서버 검증을 우회하지 않는다.
- 최초 Binding 생성과 Pit IR 생성을 별도 명령으로 표현하고, Pit 생성에는 서버에 저장된 resolved Binding ID를 사용한다.
- Pit/PR/Drama ID를 Blueprint 또는 Profile 식별자로 재사용하지 않는다.
- Blueprint/Resolved 타입에 runtime `lineageId`나 lineage 패턴을 추가하지 않는다. 최종 lineage는 서버의 Geno 등록 흐름이 실제 부모 모델로 계산한다.
- Blueprint와 Binding은 PR 독립 자원으로 취급한다. 새 PR의 Pit은 snapshot으로 보존된 동일 `sourceBlueprintBindingId`를 사용한다.
- 기존 source Binding이 있으면 새 Binding을 만들지 않는다. 같은 Binding의 업무 입력을 수정하고 활성 Pit까지 원자적으로 동기화하는 명령을 사용한다.
- Binding 수정 화면에서는 고정된 `blueprintId/key/version`과 `aggregateName`을 교체하지 않는다.
- 백엔드가 지원하지 않는 입력 규칙, Profile 표현식 또는 Query 설계를 프런트에서 성공한 것처럼 처리하지 않는다.

Blueprint 관련 변경을 완료할 때 `maro-stub`, `maro-state`, `maro-view` 빌드를 순서대로 실행한다. 기존 외부 의존성 문제로 빌드할 수 없으면 통과한 모듈과 실패 원인을 구분해 보고한다.
