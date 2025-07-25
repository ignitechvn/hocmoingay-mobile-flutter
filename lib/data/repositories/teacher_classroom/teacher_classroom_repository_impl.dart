import '../../datasources/api/teacher_classroom_api.dart';
import '../../dto/classroom_dto.dart';
import '../../dto/teacher_classroom_dto.dart';
import '../../dto/chapter_dto.dart';
import '../../../domain/repositories/teacher_classroom_repository.dart';

class TeacherClassroomRepositoryImpl implements TeacherClassroomRepository {
  final TeacherClassroomApi _api;

  TeacherClassroomRepositoryImpl(this._api);

  @override
  Future<TeacherClassroomResponseListDto> getAllClassrooms() async {
    return await _api.getAllClassrooms();
  }

  @override
  Future<ClassroomTeacherResponseDto> createClassroom(
    CreateClassroomDto dto,
  ) async {
    return await _api.createClassroom(dto);
  }

  @override
  Future<ClassroomDetailsTeacherResponseDto> getClassroomDetails(
    String classroomId,
  ) async {
    return await _api.getClassroomDetails(classroomId);
  }

  @override
  Future<List<StudentResponseDto>> getApprovedStudents(
    String classroomId,
  ) async {
    return await _api.getApprovedStudents(classroomId);
  }

  @override
  Future<void> removeStudent(String studentId) async {
    return await _api.removeStudent(studentId);
  }

  @override
  Future<List<PendingStudentResponseDto>> getPendingStudents(
    String classroomId,
  ) async {
    return await _api.getPendingStudents(classroomId);
  }

  @override
  Future<String> approveStudent(String classroomId, String studentId) async {
    return await _api.approveStudent(classroomId, studentId);
  }

  @override
  Future<String> rejectStudent(String classroomId, String studentId) async {
    return await _api.rejectStudent(classroomId, studentId);
  }

  @override
  Future<TeacherChapterResponseListDto> getChapters(String classroomId) async {
    return await _api.getChapters(classroomId);
  }
}
