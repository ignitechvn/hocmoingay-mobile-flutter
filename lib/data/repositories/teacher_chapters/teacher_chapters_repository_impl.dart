import '../../../data/datasources/api/teacher_chapters_api.dart';
import '../../../data/dto/chapter_dto.dart';
import '../../../domain/repositories/teacher_chapters_repository.dart';

class TeacherChaptersRepositoryImpl implements TeacherChaptersRepository {
  final TeacherChaptersApi _api;

  TeacherChaptersRepositoryImpl(this._api);

  @override
  Future<ChapterDetailsTeacherResponseDto> getChapterDetails(
    String chapterId,
  ) async {
    return await _api.getChapterDetails(chapterId);
  }

  @override
  Future<ChapterTeacherResponseDto> createChapter(CreateChapterDto dto) async {
    return await _api.createChapter(dto);
  }
}
