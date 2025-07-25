import '../../base/base_use_case.dart';
import '../../repositories/teacher_practice_sets_repository.dart';
import '../../../data/dto/practice_set_dto.dart';

class UpdatePracticeSetUseCase
    extends BaseUseCase<PracticeSetTeacherResponseDto, Map<String, dynamic>> {
  final TeacherPracticeSetsRepository _repository;

  UpdatePracticeSetUseCase(this._repository);

  @override
  Future<PracticeSetTeacherResponseDto> call(
    Map<String, dynamic> params,
  ) async {
    final practiceSetId = params['practiceSetId'] as String;
    final dto = params['dto'] as UpdatePracticeSetDto;
    return await _repository.updatePracticeSet(practiceSetId, dto);
  }
}
