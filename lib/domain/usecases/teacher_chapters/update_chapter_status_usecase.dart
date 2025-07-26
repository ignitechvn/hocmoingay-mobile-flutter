import '../../base/base_use_case.dart';
import '../../../data/dto/chapter_dto.dart';
import '../../repositories/teacher_chapters_repository.dart';

class UpdateChapterStatusParams {
  final String chapterId;
  final UpdateChapterStatusDto dto;

  const UpdateChapterStatusParams({required this.chapterId, required this.dto});
}

class UpdateChapterStatusUseCase
    extends BaseUseCase<ChapterTeacherResponseDto, UpdateChapterStatusParams> {
  final TeacherChaptersRepository _repository;

  UpdateChapterStatusUseCase(this._repository);

  @override
  Future<ChapterTeacherResponseDto> call(
    UpdateChapterStatusParams params,
  ) async {
    return await _repository.updateStatus(params.chapterId, params.dto);
  }
}
