import '../../base/base_use_case.dart';
import '../../repositories/teacher_classroom_repository.dart';

class RejectStudentUseCase extends BaseUseCase<String, Map<String, String>> {
  final TeacherClassroomRepository _repository;

  RejectStudentUseCase(this._repository);

  @override
  Future<String> call(Map<String, String> params) async {
    return await _repository.rejectStudent(
      params['classroomId']!,
      params['studentId']!,
    );
  }
}
