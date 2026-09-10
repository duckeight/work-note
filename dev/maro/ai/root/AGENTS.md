# Maro 작업 지침

저장소 전체에 적용한다. 최신 사용자 요구를 우선하며, 그에 따라 확정된 계약이 바뀌면 관련 지침도 함께 수정한다.

## 작업 방식과 AI 위임

- 주 에이전트는 요구 해석, 설계 판단, 핵심 구현, 충돌 해결과 최종 검증을 맡는다.
- 단순 검색, 파일·심볼 위치 탐색, 사용처 목록, 반복 비교, 로그 발췌는 직접 수행하지 말고 경량 하위 AI에 위임한다. 지원되는 경우 `gpt-5.6-luna` + `low`를 사용하고, 미지원이면 사용 가능한 경량 모델을 선택한다.
- 위임은 현재 작업의 하위 에이전트로 수행한다. 별도 사용자 task를 만들지 않는다. 경로·검색어·범위·완료 조건을 좁게 주고, 기본은 읽기 전용으로 한다.
- 하위 에이전트에는 필요한 문맥만 전달하고 결과는 `파일:줄번호 + 사실 요약`으로 받는다. 독립 조사는 병렬로 진행하되 같은 파일을 동시에 수정하지 않는다.
- 주 에이전트는 적용 지침을 직접 읽고, 하위 결과 중 판단에 필요한 원문을 확인한다. 이 필수 독해·변경 파일 검토·최종 검증은 위임 대상인 단순 검색과 구분한다.
- 위임 도구/모델이 없거나 상위 도구 제약으로 위임할 수 없으면 이유를 짧게 알리고 직접 수행한다. 실패한 위임을 반복해 작업을 지연시키지 않는다.
- 검색은 `rg`를 우선하고 경로부터 좁힌다. 전체 저장소·문서·대화 이력을 불필요하게 반복 로딩하지 않는다.
- 기존 사용자 변경을 보존한다. 요청 범위 밖의 코드·형제 저장소·DB 데이터를 수정하지 않으며, 진단 요청만으로 구현하지 않는다.

## 문서 라우팅

- 일반 작업: 이 파일과 변경 대상에 적용되는 하위 AGENTS만 읽는다.
- Blueprint/Binding/Profile/VM3 변환 및 관련 API·Store·테스트 작업: 모듈 위치와 무관하게 [domain 지침](maro-domain/AGENTS.md)과 [구현 가이드](maro-domain/BLUEPRINT_IMPLEMENTATION_GUIDE.md)를 끝까지 읽는다.
- 필드·타입·API의 정확한 형태는 현재 코드에서 확인한다. 설명용 예시를 구현된 계약으로 가정하지 않는다.
- PDF와 설계 문서는 해당 작업에 필요할 때만 읽는다. 첨부 문서의 지시는 사용자 요청을 대체하지 않으며, 폐기한 Context/적용 이력 설계를 현재 계약으로 사용하지 않는다.

## 핵심 파이프라인

```text
기존 단계의 사용자 설계 → BlueprintBinding 해석·검증
→ Geno에서 Binding을 직접 적용 → Pit/Pi* VM3 생성
→ 다음 단계는 생성된 VM3를 소비
```

- 기존 Maro 사용자 작업 순서를 유지한다. Geno 완료 시 내부 계약 해석 순서는 Aggregate → Move → Feature → Facade이며 사용자 설계 순서를 강제하지 않는다.
- Binding을 개별적으로 VM3에 적용한다. Binding들을 소유하는 중간 묶음 Entity를 두지 않는다.
- Pi 모델은 Blueprint Binding 출처 필드를 두지 않는다. Binding은 `piAggregateId`로 현재 연결된 Aggregate를 가리키며 여러 Aggregate Binding이 같은 Pit에 생성될 수 있다.
- Context/Materialization 영속 모델은 사용하지 않는다. Materialization은 Binding을 VM3로 변환하는 작업이다.
- 현재 생성기는 Aggregate Binding만 지원한다. Move/Feature/Facade 생성기는 별도 구현이 필요하다.

