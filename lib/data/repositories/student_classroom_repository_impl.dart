import '../../core/constants/app_constants.dart';
import '../../domain/entities/classroom.dart';
import '../../domain/repositories/student_classroom_repository.dart';
import '../datasources/api/student_classroom_api.dart';
import '../dto/classroom_dto.dart';
import '../dto/classroom_details_dto.dart';

// Helper function to parse date strings
DateTime _parseDateString(String dateString) {
  try {
    // Try standard DateTime.parse first
    return DateTime.parse(dateString);
  } catch (e) {
    // Handle custom format: "Wed Jul 23 2025 07:15:00 GMT+0000 (Coordinated Universal Time)"
    if (dateString.contains('GMT+0000')) {
      // Extract the date part: "Wed Jul 23 2025 07:15:00"
      final datePart = dateString.split('GMT')[0].trim();

      // Parse manually: "Wed Jul 23 2025 07:15:00"
      final parts = datePart.split(' ');
      if (parts.length >= 5) {
        final day = int.parse(parts[2]);
        final month = _getMonthNumber(parts[1]);
        final year = int.parse(parts[3]);
        final timeParts = parts[4].split(':');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final second = int.parse(timeParts[2]);

        return DateTime(year, month, day, hour, minute, second);
      }
    }
    // If all else fails, return current date
    print('⚠️ Could not parse date: $dateString, using current date');
    return DateTime.now();
  }
}

int _getMonthNumber(String month) {
  switch (month.toLowerCase()) {
    case 'jan':
      return 1;
    case 'feb':
      return 2;
    case 'mar':
      return 3;
    case 'apr':
      return 4;
    case 'may':
      return 5;
    case 'jun':
      return 6;
    case 'jul':
      return 7;
    case 'aug':
      return 8;
    case 'sep':
      return 9;
    case 'oct':
      return 10;
    case 'nov':
      return 11;
    case 'dec':
      return 12;
    default:
      return 1;
  }
}

class StudentClassroomRepositoryImpl implements StudentClassroomRepository {
  final StudentClassroomApi _api;

  StudentClassroomRepositoryImpl(this._api);

  @override
  Future<StudentClassrooms> getAllStudentClassrooms() async {
    try {
      final response = await _api.getAllStudentClassrooms();
      return _mapToEntity(response);
    } catch (e) {
      throw Exception('Failed to get student classrooms: $e');
    }
  }

  StudentClassrooms _mapToEntity(StudentClassroomResponseListDto dto) {
    return StudentClassrooms(
      enrollingClassrooms:
          dto.enrollingClassrooms.map(_mapToClassroomStudent).toList(),
      ongoingClassrooms:
          dto.ongoingClassrooms.map(_mapToClassroomStudent).toList(),
      finishedClassrooms:
          dto.finishedClassrooms.map(_mapToClassroomStudent).toList(),
    );
  }

  ClassroomStudent _mapToClassroomStudent(ClassroomStudentResponseDto dto) {
    return ClassroomStudent(
      id: dto.id,
      name: dto.name,
      code: dto.code,
      joinCode: dto.joinCode,
      grade: dto.grade,
      status: dto.status,
      lessonSessionCount: dto.lessonSessionCount,
      lessonLearnedCount: dto.lessonLearnedCount,
      startDate: _parseDateString(dto.startDate),
      endDate: _parseDateString(dto.endDate),
      totalStudents: dto.totalStudents,
      schedule: dto.schedule.map(_mapToSchedule).toList(),
      lessonSessions: dto.lessonSessions.map(_mapToLessonSession).toList(),
      studentStatus: dto.statusEnum,
      teacher: _mapToTeacher(dto.teacher),
    );
  }

  Schedule _mapToSchedule(ScheduleResponseDto dto) {
    return Schedule(
      dayOfWeek: dto.dayOfWeek,
      startTime: dto.startTime,
      endTime: dto.endTime,
    );
  }

  LessonSession _mapToLessonSession(LessonSessionResponseDto dto) {
    return LessonSession(
      id: dto.id,
      date: _parseDateString(dto.date),
      startTime: dto.startTime,
      endTime: dto.endTime,
      status: dto.status,
      note: dto.note,
      originalSessionId: dto.originalSessionId,
    );
  }

  Teacher _mapToTeacher(TeacherDto dto) {
    return Teacher(
      id: dto.id,
      fullName: dto.fullName,
      avatar: dto.avatar,
      email: dto.email,
      phone: dto.phone,
    );
  }

  Future<ClassroomDetailsStudentResponseDto> getDetails(
    String classroomId,
  ) async {
    return await _api.getDetails(classroomId);
  }
}
