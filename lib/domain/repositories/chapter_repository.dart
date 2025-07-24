import '../../data/dto/chapter_dto.dart';

abstract class ChapterRepository {
  Future<List<ChapterStudentResponseDto>> getAllByClassroom(String classroomId);
}
