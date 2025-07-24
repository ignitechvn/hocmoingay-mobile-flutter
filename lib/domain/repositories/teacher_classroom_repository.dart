import '../../data/dto/classroom_dto.dart';

abstract class TeacherClassroomRepository {
  Future<TeacherClassroomResponseListDto> getAllClassrooms();
}
