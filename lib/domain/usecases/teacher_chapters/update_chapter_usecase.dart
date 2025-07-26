import '../../base/base_use_case.dart';
import '../../../data/dto/chapter_dto.dart';
import '../../repositories/teacher_chapters_repository.dart';

class UpdateChapterParams {
  final String chapterId;
  final UpdateChapterDto dto;

  const UpdateChapterParams({required this.chapterId, required this.dto});
}

class UpdateChapterUseCase
    extends BaseUseCase<ChapterTeacherResponseDto, UpdateChapterParams> {
  final TeacherChaptersRepository _repository;

  UpdateChapterUseCase(this._repository);

  @override
  Future<ChapterTeacherResponseDto> call(UpdateChapterParams params) async {
    return await _repository.updateChapter(params.chapterId, params.dto);
  }
}
