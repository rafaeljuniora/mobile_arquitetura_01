import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  SharedPreferences? _prefs;

  factory SessionManager() => _instance;

  SessionManager._internal();

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> _ensure() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }

  Future<void> saveUsername(String username) async {
    final prefs = await _ensure();
    await prefs.setString('username', username);
  }

  Future<String?> getUsername() async {
    final prefs = await _ensure();
    return prefs.getString('username');
  }

  Future<void> saveUserJson(String json) async {
    final prefs = await _ensure();
    await prefs.setString('user_json', json);
  }

  Future<String?> getUserJson() async {
    final prefs = await _ensure();
    return prefs.getString('user_json');
  }

  Future<void> saveToken(String token) async {
    final prefs = await _ensure();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await _ensure();
    return prefs.getString('auth_token');
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> clearSession() async {
    final prefs = await _ensure();
    await prefs.remove('username');
    await prefs.remove('auth_token');
  }
}
