import 'classroom_dto.dart';

class JoinClassroomDto {
  final String joinCode;

  JoinClassroomDto({required this.joinCode});

  Map<String, dynamic> toJson() => {'joinCode': joinCode};
}

class LookupClassroomQueryDto {
  final String code;

  LookupClassroomQueryDto({required this.code});

  Map<String, dynamic> toJson() => {'code': code};
}

class ClassroomPreviewResponseDto {
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
  final List<Map<String, dynamic>> schedule;
  final List<Map<String, dynamic>> lessonSessions;
  final TeacherDto teacher;
  final bool isMember;
  final bool isWaitingTeacherConfirm;
  final bool isWaitingStudentConfirm;

  ClassroomPreviewResponseDto({
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
    required this.teacher,
    required this.isMember,
    required this.isWaitingTeacherConfirm,
    required this.isWaitingStudentConfirm,
  });

  factory ClassroomPreviewResponseDto.fromJson(Map<String, dynamic> json) {
    return ClassroomPreviewResponseDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      joinCode: json['joinCode'] ?? '',
      grade: json['grade'] ?? '',
      status: json['status'] ?? '',
      lessonSessionCount: json['lessonSessionCount'] ?? 0,
      lessonLearnedCount: json['lessonLearnedCount'] ?? 0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      totalStudents: json['totalStudents'] ?? 0,
      schedule: List<Map<String, dynamic>>.from(json['schedule'] ?? []),
      lessonSessions: List<Map<String, dynamic>>.from(
        json['lessonSessions'] ?? [],
      ),
      teacher: TeacherDto.fromJson(json['teacher'] ?? {}),
      isMember: json['isMember'] ?? false,
      isWaitingTeacherConfirm: json['isWaitingTeacherConfirm'] ?? false,
      isWaitingStudentConfirm: json['isWaitingStudentConfirm'] ?? false,
    );
  }
}
