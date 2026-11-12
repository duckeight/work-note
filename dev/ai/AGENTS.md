# 코딩 작업 지침

## 작업 전 확인

- `maro-back`에서 코드를 살펴보거나 변경하기 전에 `coding-guidelines` 스킬(`/Users/yeongju/.codex/skills/coding-guidelines/SKILL.md`)을 읽고 적용한다.
- 이 저장소의 [agent-coding-rules/AGENTS.md](agent-coding-rules/AGENTS.md)를 읽고 적용한다. 한국어 설명은 [agent-coding-rules/AGENTS.ko.md](agent-coding-rules/AGENTS.ko.md)를 참고한다. 프론트엔드 작업이 포함되면 [agent-coding-rules/AGENTS-front.md](agent-coding-rules/AGENTS-front.md)도 읽고 적용한다.
- note의 공통 지침 `/Users/yeongju/dev/note/dev/ai/instructions/CODING_GUIDELINES.md`와 작업에 관련된 note 지시파일을 읽고 적용한다. 스킬이나 문서의 경로가 오래되었으면 실제 원본 위치를 확인하고, 찾지 못한 지침은 임의로 추정하지 말고 사용자에게 알린다.

## 프로젝트 지침의 우선순위

1. 현재 작업에 대한 사용자의 명시적인 요청과 확인된 결정
2. `maro-back`의 지시파일: 이 루트 `AGENTS.md`, 작업 경로의 하위 지시파일, `agent-coding-rules`의 관련 지침
3. 사용자의 `/Users/yeongju/dev/note`에 있는 지시파일

지시파일끼리 충돌하면 위 우선순위를 적용한다. 충돌하지 않는 지침은 함께 준수한다.

## 요청과 지침이 충돌할 때

- 사용자 요청이 적용 대상 지시파일의 규칙에 어긋나면, 요청이 우선한다는 이유만으로 바로 실행하지 않는다.
- 충돌하는 규칙과 파일 위치, 요청대로 진행할 때의 영향을 짧게 설명하고 예외로 진행할지 사용자에게 확인한다. 답변을 받기 전에는 충돌하는 부분을 진행하지 않으며, 독립적으로 수행할 수 있는 작업은 계속한다.
- 사용자가 해당 충돌의 예외 적용이나 지침 변경을 이미 명시적으로 승인했다면 같은 사항을 다시 묻지 않고 확인된 결정에 따라 진행한다.
