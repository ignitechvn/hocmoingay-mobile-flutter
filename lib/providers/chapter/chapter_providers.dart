import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/api/chapter_api.dart';
import '../../data/repositories/chapter_repository_impl.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../../domain/usecases/chapter/get_chapters_usecase.dart';
import '../../domain/usecases/chapter/get_chapter_details_usecase.dart';
import '../../data/dto/chapter_dto.dart';
import '../../data/dto/chapter_details_dto.dart';
import '../api/api_providers.dart';

final chapterApiProvider = Provider<ChapterApi>((ref) {
  final apiService = ref.watch(authenticatedBaseApiServiceProvider);
  return ChapterApi(apiService);
});

final chapterRepositoryProvider = Provider<ChapterRepository>((ref) {
  final api = ref.watch(chapterApiProvider);
  return ChapterRepositoryImpl(api);
});

final getChaptersUseCaseProvider = Provider<GetChaptersUseCase>((ref) {
  final repository = ref.watch(chapterRepositoryProvider);
  return GetChaptersUseCase(repository);
});

final getChapterDetailsUseCaseProvider = Provider<GetChapterDetailsUseCase>((
  ref,
) {
  final repository = ref.watch(chapterRepositoryProvider);
  return GetChapterDetailsUseCase(repository);
});

final chaptersProvider =
    FutureProvider.family<List<ChapterStudentResponseDto>, String>((
      ref,
      classroomId,
    ) async {
      final useCase = ref.watch(getChaptersUseCaseProvider);
      return await useCase(classroomId);
    });

final chapterDetailsProvider =
    FutureProvider.family<ChapterDetailsStudentResponseDto, String>((
      ref,
      chapterId,
    ) async {
      final useCase = ref.watch(getChapterDetailsUseCaseProvider);
      return await useCase(chapterId);
    });
