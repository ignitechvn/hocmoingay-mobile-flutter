import '../../data/dto/chapter_dto.dart';
import '../../data/dto/chapter_details_dto.dart';

abstract class ChapterRepository {
  Future<List<ChapterStudentResponseDto>> getAllByClassroom(String classroomId);
  Future<ChapterDetailsStudentResponseDto> getDetails(String chapterId);
}
