# Rega 생성 흐름 작업 인계 지시

작성 기준: 2026-09-28, maro-back HEAD `c089ea193`와 당시 로컬 변경사항.
다른 PC의 에이전트는 이 파일을 읽고 **실제 체크아웃과 diff부터 확인**한다. 이 문서는 변경 방향과 인계 자료이며, 아래의 미완료 항목을 구현 완료로 간주하지 않는다.

## 1. 목표와 변경 범위

사용자가 정한 우선순위는 다음과 같다.

1. Rega Spec 사이의 참조 관계를 정확하게 검증한다.
2. 변경 전보다 AI 통신 비용이 늘어나지 않고 줄어들도록 한다.
3. 실패 시 원인을 표시하고, 정상 완료한 작업을 재사용하여 재시도한다.

기존 구조를 최대한 유지한다. 의미가 같은 필드의 명칭 변경, 새 추상화·의존성, 불필요한 도메인 필드 추가는 하지 않는다. Mono의 상세 설계·코드 생성 연동은 별도 담당자 범위다. 목표와 충돌하는 변경이 필요하면 근거와 비용 영향을 설명하고 사용자와 협의한다.

## 2. 합의한 방향과 현재 구현의 구분

최초 요청은 Draft를 Application → MicroService → MicroApp 순서로 분리 생성하고, Candidate는 Draft 전체로 한꺼번에 생성하는 것이었다. 이후 정상 경로의 LLM 호출 증가를 피하기 위해 **첫 Draft는 한 번에 생성하고, 단계별 검증·저장·재생성을 적용하는 방향**으로 진행했다.

현재 흐름:

```text
원문 + 사용자 요청 + 선택된 Rega 문맥
  → 첫 Draft 전체 생성 (LLM 1회)
  → APPLICATION 검증
  → MICROSERVICE 검증
  → MICROAPP 검증
  → COMPLETE
  → 기존 준비 상태·업무 질문 검토
  → Candidate 생성 (Draft 전체를 입력하는 기존 경로)
  → 기존 검증·승인·저장

단계 검증 실패
  → 정상 선행 단계와 원문을 domainSession에 보관
  → 실패 단계·오류를 응답하고 재시도 버튼 표시
  → 해당 단계만 생성 (재시도 요청당 LLM 1회)
  → 검증 성공 시 다음 단계로 이동
```

- 처음부터 LLM을 3회 호출하는 구조는 아니다. 이를 바꾸려면 비용 목표부터 검토한다.
- 재시도 성공 시 다음 단계를 자동으로 연속 호출하지 않는다. 다음 요청으로 이어간다.
- 실패한 단계와 그 뒤의 초기 생성 결과는 정상 Draft에 보존하지 않는다. 재생성 시 필요한 정상 선행 단계만 유지한다.
- `COMPLETE`는 생성 단계 완료다. 미결 업무 질문까지 해결되었거나 바로 저장할 수 있다는 의미는 아니다.
- 이번 작업에서 Candidate 생성 경로를 새로 단계 분리하지 않았다. 기존 내부 호출·검증 횟수까지 항상 1회라고 가정하지 않는다.

## 3. 상태와 단계별 소유 필드

`RegaWorkflowDomainSession`에 추가한 값:

- `draftGenerationStage`: `APPLICATION`, `MICROSERVICE`, `MICROAPP`, `COMPLETE`
- `draftRequest`: 재시도에 사용할 사용자 요청
- `draftGenerationErrors`: 실패 단계의 검증 오류
- 기존 `draft`: 정상 선행 결과와 `importedDocument`, `selectedSpecContext` 보관

| 단계 | 생성·교체 가능한 필드 | 주요 검증 |
| --- | --- | --- |
| APPLICATION | `goal`, `sourceMaterial` | Application 이름·코드, sourceMaterial 객체 |
| MICROSERVICE | `serviceResponsibilities` | 서비스 코드 중복, Capability 키 중복, 역할의 capabilityKeys 참조 |
| MICROAPP | `interactionContexts`, `missingQuestions`, `conflicts`, `riskNotes`, `readiness` | MicroApp 코드 중복, UC 키 중복, requiredCapabilities 및 useCaseFlows 참조 |