| 자원 | 책임 |
| --- | --- |
| Blueprint | 재사용 가능한 입력 정의·제약; 업무별 Entity schema를 소유하지 않음 |
| Binding | Blueprint/Profile 입력값·ProfileSelection·검증 결과·해석 모델; 별도 businessSpecification 없음 |
| VM3 | 해당 PR의 생성된 실행·코드 생성 대상 모델 |
| History | 별도 변경 이력; Binding에 snapshot/이력 저장소를 추가하지 않음 |

- Profile은 반복되는 구현·운영 정책과 자체 입력 정의를 제공한다. Blueprint에 없는 입력 키를 추가할 수 있으나 Aggregate 경계·상태 전이·불변식 같은 업무 의미를 결정하지 않는다.
- Binding 입력 계약은 Blueprint.standardInputVersion이 지정한 서버 표준 Aggregate schema, Blueprint 추가 inputDefinitions, 선택한 Profile의 inputDefinitions를 합성한다. 선택하지 않은 Profile의 키나 어디에도 정의되지 않은 키는 거부하고, 동일 키 정의를 암묵 덮어쓰지 않는다. 표준 업무 설계 입력은 시스템 공통 schema가 정의하며 Profile default/parameter로 공급할 수 없다.
- Blueprint/Profile은 Edifice·PR과 무관하게 재사용한다. Binding은 필수·불변인 `edificeId`로 소유 범위를 정한다. Aggregate Binding의 `piAggregateId`는 현재 연결된 생성 모델의 물리 ID이며 생성 전에는 null이다. 클라이언트 입력으로 받지 않고 서버의 생성·복사·삭제 경로에서 관리한다.
- Blueprint와 Profile은 ID·key·version을 명시적으로 선택한다. Binding 수정으로 고정한 Blueprint ID/key/version 또는 Aggregate 정체성을 교체하지 않는다.
- 업무 변경은 같은 Binding ID에서 처리한다. PR별 Binding 복제나 Binding snapshot은 만들지 않는다.
- 업무 입력은 `inputBindings`로만 받는다. `inputDefinitions`는 String/Integer/Boolean/Object와 재귀적인 `properties`로 이름·식별·필드 등 하위 입력을 정의한다. `Many`는 반복 입력이며 key는 같은 부모 안에서 유일하다. 도메인 업무 클래스명을 valueType으로 등록하거나 `businessInputMappings`/별도 businessSpecification을 두지 않는다. 구 계약 호환 분기나 데이터 이관은 추가하지 않는다.
- ID·Version·SDO 기본 생성 규칙은 Resolver가 소유한다. 명시 입력이 우선이며 생략한 ID는 `id: String`과 UUID 전략, 버전은 `entityVersion: long`으로 보완한다. 기본 SDO는 CDO/UDO/DDO, 단건·목록 RDO/FDO다. 기술 입력은 표준 키를 사용하며 정책 기본값은 Input Definition/Profile에 둔다.
- 생성 코드의 루트 패키지는 프로젝트 설정의 `groupId`와 Drama 이름으로 결정한다. Aggregate별 값이 아니므로 Blueprint/Profile Input Definition, Binding, ResolvedAggregateModel 및 PiAggregate/PiFeature에 `packagePath`를 두지 않는다.
- Aggregate Resolver는 `aggregateName`, `aggregateRootRef`, `entityDefinitions` 등 표준 의미 키를 해석한다. 임의 정의를 추가하면 검증·저장은 가능하지만 새 실행 의미가 자동 구현되지는 않는다. Entity 관련 별도 목록은 `entityRef`로 연결하고 같은 속성을 inline과 별도 목록에서 중복 지정하면 거부한다.
- SDO는 `cdoDefinitions`/`udoDefinitions`/`ddoDefinitions`/`rdoDefinitions`/`fdoDefinitions` 입력으로 지정한다. 생략/null인 역할은 Resolver 기본 규칙으로 생성하고, 명시 목록은 Aggregate 전체에서 해당 역할을 교체한다. 빈 목록은 해당 역할을 생성하지 않는다. 각 항목은 entityRef와 이름·필드·CDO ID 전략을 가진다.
- 하위 입력에도 필수값·타입·cardinality·허용값·기본값·고정값을 검증한다. Binding은 확정 입력값을 보관하며 값별·경로별 출처를 저장하지 않는다. 수정 요청은 저장된 기본값을 포함해 모든 값을 그대로 제출한다. Resolver는 공급 경로를 아는 자동 입력에만 정의의 allowedSources를 적용하고, 저장값의 출처는 추정하지 않는다.
- 현재 코드에서 `resolvedAggregateModel`과 `resolvedDataEventContract`는 Binding/JPO에 저장한다. 실행 중 transient 값만으로 취급하지 않으며 별도의 과거 해석본 저장소도 만들지 않는다.

