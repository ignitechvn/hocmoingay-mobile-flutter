import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api/teacher_profile_api.dart';
import '../../data/dto/teacher_profile_dto.dart';
import '../api/api_providers.dart';

final teacherProfileApiProvider = Provider<TeacherProfileApi>((ref) {
  final baseApiService = ref.watch(authenticatedBaseApiServiceProvider);
  return TeacherProfileApi(baseApiService);
});

final teacherProfileProvider = FutureProvider<TeacherProfileResponseDto?>((
  ref,
) async {
  print('🔍 TeacherProfileProvider: Starting to fetch profile...');
  try {
    final teacherProfileApi = ref.watch(teacherProfileApiProvider);
    print(
      '🔍 TeacherProfileProvider: API instance created, calling getMyProfile...',
    );
    final result = await teacherProfileApi.getMyProfile();
    print(
      '✅ TeacherProfileProvider: Profile fetched successfully: ${result?.id ?? 'null'}',
    );
    return result;
  } catch (e) {
    print('❌ TeacherProfileProvider: Error fetching profile: $e');
    rethrow;
  }
});

final teacherProfileTestProvider = FutureProvider<void>((ref) async {
  print('🔍 TeacherProfileTestProvider: Testing API connection...');
  try {
    final teacherProfileApi = ref.watch(teacherProfileApiProvider);
    await teacherProfileApi.testConnection();
    print('✅ TeacherProfileTestProvider: Test successful');
  } catch (e) {
    print('❌ TeacherProfileTestProvider: Test failed: $e');
    rethrow;
  }
});
