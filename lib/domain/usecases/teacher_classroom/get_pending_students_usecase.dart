import '../../../data/dto/teacher_classroom_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_classroom_repository.dart';

class GetPendingStudentsUseCase
    extends BaseUseCase<List<PendingStudentResponseDto>, String> {
  final TeacherClassroomRepository _repository;

  GetPendingStudentsUseCase(this._repository);

  @override
  Future<List<PendingStudentResponseDto>> call(String classroomId) async {
    return await _repository.getPendingStudents(classroomId);
  }
}
