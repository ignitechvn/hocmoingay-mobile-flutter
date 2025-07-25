import '../../base/base_use_case.dart';
import '../../repositories/teacher_classroom_repository.dart';

class ApproveStudentUseCase extends BaseUseCase<String, Map<String, String>> {
  final TeacherClassroomRepository _repository;

  ApproveStudentUseCase(this._repository);

  @override
  Future<String> call(Map<String, String> params) async {
    return await _repository.approveStudent(
      params['classroomId']!,
      params['studentId']!,
    );
  }
}
