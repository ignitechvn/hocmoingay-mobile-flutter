import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api/teacher_practice_sets_api.dart';
import '../../data/dto/practice_set_dto.dart';
import '../../data/repositories/teacher_practice_sets/teacher_practice_sets_repository_impl.dart';
import '../../domain/repositories/teacher_practice_sets_repository.dart';
import '../../domain/usecases/teacher_practice_sets/get_teacher_practice_sets_usecase.dart';
import '../../domain/usecases/teacher_practice_sets/get_open_or_closed_practice_sets_usecase.dart';
import '../../domain/usecases/teacher_practice_sets/create_practice_set_usecase.dart';
import '../../domain/usecases/teacher_practice_sets/update_practice_set_usecase.dart';
import '../../domain/usecases/teacher_practice_sets/update_practice_set_status_usecase.dart';
import '../../domain/usecases/teacher_practice_sets/get_practice_set_details_usecase.dart';
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

final getOpenOrClosedPracticeSetsUseCaseProvider =
    Provider<GetOpenOrClosedPracticeSetsUseCase>((ref) {
      final repository = ref.watch(teacherPracticeSetsRepositoryProvider);
      return GetOpenOrClosedPracticeSetsUseCase(repository);
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

final updatePracticeSetStatusUseCaseProvider =
    Provider<UpdatePracticeSetStatusUseCase>((ref) {
      final repository = ref.watch(teacherPracticeSetsRepositoryProvider);
      return UpdatePracticeSetStatusUseCase(repository);
    });

final getPracticeSetDetailsUseCaseProvider = Provider<GetPracticeSetDetailsUseCase>((
  ref,
) {
  final repository = ref.watch(teacherPracticeSetsRepositoryProvider);
  return GetPracticeSetDetailsUseCase(repository);
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

final teacherOpenOrClosedPracticeSetsProvider =
    FutureProvider.family<TeacherPracticeSetResponseListDto, String>((
      ref,
      classroomId,
    ) async {
      final useCase = ref.watch(getOpenOrClosedPracticeSetsUseCaseProvider);
      return await useCase(classroomId);
    });

final practiceSetDetailsProvider =
    FutureProvider.family<PracticeSetDetailsTeacherResponseDto, String>((
      ref,
      practiceSetId,
    ) async {
      final useCase = ref.watch(getPracticeSetDetailsUseCaseProvider);
      return await useCase(practiceSetId);
    });
