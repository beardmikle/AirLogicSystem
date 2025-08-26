import 'package:json_annotation/json_annotation.dart';

part 'measurement.g.dart';

@JsonSerializable(explicitToJson: true)
class UnitValue {
  final double value;
  final String unit;

  UnitValue({required this.value, required this.unit});

  factory UnitValue.fromJson(Map<String, dynamic> json) => _$UnitValueFromJson(json);
  Map<String, dynamic> toJson() => _$UnitValueToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Measurements {
  @JsonKey(name: 'CO')
  final UnitValue co;
  @JsonKey(name: 'NO2')
  final UnitValue no2;
  final UnitValue temperature;
  final UnitValue pressure;

  Measurements({required this.co, required this.no2, required this.temperature, required this.pressure});

  factory Measurements.fromJson(Map<String, dynamic> json) => _$MeasurementsFromJson(json);
  Map<String, dynamic> toJson() => _$MeasurementsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DeviceData {
  @JsonKey(name: 'device_id')
  final int deviceId;
  final String timestamp;
  final Measurements measurements;

  DeviceData({required this.deviceId, required this.timestamp, required this.measurements});

  factory DeviceData.fromJson(Map<String, dynamic> json) => _$DeviceDataFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceDataToJson(this);
}


