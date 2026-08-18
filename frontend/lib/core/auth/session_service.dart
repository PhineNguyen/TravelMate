import 'package:hive_flutter/hive_flutter.dart';

class SessionService {
  static const String _boxName = 'auth_session';
  static const String _tokenKey = 'access_token';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  static Future<void> saveToken(String token) async {
    await _box.put(_tokenKey, token);
  }

  static String? get token => _box.get(_tokenKey) as String?;

  static bool get isLoggedIn => token != null && token!.isNotEmpty;

  static Future<void> clear() async {
    await _box.delete(_tokenKey);
  }
}
