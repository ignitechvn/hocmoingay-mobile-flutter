import '../../../data/dto/exam_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_exams_repository.dart';

class GetExamDetailsUseCase
    extends BaseUseCase<ExamDetailsTeacherResponseDto, String> {
  final TeacherExamsRepository _repository;

  GetExamDetailsUseCase(this._repository);

  @override
  Future<ExamDetailsTeacherResponseDto> call(String examId) async {
    return await _repository.getExamDetails(examId);
  }
}
