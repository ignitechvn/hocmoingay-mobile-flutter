import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../interceptors/api_logging_interceptor.dart';
import 'logger.dart';

/// Demo class để test API logging
class ApiLoggingDemo {
  static void testApiLogging() {
    AppLogger.info('=== BẮT ĐẦU TEST API LOGGING ===');

    // Tạo Dio instance với logging interceptor
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Thêm logging interceptor
    dio.interceptors.add(ApiLoggingInterceptor());

    // Test các API calls
    _testGetRequest(dio);
    _testPostRequest(dio);
    _testErrorRequest(dio);
  }

  static Future<void> _testGetRequest(Dio dio) async {
    AppLogger.info('--- Testing GET Request ---');
    try {
      final response = await dio.get('/posts/1');
      AppLogger.info('GET Response received: ${response.statusCode}');
    } catch (e) {
      AppLogger.error('GET Request failed', e);
    }
  }

  static Future<void> _testPostRequest(Dio dio) async {
    AppLogger.info('--- Testing POST Request ---');
    try {
      final response = await dio.post(
        '/posts',
        data: {
          'title': 'Test Post',
          'body': 'This is a test post for logging demo',
          'userId': 1,
        },
      );
      AppLogger.info('POST Response received: ${response.statusCode}');
    } catch (e) {
      AppLogger.error('POST Request failed', e);
    }
  }

  static Future<void> _testErrorRequest(Dio dio) async {
    AppLogger.info('--- Testing Error Request ---');
    try {
      await dio.get('/nonexistent-endpoint');
    } catch (e) {
      AppLogger.error('Error Request failed (expected)', e);
    }
  }
}

/// Hướng dẫn sử dụng API Logging
class ApiLoggingGuide {
  static void showUsageGuide() {
    AppLogger.info('''
=== HƯỚNG DẪN SỬ DỤNG API LOGGING ===

1. LOGGING TỰ ĐỘNG:
   - Tất cả API calls sẽ được log tự động thông qua ApiLoggingInterceptor
   - Logs bao gồm: Request, Response, Error và Performance metrics

2. CÁC LOẠI LOG:
   - API Request: Method, URL, Headers, Body
   - API Response: Status code, Headers, Body
   - API Error: Error details, Stack trace
   - Performance: Thời gian thực hiện API call

3. CẤU HÌNH LOGGING:
   - Development/Staging: Logging được bật
   - Production: Logging bị tắt (AppConfig.enableLogging = false)

4. VÍ DỤ LOG OUTPUT:
   ```
   💡 INFO: API Request: POST https://api.example.com/auth/login
   📊 INFO: Performance: API POST /auth/login took 245ms
   💡 INFO: API Response: POST https://api.example.com/auth/login - 200
   ```

5. CÁCH TEST:
   - Chạy ApiLoggingDemo.testApiLogging() để test
   - Xem logs trong console hoặc debug console

6. TÙY CHỈNH:
   - Chỉnh sửa AppLogger để thay đổi format log
   - Thêm filters trong ApiLoggingInterceptor để lọc logs
   - Cấu hình log levels trong AppConfig
''');
  }
}
