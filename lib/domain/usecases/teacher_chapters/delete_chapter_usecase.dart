import '../../base/base_use_case.dart';
import '../../../data/dto/chapter_dto.dart';
import '../../repositories/teacher_chapters_repository.dart';

class DeleteChapterParams {
  final String chapterId;

  const DeleteChapterParams({required this.chapterId});
}

class DeleteChapterUseCase extends BaseUseCase<void, DeleteChapterParams> {
  final TeacherChaptersRepository _repository;

  DeleteChapterUseCase(this._repository);

  @override
  Future<void> call(DeleteChapterParams params) async {
    return await _repository.deleteChapter(params.chapterId);
  }
}
