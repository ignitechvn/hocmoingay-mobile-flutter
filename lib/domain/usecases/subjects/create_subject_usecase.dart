import '../../../data/dto/subject_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/subjects_repository.dart';

class CreateSubjectUseCase
    extends BaseUseCase<SubjectResponseDto, CreateSubjectDto> {
  final SubjectsRepository _repository;

  CreateSubjectUseCase(this._repository);

  @override
  Future<SubjectResponseDto> call(CreateSubjectDto dto) async {
    return await _repository.createSubject(dto);
  }
}
