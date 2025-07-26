import '../../../core/constants/exam_constants.dart';
import '../../../data/dto/exam_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_exams_repository.dart';

class UpdateExamStatusParams {
  final String examId;
  final UpdateExamStatusDto dto;

  const UpdateExamStatusParams({required this.examId, required this.dto});
}

class UpdateExamStatusUseCase
    extends BaseUseCase<ExamTeacherResponseDto, UpdateExamStatusParams> {
  final TeacherExamsRepository _repository;

  UpdateExamStatusUseCase(this._repository);

  @override
  Future<ExamTeacherResponseDto> call(UpdateExamStatusParams params) async {
    return await _repository.updateExamStatus(params.examId, params.dto);
  }
}
