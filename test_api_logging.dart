// Test file để demo API logging
// Chạy file này để test logging functionality

import 'package:dio/dio.dart';
import 'lib/core/interceptors/api_logging_interceptor.dart';
import 'lib/core/utils/logger.dart';

void main() async {
  print('=== TEST API LOGGING ===');

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

  // Test 1: GET request thành công
  print('\n--- Test 1: GET Request ---');
  try {
    final response = await dio.get('/posts/1');
    print('✅ GET Response: ${response.statusCode}');
  } catch (e) {
    print('❌ GET Error: $e');
  }

  // Test 2: POST request thành công
  print('\n--- Test 2: POST Request ---');
  try {
    final response = await dio.post(
      '/posts',
      data: {
        'title': 'Test Post',
        'body': 'This is a test post for logging demo',
        'userId': 1,
      },
    );
    print('✅ POST Response: ${response.statusCode}');
  } catch (e) {
    print('❌ POST Error: $e');
  }

  // Test 3: Request lỗi (404)
  print('\n--- Test 3: Error Request (404) ---');
  try {
    await dio.get('/nonexistent-endpoint');
  } catch (e) {
    print('❌ Expected Error: $e');
  }

  // Test 4: Request timeout
  print('\n--- Test 4: Timeout Request ---');
  try {
    await dio.get(
      '/posts/1',
      options: Options(
        sendTimeout: const Duration(milliseconds: 1),
        receiveTimeout: const Duration(milliseconds: 1),
      ),
    );
  } catch (e) {
    print('❌ Timeout Error: $e');
  }

  print('\n=== TEST COMPLETED ===');
  print('Kiểm tra logs ở trên để xem chi tiết API calls');
}

// Hướng dẫn chạy test:
// 1. Mở terminal trong thư mục project
// 2. Chạy: dart test_api_logging.dart
// 3. Xem logs xuất hiện trong terminal
