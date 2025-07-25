import '../../../data/dto/statistical_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/statistical_repository.dart';

class GetExamReportUseCase extends BaseUseCase<ExamReportDto, String> {
  final StatisticalRepository _repository;

  GetExamReportUseCase(this._repository);

  @override
  Future<ExamReportDto> call(String examId) async {
    return await _repository.getExamReport(examId);
  }
}
