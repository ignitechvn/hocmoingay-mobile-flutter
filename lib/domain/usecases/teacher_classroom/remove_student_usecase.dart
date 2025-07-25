import '../../base/base_use_case.dart';
import '../../repositories/teacher_classroom_repository.dart';

class RemoveStudentUseCase extends BaseUseCase<void, String> {
  final TeacherClassroomRepository _repository;

  RemoveStudentUseCase(this._repository);

  @override
  Future<void> call(String studentId) async {
    return await _repository.removeStudent(studentId);
  }
}
