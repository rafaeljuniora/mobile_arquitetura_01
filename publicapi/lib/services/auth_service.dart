import 'dart:convert';

import 'package:publicapi/core/api_client.dart';
import 'package:publicapi/services/session_manager.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final ApiClient _apiClient = ApiClient();
  final SessionManager _sessionManager = SessionManager();

  factory AuthService() => _instance;

  AuthService._internal();

  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      final data = response.data;
      if (data != null) {
        final token = (data['accessToken'] ?? data['token'] ?? data['refreshToken']) as String?;
        if (token != null) {
          await _sessionManager.saveToken(token);
          await _sessionManager.saveUsername(username);
          await _sessionManager.saveUserJson(const JsonEncoder().convert(data));
          _apiClient.setAuthToken(token);
          return true;
        }
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    final json = await _sessionManager.getUserJson();
    if (json == null) return null;
    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      return data;
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    await _sessionManager.clearSession();
    _apiClient.removeAuthToken();
  }

  Future<bool> isAuthenticated() async => await _sessionManager.isAuthenticated();

  Future<String?> getUsername() async => await _sessionManager.getUsername();
}
