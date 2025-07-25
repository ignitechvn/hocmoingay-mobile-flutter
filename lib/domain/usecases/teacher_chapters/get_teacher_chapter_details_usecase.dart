import '../../base/base_use_case.dart';
import '../../repositories/teacher_chapters_repository.dart';
import '../../../data/dto/chapter_dto.dart';

class GetTeacherChapterDetailsUseCase
    extends BaseUseCase<ChapterDetailsTeacherResponseDto, String> {
  final TeacherChaptersRepository _repository;

  GetTeacherChapterDetailsUseCase(this._repository);

  @override
  Future<ChapterDetailsTeacherResponseDto> call(String chapterId) async {
    return await _repository.getChapterDetails(chapterId);
  }
}
