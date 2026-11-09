# Codex 순차 기능 개발 파일 묶음

사용자와 합의한 설계를 관리하는 designer, 구현하는 implementer, 검토·리팩토링하는 reviewer, 검증하는 tester를 메인 agent가 순차 조정한다. designer는 새로운 설계를 일임받는 역할이 아니라 **사용자와의 설계 합의를 이해하고 그 합의에 대한 책임을 갖는 역할**이다.

이 폴더는 배포용 원본이다. 생성 과정에서 Codex 개인설정이나 개발 프로젝트에 설치하지 않았다. 아래 모델 배치와 작업 규칙은 사용자 요청에 맞춰 작성한 구성 제안이다.

## 파일 구성

```text
README.md
REQUEST.example.md
AGENTS.snippet.md
project/.codex/
  agents/
    designer.toml
    implementer.toml
    reviewer.toml
    tester.toml
  workflows/
    feature-development.md
    common.md
```

각 TOML의 `developer_instructions`가 해당 역할의 지시파일이다. 모든 역할이 읽는 공통 규칙은 `common.md`, 메인 agent의 실행 지침은 `feature-development.md`에 있다.

## 모델 배치

| 역할 | 모델 | reasoning effort | 선택 이유 |
| --- | --- | --- | --- |
| designer | `gpt-6.1-sol` | `high` | 합의 내용·원천·코드의 정합성을 판단 |
| implementer | `gpt-6.1-sol` | `high` | 여러 파일에 걸친 구현과 수정 |
| reviewer | `gpt-6-astra` | `high` | 별도 맥락과 다른 모델에서 정확성·구조를 독립 검토 |
| tester | `gpt-6.1-sol` | `high` | 요구사항 기반 테스트와 실패 원인 분석 |

같은 모델을 쓰는 역할도 별도 subagent로 실행한다. 역할 이름, 지시사항, 작업 맥락은 각각 독립적이다. 다른 모델이라는 이유만으로 검증 품질이 보장되지는 않으므로 검토·테스트의 근거를 함께 확인한다.

## 다른 PC에서 수동 적용

1. 묶음을 대상 PC로 옮긴다.
2. `project/.codex/agents/`의 네 TOML을 대상 저장소 루트의 `.codex/agents/`에 복사한다.
3. `project/.codex/workflows/`의 두 Markdown을 같은 저장소의 `.codex/workflows/`에 복사한다. agent 지시는 **대상 저장소 루트 기준 경로**를 사용하므로 이 구조를 유지한다.
4. 같은 이름의 역할·지시파일이 이미 있으면 내용을 비교해 수동 병합한다. 기존 파일이나 `AGENTS.md`를 통째로 덮어쓰지 않는다.
5. 매번 명시적으로 실행하려면 `REQUEST.example.md`를 참고해 메인 대화에서 요청한다. 프로젝트의 기본 개발 흐름으로 쓰려면 `AGENTS.snippet.md`의 내용을 기존 루트 `AGENTS.md`에 검토 후 추가한다. 두 방법 중 하나만 사용해도 된다.
6. 대상 PC에서 새 Codex 대화를 열고 역할 파일 인식과 모델 사용 가능 여부를 확인한다. 새 대화에는 이전 대화의 설계가 자동 전달되지 않으므로 합의 요약이나 실제 설계 문서도 제공한다.

`~/.codex/`에 복사하거나 전역 `config.toml`을 바꾸는 단계는 없다. 상위 설정에서 subagent가 비활성화됐거나 설치 버전이 이 역할 파일 형식을 지원하지 않으면 대상 PC에서 별도로 확인해야 한다. 이 묶음은 그 설정을 자동 변경하지 않는다.

모델 접근 가능 여부는 계정·클라이언트·제공자에 따라 다르다. 사용할 수 없으면 메인 agent가 이를 알리고 대안을 제시한다. 필요하면 사용자가 배포 전 해당 TOML의 `model`과 `model_reasoning_effort`를 지원되는 값으로 함께 바꾼다. 설정된 모델을 몰래 대체하지 않는다.

## 실행과 완료 기준

```text
사용자와 메인 agent의 요구·설계 합의
  → designer: 합의 숙지·정합성 확인
  → implementer: 구현
  → reviewer: 검토·범위 내 리팩토링
  → tester: 테스트 작성·실행
  → 메인 agent: 요구 충족·변경 범위·검증 근거 확인
```

사용자 결정이 필요한 공백은 메인 agent가 질문하고, 답변을 designer에게 전달해 합의 기준을 갱신한다. 코드 결함은 implementer로, 검토 후 변경은 reviewer와 tester로 돌아간다. 상세 인계·재작업 규칙은 `feature-development.md`를 따른다.

이 구성은 지시 기반 오케스트레이션이다. 별도의 프로그램으로 실행 순서·재시도·상태 저장을 강제하는 엔진은 포함하지 않는다. 중간 중단 후 재개할 때에는 마지막 인계 결과와 실제 코드 변경을 다시 대조한다. 사용자에게 매 단계 승인을 요구하는 구성은 아니며, 업무 결정이나 범위 변경이 필요한 경우 질문한다.

역할 지시의 편집 금지는 별도의 OS 권한 격리가 아니다. subagent는 부모의 권한·샌드박스를 상속한다. 전역 제공자나 권한을 역할 파일에서 바꾸지 않는다.

## 공식 근거와 확인 범위

2026-11-09 공식 OpenAI 문서의 `.codex/agents/*.toml`, `name`, `description`, `developer_instructions`, `model`, `model_reasoning_effort` 형식을 기준으로 작성했다.

- [Subagents: custom agents 및 조정 기능](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [AGENTS.md 적용 방식](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [GPT-6.1 Sol 모델](https://developers.openai.com/api/docs/models/gpt-6.1-sol)
- [GPT-6 Astra 모델](https://developers.openai.com/api/docs/models/gpt-6-astra)

파일 형식·참조 경로·패키지 내용은 로컬에서 확인한다. 이 묶음을 개인설정에 설치하거나 실제 subagent로 기능 개발을 실행해 검증하지는 않았다. 대상 PC의 설치 버전과 모델 접근 권한은 적용 시 확인해야 한다.
