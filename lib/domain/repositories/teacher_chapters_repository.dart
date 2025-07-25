import '../../data/dto/chapter_dto.dart';

abstract class TeacherChaptersRepository {
  Future<ChapterDetailsTeacherResponseDto> getChapterDetails(String chapterId);
  Future<ChapterTeacherResponseDto> createChapter(CreateChapterDto dto);
}
