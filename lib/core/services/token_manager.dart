import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

class TokenManager {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Token keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _userDataKey = 'user_data';

  // Token expiry buffer (5 minutes before actual expiry)
  static const Duration _expiryBuffer = Duration(minutes: 5);

  /// Save tokens and user data
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    Map<String, dynamic>? userData,
  }) async {
    final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));

    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
      _storage.write(key: _tokenExpiryKey, value: expiryTime.toIso8601String()),
      if (userData != null)
        _storage.write(key: _userDataKey, value: jsonEncode(userData)),
    ]);
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Check if token is expired or will expire soon
  static Future<bool> isTokenExpired() async {
    final expiryString = await _storage.read(key: _tokenExpiryKey);
    if (expiryString == null) return true;

    try {
      final expiryTime = DateTime.parse(expiryString);
      final bufferTime = expiryTime.subtract(_expiryBuffer);

      return DateTime.now().isAfter(bufferTime);
    } catch (e) {
      return true;
    }
  }

  /// Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final userDataString = await _storage.read(key: _userDataKey);
    if (userDataString == null) return null;

    try {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Clear all tokens and user data
  static Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _tokenExpiryKey),
      _storage.delete(key: _userDataKey),
    ]);
  }

  /// Update access token only (for refresh token response)
  static Future<void> updateAccessToken({
    required String accessToken,
    required int expiresIn,
  }) async {
    final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));

    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _tokenExpiryKey, value: expiryTime.toIso8601String()),
    ]);
  }

  /// Update refresh token only
  static Future<void> updateRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    return accessToken != null &&
        refreshToken != null &&
        !await isTokenExpired();
  }

  /// Get token info for debugging
  static Future<Map<String, dynamic>> getTokenInfo() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    final expiryString = await _storage.read(key: _tokenExpiryKey);
    final userData = await getUserData();

    DateTime? expiryTime;
    if (expiryString != null) {
      try {
        expiryTime = DateTime.parse(expiryString);
      } catch (e) {
        // Ignore parsing errors
      }
    }

    return {
      'hasAccessToken': accessToken != null,
      'hasRefreshToken': refreshToken != null,
      'accessTokenLength': accessToken?.length ?? 0,
      'refreshTokenLength': refreshToken?.length ?? 0,
      'expiryTime': expiryTime?.toIso8601String(),
      'isExpired': await isTokenExpired(),
      'hasUserData': userData != null,
    };
  }
}
