-- lakey.analysis_history definition

-- Drop table

-- DROP TABLE vizend_lakey_dev.analysis_history;

CREATE TABLE vizend_lakey_dev.analysis_history (
                                   id varchar(255) NOT NULL,
                                   request_query text NULL,
                                   retrieved_context text NULL,
                                   final_prompt text NULL,
                                   result text NULL,
                                   analysis_job_id varchar(255) NULL,
                                   subject_id varchar(255) NULL,
                                   execution_time int8 NOT NULL,
                                   model_name varchar(255) NULL,
                                   registered_on int8 NOT NULL,
                                   entity_version int8 NOT NULL,
                                   modified_by varchar(255) NULL,
                                   modified_on int8 NOT NULL,
                                   registered_by varchar(255) NULL,
                                   actor_id varchar(255) NULL,
                                   pavilion_id varchar(255) NULL,
                                   stage_id varchar(255) NULL,
                                   CONSTRAINT analysis_history_pkey PRIMARY KEY (id)
);

-- lakey.ANALYSIS_JOB definition

-- Drop table

-- DROP TABLE vizend_lakey_dev.ANALYSIS_JOB;

CREATE TABLE vizend_lakey_dev.ANALYSIS_JOB (
                                                   id varchar(255) NOT NULL,
                                                   name varchar(255) NULL,
                                                   request_query text NULL,
                                                   scope_json text NULL,
                                                   cron_schedule varchar(255) NULL,
                                                   report_path varchar(255) NULL,
                                                   active boolean NOT NULL,
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