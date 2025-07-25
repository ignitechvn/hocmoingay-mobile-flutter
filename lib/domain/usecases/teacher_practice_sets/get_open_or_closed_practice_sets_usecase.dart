import '../../../data/dto/practice_set_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_practice_sets_repository.dart';

class GetOpenOrClosedPracticeSetsUseCase
    extends BaseUseCase<TeacherPracticeSetResponseListDto, String> {
  final TeacherPracticeSetsRepository _repository;

  GetOpenOrClosedPracticeSetsUseCase(this._repository);

  @override
  Future<TeacherPracticeSetResponseListDto> call(String classroomId) async {
    return await _repository.getOpenOrClosedPracticeSets(classroomId);
  }
}
