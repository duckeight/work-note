-- lakey.analysis_history definition

-- Drop table

-- DROP TABLE vizend_lakey_dev.analysis_history;
CREATE TABLE vizend_lakey_dev.analysis_history (
                                                   id varchar(255) NOT NULL,
                                                   goal text NULL,
                                                   retrieved_context text NULL,
                                                   final_prompt text NULL,
                                                   "result" text NULL,
                                                   verified bool NOT NULL,
                                                   analysis_job_execution_id varchar(255) NULL,
                                                   subject_id varchar(255) NULL,
                                                   execution_time int8 NOT NULL,
                                                   model_name varchar(255) NULL,
                                                   entity_version int8 NOT NULL,
                                                   modified_by varchar(255) NULL,
                                                   modified_on int8 NOT NULL,
                                                   registered_by varchar(255) NULL,
                                                   registered_on int8 NOT NULL,
                                                   actor_id varchar(255) NULL,
                                                   pavilion_id varchar(255) NULL,
                                                   stage_id varchar(255) NULL,
                                                   CONSTRAINT analysis_history_pkey PRIMARY KEY (id)
);

-- lakey.ANALYSIS_JOB definition

-- Drop table

-- DROP TABLE vizend_lakey_dev.ANALYSIS_JOB;

CREATE TABLE vizend_lakey_dev.analysis_job (
                                               id varchar(255) NOT NULL,
                                               "name" varchar(255) NULL,
                                               goal text NULL,
                                               scope_json text NULL,
                                               cron_schedule varchar(255) NULL,
                                               report_path varchar(255) NULL,
                                               active bool NOT NULL,
                                               instructions_json text NULL,
                                               lang_code varchar(255) NULL,
                                               result_type_json text NULL,
                                               system_id varchar(255) NULL,
                                               registered_on int8 NOT NULL,
                                               entity_version int8 NOT NULL,
                                               modified_by varchar(255) NULL,
                                               modified_on int8 NOT NULL,
                                               registered_by varchar(255) NULL,
                                               actor_id varchar(255) NULL,
                                               pavilion_id varchar(255) NULL,
                                               stage_id varchar(255) NULL,
                                               CONSTRAINT analysis_job_pkey PRIMARY KEY (id)
);

-- vizend_lakey_dev.analysis_job_execution definition

-- Drop table

-- DROP TABLE vizend_lakey_dev.analysis_job_execution;

CREATE TABLE vizend_lakey_dev.analysis_job_execution (
                                                         id varchar(255) NOT NULL,
                                                         round int4 NOT NULL,
                                                         execution_results_json text NULL,
                                                         target_end_time int8 NULL,
                                                         target_start_time int8 NULL,
                                                         result_type_json text NULL,
                                                         finished bool NULL,
                                                         analysis_job_id varchar(255) NULL,
                                                         entity_version int8 NOT NULL,
                                                         modified_by varchar(255) NULL,
                                                         modified_on int8 NOT NULL,
                                                         registered_by varchar(255) NULL,
                                                         registered_on int8 NOT NULL,
                                                         actor_id varchar(255) NULL,
                                                         pavilion_id varchar(255) NULL,
                                                         stage_id varchar(255) NULL,
                                                         CONSTRAINT analysis_job_execution_pkey PRIMARY KEY (id)
);

-- vizend_lakey_dev.analysis_result definition

-- Drop table

-- DROP TABLE vizend_lakey_dev.analysis_result;

CREATE TABLE vizend_lakey_dev.analysis_result (
                                                  id varchar(255) NOT NULL,
                                                  "result" text NULL,
                                                  verified bool NOT NULL,
                                                  subject_id varchar(255) NULL,
                                                  analysis_job_execution_id varchar(255) NULL,
                                                  entity_version int8 NOT NULL,
                                                  modified_by varchar(255) NULL,
                                                  modified_on int8 NOT NULL,
                                                  registered_by varchar(255) NULL,
                                                  registered_on int8 NOT NULL,
                                                  actor_id varchar(255) NULL,
                                                  pavilion_id varchar(255) NULL,
                                                  stage_id varchar(255) NULL,
                                                  CONSTRAINT analysis_result_pkey PRIMARY KEY (id)
);

