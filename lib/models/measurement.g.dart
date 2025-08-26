// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitValue _$UnitValueFromJson(Map<String, dynamic> json) => UnitValue(
  value: (json['value'] as num).toDouble(),
  unit: json['unit'] as String,
);

Map<String, dynamic> _$UnitValueToJson(UnitValue instance) => <String, dynamic>{
  'value': instance.value,
  'unit': instance.unit,
};

Measurements _$MeasurementsFromJson(Map<String, dynamic> json) => Measurements(
  co: UnitValue.fromJson(json['CO'] as Map<String, dynamic>),
  no2: UnitValue.fromJson(json['NO2'] as Map<String, dynamic>),
  temperature: UnitValue.fromJson(json['temperature'] as Map<String, dynamic>),
  pressure: UnitValue.fromJson(json['pressure'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MeasurementsToJson(Measurements instance) =>
    <String, dynamic>{
      'CO': instance.co.toJson(),
      'NO2': instance.no2.toJson(),
      'temperature': instance.temperature.toJson(),
      'pressure': instance.pressure.toJson(),
    };

DeviceData _$DeviceDataFromJson(Map<String, dynamic> json) => DeviceData(
  deviceId: (json['device_id'] as num).toInt(),
  timestamp: json['timestamp'] as String,
  measurements: Measurements.fromJson(
    json['measurements'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DeviceDataToJson(DeviceData instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'timestamp': instance.timestamp,
      'measurements': instance.measurements.toJson(),
    };
