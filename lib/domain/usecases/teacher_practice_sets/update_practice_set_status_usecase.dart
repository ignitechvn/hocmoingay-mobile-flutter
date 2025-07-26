import '../../../core/constants/practice_set_constants.dart';
import '../../../data/dto/practice_set_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_practice_sets_repository.dart';

class UpdatePracticeSetStatusParams {
  final String practiceSetId;
  final UpdatePracticeSetStatusDto dto;

  const UpdatePracticeSetStatusParams({
    required this.practiceSetId,
    required this.dto,
  });
}

class UpdatePracticeSetStatusUseCase
    extends
        BaseUseCase<
          PracticeSetTeacherResponseDto,
          UpdatePracticeSetStatusParams
        > {
  final TeacherPracticeSetsRepository _repository;

  UpdatePracticeSetStatusUseCase(this._repository);

  @override
  Future<PracticeSetTeacherResponseDto> call(
    UpdatePracticeSetStatusParams params,
  ) async {
    return await _repository.updatePracticeSetStatus(
      params.practiceSetId,
      params.dto,
    );
  }
}
