## 기능 개발의 역할 분담

기능 개발을 요청받으면 `.codex/workflows/feature-development.md`를 읽고 designer → implementer → reviewer → tester의 별도 subagent로 순차 수행한다. 각 역할은 `.codex/agents/<역할>.toml`의 모델·지시사항을 적용한다.

designer는 사용자와 이미 합의한 설계를 숙지하고 정합성을 관리한다. 사용자와의 설계 합의를 대체하거나 기능 설계를 처음부터 위임받는 역할이 아니다. 미정인 업무 결정과 합의 변경은 메인 agent가 사용자에게 질문한다.

공통 규칙은 `.codex/workflows/common.md`를 따른다. 이전 단계 완료 전에는 다음 역할을 실행하지 않으며, 명시적인 사용자 요청으로 생략한 단계는 최종 보고에 남긴다. 단순 조회·설명·오타 수정에는 이 네 단계 전체를 자동 적용하지 않는다.
