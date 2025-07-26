import '../../core/constants/app_constants.dart';
import '../../core/constants/classroom_status_constants.dart';
import '../../core/constants/grade_constants.dart';
import '../../core/constants/subject_constants.dart';

// Schedule Response DTO
class ScheduleResponseDto {

  const ScheduleResponseDto({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleResponseDto.fromJson(Map<String, dynamic> json) =>
      ScheduleResponseDto(
        dayOfWeek: json['dayOfWeek'] as int,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
      );
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  Map<String, dynamic> toJson() => {
    'dayOfWeek': dayOfWeek,
    'startTime': startTime,
    'endTime': endTime,
  };
}

// Lesson Session Response DTO
class LessonSessionResponseDto {

  const LessonSessionResponseDto({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.note,
    this.originalSessionId,
  });

  factory LessonSessionResponseDto.fromJson(Map<String, dynamic> json) =>
      LessonSessionResponseDto(
        id: json['id'] as String,
        date: json['date'] as String,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
        status: json['status'] as String,
        note: json['note'] as String?,
        originalSessionId: json['originalSessionId'] as String?,
      );
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final String? note;
  final String? originalSessionId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'startTime': startTime,
    'endTime': endTime,
    'status': status,
    if (note != null) 'note': note,
    if (originalSessionId != null) 'originalSessionId': originalSessionId,
  };
}

// Teacher DTO
class TeacherDto {

  const TeacherDto({
    required this.id,
    required this.fullName,
    this.avatar,
    this.email,
    required this.phone,
  });

  factory TeacherDto.fromJson(Map<String, dynamic> json) => TeacherDto(
    id: json['id'] as String? ?? '',
    fullName: json['fullName'] as String? ?? '',
    avatar: json['avatar'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String? ?? '',
  );
  final String id;
  final String fullName;
  final String? avatar;
  final String? email;
  final String phone;

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    if (avatar != null) 'avatar': avatar,
    if (email != null) 'email': email,
    'phone': phone,
  };
}

// Classroom Response DTO
class ClassroomResponseDto {

  const ClassroomResponseDto({
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

  factory ClassroomResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => ClassroomResponseDto(
    id: json['id'] as String,
    name: json['name'] as String,
    code: ESubjectCode.fromString(json['code'] as String),
    joinCode: json['joinCode'] as String,
    grade: EGradeLevel.fromString(json['grade'] as String),
    status: EClassroomStatus.fromString(json['status'] as String),
    lessonSessionCount: json['lessonSessionCount'] as int,
    lessonLearnedCount: json['lessonLearnedCount'] as int,
    startDate: json['startDate'] as String,
    endDate: json['endDate'] as String,
    totalStudents: json['totalStudents'] as int,
    schedule:
        (json['schedule'] as List<dynamic>?)
            ?.map(
              (s) => ScheduleResponseDto.fromJson(s as Map<String, dynamic>),
            )
            .toList() ??
        [],
    lessonSessions:
        (json['lessonSessions'] as List<dynamic>?)
            ?.map(
              (ls) =>
                  LessonSessionResponseDto.fromJson(ls as Map<String, dynamic>),
            )
            .toList() ??
        [],
  );
  final String id;
  final String name;
  final ESubjectCode code;
  final String joinCode;
  final EGradeLevel grade;
  final EClassroomStatus status;
  final int lessonSessionCount;
  final int lessonLearnedCount;
  final String startDate;
  final String endDate;
  final int totalStudents;
  final List<ScheduleResponseDto> schedule;
  final List<LessonSessionResponseDto> lessonSessions;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code.value,
    'joinCode': joinCode,
    'grade': grade.value,
    'status': status.value,
    'lessonSessionCount': lessonSessionCount,
    'lessonLearnedCount': lessonLearnedCount,
    'startDate': startDate,
    'endDate': endDate,
    'totalStudents': totalStudents,
    'schedule': schedule.map((s) => s.toJson()).toList(),
    'lessonSessions': lessonSessions.map((ls) => ls.toJson()).toList(),
  };

  // Helper methods
  EGradeLevel? get gradeEnum => EGradeLevel.fromString(grade.value);
}

// Classroom Student Response DTO
class ClassroomStudentResponseDto extends ClassroomResponseDto {

  const ClassroomStudentResponseDto({
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
    required this.classroomStudentStatus,
    required this.teacher,
  });

  factory ClassroomStudentResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => ClassroomStudentResponseDto(
    id: json['id'] as String,
    name: json['name'] as String,
    code: ESubjectCode.fromString(json['code'] as String),
    joinCode: json['joinCode'] as String,
    grade: EGradeLevel.fromString(json['grade'] as String),
    status: EClassroomStatus.fromString(json['status'] as String),
    lessonSessionCount: json['lessonSessionCount'] as int,
    lessonLearnedCount: json['lessonLearnedCount'] as int,
    startDate: json['startDate'] as String,
    endDate: json['endDate'] as String,
    totalStudents: json['totalStudents'] as int,
    schedule:
        (json['schedule'] as List<dynamic>?)
            ?.map(
              (s) => ScheduleResponseDto.fromJson(s as Map<String, dynamic>),
            )
            .toList() ??
        [],
    lessonSessions:
        (json['lessonSessions'] as List<dynamic>?)
            ?.map(
              (ls) =>
                  LessonSessionResponseDto.fromJson(ls as Map<String, dynamic>),
            )
            .toList() ??
        [],
    classroomStudentStatus: json['classroomStudentStatus'] as String,
    teacher: TeacherDto.fromJson(json['teacher'] as Map<String, dynamic>),
  );
  final String classroomStudentStatus;
  final TeacherDto teacher;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'classroomStudentStatus': classroomStudentStatus,
    'teacher': teacher.toJson(),
  };

