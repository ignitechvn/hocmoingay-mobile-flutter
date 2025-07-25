import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api/teacher_practice_sets_api.dart';
import '../../data/dto/practice_set_dto.dart';
import '../../data/repositories/teacher_practice_sets/teacher_practice_sets_repository_impl.dart';
import '../../domain/repositories/teacher_practice_sets_repository.dart';
import '../../domain/usecases/teacher_practice_sets/get_teacher_practice_sets_usecase.dart';
import '../../domain/usecases/teacher_practice_sets/create_practice_set_usecase.dart';
import '../../domain/usecases/teacher_practice_sets/update_practice_set_usecase.dart';
import '../api/api_providers.dart';

// API Provider
final teacherPracticeSetsApiProvider = Provider<TeacherPracticeSetsApi>((ref) {
  final baseApiService = ref.watch(authenticatedBaseApiServiceProvider);
  return TeacherPracticeSetsApi(baseApiService);
});

// Repository Provider
final teacherPracticeSetsRepositoryProvider =
    Provider<TeacherPracticeSetsRepository>((ref) {
      final api = ref.watch(teacherPracticeSetsApiProvider);
      return TeacherPracticeSetsRepositoryImpl(api);
    });

// Use Case Provider
final getTeacherPracticeSetsUseCaseProvider =
    Provider<GetTeacherPracticeSetsUseCase>((ref) {
      final repository = ref.watch(teacherPracticeSetsRepositoryProvider);
      return GetTeacherPracticeSetsUseCase(repository);
    });

final createPracticeSetUseCaseProvider = Provider<CreatePracticeSetUseCase>((
  ref,
) {
  final repository = ref.watch(teacherPracticeSetsRepositoryProvider);
  return CreatePracticeSetUseCase(repository);
});

final updatePracticeSetUseCaseProvider = Provider<UpdatePracticeSetUseCase>((
  ref,
) {
  final repository = ref.watch(teacherPracticeSetsRepositoryProvider);
  return UpdatePracticeSetUseCase(repository);
});

// Data Provider
final teacherPracticeSetsProvider =
    FutureProvider.family<TeacherPracticeSetResponseListDto, String>((
      ref,
      classroomId,
    ) async {
      final useCase = ref.watch(getTeacherPracticeSetsUseCaseProvider);
      return await useCase(classroomId);
    });
