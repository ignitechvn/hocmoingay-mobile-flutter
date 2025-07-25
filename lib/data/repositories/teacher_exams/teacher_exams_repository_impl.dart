import '../../../data/datasources/api/teacher_exams_api.dart';
import '../../../data/dto/exam_dto.dart';
import '../../../domain/repositories/teacher_exams_repository.dart';

class TeacherExamsRepositoryImpl implements TeacherExamsRepository {
  final TeacherExamsApi _api;

  TeacherExamsRepositoryImpl(this._api);

  @override
  Future<TeacherExamResponseListDto> getExams(String classroomId) async {
    return await _api.getExams(classroomId);
  }

  @override
  Future<TeacherExamResponseListDto> getClosedExams(String classroomId) async {
    return await _api.getClosedExams(classroomId);
  }

  @override
  Future<ExamTeacherResponseDto> createExam(CreateExamDto dto) async {
    return await _api.createExam(dto);
  }

  @override
  Future<ExamTeacherResponseDto> updateExam(
    String examId,
    UpdateExamDto dto,
  ) async {
    return await _api.updateExam(examId, dto);
  }
}
