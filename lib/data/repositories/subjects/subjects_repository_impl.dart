import '../../../data/dto/subject_dto.dart';
import '../../../data/datasources/api/subjects_api.dart';
import '../../../domain/repositories/subjects_repository.dart';

class SubjectsRepositoryImpl implements SubjectsRepository {
  final SubjectsApi _api;

  SubjectsRepositoryImpl(this._api);

  @override
  Future<List<SubjectResponseDto>> getAllSubjects() async {
    return await _api.getAllSubjects();
  }

  @override
  Future<SubjectResponseDto> createSubject(CreateSubjectDto dto) async {
    return await _api.createSubject(dto);
  }
}