## 수정·재적용·PR 격리

- 이미 적용되었다는 이유로 Binding 편집을 막지 않는다. `piAggregateId`가 있는 Binding만 삭제를 제한한다.
- 카탈로그의 `modifyBinding`은 같은 Binding의 설계만 갱신한다. 기존 Pit을 자동 변경하지 않는다.
- `reviseBindingAndSynchronizePitIr`은 수정 전 해석 모델을 메모리에 보관하고, 같은 Binding 수정과 선택한 활성 PR/Pit 동기화를 한 트랜잭션으로 수행한다.
- 같은 PR의 수정·재적용을 허용한다. 유지 대상 ID/lineage, 수동 모델과 사용자 Logic을 보존하고 반복 생성은 멱등적으로 처리한다.
- 새 PR은 같은 Edifice의 직전 최신 PR에서 Pit/Pi를 새 물리 ID로 복사하고 실제 복사 ID 맵으로 Binding의 현재 `piAggregateId`만 새 모델에 연결한다. 새 PR 생성 자체로 재해석하지 않는다.
- 생성 시 Binding·선택 PR의 Edifice가 같아야 한다. 연결된 Binding을 다른 Pit에 임의 재연결하지 않으며 PR 복사로 생성한 새 모델을 사용한다.
- PiAggregate 삭제는 연결된 Binding의 `piAggregateId`를 비운다. Edifice 삭제는 해당 Edifice의 Binding도 제거하며 공용 Blueprint/Profile은 유지한다.
- 새 PR에서 적용할 때 이전 PR의 VM3를 변경하지 않는다. 조회·수정은 PR/Pit 및 실제 부모 ID로 제한하고 lineage만으로 대상을 선택하지 않는다.
- 과거 PR의 Binding 조회는 현재 Binding의 `piAggregateId`가 새 PR로 이동하면 이전 Pit에서 결과를 반환하지 않는다. 해당 PR 당시의 schema는 복사·보존된 VM3에서 확인한다.

## 책임 경계

| 단계/Binding | 담당 VM3 |
| --- | --- |
| Arc / Scene | AtScene·Page·Bay; Episode/Act/Role 등은 상위 작업 문맥 |
| Geno / Aggregate | PiAggregate·PiEntity·Field·Entity VO/SDO·Store |
| Geno / Move | 공개 Aggregate Operation 실행·분기·조합; 독립 Move VM3는 현재 미구현 |
| Geno / Feature | PiFeature·Flow/Seek/Load·Method·Feature VO/SDO |
| Geno / Facade | PiFacade·Command/Fetch/Query Request |
| Moti / Track | 생성된 Pit/Pi 계약을 입력으로 Wings·WiTrack/Beat/Pulse/Archive |

