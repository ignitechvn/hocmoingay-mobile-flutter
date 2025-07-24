import '../../base/base_use_case.dart';
import '../../repositories/chapter_repository.dart';
import '../../../data/dto/chapter_details_dto.dart';

class GetChapterDetailsUseCase
    implements BaseUseCase<ChapterDetailsStudentResponseDto, String> {
  final ChapterRepository _repository;

  GetChapterDetailsUseCase(this._repository);

  @override
  Future<ChapterDetailsStudentResponseDto> call(String chapterId) async {
    return await _repository.getDetails(chapterId);
  }
}
