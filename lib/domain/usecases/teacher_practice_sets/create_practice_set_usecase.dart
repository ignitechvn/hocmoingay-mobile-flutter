import '../../base/base_use_case.dart';
import '../../repositories/teacher_practice_sets_repository.dart';
import '../../../data/dto/practice_set_dto.dart';

class CreatePracticeSetUseCase
    extends BaseUseCase<PracticeSetTeacherResponseDto, CreatePracticeSetDto> {
  final TeacherPracticeSetsRepository _repository;

  CreatePracticeSetUseCase(this._repository);

  @override
  Future<PracticeSetTeacherResponseDto> call(CreatePracticeSetDto dto) async {
    return await _repository.createPracticeSet(dto);
  }
}