재시도 결과는 해당 단계 소유 필드만 병합한다. 다른 단계 필드를 LLM이 반환해도 덮어쓰지 않는다. 재검증에 실패하면 기존 정상 Draft를 유지한다.

참조 규칙:

- `responsibilityRoles[].capabilityKeys[]`는 같은 서비스의 `providerCapabilities[].key`를 참조한다.
- `requiredCapabilities[].useCaseKey`는 같은 interactionContext의 Act 하위 UC를 참조한다.
- `providerMicroserviceCode`와 `requiredCapabilityKey`는 저장된 서비스와 해당 서비스의 Capability를 참조한다.
- `useCaseFlows`의 양쪽 UC 키는 같은 interactionContext에 존재해야 한다. 원문에 흐름이 없으면 `[]`를 허용하며 임의 흐름을 만들지 않는다.
- 서로 다른 interactionContext에 동일한 `candidateMicroApp` 코드를 주면 안 된다. 현재 Mapper는 context마다 MicroApp을 생성한다.
- Draft의 `acts[].useCases[]` 중첩과 최종 Spec의 `acts[]`, `useCases[]` 분리는 기존 계약이다. 최종 UC는 `actKey`로 Act를 참조한다.

여기서 저장은 domainSession에 결과를 담아 후속 요청에 재사용하는 것을 뜻한다. 별도 DB 영속화나 PC 간 세션 이동을 보장한다는 의미는 아니다.

## 4. 먼저 읽을 파일

아래 경로는 모두 maro-back 루트 기준이다.

| 파일 | 확인할 내용 |
| --- | --- |
| `maro-feature/src/main/java/io/vizend/maro/feature/rega/workflow/RegaWorkflowService.java` | `requestDraftForWorkflow`, `evaluateInitialDraft`, `retryDraftStage`, `validateDraftStage`, `mergeDraftStage`, `draftOutputContract`, `draftStageInstruction`, `callLlm` |
| `maro-feature/src/main/java/io/vizend/maro/feature/rega/workflow/RegaWorkflowStageResult.java` | 응답의 단계 정보 |
| `maro-feature/src/main/java/io/vizend/maro/feature/rega/workflow/flow/RegaDraftGenerationStage.java` | 단계 enum |
| `maro-feature/src/main/java/io/vizend/maro/feature/rega/workflow/flow/RegaWorkflowDomainSession.java` | 체크포인트와 오류 |
| `maro-feature/src/main/java/io/vizend/maro/feature/rega/workflow/flow/RegaToolRegistry.java` | 요청 전달, 실패 결과·부분 Draft 저장 |
| `maro-feature/src/main/java/io/vizend/maro/feature/rega/workflow/flow/RegaFlowPolicy.java` | 미완료 시 REQUEST_DRAFT 허용, Candidate 차단, 기존 중복 코드 검사 |
| `maro-feature/src/main/java/io/vizend/maro/feature/rega/workflow/flow/RegaWorkflowFlowService.java` | 미완료 단계 재개 분기 |
| `maro-feature/src/main/java/io/vizend/maro/feature/rega/workflow/RegaWorkflowCandidateMapper.java` | context → MicroApp 매핑 확인용 |
| `maro-feature/src/main/resources/prompts/rega-workflow/` | 초기·재시도·병합 프롬프트와 공통 출력 계약 |
| `maro-feature/src/test/java/io/vizend/maro/feature/rega/workflow/action/RegaWorkflowServiceStageTest.java` | 부분 보존, 단계 재시도, 오류 전달 테스트 |

프롬프트 관련 파일:

- `draft-output-contract.json`: 기존 초기 Draft 출력 예시를 추출한 공통 계약. **JSON Schema가 아니라 placeholder를 포함한 JSON 출력 예시**다. Structured Outputs의 schema로 그대로 보내면 안 된다.
- `request-draft.system.md`: 전체 계약을 `{{draftOutputContract}}`로 주입한다.
- `retry-draft-stage.system.md`, `retry-draft-stage.user.md`: 단계 계약, 저장된 원문·Draft, 사용자 요청, `validationErrorsJson`을 전달한다.
- `merge-draft.system.md`: 기존 MicroApp 중복 금지·해결 지침을 확인한다.

