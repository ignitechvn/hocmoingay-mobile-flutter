import '../../../data/dto/chapter_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_chapters_repository.dart';

class GetTeacherChaptersUseCase
    extends BaseUseCase<TeacherChapterResponseListDto, String> {
  final TeacherChaptersRepository _repository;

  GetTeacherChaptersUseCase(this._repository);

  @override
  Future<TeacherChapterResponseListDto> call(String classroomId) async {
    return await _repository.getTeacherChapters(classroomId);
  }
}
