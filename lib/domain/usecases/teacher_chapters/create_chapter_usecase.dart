import '../../base/base_use_case.dart';
import '../../repositories/teacher_chapters_repository.dart';
import '../../../data/dto/chapter_dto.dart';

class CreateChapterUseCase
    extends BaseUseCase<ChapterTeacherResponseDto, CreateChapterDto> {
  final TeacherChaptersRepository _repository;

  CreateChapterUseCase(this._repository);

  @override
  Future<ChapterTeacherResponseDto> call(CreateChapterDto dto) async {
    return await _repository.createChapter(dto);
  }
}