기존 독립 `requestDraft(...)` API와 `mergeDraft(...)`에는 원래의 재시도 동작이 남아 있다. Workflow의 `request-draft-initial` 및 단계 재시도와 혼동하지 말고 호출자를 추적한다.

프런트엔드는 별도 저장소 maro-front의 다음 파일에 변경이 있다.

`dramas/maro-view/src/components/rega/RegaWorkflowShell.tsx`

- `allowedTools`에 `REQUEST_DRAFT`가 있고 Draft가 있으면 재시도 버튼을 표시한다.
- 버튼명 `Retry MicroService` 등은 `domainSession.draftGenerationStage`를 표시한 것이다.
- 후속 요청은 기존 domainSession을 전달한다. 최신 도구 오류가 있으면 `draftGenerationErrors`에도 넣는다.
- 다음 단계가 처음 실행되는 상황에도 현재 버튼명은 Retry로 표시된다.
- 해당 변경은 현재 `asRecord`/타입 단언을 사용한다. 공유 클라이언트 타입까지 갱신되었다고 가정하지 않는다.

## 5. 직전까지 수정한 문제

1. 부분 Draft가 실패 상태로 반환될 때 화면에 재시도 버튼이 없던 문제: 화면에 단계 재시도 동작을 추가했다.
2. 재시도에서 오류 원인을 전달하지 않던 문제: session의 오류를 저장하고 프롬프트로 전달하도록 했다.
3. 재시도 프롬프트에 출력 구조가 부족했던 문제: 공통 JSON 계약을 추출하고 단계별 부분 계약을 주입했다. 배열 대신 객체를 반환하면 타입을 포함한 오류를 전달한다.

실제 MicroService 실패에서는 `providerCapabilities`를 배열 대신 키 기반 객체로 생성하고, 동일한 `growin` 서비스를 8번 반환했다. 이를 계기로 계약과 서비스 경계 지침을 보완했다.

## 6. 현재 남아 있는 실제 오류 — 다음 작업 우선순위

마지막 사용자 응답에서는 MicroService 단계를 통과한 뒤 **MICROAPP 검증에서 실패**했다. JSON 파싱 오류는 아니다.

| interactionContext.key | candidateMicroApp |
| --- | --- |
| recruitment-preparation | growinrecruitment |
| demand-and-content-activation | growinrecruitmentgrowth |
| learner-participation-and-consent | growinrecruitmentgrowth |
| course-selection-and-academy-connection | growinrecruitmentgrowth |
| academy-follow-up-and-performance | growinrecruitmentgrowth |
| commercial-settlement-and-referral-reward | growinrecruitmentgrowth |

오류는 `[MICROAPP] interactionContexts[2..5].candidateMicroApp is duplicated: growinrecruitmentgrowth`의 각 인덱스별 4건이다. Application·MicroService 결과는 domainSession에 남아 있다.

확인된 누락: 기존 `merge-draft.system.md`에는 서로 다른 context가 같은 MicroApp 코드를 사용하지 않도록 하는 지침과 해결 방법이 있지만, 새 단계 재시도 지침에는 이 규칙이 명시되어 있지 않다. **원인 확인만 했고 이 부분의 코드는 아직 수정하지 않았다.**

다음 에이전트의 최소 작업:

1. 초기 생성·단계 재생성·병합의 프롬프트와 실제 검증 규칙을 비교한다.
2. 서로 다른 MicroApp에는 고유 코드를 부여하고, 실제 같은 MicroApp이라면 역할·UC·참조를 보존하여 하나의 context로 합치도록 기존 지침을 필요한 생성 경로에 반영한다.
3. 검증을 끄거나 코드에 임의 숫자를 붙여 통과시키지 않는다. 서로 다른 업무 맥락을 무조건 합치지도 않는다.
4. 오류가 재시도 프롬프트에 전달되고, 선행 단계가 보존되며, 수정된 단계가 다음 상태로 진행되는지 기존 테스트에서 확인한다.

