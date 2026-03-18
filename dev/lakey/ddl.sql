-- lakey.ANALYSIS_JOB definition

-- Drop table

-- DROP TABLE vizend_lakey_dev.ANALYSIS_JOB;

CREATE TABLE vizend_lakey_dev.analysis_job (
                                    id varchar(255) NOT NULL,
                                    "name" varchar(255) NULL,
                                    goal text NULL,
                                    scope_json text NULL,
                                    cron_schedule varchar(255) NULL,
                                    code varchar(255) NULL,
                                    active bool NOT NULL,
                                    instructions_json text NULL,
                                    lang_code varchar(255) NULL,
                                    result_type_json text NULL,
                                    context_type varchar(255) NULL,
                                    system_id varchar(255) NULL,
                                    registered_on int8 NOT NULL,
                                    entity_version int8 NOT NULL,
                                    modified_by varchar(255) NULL,
                                    modified_on int8 NOT NULL,
                                    registered_by varchar(255) NULL,
                                    actor_id varchar(255) NULL,
                                    pavilion_id varchar(255) NULL,
                                    stage_id varchar(255) NULL,
                                    CONSTRAINT analysis_job_context_type_check CHECK (((context_type)::text = ANY ((ARRAY['Timeline'::character varying, 'Profile'::character varying])::text[]))),
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

-- lakey.analysis_history definition

-- Drop table

-- DROP TABLE vizend_lakey_dev.analysis_history;
CREATE TABLE vizend_lakey_dev.analysis_history (
                                                   id varchar(255) NOT NULL,
                                                   goal text NULL,
                                                   retrieved_context text NULL,
                                                   final_prompt text NULL,
                                                   result_json text NULL,
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
-- vizend_lakey_dev.analysis_result definition

-- Drop table

-- DROP TABLE vizend_lakey_dev.analysis_result;

CREATE TABLE vizend_lakey_dev.analysis_result (
                                                  id varchar(255) NOT NULL,
                                                  result_json text NULL,
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

CREATE TABLE vizend_lakey_dev.timeline (
                                           id varchar(255) NOT NULL,
                                           subject_type varchar(255) NULL,
                                           subject_id varchar(255) NULL,
                                           category varchar(255) NULL,
                                           description text NULL,
                                           occurred_at int8 NOT NULL,
                                           event_id varchar(255) NULL,
                                           entity_version int8 NOT NULL,
                                           modified_on int8 NOT NULL,
                                           modified_by varchar(255) NULL,
                                           registered_by varchar(255) NULL,
                                           registered_on int8 NOT NULL,
                                           pavilion_id varchar(255) NULL,
                                           stage_id varchar(255) NULL,
                                           actor_id varchar(255) NULL,
                                           CONSTRAINT timeline_pkey PRIMARY KEY (id)
);
CREATE INDEX timeline_event_id_idx ON vizend_lakey_dev.timeline USING btree (event_id);
CREATE TABLE vizend_lakey_dev.timeline_summary (
                                                   id varchar(255) NOT NULL,
                                                   subject_type varchar(255) NULL,
                                                   subject_id varchar(255) NULL,
                                                   category varchar(255) NULL,
                                                   description text NULL,
                                                   summarized_from int8 NOT NULL,
                                                   summarized_to int8 NOT NULL,
                                                   summary_period_json text NULL,
                                                   timeline_summary_job_id varchar(255) NULL,
                                                   entity_version int8 NOT NULL,
                                                   modified_by varchar(255) NULL,
                                                   modified_on int8 NOT NULL,
                                                   registered_by varchar(255) NULL,
                                                   registered_on int8 NOT NULL,
                                                   actor_id varchar(255) NULL,
                                                   pavilion_id varchar(255) NULL,
                                                   stage_id varchar(255) NULL,
                                                   CONSTRAINT timeline_summary_pkey PRIMARY KEY (id)
);

CREATE TABLE vizend_lakey_dev.timeline_summary_job (
                                                       id varchar(255) NOT NULL,
                                                       subject_type varchar(255) NULL,
                                                       category varchar(255) NULL,
                                                       requested_query text NULL,
                                                       start_date date NULL,
                                                       summary_period_json text NULL,
                                                       active bool NOT NULL,
                                                       entity_version int8 NOT NULL,
                                                       modified_by varchar(255) NULL,
                                                       modified_on int8 NOT NULL,
                                                       registered_by varchar(255) NULL,
                                                       registered_on int8 NOT NULL,
                                                       actor_id varchar(255) NULL,
                                                       pavilion_id varchar(255) NULL,
                                                       stage_id varchar(255) NULL,
                                                       CONSTRAINT timeline_summary_job_pkey PRIMARY KEY (id)
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
                                            conversion_failed_message varchar(255) NULL,
                                            entity_version int8 NOT NULL,
                                            modified_by varchar(255) NULL,
                                            modified_on int8 NOT NULL,
                                            registered_by varchar(255) NULL,
                                            registered_on int8 NOT NULL,
                                            CONSTRAINT raw_event_pkey PRIMARY KEY (id)
);

-- vizend_lakey_dev.profile definition

-- Drop table

-- DROP TABLE vizend_lakey_dev.profile;

CREATE TABLE vizend_lakey_dev.profile (
                                          id varchar(255) NOT NULL,
                                          event_id varchar(255) NULL,
                                          subject_id varchar(255) NULL,
                                          subject_type varchar(255) NULL,
                                          content_descriptions_json text NULL,
                                          related_subjects_json text NULL,
                                          entity_version int8 NOT NULL,
                                          modified_by varchar(255) NULL,
                                          modified_on int8 NOT NULL,
                                          registered_by varchar(255) NULL,
                                          registered_on int8 NOT NULL,
                                          actor_id varchar(255) NULL,
                                          pavilion_id varchar(255) NULL,
                                          stage_id varchar(255) NULL,
                                          CONSTRAINT profile_pkey PRIMARY KEY (id)
);


CREATE TABLE vizend_lakey_dev.profile_vector (
                                                 id varchar(255) NULL,
                                                 category varchar(255) NULL,
                                                 description text NULL,
                                                 profile_id varchar(255) NULL,
                                                 related_subjects_json text NULL,
                                                 vector _float4 NULL,
                                                 entity_version int8 NOT NULL,
                                                 modified_by varchar(255) NULL,
                                                 modified_on int8 NOT NULL,
                                                 registered_by varchar(255) NULL,
                                                 registered_on int8 NOT NULL,
                                                 actor_id varchar(255) NULL,
                                                 pavilion_id varchar(255) NULL,
                                                 stage_id varchar(255) NULL,
                                                 CONSTRAINT profile_vector_pkey PRIMARY KEY (id)
);

CREATE INDEX idx_pv_related_subjects_cast_gin
    ON vizend_lakey_dev.profile_vector USING gin ((related_subjects_json::jsonb) jsonb_path_ops);
