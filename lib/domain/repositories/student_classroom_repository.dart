import '../entities/classroom.dart';

abstract class StudentClassroomRepository {
  /// Get all student classrooms grouped by status
  Future<StudentClassrooms> getAllStudentClassrooms();
}
