import '../../core/constants/app_constants.dart';

// Schedule Response DTO
class ScheduleResponseDto {
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  const ScheduleResponseDto({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
    'dayOfWeek': dayOfWeek,
    'startTime': startTime,
    'endTime': endTime,
  };

  factory ScheduleResponseDto.fromJson(Map<String, dynamic> json) =>
      ScheduleResponseDto(
        dayOfWeek: json['dayOfWeek'] as int,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
      );
}

// Lesson Session Response DTO
class LessonSessionResponseDto {
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final String? note;
  final String? originalSessionId;

  const LessonSessionResponseDto({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.note,
    this.originalSessionId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'startTime': startTime,
    'endTime': endTime,
    'status': status,
    if (note != null) 'note': note,
    if (originalSessionId != null) 'originalSessionId': originalSessionId,
  };

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
}

// Teacher DTO
class TeacherDto {
  final String id;
  final String fullName;
  final String? avatar;
  final String? email;
  final String phone;

  const TeacherDto({
    required this.id,
    required this.fullName,
    this.avatar,
    this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    if (avatar != null) 'avatar': avatar,
    if (email != null) 'email': email,
    'phone': phone,
  };

  factory TeacherDto.fromJson(Map<String, dynamic> json) => TeacherDto(
    id: json['id'] as String,
    fullName: json['fullName'] as String,
    avatar: json['avatar'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String,
  );
}

// Classroom Response DTO
class ClassroomResponseDto {
  final String id;
  final String name;
  final String code;
  final String joinCode;
  final String grade;
  final String status;
  final int lessonSessionCount;
  final int lessonLearnedCount;
  final String startDate;
  final String endDate;
  final int totalStudents;
  final List<ScheduleResponseDto> schedule;
  final List<LessonSessionResponseDto> lessonSessions;

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'joinCode': joinCode,
    'grade': grade,
    'status': status,
    'lessonSessionCount': lessonSessionCount,
    'lessonLearnedCount': lessonLearnedCount,
    'startDate': startDate,
    'endDate': endDate,
    'totalStudents': totalStudents,
    'schedule': schedule.map((s) => s.toJson()).toList(),
    'lessonSessions': lessonSessions.map((ls) => ls.toJson()).toList(),
  };

  factory ClassroomResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => ClassroomResponseDto(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String,
    joinCode: json['joinCode'] as String,
    grade: json['grade'] as String,
    status: json['status'] as String,
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

  // Helper methods
  GradeLevel? get gradeEnum => GradeLevel.fromString(grade);
}

// Classroom Student Response DTO
class ClassroomStudentResponseDto extends ClassroomResponseDto {
  final String classroomStudentStatus;
  final TeacherDto teacher;

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

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'classroomStudentStatus': classroomStudentStatus,
    'teacher': teacher.toJson(),
  };

  factory ClassroomStudentResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => ClassroomStudentResponseDto(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String,
    joinCode: json['joinCode'] as String,
    grade: json['grade'] as String,
    status: json['status'] as String,
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

  // Helper methods
  ClassroomStudentStatus get statusEnum =>
      ClassroomStudentStatus.fromString(classroomStudentStatus);
}

// Student Classroom Response List DTO
class StudentClassroomResponseListDto {
  final List<ClassroomStudentResponseDto> enrollingClassrooms;
  final List<ClassroomStudentResponseDto> ongoingClassrooms;
  final List<ClassroomStudentResponseDto> finishedClassrooms;

  const StudentClassroomResponseListDto({
    required this.enrollingClassrooms,
    required this.ongoingClassrooms,
    required this.finishedClassrooms,
  });

  Map<String, dynamic> toJson() => {
    'enrollingClassrooms': enrollingClassrooms.map((c) => c.toJson()).toList(),
    'ongoingClassrooms': ongoingClassrooms.map((c) => c.toJson()).toList(),
    'finishedClassrooms': finishedClassrooms.map((c) => c.toJson()).toList(),
  };

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
}
