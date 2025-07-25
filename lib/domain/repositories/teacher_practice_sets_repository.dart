import '../../data/dto/practice_set_dto.dart';

abstract class TeacherPracticeSetsRepository {
  Future<TeacherPracticeSetResponseListDto> getPracticeSets(String classroomId);
  Future<TeacherPracticeSetResponseListDto> getOpenOrClosedPracticeSets(
    String classroomId,
  );
  Future<PracticeSetTeacherResponseDto> createPracticeSet(
    CreatePracticeSetDto dto,
  );
  Future<PracticeSetTeacherResponseDto> updatePracticeSet(
    String practiceSetId,
    UpdatePracticeSetDto dto,
  );
}
