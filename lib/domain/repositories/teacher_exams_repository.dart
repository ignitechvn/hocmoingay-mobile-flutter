import '../../data/dto/exam_dto.dart';

abstract class TeacherExamsRepository {
  Future<TeacherExamResponseListDto> getExams(String classroomId);
  Future<TeacherExamResponseListDto> getClosedExams(String classroomId);
  Future<ExamTeacherResponseDto> createExam(CreateExamDto dto);
  Future<ExamTeacherResponseDto> updateExam(String examId, UpdateExamDto dto);
  Future<DeleteExamResponseDto> deleteExam(String examId);
  Future<ExamTeacherResponseDto> updateExamStatus(String examId, UpdateExamStatusDto dto);
  Future<ExamDetailsTeacherResponseDto> getExamDetails(String examId);
}
