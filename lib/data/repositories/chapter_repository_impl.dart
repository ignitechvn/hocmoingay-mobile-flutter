import '../../domain/repositories/chapter_repository.dart';
import '../dto/chapter_dto.dart';
import '../dto/chapter_details_dto.dart';
import '../datasources/api/chapter_api.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  final ChapterApi _api;

  ChapterRepositoryImpl(this._api);

  @override
  Future<List<ChapterStudentResponseDto>> getAllByClassroom(
    String classroomId,
  ) async {
    return await _api.getAllByClassroom(classroomId);
  }

  @override
  Future<ChapterDetailsStudentResponseDto> getDetails(String chapterId) async {
    return await _api.getDetails(chapterId);
  }
}
