import 'package:logger/logger.dart';
import '../config/app_config.dart';

class AppLogger {
  static Logger? _logger;

  static Logger get logger {
    _logger ??= Logger(
      filter:
          AppConfig.enableLogging ? DevelopmentFilter() : ProductionFilter(),
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      output: ConsoleOutput(),
    );
    return _logger!;
  }

  // Debug level - for detailed debugging information
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.enableLogging) {
      logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  // Info level - for general information
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.enableLogging) {
      logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  // Warning level - for warnings
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.enableLogging) {
      logger.w(message, error: error, stackTrace: stackTrace);
    }
  }

  // Error level - for errors
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }

  // Fatal level - for fatal errors
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.f(message, error: error, stackTrace: stackTrace);
  }

  // API logging
  static void logApiRequest(
    String method,
    String url,
    Map<String, dynamic>? headers,
    dynamic body,
  ) {
    if (AppConfig.enableLogging) {
      logger.i(
        'API Request: $method $url',
        error: {'headers': headers, 'body': body},
      );
    }
  }

  static void logApiResponse(
    String method,
    String url,
    int statusCode,
    Map<String, dynamic>? headers,
    dynamic body,
  ) {
    if (AppConfig.enableLogging) {
      logger.i(
        'API Response: $method $url - $statusCode',
        error: {'headers': headers, 'body': body},
      );
    }
  }

  static void logApiError(
    String method,
    String url,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    logger.e('API Error: $method $url', error: error, stackTrace: stackTrace);
  }

  // Navigation logging
  static void logNavigation(
    String from,
    String to,
    Map<String, dynamic>? arguments,
  ) {
    if (AppConfig.enableLogging) {
      logger.i('Navigation: $from -> $to', error: arguments);
    }
  }

  // User action logging
  static void logUserAction(String action, Map<String, dynamic>? parameters) {
    if (AppConfig.enableLogging) {
      logger.i('User Action: $action', error: parameters);
    }
  }

  // Performance logging
  static void logPerformance(String operation, Duration duration) {
    if (AppConfig.enableLogging) {
      logger.i('Performance: $operation took ${duration.inMilliseconds}ms');
    }
  }

  // Security logging
  static void logSecurityEvent(String event, Map<String, dynamic>? details) {
    logger.w('Security Event: $event', error: details);
  }

  // Database logging
  static void logDatabaseOperation(
    String operation,
    String table,
    Map<String, dynamic>? data,
  ) {
    if (AppConfig.enableLogging) {
      logger.d('Database: $operation on $table', error: data);
    }
  }

  // Cache logging
  static void logCacheOperation(String operation, String key, dynamic value) {
    if (AppConfig.enableLogging) {
      logger.d('Cache: $operation - $key', error: value);
    }
  }

  // File operation logging
  static void logFileOperation(String operation, String path, dynamic result) {
    if (AppConfig.enableLogging) {
      logger.d('File: $operation - $path', error: result);
    }
  }

  // Network logging
  static void logNetworkStatus(bool isConnected, String? connectionType) {
    if (AppConfig.enableLogging) {
      logger.i(
        'Network: ${isConnected ? 'Connected' : 'Disconnected'} ${connectionType ?? ''}',
      );
    }
  }

  // Memory usage logging
  static void logMemoryUsage(String context, int memoryUsage) {
    if (AppConfig.enableLogging) {
      logger.d('Memory: $context - ${memoryUsage}MB');
    }
  }

  // App lifecycle logging
  static void logAppLifecycle(String state) {
    if (AppConfig.enableLogging) {
      logger.i('App Lifecycle: $state');
    }
  }

  // Error tracking
  static void trackError(
    String error,
    StackTrace stackTrace,
    Map<String, dynamic>? context,
  ) {
    logger.e('Error Tracked: $error', error: context, stackTrace: stackTrace);

    // TODO: Send to crashlytics or other error tracking service
    if (AppConfig.enableCrashlytics) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: context.toString());
    }
  }
}
