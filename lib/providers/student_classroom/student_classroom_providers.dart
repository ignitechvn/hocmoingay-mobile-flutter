import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/student_classroom_repository_impl.dart';
import '../../domain/entities/classroom.dart';
import '../../domain/usecases/student_classroom/get_student_classrooms_usecase.dart';
import '../../core/constants/app_constants.dart';
import '../api/api_providers.dart';

// Repository Provider
final studentClassroomRepositoryProvider =
    Provider<StudentClassroomRepositoryImpl>((ref) {
      final api = ref.watch(studentClassroomApiProvider);
      return StudentClassroomRepositoryImpl(api);
    });

// Use Case Provider
final getStudentClassroomsUseCaseProvider =
    Provider<GetStudentClassroomsUseCase>((ref) {
      final repository = ref.watch(studentClassroomRepositoryProvider);
      return GetStudentClassroomsUseCase(repository);
    });

// Mock Data Provider for Testing UI
final studentClassroomsProvider = FutureProvider<StudentClassrooms>((
  ref,
) async {
  // TODO: Replace with real API call when ready
  await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

  return _createMockData();
});

// Mock Data Creation
StudentClassrooms _createMockData() {
  final teacher1 = Teacher(
    id: '1',
    fullName: 'Nguyễn Văn A',
    avatar: null,
    email: 'teacher1@example.com',
    phone: '0912345678',
  );

  final teacher2 = Teacher(
    id: '2',
    fullName: 'Trần Thị B',
    avatar: null,
    email: 'teacher2@example.com',
    phone: '0987654321',
  );

  final schedule1 = [
    Schedule(dayOfWeek: 2, startTime: '08:00', endTime: '09:30'),
    Schedule(dayOfWeek: 4, startTime: '08:00', endTime: '09:30'),
  ];

  final schedule2 = [
    Schedule(dayOfWeek: 3, startTime: '14:00', endTime: '15:30'),
    Schedule(dayOfWeek: 5, startTime: '14:00', endTime: '15:30'),
  ];

  final lessonSessions1 = [
    LessonSession(
      id: '1',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: '08:00',
      endTime: '09:30',
      status: 'scheduled',
    ),
    LessonSession(
      id: '2',
      date: DateTime.now().add(const Duration(days: 3)),
      startTime: '08:00',
      endTime: '09:30',
      status: 'scheduled',
    ),
  ];

  final lessonSessions2 = [
    LessonSession(
      id: '3',
      date: DateTime.now().add(const Duration(days: 2)),
      startTime: '14:00',
      endTime: '15:30',
      status: 'scheduled',
    ),
  ];

  // Enrolling Classrooms
  final enrollingClassrooms = [
    ClassroomStudent(
      id: '1',
      name: 'Toán học nâng cao lớp 9',
      code: 'MATH',
      joinCode: 'MATH001',
      grade: GradeLevel.grade9,
      status: 'enrolling',
      lessonSessionCount: 20,
      lessonLearnedCount: 0,
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 90)),
      totalStudents: 15,
      schedule: schedule1,
      lessonSessions: lessonSessions1,
      studentStatus: ClassroomStudentStatus.waitingTeacherConfirm,
      teacher: teacher1,
    ),
  ];

  // Ongoing Classrooms
  final ongoingClassrooms = [
    ClassroomStudent(
      id: '2',
      name: 'Vật lý cơ bản lớp 10',
      code: 'PHYSICS',
      joinCode: 'PHY001',
      grade: GradeLevel.grade10,
      status: 'active',
      lessonSessionCount: 15,
      lessonLearnedCount: 8,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 60)),
      totalStudents: 20,
      schedule: schedule2,
      lessonSessions: lessonSessions2,
      studentStatus: ClassroomStudentStatus.actived,
      teacher: teacher2,
    ),
    ClassroomStudent(
      id: '3',
      name: 'Hóa học nâng cao lớp 11',
      code: 'CHEMISTRY',
      joinCode: 'CHEM001',
      grade: GradeLevel.grade11,
      status: 'active',
      lessonSessionCount: 12,
      lessonLearnedCount: 5,
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 75)),
      totalStudents: 18,
      schedule: schedule1,
      lessonSessions: [],
      studentStatus: ClassroomStudentStatus.actived,
      teacher: teacher1,
    ),
  ];

  // Finished Classrooms
  final finishedClassrooms = [
    ClassroomStudent(
      id: '4',
      name: 'Tiếng Anh giao tiếp',
      code: 'ENGLISH',
      joinCode: 'ENG001',
      grade: GradeLevel.grade12,
      status: 'finished',
      lessonSessionCount: 10,
      lessonLearnedCount: 10,
      startDate: DateTime.now().subtract(const Duration(days: 120)),
      endDate: DateTime.now().subtract(const Duration(days: 30)),
      totalStudents: 25,
      schedule: [],
      lessonSessions: [],
      studentStatus: ClassroomStudentStatus.actived,
      teacher: teacher2,
    ),
  ];

  return StudentClassrooms(
    enrollingClassrooms: enrollingClassrooms,
    ongoingClassrooms: ongoingClassrooms,
    finishedClassrooms: finishedClassrooms,
  );
}
