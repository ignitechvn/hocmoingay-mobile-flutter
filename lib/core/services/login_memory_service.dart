import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class LoginMemoryService {
  static const String _lastLoginKey = 'last_login_info';
  static const String _rememberMeKey = 'remember_me';

  /// Save last login information
  static Future<void> saveLastLogin({
    required String phone,
    required String password,
    required String role,
    bool rememberMe = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final loginInfo = {
      'phone': phone,
      'password': password,
      'role': role,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await prefs.setString(_lastLoginKey, jsonEncode(loginInfo));
    await prefs.setBool(_rememberMeKey, rememberMe);
  }

  /// Get last login information
  static Future<Map<String, dynamic>?> getLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;

    if (!rememberMe) return null;

    final loginInfoString = prefs.getString(_lastLoginKey);
    if (loginInfoString == null) return null;

    try {
      return jsonDecode(loginInfoString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Clear last login information
  static Future<void> clearLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastLoginKey);
    await prefs.remove(_rememberMeKey);
  }

  /// Check if remember me is enabled
  static Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  /// Set remember me preference
  static Future<void> setRememberMe(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, enabled);

    if (!enabled) {
      await clearLastLogin();
    }
  }
}
