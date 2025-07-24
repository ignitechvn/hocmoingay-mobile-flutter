import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api/teacher_classroom_api.dart';
import '../../data/repositories/teacher_classroom/teacher_classroom_repository_impl.dart';
import '../../domain/repositories/teacher_classroom_repository.dart';
import '../../domain/usecases/teacher_classroom/get_teacher_classrooms_usecase.dart';
import '../../providers/api/api_providers.dart';

// API Provider
final teacherClassroomApiProvider = Provider<TeacherClassroomApi>((ref) {
  final baseApiService = ref.watch(authenticatedBaseApiServiceProvider);
  return TeacherClassroomApi(baseApiService);
});

// Repository Provider
final teacherClassroomRepositoryProvider = Provider<TeacherClassroomRepository>(
  (ref) {
    final api = ref.watch(teacherClassroomApiProvider);
    return TeacherClassroomRepositoryImpl(api);
  },
);

// Use Case Provider
final getTeacherClassroomsUseCaseProvider =
    Provider<GetTeacherClassroomsUseCase>((ref) {
      final repository = ref.watch(teacherClassroomRepositoryProvider);
      return GetTeacherClassroomsUseCase(repository);
    });

// Data Provider
final teacherClassroomsProvider = FutureProvider((ref) async {
  final useCase = ref.watch(getTeacherClassroomsUseCaseProvider);
  return await useCase(null);
});
