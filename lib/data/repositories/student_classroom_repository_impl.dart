import '../../core/constants/app_constants.dart';
import '../../domain/entities/classroom.dart';
import '../../domain/repositories/student_classroom_repository.dart';
import '../datasources/api/student_classroom_api.dart';
import '../dto/classroom_dto.dart';

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
      grade: dto.gradeEnum ?? GradeLevel.grade1,
      status: dto.status,
      lessonSessionCount: dto.lessonSessionCount,
      lessonLearnedCount: dto.lessonLearnedCount,
      startDate: DateTime.parse(dto.startDate),
      endDate: DateTime.parse(dto.endDate),
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
      date: DateTime.parse(dto.date),
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
}
