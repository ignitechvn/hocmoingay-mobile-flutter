import '../../../data/dto/statistical_dto.dart';

abstract class StatisticalRepository {
  Future<ClassroomOverviewResponseDto> getClassroomOverview(String classroomId);
  Future<StudentProgressReportDto> getStudentProgressReport(
    String classroomId,
    String studentId,
  );
  Future<ChapterReportDto> getChapterReport(String chapterId);
  Future<PracticeSetReportDto> getPracticeSetReport(String practiceSetId);
  Future<ExamReportDto> getExamReport(String examId);
}
