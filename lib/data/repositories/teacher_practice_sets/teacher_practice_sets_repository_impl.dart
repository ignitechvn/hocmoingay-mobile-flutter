import '../../../data/datasources/api/teacher_practice_sets_api.dart';
import '../../../data/dto/practice_set_dto.dart';
import '../../../domain/repositories/teacher_practice_sets_repository.dart';

class TeacherPracticeSetsRepositoryImpl
    implements TeacherPracticeSetsRepository {
  final TeacherPracticeSetsApi _api;

  TeacherPracticeSetsRepositoryImpl(this._api);

  @override
  Future<TeacherPracticeSetResponseListDto> getPracticeSets(
    String classroomId,
  ) async {
    return await _api.getPracticeSets(classroomId);
  }

  @override
  Future<TeacherPracticeSetResponseListDto> getOpenOrClosedPracticeSets(
    String classroomId,
  ) async {
    return await _api.getOpenOrClosedPracticeSets(classroomId);
  }

  @override
  Future<PracticeSetTeacherResponseDto> createPracticeSet(
    CreatePracticeSetDto dto,
  ) async {
    return await _api.createPracticeSet(dto);
  }

  @override
  Future<PracticeSetTeacherResponseDto> updatePracticeSet(
    String practiceSetId,
    UpdatePracticeSetDto dto,
  ) async {
    return await _api.updatePracticeSet(practiceSetId, dto);
  }

  @override
  Future<PracticeSetTeacherResponseDto> updatePracticeSetStatus(
    String practiceSetId,
    UpdatePracticeSetStatusDto dto,
  ) async {
    return await _api.updatePracticeSetStatus(practiceSetId, dto);
  }

  @override
  Future<PracticeSetDetailsTeacherResponseDto> getPracticeSetDetails(
    String practiceSetId,
  ) async {
    return await _api.getPracticeSetDetails(practiceSetId);
  }
}
