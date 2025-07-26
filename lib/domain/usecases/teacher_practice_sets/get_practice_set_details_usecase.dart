import '../../../data/dto/practice_set_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_practice_sets_repository.dart';

class GetPracticeSetDetailsUseCase
    extends BaseUseCase<PracticeSetDetailsTeacherResponseDto, String> {
  final TeacherPracticeSetsRepository _repository;

  GetPracticeSetDetailsUseCase(this._repository);

  @override
  Future<PracticeSetDetailsTeacherResponseDto> call(
    String practiceSetId,
  ) async {
    return await _repository.getPracticeSetDetails(practiceSetId);
  }
}
