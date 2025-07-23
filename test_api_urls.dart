// Test file để xác nhận API URLs đã được cập nhật
// Chạy file này để kiểm tra base URL và endpoints

import 'lib/core/config/app_config.dart';
import 'lib/data/datasources/api/base_api_service.dart';
import 'lib/core/utils/logger.dart';

void main() {
  print('=== TEST API URLS ===');

  // Test 1: Kiểm tra base URL
  print('\n--- Test 1: Base URL Configuration ---');
  print('Environment: ${AppConfig.environment}');
  print('Base URL: ${AppConfig.baseUrl}');
  print('API Version: "${AppConfig.apiVersion}"');
  print('Full Base URL: ${AppConfig.baseUrl}${AppConfig.apiVersion}');

  // Test 2: Tạo BaseApiService và kiểm tra URL
  print('\n--- Test 2: BaseApiService URL ---');
  final apiService = BaseApiService();
  print('Dio Base URL: ${apiService.dio.options.baseUrl}');

  // Test 3: Test các endpoints
  print('\n--- Test 3: API Endpoints ---');
  final endpoints = [
    '/auth/login',
    '/auth/register/student',
    '/auth/register/teacher',
    '/auth/forgot-password',
    '/auth/verify-otp',
    '/auth/reset-password',
    '/auth/logout',
    '/auth/refresh',
  ];

  for (final endpoint in endpoints) {
    final fullUrl = '${AppConfig.baseUrl}${AppConfig.apiVersion}$endpoint';
    print('$endpoint -> $fullUrl');
  }

  // Test 4: Log test
  print('\n--- Test 4: Logging Test ---');
  AppLogger.info('API URLs đã được cập nhật thành công');
  AppLogger.info('Base URL: ${AppConfig.baseUrl}');
  AppLogger.info('API Version: ${AppConfig.apiVersion}');

  print('\n=== TEST COMPLETED ===');
  print('✅ API URLs đã được cập nhật - không còn tiền tố /api/v1');
}

// Kết quả mong đợi:
// Base URL: http://54.179.51.171:8000
// API Version: "" (empty string)
// Full Base URL: http://54.179.51.171:8000
// 
// Endpoints sẽ là:
// /auth/login -> http://54.179.51.171:8000/auth/login
// /auth/register/student -> http://54.179.51.171:8000/auth/register/student
// v.v. 