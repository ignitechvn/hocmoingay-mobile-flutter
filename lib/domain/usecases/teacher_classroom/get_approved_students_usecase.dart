import '../../../data/dto/teacher_classroom_dto.dart';
import '../../base/base_use_case.dart';
import '../../repositories/teacher_classroom_repository.dart';

class GetApprovedStudentsUseCase
    extends BaseUseCase<List<StudentResponseDto>, String> {
  final TeacherClassroomRepository _repository;

  GetApprovedStudentsUseCase(this._repository);

  @override
  Future<List<StudentResponseDto>> call(String classroomId) async {
    return await _repository.getApprovedStudents(classroomId);
  }
}
