INSERT INTO public.alarm
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id,
 stage_id, alarm_severity, description, device_unit_id, gateway_id, location_path, occurred_at, status,
 status_changed_at, title, "type", duplication_count, message, remark)
VALUES ('1', 1, '1', 0, '1', 0, '1@1:1:1-1', '1:1:1', '1:1', '1:1:1-1', 'MAJOR', NULL, '1:1-38:opcua-model-01-9',
        '1:1-7', '/용접공장/For-Test-01', 1747196826263, 'OUTSTANDING', 1747196826263, NULL, 'DEVICE', 0, 'Device Opcua was turned off',
        NULL);
INSERT INTO public.alarm
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id,
 stage_id, alarm_severity, description, device_unit_id, gateway_id, location_path, occurred_at, status,
 status_changed_at, title, "type", duplication_count, message, remark)
VALUES ('2', 1, '1', 0, '1', 0, '1@1:1:1-1', '1:1:1', '1:1', '1:1:1-1', 'CRITICAL', NULL, null,
        '1:1-7', '/용접공장/For-Test-01', 1747196826263, 'OUTSTANDING', 1747196826263, NULL, 'NETWORK', 0, 'Gateway was turned off', NULL);

INSERT INTO public.notification_rule
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id,
 stage_id, alarm_types_json, description, enabled, "name", recipient_group_ids_json, recipient_ids_json,
 severities_json, alarm_scope_json, device_unit_alarm_scope_json, gateway_alarm_scope_json, location_alarm_scope_json)
VALUES ('G-1-1-15', 3, 'vizend@vizend.io', 1749449130975, 'vizend@vizend.io', 1748328997018, '1@1:1:1-1', '1:1:1',
        '1:1', '1:1:1-1', '["NETWORK","SYSTEM"]', '', true, 'IoT-Team-Noti-Rule', '["G-1-1-21","G-1-1-22"]',
        '["G-1-1-14","G-1-1-25"]', '["CRITICAL","MAJOR","MINOR","INFO"]',
        '{"all":false,"alarmScopeTargetIds":{"LOCATION":["HD:1-TestNoDelete"],"DEVICE_UNIT":["1:1-38:opcua-model-01-9","1:1-38:opcua-model-01-6"],"KURA_GATEWAY":["1:1-7"]}}',
        NULL, NULL, NULL);

INSERT INTO public.recipient
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id,
 stage_id, description, enabled, "name", notification_channels_json, receive_day_constraint_json,
 receive_time_constraint_json, recipient_group_ids_json)
VALUES ('G-1-1-16', 44, 'vizend@vizend.io', 1749534141608, 'vizend@vizend.io', 1747786181999, '1@1:1:1-1', '1:1:1',
        '1:1', '1:1:1-1', 'sfdsfdg', false, 'Brad Pitt', '[{"type":"SMS","destination":"010-0000-0004"}]',
        '{"enabled":true,"allowedDays":["THURSDAY","SUNDAY","SATURDAY","FRIDAY"]}',
        '{"enabled":false,"from":null,"to":null}', '["G-1-1-21","G-1-1-17","G-1-1-8","G-1-1-19"]');

INSERT INTO public.notification_history
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id,
 stage_id, alarm_severity, description, device_unit_id, gateway_id, location_path, notification_channel_json,
 notification_rule_id, notified_at, occurred_at, recipient_id, status, status_changed_at, title, "type", alarm_id,
 message, remark)
VALUES ('1', 1, '1', 0, '1', 0, '1@1:1:1-1', '1:1:1', '1:1', '1:1:1-1', 'CRITICAL', NULL, NULL, '1:1-7',
        '/용접공장/For-Test-01', '{"type":"SMS","destination":"010-0000-0004"}', 'G-1-1-15', 1747196826263, 1747196826263,
        'G-1-1-16', 'OUTSTANDING', 1747196826263, NULL, NULL, '2', 'Gateway was turned off', NULL);


-- incident
INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('1', 1, '1', 1750397357144, '1', 1750397357144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', '1:1-38:opcua-model-01-9', '1:1-7', '/용접공장/For-Test-01', 'Device Opcua was turned off', 1750397357144, NULL, 'DEVICE');
INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('2', 1, '1', 1750397357144, '1', 1750397357144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', null, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750397357144, NULL, 'SYSTEM');
INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('3', 1, '1', 1750393757144, '1', 1750393757144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750393757144, NULL, 'SYSTEM');

INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('4', 1, '1', 1750390157144, '1', 1750390157144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750390157144, NULL, 'SYSTEM');

INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('5', 1, '1', 1750386557144, '1', 1750386557144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750386557144, NULL, 'SYSTEM');

INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('6', 1, '1', 1750382957144, '1', 1750382957144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750382957144, NULL, 'SYSTEM');

INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('7', 1, '1', 1750379357144, '1', 1750379357144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750379357144, NULL, 'SYSTEM');

INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('8', 1, '1', 1750375757144, '1', 1750375757144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750375757144, NULL, 'SYSTEM');

INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('9', 1, '1', 1750372157144, '1', 1750372157144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750372157144, NULL, 'SYSTEM');

INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('10', 1, '1', 1750368557144, '1', 1750368557144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750368557144, NULL, 'SYSTEM');

INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('11', 1, '1', 1750364957144, '1', 1750364957144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750364957144, NULL, 'SYSTEM');

INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('12', 1, '1', 1750361357144, '1', 1750361357144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750361357144, NULL, 'SYSTEM');

INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('13', 1, '1', 1750357757144, '1', 1750357757144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750357757144, NULL, 'SYSTEM');

INSERT INTO public.incident
(id, entity_version, modified_by, modified_on, registered_by, registered_on, actor_id, cineroom_id, pavilion_id, stage_id, device_unit_id, gateway_id, location_path, message, occurred_at, remark, "type")
VALUES('14', 1, '1', 1750354157144, '1', 1750354157144, '1@1:1:1-1', '1:1', '1:1', '1:1:1-1', NULL, '1:1-7', '/용접공장/For-Test-01', 'Gateway was turned off', 1750354157144, NULL, 'SYSTEM');


