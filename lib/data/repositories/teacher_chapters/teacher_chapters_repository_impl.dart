import '../../../data/datasources/api/teacher_chapters_api.dart';
import '../../../data/dto/chapter_dto.dart';
import '../../../domain/repositories/teacher_chapters_repository.dart';

class TeacherChaptersRepositoryImpl implements TeacherChaptersRepository {
  final TeacherChaptersApi _api;

  TeacherChaptersRepositoryImpl(this._api);

  @override
  Future<TeacherChapterResponseListDto> getTeacherChapters(
    String classroomId,
  ) async {
    return await _api.getTeacherChapters(classroomId);
  }

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

  @override
  Future<ChapterTeacherResponseDto> updateChapter(
    String chapterId,
    UpdateChapterDto dto,
  ) async {
    return await _api.updateChapter(chapterId, dto);
  }

  @override
  Future<TeacherChapterQuestionsResponseDto> getChapterQuestions(
    String chapterId,
  ) async {
    return await _api.getChapterQuestions(chapterId);
  }

  @override
  Future<void> deleteChapter(String chapterId) async {
    return await _api.deleteChapter(chapterId);
  }

  @override
  Future<ChapterTeacherResponseDto> updateStatus(
    String chapterId,
    UpdateChapterStatusDto dto,
  ) async {
    return await _api.updateStatus(chapterId, dto);
  }
}
