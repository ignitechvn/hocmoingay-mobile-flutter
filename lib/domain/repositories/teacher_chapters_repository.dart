import '../../data/dto/chapter_dto.dart';

abstract class TeacherChaptersRepository {
  Future<TeacherChapterResponseListDto> getTeacherChapters(String classroomId);
  Future<ChapterDetailsTeacherResponseDto> getChapterDetails(String chapterId);
  Future<ChapterTeacherResponseDto> createChapter(CreateChapterDto dto);
  Future<ChapterTeacherResponseDto> updateChapter(String chapterId, UpdateChapterDto dto);
  Future<TeacherChapterQuestionsResponseDto> getChapterQuestions(
    String chapterId,
  );
  Future<void> deleteChapter(String chapterId);
  Future<ChapterTeacherResponseDto> updateStatus(String chapterId, UpdateChapterStatusDto dto);
}
