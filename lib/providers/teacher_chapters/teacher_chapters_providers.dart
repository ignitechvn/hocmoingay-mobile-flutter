import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api/teacher_chapters_api.dart';
import '../../data/dto/chapter_dto.dart';
import '../../data/repositories/teacher_chapters/teacher_chapters_repository_impl.dart';
import '../../domain/repositories/teacher_chapters_repository.dart';
import '../../domain/usecases/teacher_chapters/get_teacher_chapter_details_usecase.dart';
import '../../domain/usecases/teacher_chapters/create_chapter_usecase.dart';
import '../../domain/usecases/teacher_chapters/get_teacher_chapter_questions_usecase.dart';
import '../../domain/usecases/teacher_chapters/get_teacher_chapters_usecase.dart';
import '../api/api_providers.dart';

// API Provider
final teacherChaptersApiProvider = Provider<TeacherChaptersApi>((ref) {
  final baseApiService = ref.watch(authenticatedBaseApiServiceProvider);
  return TeacherChaptersApi(baseApiService);
});

// Repository Provider
final teacherChaptersRepositoryProvider = Provider<TeacherChaptersRepository>((
  ref,
) {
  final api = ref.watch(teacherChaptersApiProvider);
  return TeacherChaptersRepositoryImpl(api);
});

// Use Case Provider
final getTeacherChapterDetailsUseCaseProvider =
    Provider<GetTeacherChapterDetailsUseCase>((ref) {
      final repository = ref.watch(teacherChaptersRepositoryProvider);
      return GetTeacherChapterDetailsUseCase(repository);
    });

final createChapterUseCaseProvider = Provider<CreateChapterUseCase>((ref) {
  final repository = ref.watch(teacherChaptersRepositoryProvider);
  return CreateChapterUseCase(repository);
});

final getTeacherChapterQuestionsUseCaseProvider =
    Provider<GetTeacherChapterQuestionsUseCase>((ref) {
      final repository = ref.watch(teacherChaptersRepositoryProvider);
      return GetTeacherChapterQuestionsUseCase(repository);
    });

final getTeacherChaptersUseCaseProvider = Provider<GetTeacherChaptersUseCase>((
  ref,
) {
  final repository = ref.watch(teacherChaptersRepositoryProvider);
  return GetTeacherChaptersUseCase(repository);
});

// Data Provider
final teacherChapterDetailsProvider =
    FutureProvider.family<ChapterDetailsTeacherResponseDto, String>((
      ref,
      chapterId,
    ) async {
      final useCase = ref.watch(getTeacherChapterDetailsUseCaseProvider);
      return await useCase(chapterId);
    });

final teacherChapterQuestionsProvider =
    FutureProvider.family<TeacherChapterQuestionsResponseDto, String>((
      ref,
      chapterId,
    ) async {
      final useCase = ref.watch(getTeacherChapterQuestionsUseCaseProvider);
      return await useCase(chapterId);
    });

final teacherChaptersProvider =
    FutureProvider.family<TeacherChapterResponseListDto, String>((
      ref,
      classroomId,
    ) async {
      final useCase = ref.watch(getTeacherChaptersUseCaseProvider);
      return await useCase(classroomId);
    });
