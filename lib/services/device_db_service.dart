import 'package:hive_flutter/hive_flutter.dart';

class StoredDevice {
  final String id;
  final String name;
  final String brand;
  final String type;
  final String serialNumber;
  final DateTime? verificationDate;
  final DateTime? commissioningDate;
  final bool isOn;
  final int emergencyStatus;

  StoredDevice({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.serialNumber,
    required this.verificationDate,
    required this.commissioningDate,
    required this.isOn,
    required this.emergencyStatus,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'brand': brand,
        'type': type,
        'serialNumber': serialNumber,
        'verificationDate': verificationDate?.toIso8601String(),
        'commissioningDate': commissioningDate?.toIso8601String(),
        'isOn': isOn,
        'emergencyStatus': emergencyStatus,
      };

  static StoredDevice fromMap(Map map) => StoredDevice(
        id: map['id'] as String,
        name: map['name'] as String,
        brand: map['brand'] as String,
        type: map['type'] as String,
        serialNumber: map['serialNumber'] as String,
        verificationDate: (map['verificationDate'] as String?) != null
            ? DateTime.parse(map['verificationDate'] as String)
            : null,
        commissioningDate: (map['commissioningDate'] as String?) != null
            ? DateTime.parse(map['commissioningDate'] as String)
            : null,
        isOn: (map['isOn'] as bool?) ?? false,
        emergencyStatus: (map['emergencyStatus'] as int?) ?? 0,
      );
}

class DeviceDbService {
  static const String _boxName = 'devices_box';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static String _keyForUser(String username) => 'devices_$username';

  static List<StoredDevice> _readAll(String username) {
    final box = Hive.box(_boxName);
    final list = (box.get(_keyForUser(username)) as List?)?.cast<Map>() ?? <Map>[];
    return list.map(StoredDevice.fromMap).toList();
  }

  static Future<void> _writeAll(String username, List<StoredDevice> devices) async {
    final box = Hive.box(_boxName);
    await box.put(_keyForUser(username), devices.map((e) => e.toMap()).toList());
  }

  static List<StoredDevice> list(String username) {
    return _readAll(username);
  }

  static Future<void> add(String username, StoredDevice device) async {
    final items = _readAll(username);
    items.add(device);
    await _writeAll(username, items);
  }

  static Future<void> update(String username, StoredDevice device) async {
    final items = _readAll(username);
    final index = items.indexWhere((d) => d.id == device.id);
    if (index != -1) {
      items[index] = device;
      await _writeAll(username, items);
    }
  }

  static Future<void> remove(String username, String deviceId) async {
    final items = _readAll(username);
    final filtered = items.where((d) => d.id != deviceId).toList();
    await _writeAll(username, filtered);
  }
}
