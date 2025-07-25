import '../../dto/statistical_dto.dart';
import '../../datasources/api/statistical_api.dart';
import '../../../domain/repositories/statistical_repository.dart';

class StatisticalRepositoryImpl implements StatisticalRepository {
  final StatisticalApi _api;

  StatisticalRepositoryImpl(this._api);

  @override
  Future<ClassroomOverviewResponseDto> getClassroomOverview(
    String classroomId,
  ) async {
    return await _api.getClassroomOverview(classroomId);
  }

  @override
  Future<StudentProgressReportDto> getStudentProgressReport(
    String classroomId,
    String studentId,
  ) async {
    return await _api.getStudentProgressReport(classroomId, studentId);
  }

  @override
  Future<ChapterReportDto> getChapterReport(String chapterId) async {
    return await _api.getChapterReport(chapterId);
  }

  @override
  Future<PracticeSetReportDto> getPracticeSetReport(
    String practiceSetId,
  ) async {
    return await _api.getPracticeSetReport(practiceSetId);
  }

  @override
  Future<ExamReportDto> getExamReport(String examId) async {
    return await _api.getExamReport(examId);
  }
}
