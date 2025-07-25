import '../../../data/dto/statistical_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/statistical_repository.dart';

class GetClassroomOverviewUseCase
    extends BaseUseCase<ClassroomOverviewResponseDto, String> {
  final StatisticalRepository _repository;

  GetClassroomOverviewUseCase(this._repository);

  @override
  Future<ClassroomOverviewResponseDto> call(String classroomId) async {
    return await _repository.getClassroomOverview(classroomId);
  }
}
