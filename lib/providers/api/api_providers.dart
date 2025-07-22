import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api/auth_api.dart';
import '../../data/datasources/api/base_api_service.dart';
import '../../data/datasources/api/student_classroom_api.dart';

// Base API Service Provider
final baseApiServiceProvider = Provider<BaseApiService>((ref) {
  return BaseApiService();
});

// Auth API Provider
final authApiProvider = Provider<AuthApi>((ref) {
  final baseApiService = ref.watch(baseApiServiceProvider);
  return AuthApi(baseApiService);
});

// Base API Service with Auth Interceptor Provider
final authenticatedBaseApiServiceProvider = Provider<BaseApiService>((ref) {
  final authApi = ref.watch(authApiProvider);
  return BaseApiService(authApi: authApi);
});

// Student Classroom API Provider (with auth)
final studentClassroomApiProvider = Provider<StudentClassroomApi>((ref) {
  final baseApiService = ref.watch(authenticatedBaseApiServiceProvider);
  return StudentClassroomApi(baseApiService);
});
