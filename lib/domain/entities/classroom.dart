import '../../core/constants/app_constants.dart';
import '../../core/constants/classroom_status_constants.dart';
import '../../core/constants/grade_constants.dart';
import '../../core/constants/subject_constants.dart';

// Schedule Entity
class Schedule {
  const Schedule({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  // Helper methods
  String get dayOfWeekText {
    switch (dayOfWeek) {
      case 1:
        return 'Thứ 2';
      case 2:
        return 'Thứ 3';
      case 3:
        return 'Thứ 4';
      case 4:
        return 'Thứ 5';
      case 5:
        return 'Thứ 6';
      case 6:
        return 'Thứ 7';
      case 7:
        return 'Chủ nhật';
      default:
        return 'Không xác định';
    }
  }

  String get timeRange => '$startTime - $endTime';
}

// Lesson Session Entity
class LessonSession {
  const LessonSession({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.note,
    this.originalSessionId,
  });
  final String id;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String status;
  final String? note;
  final String? originalSessionId;

  // Helper methods
  String get timeRange => '$startTime - $endTime';
  bool get isToday => DateTime.now().difference(date).inDays == 0;
  bool get isUpcoming => date.isAfter(DateTime.now());
  bool get isPast => date.isBefore(DateTime.now());
}

// Teacher Entity
class Teacher {
  const Teacher({
    required this.id,
    required this.fullName,
    this.avatar,
    this.email,
    required this.phone,
  });
  final String id;
  final String fullName;
  final String? avatar;
  final String? email;
  final String phone;
}

// Classroom Entity
class Classroom {
  const Classroom({
    required this.id,
    required this.name,
    required this.code,
    required this.joinCode,
    required this.grade,
    required this.status,
    required this.lessonSessionCount,
    required this.lessonLearnedCount,
    required this.startDate,
    required this.endDate,
    required this.totalStudents,
    required this.schedule,
    required this.lessonSessions,
  });
  final String id;
  final String name;
  final ESubjectCode code;
  final String joinCode;
  final EGradeLevel grade;
  final EClassroomStatus status;
  final int lessonSessionCount;
  final int lessonLearnedCount;
  final DateTime startDate;
  final DateTime endDate;
  final int totalStudents;
  final List<Schedule> schedule;
  final List<LessonSession> lessonSessions;

  // Helper methods
  double get progressPercentage {
    if (lessonSessionCount == 0) return 0.0;
    return (lessonLearnedCount / lessonSessionCount) * 100;
  }

  bool get isActive => status == EClassroomStatus.ONGOING;
  bool get isFinished => status == EClassroomStatus.FINISHED;
  bool get isEnrolling => status == EClassroomStatus.ENROLLING;

  String get nextLessonTime {
    final now = DateTime.now();
    final upcomingSessions =
        lessonSessions.where((session) => session.date.isAfter(now)).toList();

    if (upcomingSessions.isEmpty) return 'Không có lịch học';

    upcomingSessions.sort((a, b) => a.date.compareTo(b.date));
    final nextSession = upcomingSessions.first;

    return '${nextSession.date.toString().split(' ')[0]} ${nextSession.timeRange}';
  }
}

// Classroom Student Entity
class ClassroomStudent extends Classroom {
  const ClassroomStudent({
    required super.id,
    required super.name,
    required super.code,
    required super.joinCode,
    required super.grade,
    required super.status,
    required super.lessonSessionCount,
    required super.lessonLearnedCount,
    required super.startDate,
    required super.endDate,
    required super.totalStudents,
    required super.schedule,
    required super.lessonSessions,
    required this.studentStatus,
    required this.teacher,
  });
  final ClassroomStudentStatus studentStatus;
  final Teacher teacher;

  // Helper methods
  bool get isEnrolled => studentStatus == ClassroomStudentStatus.actived;
  bool get isWaitingConfirmation =>
      studentStatus == ClassroomStudentStatus.waitingTeacherConfirm ||
      studentStatus == ClassroomStudentStatus.waitingStudentConfirm;
  bool get isRejected =>
      studentStatus == ClassroomStudentStatus.rejectedByStudent ||
      studentStatus == ClassroomStudentStatus.rejectedByTeacher;
}

// Classroom Teacher Entity
class ClassroomTeacher extends Classroom {
  const ClassroomTeacher({
    required super.id,
    required super.name,
    required super.code,
    required super.joinCode,
    required super.grade,
    required super.status,
    required super.lessonSessionCount,
    required super.lessonLearnedCount,
    required super.startDate,
    required super.endDate,
    required super.totalStudents,
    required super.schedule,
    required super.lessonSessions,
  });

  // Helper methods for teacher-specific functionality
  bool get canManageStudents =>
      status == EClassroomStatus.ENROLLING ||
      status == EClassroomStatus.ONGOING;
  bool get canCreateLessons => status == EClassroomStatus.ONGOING;
  bool get canViewAnalytics =>
      status == EClassroomStatus.ONGOING || status == EClassroomStatus.FINISHED;
}

// Student Classrooms Entity
class StudentClassrooms {
  const StudentClassrooms({
    required this.enrollingClassrooms,
    required this.ongoingClassrooms,
    required this.finishedClassrooms,
  });
  final List<ClassroomStudent> enrollingClassrooms;
  final List<ClassroomStudent> ongoingClassrooms;
  final List<ClassroomStudent> finishedClassrooms;

  // Helper methods
  int get totalClassrooms =>
      enrollingClassrooms.length +
      ongoingClassrooms.length +
      finishedClassrooms.length;

  List<ClassroomStudent> get allClassrooms => [
    ...enrollingClassrooms,
    ...ongoingClassrooms,
    ...finishedClassrooms,
  ];

  List<ClassroomStudent> get activeClassrooms => [
    ...enrollingClassrooms,
    ...ongoingClassrooms,
  ];
}

// Teacher Classrooms Entity
class TeacherClassrooms {
  const TeacherClassrooms({
    required this.enrollingClassrooms,
    required this.ongoingClassrooms,
    required this.finishedClassrooms,
  });
  final List<ClassroomTeacher> enrollingClassrooms;
  final List<ClassroomTeacher> ongoingClassrooms;
  final List<ClassroomTeacher> finishedClassrooms;

  // Helper methods
  int get totalClassrooms =>
      enrollingClassrooms.length +
      ongoingClassrooms.length +
      finishedClassrooms.length;

  List<ClassroomTeacher> get allClassrooms => [
    ...enrollingClassrooms,
    ...ongoingClassrooms,
    ...finishedClassrooms,
  ];

  List<ClassroomTeacher> get activeClassrooms => [
    ...enrollingClassrooms,
    ...ongoingClassrooms,
  ];
}
