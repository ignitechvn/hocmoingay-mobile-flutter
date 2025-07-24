import '../entities/classroom.dart';
import '../../data/dto/classroom_details_dto.dart';

abstract class StudentClassroomRepository {
  /// Get all student classrooms grouped by status
  Future<StudentClassrooms> getAllStudentClassrooms();
  
  /// Get classroom details by ID
  Future<ClassroomDetailsStudentResponseDto> getDetails(String classroomId);
}
