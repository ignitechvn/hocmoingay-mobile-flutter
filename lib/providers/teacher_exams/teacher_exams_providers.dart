import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/api/teacher_exams_api.dart';
import '../../../data/dto/exam_dto.dart';
import '../../../data/repositories/teacher_exams/teacher_exams_repository_impl.dart';
import '../../../domain/repositories/teacher_exams_repository.dart';
import '../../../domain/usecases/teacher_exams/get_teacher_exams_usecase.dart';
import '../../../domain/usecases/teacher_exams/get_closed_exams_usecase.dart';
import '../../../domain/usecases/teacher_exams/create_exam_usecase.dart';
import '../../../domain/usecases/teacher_exams/update_exam_usecase.dart';
import '../api/api_providers.dart';

// API Provider
final teacherExamsApiProvider = Provider<TeacherExamsApi>((ref) {
  final baseApiService = ref.watch(authenticatedBaseApiServiceProvider);
  return TeacherExamsApi(baseApiService);
});

// Repository Provider
final teacherExamsRepositoryProvider = Provider<TeacherExamsRepository>((ref) {
  final api = ref.watch(teacherExamsApiProvider);
  return TeacherExamsRepositoryImpl(api);
});

// Use Case Providers
final getTeacherExamsUseCaseProvider = Provider<GetTeacherExamsUseCase>((ref) {
  final repository = ref.watch(teacherExamsRepositoryProvider);
  return GetTeacherExamsUseCase(repository);
});

final getClosedExamsUseCaseProvider = Provider<GetClosedExamsUseCase>((ref) {
  final repository = ref.watch(teacherExamsRepositoryProvider);
  return GetClosedExamsUseCase(repository);
});

final createExamUseCaseProvider = Provider<CreateExamUseCase>((ref) {
  final repository = ref.watch(teacherExamsRepositoryProvider);
  return CreateExamUseCase(repository);
});

final updateExamUseCaseProvider = Provider<UpdateExamUseCase>((ref) {
  final repository = ref.watch(teacherExamsRepositoryProvider);
  return UpdateExamUseCase(repository);
});

// Data Provider
final teacherExamsProvider =
    FutureProvider.family<TeacherExamResponseListDto, String>((
      ref,
      classroomId,
    ) async {
      final useCase = ref.watch(getTeacherExamsUseCaseProvider);
      return await useCase(classroomId);
    });

final teacherClosedExamsProvider =
    FutureProvider.family<TeacherExamResponseListDto, String>((
      ref,
      classroomId,
    ) async {
      final useCase = ref.watch(getClosedExamsUseCaseProvider);
      return await useCase(classroomId);
    });
