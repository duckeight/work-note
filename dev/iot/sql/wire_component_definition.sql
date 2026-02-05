INSERT INTO public.wire_component_definition
(id, entity_version, factory_pid, kura_service_factory_pid, min_input_ports, max_input_ports, default_input_ports, min_output_ports, max_output_ports, default_output_ports, wire_component_type, wire_component_field_definitions_json, field_sequence, registered_by, registered_on, modified_by, modified_on, cineroom_id, pavilion_id, actor_id, stage_id, description, "name")
VALUES('1:1:1-1', 4, 'ModbusDriver', 'com.hd.edgewise.kura.wire.component.driver.modbus.ModbusDriver', 1, 1, 1, 1, 1, 1, 'Source', '[
  {
    "fieldId": "device.unit.id",
    "label": "Device Unit ID",
    "description": "Device Unit ID description",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "ip",
    "label": "Host IP",
    "description": "Modbus Host IP (e.g., localhost)",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "port",
    "label": "Host Port",
    "description": "Modbus Host Port",
    "dataType": "Long",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "enabled",
    "label": "Enable data collection",
    "description": "Set Device Enabled edit",
    "dataType": "Boolean",
    "defaultValue": false,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "zeroBased",
    "label": "Modbus Address Zero Based",
    "description": "Set Modbus Address Zero Based",
    "dataType": "Boolean",
    "defaultValue": true,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "periodic-fetch-millis",
    "label": "Periodic Fetch Millis",
    "description": "Milli Seconds to Fetch Data Periodically",
    "dataType": "Long",
    "defaultValue": 500,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+name",
    "label": "Name of the Channel",
    "description": "Name of the Channel",
    "dataType": "String",
    "defaultValue": "Channel-1",
    "channel": true,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+type",
    "label": "Type",
    "description": "Read or Write",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "Read",
        "value": "Read"
      },
      {
        "label": "Read_Write",
        "value": "Read_Write"
      }
    ]
  },
  {
    "fieldId": "+value.type",
    "label": "Value type of the Channel",
    "description": "Value type of the channel",
    "dataType": "String",
    "defaultValue": "Long",
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "Boolean",
        "value": "Boolean"
      },
      {
        "label": "String",
        "value": "String"
      },
      {
        "label": "Long",
        "value": "Long"
      },
      {
        "label": "Double",
        "value": "Double"
      }
    ]
  },
  {
    "fieldId": "+range.filter.enabled",
    "label": "Range Filter of the Channel",
    "description": "Range Filter of the Channel",
    "dataType": "Boolean",
    "defaultValue": false,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+range.lower",
    "label": "Lower Range",
    "description": "Lower Range of the Channel",
    "dataType": "Double",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+range.upper",
    "label": "Upper Range",
    "description": "Upper Range of the Channel",
    "dataType": "Double",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "address",
    "label": "Modbus Address",
    "description": "Modbus address",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "signed",
    "label": "Is Signed Value",
    "description": "Is Signed Value",
    "dataType": "Boolean",
    "defaultValue": false,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "endian",
    "label": "Endian",
    "description": "Endian",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": [
      {
        "label": "BigEndian",
        "value": "BigEndian"
      },
      {
        "label": "LittleEndian",
        "value": "LittleEndian"
      }
    ]
  },
  {
    "fieldId": "bit.mask",
    "label": "Bit Mask",
    "description": "Bit Mask",
    "dataType": "Long",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "enumeration",
    "label": "Enumeration",
    "description": "Enumeration",
    "dataType": "Boolean",
    "defaultValue": false,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "aggregationType",
    "label": "Aggregation Type",
    "description": "Aggregation type of Data",
    "dataType": "Long",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": [
      {
        "label": "Average",
        "value": "AVERAGE"
      },
      {
        "label": "Minimum",
        "value": "MIN"
      },
      {
        "label": "Maximum",
        "value": "MAX"
      },
      {
        "label": "First",
        "value": "FIRST"
      },
      {
        "label": "Last",
        "value": "LAST"
      },
      {
        "label": "Median",
        "value": "MEDIAN"
      }
    ]
  }
]', 0, 'vizend@vizend.io', 1741599258205, 'vizend@vizend.io', 1752118437895, '1:1:1', '1:1:1', '1@1:1:1-1', '1:1:1-1', 'Modbus Driver Description', 'ModbusDriver');
INSERT INTO public.wire_component_definition
(id, entity_version, factory_pid, kura_service_factory_pid, min_input_ports, max_input_ports, default_input_ports, min_output_ports, max_output_ports, default_output_ports, wire_component_type, wire_component_field_definitions_json, field_sequence, registered_by, registered_on, modified_by, modified_on, cineroom_id, pavilion_id, actor_id, stage_id, description, "name")
VALUES('1:1:1-2', 3, 'FileLogWire', 'com.hd.edgewise.kura.wire.component.logger.FileLogWire', 1, 1, 1, 1, 1, 1, 'Sink', '[{"fieldId":"baseLogDirectory","label":"Base log directory","description":"log files will be generated under the directory","dataType":"String","defaultValue":"logs","channel":false,"required":true,"readonly":true,"options":[]}]', 0, 'vizend@vizend.io', 1741489458334, 'vizend@vizend.io', 1743054959550, '1:1:1', '1:1:1', '1@1:1:1-1', '1:1:1-1', '', 'FileLogWire');
INSERT INTO public.wire_component_definition
(id, entity_version, factory_pid, kura_service_factory_pid, min_input_ports, max_input_ports, default_input_ports, min_output_ports, max_output_ports, default_output_ports, wire_component_type, wire_component_field_definitions_json, field_sequence, registered_by, registered_on, modified_by, modified_on, cineroom_id, pavilion_id, actor_id, stage_id, description, "name")
VALUES('1:1:1-4', 1, 'SerialDriver', 'com.hd.edgewise.kura.wire.component.driver.serial.SerialDriver', 1, 1, 1, 1, 1, 1, 'Source', '[
  {
    "fieldId": "device.unit.id",
    "label": "Device Unit ID",
    "description": "Device Unit ID",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "enabled",
    "label": "Device Enabled",
    "description": "Set Device Enabled",
    "dataType": "Boolean",
    "defaultValue": false,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "ip",
    "label": "Host IP",
    "description": "Set Serial Tcp Host Ip",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "port",
    "label": "Host Port",
    "description": "Set Serial Tcp Host Port",
    "dataType": "Long",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "fixed.data.length",
    "label": "Fixed Data Length",
    "description": "Set Length Of Data Uploaded Through Serial Communication",
    "dataType": "Long",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "scan.rate",
    "label": "Scan Rate",
    "description": "Set Scan Rate In Milliseconds",
    "dataType": "Long",
    "defaultValue": 1000,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+name",
    "label": "name",
    "description": "Name of Channel",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+type",
    "label": "Type",
    "description": "Read or Write",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "Read",
        "value": "Read"
      },
      {
        "label": "Read_Write",
        "value": "Read_Write"
      }
    ]
  },
  {
    "fieldId": "+value.type",
    "label": "Value Type",
    "description": "Value Type of Channel",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "Boolean",
        "value": "Boolean"
      },
      {
        "label": "String",
        "value": "String"
      },
      {
        "label": "Long",
        "value": "Long"
      },
      {
        "label": "Double",
        "value": "Double"
      }
    ]
  },
  {
    "fieldId": "+range.filter.enabled",
    "label": "Range Filter of the Channel",
    "description": "Range Filter of the Channel",
    "dataType": "Boolean",
    "defaultValue": false,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+range.lower",
    "label": "Lower Range",
    "description": "Lower Range of the Channel",
    "dataType": "Double",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+range.upper",
    "label": "Upper Range",
    "description": "Upper Range of the Channel",
    "dataType": "Double",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+value",
    "label": "Value",
    "description": "Value of the Channel",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+unit",
    "label": "Unit",
    "description": "Unit of the Channel",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+scale",
    "label": "Scale",
    "description": "Scale to be applied to numeric value of the channel",
    "dataType": "Double",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "index",
    "label": "Index",
    "description": "Serial Index",
    "dataType": "Long",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "sub.index",
    "label": "Sub Index",
    "description": "Serial Sub Index",
    "dataType": "Long",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "length",
    "label": "Length",
    "description": "Channel Byte Length",
    "dataType": "Long",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "data.type",
    "label": "Data Type",
    "description": "Source Data Type",
    "dataType": "String",
    "defaultValue": "ASCII",
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "ASCII",
        "value": "ASCII"
      },
      {
        "label": "BINARY",
        "value": "BINARY"
      }
    ]
  },
  {
    "fieldId": "aggregationType",
    "label": "Aggregation Type",
    "description": "Aggregation type of Data",
    "dataType": "Long",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": [
      {
        "label": "Average",
        "value": "AVERAGE"
      },
      {
        "label": "Minimum",
        "value": "MIN"
      },
      {
        "label": "Maximum",
        "value": "MAX"
      },
      {
        "label": "First",
        "value": "FIRST"
      },
      {
        "label": "Last",
        "value": "LAST"
      },
      {
        "label": "Median",
        "value": "MEDIAN"
      }
    ]
  }
]', 0, 'vizend@vizend.io', 1741599258205, 'vizend@vizend.io', 1742181918495, '1:1:1', '1:1', '1@1:1:1-1', '1:1:1-1', 'test 수정', 'SerialDriver');
INSERT INTO public.wire_component_definition
(id, entity_version, factory_pid, kura_service_factory_pid, min_input_ports, max_input_ports, default_input_ports, min_output_ports, max_output_ports, default_output_ports, wire_component_type, wire_component_field_definitions_json, field_sequence, registered_by, registered_on, modified_by, modified_on, cineroom_id, pavilion_id, actor_id, stage_id, description, "name")
VALUES('1:1:1-5', 1, 'RtdeDriver', 'com.hd.edgewise.kura.wire.component.driver.rtde.RtdeDriver', 1, 1, 1, 1, 1, 1, 'Source', '[
  {
    "fieldId": "device.unit.id",
    "label": "Device Unit ID",
    "description": "Device Unit ID",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "ip",
    "label": "Host IP",
    "description": "RTDE Host IP",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "port",
    "label": "Host Port",
    "description": "RTDE Host Port",
    "dataType": "Long",
    "defaultValue": 30004,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "enabled",
    "label": "Enable RTDE",
    "description": "Enable RTDE Data Streaming",
    "dataType": "Boolean",
    "defaultValue": true,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "frequency",
    "label": "Sampling Frequency",
    "description": "Number of times per second RTDE data is fetched",
    "dataType": "Long",
    "defaultValue": 100,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+name",
    "label": "Name",
    "description": "Name of Channel",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+type",
    "label": "Type",
    "description": "Read or Write",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "Read",
        "value": "Read"
      },
      {
        "label": "Read_Write",
        "value": "Read_Write"
      }
    ]
  },
  {
    "fieldId": "+value.type",
    "label": "Value Type",
    "description": "value.type of Channel",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "Boolean",
        "value": "Boolean"
      },
      {
        "label": "String",
        "value": "String"
      },
      {
        "label": "Long",
        "value": "Long"
      },
      {
        "label": "Double",
        "value": "Double"
      }
    ]
  },
  {
    "fieldId": "+range.filter.enabled",
    "label": "Range Filter of the Channel",
    "description": "Range Filter of the Channel",
    "dataType": "Boolean",
    "defaultValue": false,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+range.lower",
    "label": "Lower Range",
    "description": "Lower Range of the Channel",
    "dataType": "Double",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+range.upper",
    "label": "Upper Range",
    "description": "Upper Range of the Channel",
    "dataType": "Double",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "fieldName",
    "label": "Field Name",
    "description": "Field Name - RTDE Field Name",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "index",
    "label": "Index",
    "description": "Index of Vector Data",
    "dataType": "Long",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": [
      {
        "label": "0",
        "value": 0
      },
      {
        "label": "1",
        "value": 1
      },
      {
        "label": "2",
        "value": 2
      },
      {
        "label": "3",
        "value": 3
      },
      {
        "label": "4",
        "value": 4
      },
      {
        "label": "5",
        "value": 5
      }
    ]
  },
  {
    "fieldId": "data.type",
    "label": "Data Type",
    "description": "RTDE Field Type",
    "dataType": "String",
    "defaultValue": "DOUBLE",
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "BOOL",
        "value": "BOOL"
      },
      {
        "label": "UINT8",
        "value": "UINT8"
      },
      {
        "label": "INT32",
        "value": "INT32"
      },
      {
        "label": "UINT32",
        "value": "UINT32"
      },
      {
        "label": "UINT64",
        "value": "UINT64"
      },
      {
        "label": "DOUBLE",
        "value": "DOUBLE"
      },
      {
        "label": "VECTOR3D",
        "value": "VECTOR3D"
      },
      {
        "label": "VECTOR6D",
        "value": "VECTOR6D"
      },
      {
        "label": "VECTOR6INT32",
        "value": "VECTOR6INT32"
      }
    ]
  },
  {
    "fieldId": "aggregationType",
    "label": "Aggregation Type",
    "description": "Aggregation type of Data",
    "dataType": "Long",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": [
      {
        "label": "Average",
        "value": "AVERAGE"
      },
      {
        "label": "Minimum",
        "value": "MIN"
      },
      {
        "label": "Maximum",
        "value": "MAX"
      },
      {
        "label": "First",
        "value": "FIRST"
      },
      {
        "label": "Last",
        "value": "LAST"
      },
      {
        "label": "Median",
        "value": "MEDIAN"
      }
    ]
  }
]', 0, 'vizend@vizend.io', 1741599258205, 'vizend@vizend.io', 1742193961899, '1:1:1', '1:1', '1@1:1:1-1', '1:1:1-1', '', 'RtdeDriver');
INSERT INTO public.wire_component_definition
(id, entity_version, factory_pid, kura_service_factory_pid, min_input_ports, max_input_ports, default_input_ports, min_output_ports, max_output_ports, default_output_ports, wire_component_type, wire_component_field_definitions_json, field_sequence, registered_by, registered_on, modified_by, modified_on, cineroom_id, pavilion_id, actor_id, stage_id, description, "name")
VALUES('1:1:1-3', 0, 'MqttPubWire', 'com.hd.edgewise.kura.wire.component.mqtt.MqttPubWire', 1, 2, 1, 0, 0, 0, 'Sink', '[
  {
    "fieldId": "topic",
    "label": "Topic",
    "description": "The topic to publish messages to (If empty, the default topic will be applied)",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "qos",
    "label": "QoS",
    "description": "The quality of service level for the published messages",
    "dataType": "Long",
    "defaultValue": 0,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "At most once (0)",
        "value": 0
      },
      {
        "label": "At least once (1)",
        "value": 1
      },
      {
        "label": "Exactly once (2)",
        "value": 2
      }
    ]
  },
  {
    "fieldId": "retain",
    "label": "Retain",
    "description": "Whether to set the retain flag on published messages",
    "dataType": "Boolean",
    "defaultValue": false,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "clean.session",
    "label": "Clean Session",
    "description": "Whether to start a clean session on each connection",
    "dataType": "Boolean",
    "defaultValue": true,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "keep.alive",
    "label": "Keep Alive (seconds)",
    "description": "The keep alive interval in seconds",
    "dataType": "Long",
    "defaultValue": 60,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "influxdb.url",
    "label": "InfluxDB URL",
    "description": "The URL of the InfluxDB",
    "dataType": "String",
    "defaultValue": "http://influxdbold:8086",
    "channel": false,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "influxdb.user",
    "label": "InfluxDB User",
    "description": "The User of the InfluxDB",
    "dataType": "String",
    "defaultValue": "admin",
    "channel": false,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "influxdb.password",
    "label": "InfluxDB Password",
    "description": "The Password of the InfluxDB",
    "dataType": "String",
    "defaultValue": "bizadmin",
    "channel": false,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "influxdb.database",
    "label": "InfluxDB Database",
    "description": "The Database of the InfluxDB",
    "dataType": "String",
    "defaultValue": "hd-iot",
    "channel": false,
    "required": false,
    "readonly": false,
    "options": []
  }
]', 0, 'vizend@vizend.io', 1741314835473, 'vizend@vizend.io', 0, '1:1:1', '1:1:1', '1@1:1:1-1', '1:1:1-1', NULL, 'MqttPubWire');
INSERT INTO public.wire_component_definition
(id, entity_version, factory_pid, kura_service_factory_pid, min_input_ports, max_input_ports, default_input_ports, min_output_ports, max_output_ports, default_output_ports, wire_component_type, wire_component_field_definitions_json, field_sequence, registered_by, registered_on, modified_by, modified_on, cineroom_id, pavilion_id, actor_id, stage_id, description, "name")
VALUES('1:1:1-6', 2, 'InfluxDbWire', 'com.hd.edgewise.kura.wire.component.db.influxdb.provider.InfluxDbWire', 1, 1, 1, 1, 1, 1, 'Sink', '[{"fieldId":"influxdb.url","label":"InfluxDB Url","description":"Host Address for InfluxDb","dataType":"String","defaultValue":null,"channel":false,"required":true,"readonly":false,"options":[]},{"fieldId":"influxdb.user","label":"InfluxDB User","description":"InfluxDB User","dataType":"String","defaultValue":null,"channel":false,"required":true,"readonly":false,"options":[]},{"fieldId":"influxdb.password","label":"InfluxDB Password","description":"InfluxDB Password","dataType":"String","defaultValue":null,"channel":false,"required":false,"readonly":false,"options":[]},{"fieldId":"influxdb.database","label":"Database","description":"Database Name","dataType":"String","defaultValue":null,"channel":false,"required":true,"readonly":false,"options":[]}]', 0, 'vizend@vizend.io', 1741489458334, 'iot_user', 1742910601634, '1:1:1', '1:1:1', '1@1:1:1-1', '1:1:1-1', 'InfluxDBWire', 'InfluxDbWire');
INSERT INTO public.wire_component_definition
(id, entity_version, factory_pid, kura_service_factory_pid, min_input_ports, max_input_ports, default_input_ports, min_output_ports, max_output_ports, default_output_ports, wire_component_type, wire_component_field_definitions_json, field_sequence, registered_by, registered_on, modified_by, modified_on, cineroom_id, pavilion_id, actor_id, stage_id, description, "name")
VALUES('1:1:1-7', 1, 'OpcUaDriver', 'org.eclipse.kura.driver.opcua', 1, 1, 1, 1, 1, 1, 'Source', '[
  {
    "fieldId": "device.unit.id",
    "label": "Device Unit ID",
    "description": "Device Unit ID description",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "endpoint.ip",
    "label": "Host IP",
    "description": "OPC-UA Endpoint IP Address",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "endpoint.port",
    "label": "Host Port",
    "description": "OPC-UA Endpoint Port",
    "dataType": "Long",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": true,
    "options": []
  },
  {
    "fieldId": "server.name",
    "label": "Server Name",
    "description": "OPC-UA Server Name",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "force.endpoint.url",
    "label": "Force endpoint URL",
    "description": "If set to true the driver will use the hostname, port, and server name parameters specified in the configuration instead of the values contained in endpoint descriptions fetched from the server.",
    "dataType": "Boolean",
    "defaultValue": true,
    "channel": false,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "session.timeout",
    "label": "Session timeout",
    "description": "Session timeout (in seconds)",
    "dataType": "Long",
    "defaultValue": 120,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "request.timeout",
    "label": "Request timeout",
    "description": "Request timeout (in seconds)",
    "dataType": "Long",
    "defaultValue": 60,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "acknowledge.timeout",
    "label": "Acknowledge timeout",
    "description": "The time to wait for the server response to the ''Hello'' message (in seconds)",
    "dataType": "Long",
    "defaultValue": 40,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "application.name",
    "label": "Application name",
    "description": "OPC-UA application name",
    "dataType": "String",
    "defaultValue": "opc-ua client",
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "application.uri",
    "label": "Application URI",
    "description": "OPC-UA application uri",
    "dataType": "String",
    "defaultValue": "urn:kura:opcua:client",
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "subscription.publish.interval",
    "label": "Subscription publish interval",
    "description": "The publish interval in milliseconds for the subscription created by the driver.",
    "dataType": "Long",
    "defaultValue": 1000,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "certificate.location",
    "label": "Keystore path",
    "description": "Absolute path of the PKCS or JKS keystore that contains the OPC-UA client certificate, private key and trusted server certificates",
    "dataType": "String",
    "defaultValue": "PFX or JKS Keystore",
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "security.policy",
    "label": "Security policy",
    "description": "Security Policy",
    "dataType": "Long",
    "defaultValue": 0,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "None",
        "value": 0
      },
      {
        "label": "Basic128Rsa15",
        "value": 1
      },
      {
        "label": "Basic256",
        "value": 2
      },
      {
        "label": "Basic256Sha256",
        "value": 3
      }
    ]
  },
  {
    "fieldId": "username",
    "label": "Username",
    "description": "OPC-UA server username",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "password",
    "label": "Password",
    "description": "OPC-UA server password",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "keystore.client.alias",
    "label": "Client certificate alias",
    "description": "Alias for the client certificate in the keystore",
    "dataType": "String",
    "defaultValue": "client-ai",
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "authenticate.server",
    "label": "Enable server authentication",
    "description": "Specifies whether to enable or not server certificate verification. If set to true, server certificate will be checked to be valid, not expired and trusted according to the certificates currently in the keystore. Server certificate SubjectAlternativeName will also be matched against server application URI. If set to false, no checks will be performed (This should be used for testing purposes only).",
    "dataType": "Boolean",
    "defaultValue": true,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "keystore.type",
    "label": "Keystore type",
    "description": "Keystore type",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "JKS",
        "value": "JKS"
      },
      {
        "label": "PKCS11",
        "value": "PKCS11"
      },
      {
        "label": "PKCS12",
        "value": "PKCS12"
      }
    ]
  },
  {
    "fieldId": "keystore.password",
    "label": "Keystore password",
    "description": "Configurable Property to set keystore password (default set to password)",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "max.request.items",
    "label": "Max request items",
    "description": "Maximum number of items that will be included in a single request to the server.",
    "dataType": "Long",
    "defaultValue": 200,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "subtree.subscription.name.format",
    "label": "Subtree subscription events channel name format",
    "description": "The format to be used for channel name for subtree subscriptions. If set to BROWSE_PATH, the channel name will contain the browse path of the source node relative to the subscription root. If set to NODE_ID, the name will contain the node id of the source node.",
    "dataType": "String",
    "defaultValue": null,
    "channel": false,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "BROWSE_PATH",
        "value": "BROWSE_PATH"
      },
      {
        "label": "NODE_ID",
        "value": "NODE_ID"
      }
    ]
  },
  {
    "fieldId": "+name",
    "label": "Name of the Channel",
    "description": "Name of the Channel",
    "dataType": "String",
    "defaultValue": "Channel-1",
    "channel": true,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+type",
    "label": "Type",
    "description": "Read or Write",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "Read",
        "value": "Read"
      },
      {
        "label": "Read_Write",
        "value": "Read_Write"
      }
    ]
  },
  {
    "fieldId": "+value.type",
    "label": "Value type of the Channel",
    "description": "Value type of the channel",
    "dataType": "String",
    "defaultValue": "Long",
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "Boolean",
        "value": "Boolean"
      },
      {
        "label": "String",
        "value": "String"
      },
      {
        "label": "Long",
        "value": "Long"
      },
      {
        "label": "Double",
        "value": "Double"
      }
    ]
  },
  {
    "fieldId": "+range.filter.enabled",
    "label": "Range Filter of the Channel",
    "description": "Range Filter of the Channel",
    "dataType": "Boolean",
    "defaultValue": false,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+range.lower",
    "label": "Lower Range",
    "description": "Lower Range of the Channel",
    "dataType": "Double",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+range.upper",
    "label": "Upper Range",
    "description": "Upper Range of the Channel",
    "dataType": "Double",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "+scale",
    "label": "Scale",
    "description": "Scale to be applied to numeric value of the channel",
    "dataType": "Double",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "node.id",
    "label": "Node Id",
    "description": "node.id",
    "dataType": "String",
    "defaultValue": null,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "node.namespace.index",
    "label": "Node Namespace Idx",
    "description": "node.namespace.index",
    "dataType": "Long",
    "defaultValue": 2,
    "channel": true,
    "required": true,
    "readonly": false,
    "options": []
  },
  {
    "fieldId": "opcUa.type",
    "label": "OPC-UA Type",
    "description": "opcua.type",
    "dataType": "String",
    "defaultValue": "DEFINED_BY_JAVA_TYPE",
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "BOOLEAN",
        "value": "BOOLEAN"
      },
      {
        "label": "BYTE_ARRAY",
        "value": "BYTE_ARRAY"
      },
      {
        "label": "BYTE_STRING",
        "value": "BYTE_STRING"
      },
      {
        "label": "BYTE",
        "value": "BYTE"
      },
      {
        "label": "DEFINED_BY_OPC_UA_TYPE",
        "value": "DEFINED_BY_OPC_UA_TYPE"
      },
      {
        "label": "DOUBLE",
        "value": "DOUBLE"
      },
      {
        "label": "FLOAT",
        "value": "FLOAT"
      },
      {
        "label": "INT16",
        "value": "INT16"
      },
      {
        "label": "INT32",
        "value": "INT32"
      },
      {
        "label": "INT64",
        "value": "INT64"
      },
      {
        "label": "SBYTE",
        "value": "SBYTE"
      },
      {
        "label": "SBYTE_ARRAY",
        "value": "SBYTE_ARRAY"
      },
      {
        "label": "STRING",
        "value": "STRING"
      },
      {
        "label": "UNIT16",
        "value": "UNIT16"
      },
      {
        "label": "UNIT32",
        "value": "UNIT32"
      },
      {
        "label": "UNIT64",
        "value": "UNIT64"
      }
    ]
  },
  {
    "fieldId": "node.id.type",
    "label": "Node Id Type",
    "description": "node.id.type",
    "dataType": "String",
    "defaultValue": "STRING",
    "channel": true,
    "required": true,
    "readonly": false,
    "options": [
      {
        "label": "GUID",
        "value": "GUID"
      },
      {
        "label": "NUMERIC",
        "value": "NUMERIC"
      },
      {
        "label": "OPAQUE",
        "value": "OPAQUE"
      },
      {
        "label": "STRING",
        "value": "STRING"
      }
    ]
  },
  {
    "fieldId": "aggregationType",
    "label": "Aggregation Type",
    "description": "Aggregation type of Data",
    "dataType": "Long",
    "defaultValue": null,
    "channel": true,
    "required": false,
    "readonly": false,
    "options": [
      {
        "label": "Average",
        "value": "AVERAGE"
      },
      {
        "label": "Minimum",
        "value": "MIN"
      },
      {
        "label": "Maximum",
        "value": "MAX"
      },
      {
        "label": "First",
        "value": "FIRST"
      },
      {
        "label": "Last",
        "value": "LAST"
      },
      {
        "label": "Median",
        "value": "MEDIAN"
      }
    ]
  }
]', 0, 'vizend@vizend.io', 1741599258205, 'vizend@vizend.io', 1742254882473, '1:1:1', '1:1:1', '1@1:1:1-1', '1:1:1-1', 'OPC UA Driver Description', 'OpcUaDriver');
INSERT INTO public.wire_component_definition
(id, entity_version, factory_pid, kura_service_factory_pid, min_input_ports, max_input_ports, default_input_ports, min_output_ports, max_output_ports, default_output_ports, wire_component_type, wire_component_field_definitions_json, field_sequence, registered_by, registered_on, modified_by, modified_on, cineroom_id, pavilion_id, actor_id, stage_id, description, "name")
VALUES('1:1:1-8', 1, 'LsDriver', 'com.hd.edgewise.kura.wire.component.driver.ls.LsDriver', 1, 1, 1, 1, 1, 1, 'Source', '[
{
"fieldId": "device.unit.id",
"label": "Device Unit ID",
"description": "Device Unit ID description",
"dataType": "String",
"defaultValue": null,
"channel": false,
"required": true,
"readonly": true,
"options": []
},
{
"fieldId": "ip",
"label": "Host IP",
"description": "Ls Host IP (e.g., localhost)",
"dataType": "String",
"defaultValue": null,
"channel": false,
"required": true,
"readonly": true,
"options": []
},
{
"fieldId": "port",
"label": "Host Port",
"description": "Ls Host Port",
"dataType": "Long",
"defaultValue": 502,
"channel": false,
"required": true,
"readonly": true,
"options": []
},
{
"fieldId": "cpuInfo",
"label": "Cpu Information",
"description": "LS PLC Cpu Information",
"dataType": "String",
"defaultValue": "XGI",
"channel": false,
"required": true,
"readonly": false,
"options": [
{
"label": "XGI",
"value": "XGI"
},
{
"label": "XGK",
"value": "XGK"
},
{
"label": "XGR",
"value": "XGR"
},
{
"label": "XGB_MK",
"value": "XGB_MK"
},
{
"label": "XGB_IEC",
"value": "XGB_IEC"
}
]
},
{
"fieldId": "enabled",
"label": "Enabled Device",
"description": "Set Device Enabled",
"dataType": "Boolean",
"defaultValue": false,
"channel": false,
"required": true,
"readonly": false,
"options": []
},
{
"fieldId": "periodicFetchMillis",
"label": "Periodic Fetch Millis",
"description": "Milli Seconds to Fetch Data Periodically",
"dataType": "Long",
"defaultValue": 500,
"channel": false,
"required": true,
"readonly": false,
"options": []
},
{
"fieldId": "+name",
"label": "Name of the Channel",
"description": "Name of the Channel",
"dataType": "String",
"defaultValue": "Channel-1",
"channel": true,
"required": true,
"readonly": false,
"options": []
},
{
"fieldId": "+type",
"label": "Type",
"description": "Read or Write",
"dataType": "String",
"defaultValue": null,
"channel": true,
"required": true,
"readonly": false,
"options": [
{
"label": "Read",
"value": "Read"
},
{
"label": "Read_Write",
"value": "Read_Write"
}
]
},
{
"fieldId": "+value.type",
"label": "Value type of the Channel",
"description": "Value type of the channel",
"dataType": "String",
"defaultValue": "Long",
"channel": true,
"required": true,
"readonly": false,
"options": [
{
"label": "Boolean",
"value": "Boolean"
},
{
"label": "String",
"value": "String"
},
{
"label": "Long",
"value": "Long"
},
{
"label": "Double",
"value": "Double"
}
]
},
{
"fieldId": "+range.filter.enabled",
"label": "Range Filter of the Channel",
"description": "Range Filter of the Channel",
"dataType": "Boolean",
"defaultValue": false,
"channel": true,
"required": false,
"readonly": false,
"options": []
},
{
"fieldId": "+range.lower",
"label": "Lower Range",
"description": "Lower Range of the Channel",
"dataType": "Double",
"defaultValue": null,
"channel": true,
"required": false,
"readonly": false,
"options": []
},
{
"fieldId": "+range.upper",
"label": "Upper Range",
"description": "Upper Range of the Channel",
"dataType": "Double",
"defaultValue": null,
"channel": true,
"required": false,
"readonly": false,
"options": []
},
{
"fieldId": "+scale",
"label": "Scale",
"description": "Scale to be applied to numeric value of the channel",
"dataType": "Double",
"defaultValue": null,
"channel": true,
"required": false,
"readonly": false,
"options": []
},
{
"fieldId": "address",
"label": "address",
"description": "LS address",
"dataType": "String",
"defaultValue": null,
"channel": true,
"required": true,
"readonly": false,
"options": []
},
{
"fieldId": "signed",
"label": "signed",
"description": "Is Signed Value",
"dataType": "Boolean",
"defaultValue": false,
"channel": true,
"required": true,
"readonly": false,
"options": []
},
{
"fieldId": "aggregationType",
"label": "Aggregation Type",
"description": "Aggregation type of Data",
"dataType": "Long",
"defaultValue": null,
"channel": true,
"required": false,
"readonly": false,
"options": [
{
"label": "Average",
"value": "AVERAGE"
},
{
"label": "Minimum",
"value": "MIN"
},
{
"label": "Maximum",
"value": "MAX"
},
{
"label": "First",
"value": "FIRST"
},
{
"label": "Last",
"value": "LAST"
},
{
"label": "Median",
"value": "MEDIAN"
}
]
}
]', 0, 'vizend@vizend.io', 1754956279000, 'vizend@vizend.io', 1754956279000, '1:1:1', '1:1:1', '1@1:1:1-1', '1:1:1-1', 'LS Driver Description', 'LsDriver');