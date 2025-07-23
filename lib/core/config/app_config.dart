import 'package:flutter/foundation.dart';

enum Environment { development, staging, production }

class AppConfig {
  static Environment _environment = Environment.development;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static Environment get environment => _environment;

  static bool get isDevelopment => _environment == Environment.development;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;

  // API Configuration
  static String get baseUrl {
    switch (_environment) {
      case Environment.development:
        return 'http://54.179.51.171:8000';
      case Environment.staging:
        return 'http://54.179.51.171:8000';
      case Environment.production:
        return 'http://54.179.51.171:8000';
    }
  }

  static String get apiVersion => '';

  // App Configuration
  static const String appName = 'Học Mỗi Ngày';
  static const String appVersion = '1.0.0';
  static const int appVersionCode = 1;

  // Timeout Configuration
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Cache Configuration
  static const Duration cacheTimeout = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // Logging Configuration
  static bool get enableLogging => !isProduction;
  static bool get enableCrashlytics => isProduction;

  // Feature Flags
  static bool get enableAnalytics => true;
  static bool get enablePushNotifications => true;
  static bool get enableVideoCalling => true;
  static bool get enableFileSharing => true;

  // Security Configuration
  static const String encryptionKey = 'your-encryption-key-here';
  static const Duration tokenExpiration = Duration(days: 7);

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashScreenDuration = Duration(seconds: 2);

  // Error Messages
  static const String networkErrorMessage =
      'Không thể kết nối mạng. Vui lòng kiểm tra lại.';
  static const String serverErrorMessage = 'Lỗi máy chủ. Vui lòng thử lại sau.';
  static const String unknownErrorMessage = 'Đã xảy ra lỗi không xác định.';
}