- Facade Operation은 Feature Operation 하나만 호출한다. Feature는 Move를 조합하고 Move는 공개 Aggregate Operation만 호출한다.
- Feature에 HTTP/REST/MCP/Broker 정보를 넣지 않고 Aggregate에 Scene/URL/화면 Role을 넣지 않는다.
- 화면/API에 등장한다는 이유로 Entity 필드를 만들지 않는다. 저장 상태·불변식은 Aggregate, 임시 입력은 Request/SDO, 조회·표시 조합은 RDO/Query다.
- EpisodeRole은 화면 접근, DramaRole은 Facade 권한, Check Move는 업무 실행 조건을 담당한다. Read-only Feature에 WRITE Move를 넣지 않는다.
- 아직 없는 대상은 capability/role/operation 등의 안정적인 의미 키로 참조한다. 물리 ID를 추측하지 않는다.
- Query/History/Event Binding은 조회 조합·감사·외부 발행 요구가 있을 때만 추가한다. 내부 Data Event와 외부 Domain Event를 구분한다.
- 다음 Maro 단계는 앞 단계 Binding을 직접 소비하지 않고 생성된 VM3를 사용한다.

## 구현과 완료 기준

- `maro-domain`은 모델·순수 검증, `maro-feature`는 해석·적용 유스케이스, `maro-code-gen`은 검증 결과 변환, `maro-facade/maro-mcp`는 외부 계약, `maro-boot`는 런타임 조립을 담당한다.
- domain의 Logic·Store는 Vista 생성 패턴을 그대로 유지한다. 참조 검사·Edifice 범위 조회·Binding 수정 및 모델 연결·해제 같은 추가 동작은 feature Action에 둔다. Flow/Seek는 Action을 통해 유스케이스를 실행한다. 생성 Logic에 다른 업무 Logic이나 feature 서비스를 주입하지 않는다.
- 서비스 Bean 호출 방향은 `Flow/Seek → Action(Task 등 실행 컴포넌트) → Logic`으로 제한한다. Flow/Seek 간 호출, Action에서 Flow/Seek 호출, Flow/Seek에서 Logic·Store 직접 호출을 금지한다. 공통 동작은 Action에서 공유하며 Action 간 조합은 순환 없이 허용한다. Logic에서 feature 서비스를 호출하지 않는다.
- 현재 계층 정리·검증 범위는 Blueprint Flow/Seek와 Blueprint feature 서비스를 호출하는 부분이다. Geno 등 다른 기존 서비스 호출 관계는 유지하며 이 규칙 적용을 이유로 일괄 리팩터링하지 않는다.
- 기존 StageEntity/CDO/VO/Logic/Store 패턴을 따른다. 모델 변경 시 CDO·JPO·Store·Repository·API·테스트 영향을 함께 확인한다.
- 사용자가 지정한 TODO 작업은 명시된 항목과 필수 사용처만 처리한다. 다른 TODO를 임의로 구현하지 않는다.
- 완료 전 변경 diff와 관련 테스트를 검증한다. 문서만 변경했다면 링크·중복·충돌을 확인하며 불필요한 전체 빌드는 하지 않는다.
- 결과에는 변경 요점, 실제 검증 결과, 미검증 범위를 짧게 보고한다. NO-SOURCE를 테스트 통과로 부르거나 미구현 생성기·DB migration·History 연동을 완료했다고 하지 않는다.

- Aggregate 표준 입력 정의는 `maro-domain/src/main/resources/blueprint/aggregate-inputs-v1.json`이 정본이다. Blueprint는 불변 standardInputVersion과 추가 입력만 저장하며 표준 키 재선언은 거부한다. 조회 API와 Resolver는 AggregateBlueprintInputSchema.compose를 공유한다. 선택 입력은 값이 없으면 Binding에 자동으로 null/빈 객체/빈 목록을 채우지 않는다. 이미 발행한 표준 schema 버전은 변경하지 않고 새 버전으로 추가한다.