INSERT INTO timeline
(id, entity_version, modified_by, modified_on, registered_by, registered_on, category, description, subject_id, subject_type, event_id, occurred_at)
VALUES
    ('TL-ERR-101', 1, 'SYSTEM', 1769300400100, 'SYSTEM', 1769300400100, 'Attendance', '주말 당직 근무에 지각했습니다. (09:20 도착)', 'WORKER-BAD-01', 'Member', 'TL-ERR-101', 1769300400000),
    ('TL-ERR-102', 1, 'SYSTEM', 1769314800200, 'SYSTEM', 1769314800200, 'Attendance', '점심시간 복귀가 1시간 지연되었습니다.', 'WORKER-BAD-02', 'Member', 'TL-ERR-102', 1769314800000),
    ('TL-ERR-103', 1, 'SYSTEM', 1769332800300, 'SYSTEM', 1769332800300, 'Attendance', '승인되지 않은 조기 퇴근을 시도했습니다.', 'WORKER-BAD-01', 'Member', 'TL-ERR-103', 1769332800000),
    ('TL-ERR-104', 1, 'SYSTEM', 1769364000400, 'SYSTEM', 1769364000400, 'Profile', '새벽 시간대(03:00) 사내 서버 비정상 접속 기록 발생.', 'WORKER-BAD-02', 'Member', 'TL-ERR-104', 1769364000000),
    ('TL-ERR-105', 1, 'SYSTEM', 1769403600500, 'SYSTEM', 1769403600500, 'DailyScrum', '휴일 긴급 회의에 연락 두절로 불참했습니다.', 'WORKER-BAD-01', 'Member', 'TL-ERR-105', 1769403600000),
    ('TL-ERR-106', 1, 'SYSTEM', 1769473800600, 'SYSTEM', 1769473800600, 'Attendance', '월요일 정기 회의 시간에 30분 늦게 출근했습니다.', 'WORKER-BAD-02', 'Member', 'TL-ERR-106', 1769473800000),
    ('TL-ERR-107', 1, 'SYSTEM', 1769475600700, 'SYSTEM', 1769475600700, 'DailyScrum', '업무 도중 잡담으로 주의를 받았습니다.', 'WORKER-BAD-01', 'Member', 'TL-ERR-107', 1769475600000),
    ('TL-ERR-108', 1, 'SYSTEM', 1769479200800, 'SYSTEM', 1769479200800, 'Attendance', '업무 시간 중 휴게실에서 취침하다 적발되었습니다.', 'WORKER-BAD-02', 'Member', 'TL-ERR-108', 1769479200000),
    ('TL-ERR-109', 1, 'SYSTEM', 1769490000900, 'SYSTEM', 1769490000900, 'Attendance', '근무지 이탈 (사우나 방문 의심) 정황이 포착되었습니다.', 'WORKER-BAD-01', 'Member', 'TL-ERR-109', 1769490000000),
    ('TL-ERR-110', 1, 'SYSTEM', 1769499001000, 'SYSTEM', 1769499001000, 'Attendance', '퇴근 시간 30분 전부터 업무 중단하고 대기했습니다.', 'WORKER-BAD-02', 'Member', 'TL-ERR-110', 1769499000000);




CREATE TABLE vizend_lakey_dev.timeline_summary (
                                                   id varchar(255) NOT NULL,
                                                   subject_type varchar(255) NULL,
                                                   subject_id varchar(255) NULL,
                                                   category varchar(255) NULL,
                                                   description text NULL,
                                                   summarized_from int8 NOT NULL,
                                                   summarized_to int8 NOT NULL,
                                                   summary_period varchar(255) NULL,
                                                   timeline_summary_job_id varchar(255) NULL,
                                                   entity_version int8 NOT NULL,
                                                   modified_by varchar(255) NULL,
                                                   modified_on int8 NOT NULL,
                                                   registered_by varchar(255) NULL,
                                                   registered_on int8 NOT NULL,
                                                   actor_id varchar(255) NULL,
                                                   pavilion_id varchar(255) NULL,
                                                   stage_id varchar(255) NULL,
                                                   CONSTRAINT timeline_summary_pkey PRIMARY KEY (id),
                                                   CONSTRAINT timeline_summary_summary_period_check CHECK (((summary_period)::text = ANY ((ARRAY['Daily'::character varying, 'Weekly'::character varying, 'Monthly'::character varying])::text[])))
);

CREATE TABLE vizend_lakey_dev.timeline_summary_job (
                                                       id varchar(255) NOT NULL,
                                                       subject_type varchar(255) NULL,
                                                       category varchar(255) NULL,
                                                       requested_query text NULL,
                                                       start_date date NULL,
                                                       summary_period varchar(255) NULL,
                                                       active bool NOT NULL,
                                                       entity_version int8 NOT NULL,
                                                       modified_by varchar(255) NULL,
                                                       modified_on int8 NOT NULL,
                                                       registered_by varchar(255) NULL,
                                                       registered_on int8 NOT NULL,
                                                       actor_id varchar(255) NULL,
                                                       pavilion_id varchar(255) NULL,
                                                       stage_id varchar(255) NULL,
                                                       CONSTRAINT timeline_summary_job_pkey PRIMARY KEY (id),
                                                       CONSTRAINT timeline_summary_job_summary_period_check CHECK (((summary_period)::text = ANY ((ARRAY['Daily'::character varying, 'Weekly'::character varying, 'Monthly'::character varying])::text[])))
);

-- vizend_lakey_dev.raw_event definition

-- Drop table

-- DROP TABLE vizend_lakey_dev.raw_event;

CREATE TABLE vizend_lakey_dev.raw_event (
                                            id varchar(255) NOT NULL,
                                            event_id varchar(255) NULL,
                                            event_type varchar(255) NULL,
                                            payload_json text NULL,
                                            occurred_at int8 NOT NULL,
                                            topic_name varchar(255) NULL,
                                            conversion_status varchar(255) NULL,
                                            entity_version int8 NOT NULL,
                                            modified_by varchar(255) NULL,
                                            modified_on int8 NOT NULL,
                                            registered_by varchar(255) NULL,
                                            registered_on int8 NOT NULL,
                                            CONSTRAINT raw_event_pkey PRIMARY KEY (id)
);