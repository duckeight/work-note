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
→ Geno의 MsBlueprintBindingSet 확정 → Pit/Pi* VM3 생성
→ 다음 단계는 생성된 VM3를 소비
```

- 기존 Maro 사용자 작업 순서를 유지한다. Geno 완료 시 내부 계약 해석 순서는 Aggregate → Move → Feature → Facade이며 사용자 설계 순서를 강제하지 않는다.
- `MsBlueprintBindingSet`은 마이크로서비스 범위의 타입별 Binding ID와 교차 검증 결과를 묶는 PR 독립 설계 자원이다. AggregateBinding이 다른 Binding을 소유하지 않는다.
- Pit은 `sourceMsBlueprintBindingSetId`로 전체 설계 출처를 참조한다. 개별 Binding 출처 필드를 Pit에 추가하지 않는다.
- Context/Materialization 영속 모델은 사용하지 않는다. Materialization은 BindingSet을 VM3로 변환하는 작업이지 별도 적용 이력 Entity가 아니다.
- 현재 생성기는 Aggregate-only Set을 지원한다. Move/Feature/Facade 등의 ID 목록이 있다는 이유로 생성기가 구현됐다고 판단하지 않는다. 미지원 구성원은 명시적으로 거부한다.

| 자원 | 책임 |
| --- | --- |
| Blueprint | 재사용 가능한 입력 정의·해석 규칙; 업무별 Entity schema를 소유하지 않음 |
| Binding | 업무 명세·Blueprint/Profile에서 해석한 입력·ProfileSelection·검증 결과·해석 모델 |
| MsBlueprintBindingSet | 타입별 Binding ID·묶음 검증·VM3 생성 경계 |
| VM3 | 해당 PR의 생성된 실행·코드 생성 대상 모델 |
| History | 별도 변경 이력; BindingSet에 snapshot/이력 저장소를 추가하지 않음 |

- Profile은 반복되는 구현·운영 정책과 자체 입력 정의를 제공한다. Blueprint에 없는 입력 키를 추가할 수 있으나 Aggregate 경계·상태 전이·불변식 같은 업무 의미를 결정하지 않는다.
- Binding 입력 계약은 Blueprint와 선택한 Profile의 inputDefinitions를 합성한다. 선택하지 않은 Profile의 키나 어디에도 정의되지 않은 키는 거부하고, 동일 키 정의를 암묵 덮어쓰지 않는다.
- Blueprint와 Profile은 ID·key·version을 명시적으로 선택한다. Binding 수정으로 고정한 Blueprint ID/key/version 또는 Aggregate 정체성을 교체하지 않는다.
- 업무 변경은 같은 Binding ID에서 처리한다. PR별 Binding/Set 복제나 Binding snapshot은 만들지 않는다.
- 현재 코드에서 `resolvedAggregateModel`과 `resolvedDataEventContract`는 Binding/JPO에 저장한다. 실행 중 transient 값만으로 취급하지 않으며 별도의 과거 해석본 저장소도 만들지 않는다.

## 수정·재적용·PR 격리

- Set에 포함되었거나 이미 적용되었다는 이유로 Binding 편집을 막지 않는다. Set에 참조된 Binding 삭제 제한과 편집 가능 여부를 혼동하지 않는다.
- 카탈로그의 `modifyBinding`은 같은 Binding의 설계만 갱신한다. 기존 Pit을 자동 변경하지 않는다.
- `reviseBindingAndSynchronizePitIr`은 수정 전 해석 모델을 메모리에 보관하고, 같은 Binding 수정과 선택한 활성 PR/Pit 동기화를 한 트랜잭션으로 수행한다.
- 같은 PR의 수정·재적용을 허용한다. 유지 대상 ID/lineage, 수동 모델과 사용자 Logic을 보존하고 반복 생성은 멱등적으로 처리한다.
- 새 PR은 직전 최신 PR의 Pit/Pi를 새 물리 ID로 복사하고 lineage와 `sourceMsBlueprintBindingSetId`를 보존한다. 같은 Set/Binding ID를 이어받고 새 PR 생성 자체로 재해석하지 않는다.
- 새 PR에서 적용할 때 이전 PR의 VM3를 변경하지 않는다. 조회·수정은 PR/Pit 및 실제 부모 ID로 제한하고 lineage만으로 대상을 선택하지 않는다.
- 과거 PR에서 Set/Binding을 조회하면 현재 설계가 보일 수 있다. 해당 PR 당시의 schema는 복사·보존된 VM3에서 확인한다.

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
- 기존 StageEntity/CDO/VO/Logic/Store 패턴을 따른다. 모델 변경 시 CDO·JPO·Store·Repository·API·테스트 영향을 함께 확인한다.
- 사용자가 지정한 TODO 작업은 명시된 항목과 필수 사용처만 처리한다. 다른 TODO를 임의로 구현하지 않는다.
- 완료 전 변경 diff와 관련 테스트를 검증한다. 문서만 변경했다면 링크·중복·충돌을 확인하며 불필요한 전체 빌드는 하지 않는다.
- 결과에는 변경 요점, 실제 검증 결과, 미검증 범위를 짧게 보고한다. NO-SOURCE를 테스트 통과로 부르거나 미구현 생성기·DB migration·History 연동을 완료했다고 하지 않는다.
