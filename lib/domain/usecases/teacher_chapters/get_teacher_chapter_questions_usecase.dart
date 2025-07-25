import '../../../data/dto/chapter_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_chapters_repository.dart';

class GetTeacherChapterQuestionsUseCase
    extends BaseUseCase<TeacherChapterQuestionsResponseDto, String> {
  final TeacherChaptersRepository _repository;

  GetTeacherChapterQuestionsUseCase(this._repository);

  @override
  Future<TeacherChapterQuestionsResponseDto> call(String chapterId) async {
    return await _repository.getChapterQuestions(chapterId);
  }
}
