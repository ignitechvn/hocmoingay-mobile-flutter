import '../../core/constants/classroom_status_constants.dart';
import '../../core/constants/grade_constants.dart';
import '../../core/constants/subject_constants.dart';
import 'classroom_dto.dart';

class ClassroomDetailsStudentResponseDto extends ClassroomResponseDto {

  ClassroomDetailsStudentResponseDto({
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
    required this.teacher,
    required this.chaptersCount,
    required this.practiceSetsCount,
    required this.examsCount,
  });

  factory ClassroomDetailsStudentResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => ClassroomDetailsStudentResponseDto(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    code: ESubjectCode.fromString(json['code'] as String? ?? 'MATH'),
    joinCode: json['joinCode'] as String? ?? '',
    grade: EGradeLevel.fromString(json['grade'] as String? ?? 'GRADE_1'),
    status: EClassroomStatus.fromString(
      json['status'] as String? ?? 'ENROLLING',
    ),
    lessonSessionCount: json['lessonSessionCount'] as int? ?? 0,
    lessonLearnedCount: json['lessonLearnedCount'] as int? ?? 0,
    startDate: json['startDate'] as String? ?? '',
    endDate: json['endDate'] as String? ?? '',
    totalStudents: json['totalStudents'] as int? ?? 0,
    schedule:
        (json['schedule'] as List<dynamic>? ?? [])
            .map((e) => ScheduleResponseDto.fromJson(e as Map<String, dynamic>))
            .toList(),
    lessonSessions:
        (json['lessonSessions'] as List<dynamic>? ?? [])
            .map(
              (e) =>
                  LessonSessionResponseDto.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
    teacher:
        json['teacher'] != null
            ? TeacherDto.fromJson(json['teacher'] as Map<String, dynamic>)
            : const TeacherDto(id: '', fullName: 'N/A', phone: 'N/A'),
    chaptersCount: json['chaptersCount'] as int? ?? 0,
    practiceSetsCount: json['practiceSetsCount'] as int? ?? 0,
    examsCount: json['examsCount'] as int? ?? 0,
  );
  final TeacherDto teacher;
  final int chaptersCount;
  final int practiceSetsCount;
  final int examsCount;

  @override
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
      'schedule': schedule.map((e) => e.toJson()).toList(),
      'lessonSessions': lessonSessions.map((e) => e.toJson()).toList(),
      'teacher': teacher.toJson(),
      'chaptersCount': chaptersCount,
      'practiceSetsCount': practiceSetsCount,
      'examsCount': examsCount,
    };
}
