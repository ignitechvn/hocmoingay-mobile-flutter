import '../../../data/dto/exam_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_exams_repository.dart';

class CreateExamUseCase
    extends BaseUseCase<ExamTeacherResponseDto, CreateExamDto> {
  final TeacherExamsRepository _repository;

  CreateExamUseCase(this._repository);

  @override
  Future<ExamTeacherResponseDto> call(CreateExamDto dto) async {
    return await _repository.createExam(dto);
  }
}
