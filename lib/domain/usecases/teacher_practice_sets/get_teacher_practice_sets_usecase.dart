import '../../base/base_use_case.dart';
import '../../repositories/teacher_practice_sets_repository.dart';
import '../../../data/dto/practice_set_dto.dart';

class GetTeacherPracticeSetsUseCase
    extends BaseUseCase<TeacherPracticeSetResponseListDto, String> {
  final TeacherPracticeSetsRepository _repository;

  GetTeacherPracticeSetsUseCase(this._repository);

  @override
  Future<TeacherPracticeSetResponseListDto> call(String classroomId) async {
    return await _repository.getPracticeSets(classroomId);
  }
}
