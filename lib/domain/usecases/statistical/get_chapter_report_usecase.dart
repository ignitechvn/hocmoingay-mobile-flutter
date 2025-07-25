import '../../../data/dto/statistical_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/statistical_repository.dart';

class GetChapterReportUseCase extends BaseUseCase<ChapterReportDto, String> {
  final StatisticalRepository _repository;

  GetChapterReportUseCase(this._repository);

  @override
  Future<ChapterReportDto> call(String chapterId) async {
    return await _repository.getChapterReport(chapterId);
  }
}
