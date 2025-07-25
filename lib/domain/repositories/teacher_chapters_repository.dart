import '../../data/dto/chapter_dto.dart';

abstract class TeacherChaptersRepository {
  Future<TeacherChapterResponseListDto> getTeacherChapters(String classroomId);
  Future<ChapterDetailsTeacherResponseDto> getChapterDetails(String chapterId);
  Future<ChapterTeacherResponseDto> createChapter(CreateChapterDto dto);
  Future<TeacherChapterQuestionsResponseDto> getChapterQuestions(
    String chapterId,
  );
}
