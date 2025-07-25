import '../../../data/dto/subject_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/subjects_repository.dart';

class GetAllSubjectsUseCase
    extends BaseUseCase<List<SubjectResponseDto>, void> {
  final SubjectsRepository _repository;

  GetAllSubjectsUseCase(this._repository);

  @override
  Future<List<SubjectResponseDto>> call(void params) async {
    return await _repository.getAllSubjects();
  }
}