  // Helper methods
  ClassroomStudentStatus get statusEnum =>
      ClassroomStudentStatus.fromString(classroomStudentStatus);
}

// Student Classroom Response List DTO
class StudentClassroomResponseListDto {

  const StudentClassroomResponseListDto({
    required this.enrollingClassrooms,
    required this.ongoingClassrooms,
    required this.finishedClassrooms,
  });

  factory StudentClassroomResponseListDto.fromJson(Map<String, dynamic> json) =>
      StudentClassroomResponseListDto(
        enrollingClassrooms:
            (json['enrollingClassrooms'] as List<dynamic>)
                .map(
                  (c) => ClassroomStudentResponseDto.fromJson(
                    c as Map<String, dynamic>,
                  ),
                )
                .toList(),
        ongoingClassrooms:
            (json['ongoingClassrooms'] as List<dynamic>)
                .map(
                  (c) => ClassroomStudentResponseDto.fromJson(
                    c as Map<String, dynamic>,
                  ),
                )
                .toList(),
        finishedClassrooms:
            (json['finishedClassrooms'] as List<dynamic>)
                .map(
                  (c) => ClassroomStudentResponseDto.fromJson(
                    c as Map<String, dynamic>,
                  ),
                )
                .toList(),
      );
  final List<ClassroomStudentResponseDto> enrollingClassrooms;
  final List<ClassroomStudentResponseDto> ongoingClassrooms;
  final List<ClassroomStudentResponseDto> finishedClassrooms;

  Map<String, dynamic> toJson() => {
    'enrollingClassrooms': enrollingClassrooms.map((c) => c.toJson()).toList(),
    'ongoingClassrooms': ongoingClassrooms.map((c) => c.toJson()).toList(),
    'finishedClassrooms': finishedClassrooms.map((c) => c.toJson()).toList(),
  };
}

// Teacher Classroom Response List DTO
class TeacherClassroomResponseListDto {

  const TeacherClassroomResponseListDto({
    required this.enrollingClassrooms,
    required this.ongoingClassrooms,
    required this.finishedClassrooms,
  });

  factory TeacherClassroomResponseListDto.fromJson(Map<String, dynamic> json) =>
      TeacherClassroomResponseListDto(
        enrollingClassrooms:
            (json['enrollingClassrooms'] as List<dynamic>)
                .map(
                  (c) => ClassroomTeacherResponseDto.fromJson(
                    c as Map<String, dynamic>,
                  ),
                )
                .toList(),
        ongoingClassrooms:
            (json['ongoingClassrooms'] as List<dynamic>)
                .map(
                  (c) => ClassroomTeacherResponseDto.fromJson(
                    c as Map<String, dynamic>,
                  ),
                )
                .toList(),
        finishedClassrooms:
            (json['finishedClassrooms'] as List<dynamic>)
                .map(
                  (c) => ClassroomTeacherResponseDto.fromJson(
                    c as Map<String, dynamic>,
                  ),
                )
                .toList(),
      );
  final List<ClassroomTeacherResponseDto> enrollingClassrooms;
  final List<ClassroomTeacherResponseDto> ongoingClassrooms;
  final List<ClassroomTeacherResponseDto> finishedClassrooms;

  Map<String, dynamic> toJson() => {
    'enrollingClassrooms': enrollingClassrooms.map((c) => c.toJson()).toList(),
    'ongoingClassrooms': ongoingClassrooms.map((c) => c.toJson()).toList(),
    'finishedClassrooms': finishedClassrooms.map((c) => c.toJson()).toList(),
  };
}

// Classroom Teacher Response DTO
class ClassroomTeacherResponseDto extends ClassroomResponseDto {
  const ClassroomTeacherResponseDto({
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

  factory ClassroomTeacherResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => ClassroomTeacherResponseDto(
    id: json['id'] as String,
    name: json['name'] as String,
    code: ESubjectCode.fromString(json['code'] as String),
    joinCode: json['joinCode'] as String,
    grade: EGradeLevel.fromString(json['grade'] as String),
    status: EClassroomStatus.fromString(json['status'] as String),
    lessonSessionCount: json['lessonSessionCount'] as int,
    lessonLearnedCount: json['lessonLearnedCount'] as int,
    startDate: json['startDate'] as String,
    endDate: json['endDate'] as String,
    totalStudents: json['totalStudents'] as int,
    schedule:
        (json['schedule'] as List<dynamic>?)
            ?.map(
              (s) => ScheduleResponseDto.fromJson(s as Map<String, dynamic>),
            )
            .toList() ??
        [],
    lessonSessions:
        (json['lessonSessions'] as List<dynamic>?)
            ?.map(
              (ls) =>
                  LessonSessionResponseDto.fromJson(ls as Map<String, dynamic>),
            )
            .toList() ??
        [],
  );

}

// Update Classroom Status DTO
class UpdateClassroomStatusDto {

  const UpdateClassroomStatusDto({
    required this.status,
  });

  factory UpdateClassroomStatusDto.fromJson(Map<String, dynamic> json) =>
      UpdateClassroomStatusDto(
        status: EClassroomStatus.fromString(json['status'] as String),
      );
  final EClassroomStatus status;

  Map<String, dynamic> toJson() => {
    'status': status.value,
  };
}
