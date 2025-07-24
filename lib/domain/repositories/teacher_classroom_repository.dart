import '../../data/dto/classroom_dto.dart';
import '../../data/dto/teacher_classroom_dto.dart';

abstract class TeacherClassroomRepository {
  Future<TeacherClassroomResponseListDto> getAllClassrooms();
  Future<ClassroomTeacherResponseDto> createClassroom(CreateClassroomDto dto);
}
