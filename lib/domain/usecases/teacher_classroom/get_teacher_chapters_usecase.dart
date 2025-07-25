import '../../base/base_use_case.dart';
import '../../repositories/teacher_classroom_repository.dart';
import '../../../data/dto/chapter_dto.dart';

class GetTeacherChaptersUseCase
    extends BaseUseCase<TeacherChapterResponseListDto, String> {
  final TeacherClassroomRepository _repository;

  GetTeacherChaptersUseCase(this._repository);

  @override
  Future<TeacherChapterResponseListDto> call(String classroomId) async {
    return await _repository.getChapters(classroomId);
  }
}
