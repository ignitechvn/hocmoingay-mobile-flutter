import '../../../data/dto/exam_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_exams_repository.dart';

class UpdateExamUseCase
    extends BaseUseCase<ExamTeacherResponseDto, Map<String, dynamic>> {
  final TeacherExamsRepository _repository;

  UpdateExamUseCase(this._repository);

  @override
  Future<ExamTeacherResponseDto> call(Map<String, dynamic> params) async {
    final examId = params['examId'] as String;
    final dto = params['dto'] as UpdateExamDto;
    return await _repository.updateExam(examId, dto);
  }
}
