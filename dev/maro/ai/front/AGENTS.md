# Maro Front AI 작업 지침

## Blueprint 작업

`maro-front`에서 Aggregate Blueprint, Blueprint Binding, Blueprint Profile 또는 Blueprint 기반 Pit 생성을 다루기 전에 다음 문서를 처음부터 끝까지 읽는다.

1. [`../maro-back/AGENTS.md`](../maro-back/AGENTS.md)
2. [`../maro-back/maro-domain/AGENTS.md`](../maro-back/maro-domain/AGENTS.md)
3. [`../maro-back/maro-domain/BLUEPRINT_IMPLEMENTATION_GUIDE.md`](../maro-back/maro-domain/BLUEPRINT_IMPLEMENTATION_GUIDE.md)

백엔드의 `io.vizend.maro.domain.blueprint`가 모델 의미와 검증 규칙의 정본이다. 프런트 TypeScript 인터페이스는 API 전송 계약을 표현할 뿐이며, 별도의 Blueprint 의미나 완화된 기본 규칙을 정의하면 안 된다.

다음 제약을 지킨다.

- Blueprint와 Profile의 `id`, 논리 키, 버전을 함께 전송하여 버전을 고정한다.
- 표준 입력은 서버의 `standardInputVersion` 계약에서 자동 제공하고 Blueprint `inputDefinitions`에는 추가 정의만 선언한다. 업무별 값은 `inputBindings`로 입력한다. Binding 화면은 inputBindings JSON을 직접 편집한다. 타입별 동적 입력 폼은 사용하지 않는다. 예제 값 초기화는 서버의 합성 입력 정의 조회 API를 사용하며 표준 schema를 클라이언트에 복제하지 않는다. valueType은 String/Integer/Boolean/Object이며 업무 클래스명과 businessInputMappings는 사용하지 않는다. 표준 입력 키를 서버가 해석하며 하위 키는 부모 범위에서 유일하다.
- Binding에 저장된 입력은 출처와 무관한 최종 `inputKey`/`value`로 편집·전송한다. `valueSource`와 `propertySources`를 프런트 전송 모델에 추가하거나 UI에서 Selected/Defaulted 출처를 강제하지 않는다. `BlueprintInputDefinition.allowedSources`는 초기 입력 검증 계약으로 유지한다.
- Profile은 Blueprint의 하위 항목으로 취급하지 않고 독립 선택 항목으로 제공한다.
- 클라이언트가 `ResolvedAggregateModel`이나 이벤트 계약을 만들어 서버 검증을 우회하지 않는다.
- 최초 Binding 생성과 Pit IR 생성을 별도 명령으로 표현하고, Pit 생성에는 서버에 저장된 resolved Binding ID를 사용한다.
- Pit/PR/Drama ID를 Blueprint 또는 Profile 식별자로 재사용하지 않는다.
- Blueprint/Resolved 타입에 runtime `lineageId`나 lineage 패턴을 추가하지 않는다. 최종 lineage는 서버의 Geno 등록 흐름이 실제 부모 모델로 계산한다.
- Blueprint와 Profile은 공용 자원이며 Binding은 `edificeId`를 가진 Edifice 소유 자원이다. Binding 생성·목록 조회에는 Edifice ID가 필요하고 `piAggregateId`는 서버가 생성 모델을 가리키는 nullable 참조로 관리한다.
- 새 PR의 Pit/Pi 모델은 같은 Edifice에서 복사되며 Binding ID는 유지한다. 서버가 실제 복사 ID 맵으로 현재 Binding의 `piAggregateId`를 새 PiAggregate ID로 교체한다. 다른 Pit 모델을 임의로 재연결하지 않는다.
- Pit 화면은 기존 Edifice Binding 목록을 조회해 선택하거나 새 Binding을 만든 뒤, 선택한 Binding ID로 생성 명령을 실행한다.
- Binding의 piAggregateId가 연결되어 있으면 삭제할 수 없다. Pi 모델은 Blueprint Binding을 참조하지 않으며 Pit 조회는 Binding의 piAggregateId로 연결을 확인한다. Binding은 생성 전후 같은 ID에서 수정할 수 있다.
- 카탈로그 화면의 Binding 수정은 특정 Pit 문맥이 없으므로 Binding 설계만 갱신한다. 기존 Pit VM3 snapshot은 자동 변경하지 않으며, 사용자가 Pit 화면에서 명시적으로 동기화할 수 있게 안내한다.
- Pit 화면의 Binding 수정은 같은 Binding ID의 갱신과 선택한 활성 Pit VM3 동기화를 한 요청으로 수행한다.
- Binding 수정 화면에서는 고정된 `blueprintId/key/version`과 `aggregateName`을 교체하지 않는다.
- “immutable revision”, “unmaterialized Binding만 수정”, “materialized 후 새 Binding 생성” 같은 문구나 동작을 제공하지 않는다.
- 백엔드가 지원하지 않는 입력 규칙, Profile 표현식 또는 Query 설계를 프런트에서 성공한 것처럼 처리하지 않는다.

Blueprint 관련 변경을 완료할 때 `maro-stub`, `maro-state`, `maro-view` 빌드를 순서대로 실행한다. 기존 외부 의존성 문제로 빌드할 수 없으면 통과한 모듈과 실패 원인을 구분해 보고한다.
