import '../../data/dto/classroom_dto.dart';
import '../../data/dto/teacher_classroom_dto.dart';
import '../../data/dto/chapter_dto.dart';

abstract class TeacherClassroomRepository {
  Future<TeacherClassroomResponseListDto> getAllClassrooms();
  Future<ClassroomTeacherResponseDto> createClassroom(CreateClassroomDto dto);
  Future<ClassroomDetailsTeacherResponseDto> getClassroomDetails(
    String classroomId,
  );
  Future<List<StudentResponseDto>> getApprovedStudents(String classroomId);
  Future<void> removeStudent(String studentId);
  Future<List<PendingStudentResponseDto>> getPendingStudents(
    String classroomId,
  );
  Future<String> approveStudent(String classroomId, String studentId);
  Future<String> rejectStudent(String classroomId, String studentId);
  Future<ClassroomTeacherResponseDto> updateClassroom(
    String classroomId,
    UpdateClassroomDto dto,
  );
  Future<ClassroomTeacherResponseDto> updateClassroomStatus(
    String classroomId,
    UpdateClassroomStatusDto dto,
  );
  Future<TeacherChapterResponseListDto> getChapters(String classroomId);
}
