import '../../../data/dto/statistical_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/statistical_repository.dart';

class GetPracticeSetReportUseCase
    extends BaseUseCase<PracticeSetReportDto, String> {
  final StatisticalRepository _repository;

  GetPracticeSetReportUseCase(this._repository);

  @override
  Future<PracticeSetReportDto> call(String practiceSetId) async {
    return await _repository.getPracticeSetReport(practiceSetId);
  }
}