LLM이 이 규칙을 지킬지는 실제 생성으로 별도 확인해야 한다. 프롬프트 문구와 mock 테스트만으로 재발 방지를 단정하지 않는다.

## 7. 비용과 미확인 범위

- 정상 최초 생성은 LLM 1회, 재시도는 실패 단계 출력만 받는다. 성공한 Application·MicroService 출력을 반복 생성하지 않는다.
- 재시도 입력에는 원문과 정상 Draft가 포함된다. 입력 토큰까지 항상 감소하거나 총비용이 감소했다고 검증한 것은 아니다. 실제 호출 수·입출력 토큰으로 비교해야 한다.
- 비용 절감을 이유로 원문을 요약본으로 대체하거나 참조 검증을 약화하지 않는다.
- 실패한 출력 전체는 재시도용 정상 Draft에 남기지 않는다. 오류와 원문으로 단계 전체를 재생성하는 현재 방식을 먼저 유지한다.
- HTTP/transport 예외가 최초 생성 중 발생하는 경로까지 체크포인트 복구가 검증된 것은 아니다. 검증 실패 처리와 구분한다.
- 과거 OpenAI `Invalid schema for response_format` 오류와 이번 MicroApp 코드 중복은 다른 오류다. 이번 단계 재생성 호출은 JSON 지침 방식이며 공통 계약을 response_format schema로 전달하지 않는다.

## 8. 검증과 다른 PC에서의 시작 방법

1. 이 파일만 복사하면 코드 변경은 이동하지 않는다. maro-back과 maro-front의 관련 커밋 또는 패치를 함께 옮기고, staged·unstaged·새 파일 누락을 확인한다. 작업 인계 시점에는 관련 변경이 아직 로컬 diff에 있다.
2. 각 저장소의 AGENTS.md 등 적용 지침과 현재 diff를 먼저 확인한다. 위 파일 목록은 탐색 기준이며 최신 코드가 우선이다.
3. Java 21 및 프로젝트 Gradle 환경에서 아래 테스트를 실행한다. wrapper 실행 파일이 제공되는 환경이라면 해당 실행 파일을 사용한다.

```sh
gradle :maro-feature:test --tests 'io.vizend.maro.feature.rega.workflow.*'
git diff --check
```

직전 수정 후 위 Workflow 테스트는 70개 통과했다. 이는 이전 PC에서의 실행 기록이며 이 문서 작성 시 재실행한 결과는 아니다. 실제 OpenAI 호출은 해당 검증에 포함되지 않았다.

중점 테스트는 `workflowRetriesOnlyFailedMicroAppStageAndKeepsValidDraftPrefix`와 `microserviceRetrySuppliesArrayContractAndRejectsRepeatedServiceObjects`다. 이번 중복 오류의 실패 → 수정 성공도 선행 결과 보존·호출 횟수와 함께 검증한다.

프런트 빌드에는 이전 확인 당시 `workingCandidate`/`generationProgress` 관련 TS2339 오류가 있었고, 당시 조사에서는 기존 커밋 `f65089388` 변경으로 분류해 두었다. 새 PC에서 재확인하되 이번 변경 때문이 아니라면 임의 수정하지 않는다. `episodes/episode-maro/vite.config.mts`의 사용자 로컬 변경과 `scripts/rega-migration/generated/`의 SQL은 이번 작업 대상이 아니다.

실제 통합 검증에서는 최초 성공 경로, 각 단계 실패·재시도, 오류 표시, 정상 선행 결과 보존, 미완료 Candidate 차단, 완료 후 기존 Candidate 흐름을 확인한다. 사용자가 테스트한 provider/model은 `openai` / `gpt-5.6-luna`였으며 새 PC의 실제 설정·지원 여부를 확인한다.

보고할 때는 적용 변경, 통과한 검증, 실제 LLM 검증 여부, 남은 문제를 구분한다. 이 인계 문서를 만들면서 애플리케이션 코드를 추가 수정하지는 않았다.
