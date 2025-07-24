import '../../../data/dto/classroom_dto.dart';
import '../../../domain/repositories/teacher_classroom_repository.dart';
import '../../base/base_use_case.dart';

class GetTeacherClassroomsUseCase
    implements BaseUseCase<void, TeacherClassroomResponseListDto> {
  final TeacherClassroomRepository _repository;

  GetTeacherClassroomsUseCase(this._repository);

  @override
  Future<TeacherClassroomResponseListDto> call(void params) async {
    return await _repository.getAllClassrooms();
  }
}
