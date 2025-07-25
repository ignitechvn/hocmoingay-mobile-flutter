import '../../../data/dto/exam_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_exams_repository.dart';

class GetClosedExamsUseCase
    extends BaseUseCase<TeacherExamResponseListDto, String> {
  final TeacherExamsRepository _repository;

  GetClosedExamsUseCase(this._repository);

  @override
  Future<TeacherExamResponseListDto> call(String classroomId) async {
    return await _repository.getClosedExams(classroomId);
  }
}
