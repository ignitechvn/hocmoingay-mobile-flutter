import '../../../data/dto/exam_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_exams_repository.dart';

class DeleteExamUseCase extends BaseUseCase<DeleteExamResponseDto, String> {
  final TeacherExamsRepository _repository;

  DeleteExamUseCase(this._repository);

  @override
  Future<DeleteExamResponseDto> call(String examId) async {
    return await _repository.deleteExam(examId);
  }
}
