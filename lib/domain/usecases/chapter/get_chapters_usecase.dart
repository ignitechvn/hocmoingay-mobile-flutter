import '../../base/base_use_case.dart';
import '../../repositories/chapter_repository.dart';
import '../../../data/dto/chapter_dto.dart';

class GetChaptersUseCase
    implements BaseUseCase<List<ChapterStudentResponseDto>, String> {
  final ChapterRepository _repository;

  GetChaptersUseCase(this._repository);

  @override
  Future<List<ChapterStudentResponseDto>> call(String classroomId) async {
    return await _repository.getAllByClassroom(classroomId);
  }
}
