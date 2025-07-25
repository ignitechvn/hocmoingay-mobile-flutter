import '../../data/dto/subject_dto.dart';

abstract class SubjectsRepository {
  Future<List<SubjectResponseDto>> getAllSubjects();
  Future<SubjectResponseDto> createSubject(CreateSubjectDto dto);
}
