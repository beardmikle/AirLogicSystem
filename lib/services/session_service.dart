import 'package:hive_flutter/hive_flutter.dart';

class SessionService {
  static const String _boxName = 'session_box';
  static const String _keyUsername = 'username';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static Future<void> setCurrentUsername(String username) async {
    final box = Hive.box(_boxName);
    await box.put(_keyUsername, username);
  }

  static String? getCurrentUsername() {
    final box = Hive.box(_boxName);
    return box.get(_keyUsername) as String?;
  }

  static Future<void> clear() async {
    final box = Hive.box(_boxName);
    await box.delete(_keyUsername);
  }
}
