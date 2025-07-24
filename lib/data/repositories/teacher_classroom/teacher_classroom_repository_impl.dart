import '../../datasources/api/teacher_classroom_api.dart';
import '../../dto/classroom_dto.dart';
import '../../dto/teacher_classroom_dto.dart';
import '../../../domain/repositories/teacher_classroom_repository.dart';

class TeacherClassroomRepositoryImpl implements TeacherClassroomRepository {
  final TeacherClassroomApi _api;

  TeacherClassroomRepositoryImpl(this._api);

  @override
  Future<TeacherClassroomResponseListDto> getAllClassrooms() async {
    return await _api.getAllClassrooms();
  }

  @override
  Future<ClassroomTeacherResponseDto> createClassroom(CreateClassroomDto dto) async {
    return await _api.createClassroom(dto);
  }
}
