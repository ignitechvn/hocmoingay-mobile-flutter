import '../../../data/dto/statistical_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/statistical_repository.dart';

class GetStudentProgressReportUseCase
    extends BaseUseCase<StudentProgressReportDto, Map<String, String>> {
  final StatisticalRepository _repository;

  GetStudentProgressReportUseCase(this._repository);

  @override
  Future<StudentProgressReportDto> call(Map<String, String> params) async {
    final classroomId = params['classroomId']!;
    final studentId = params['studentId']!;
    return await _repository.getStudentProgressReport(classroomId, studentId);
  }
}
