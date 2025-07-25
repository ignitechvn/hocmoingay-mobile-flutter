import '../../data/dto/exam_dto.dart';

abstract class TeacherExamsRepository {
  Future<TeacherExamResponseListDto> getExams(String classroomId);
  Future<TeacherExamResponseListDto> getClosedExams(String classroomId);
  Future<ExamTeacherResponseDto> createExam(CreateExamDto dto);
  Future<ExamTeacherResponseDto> updateExam(String examId, UpdateExamDto dto);
}
