import '../../base/base_use_case.dart';
import '../../entities/classroom.dart';
import '../../repositories/student_classroom_repository.dart';

class GetStudentClassroomsUseCase
    implements BaseUseCase<void, StudentClassrooms> {
  final StudentClassroomRepository _repository;

  GetStudentClassroomsUseCase(this._repository);

  @override
  Future<StudentClassrooms> call(void params) async {
    return await _repository.getAllStudentClassrooms();
  }
}
