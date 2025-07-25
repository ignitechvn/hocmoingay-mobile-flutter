import '../../domain/entities/classroom.dart';
import 'classroom_dto.dart';

// Schedule Item DTO for creating classroom
class ScheduleItemDto {
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  const ScheduleItemDto({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleItemDto.fromJson(Map<String, dynamic> json) =>
      ScheduleItemDto(
        dayOfWeek: json['dayOfWeek'] as int,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
      );

  Map<String, dynamic> toJson() => {
    'dayOfWeek': dayOfWeek,
    'startTime': startTime,
    'endTime': endTime,
  };
}

// Create Classroom DTO
class CreateClassroomDto {
  final String name;
  final String code;
  final String grade;
  final int? numberOfLessons;
  final String? startDate;
  final String? endDate;
  final List<ScheduleItemDto>? schedule;

  const CreateClassroomDto({
    required this.name,
    required this.code,
    required this.grade,
    this.numberOfLessons,
    this.startDate,
    this.endDate,
    this.schedule,
  });

  factory CreateClassroomDto.fromJson(
    Map<String, dynamic> json,
  ) => CreateClassroomDto(
    name: json['name'] as String,
    code: json['code'] as String,
    grade: json['grade'] as String,
    numberOfLessons: json['numberOfLessons'] as int?,
    startDate: json['startDate'] as String?,
    endDate: json['endDate'] as String?,
    schedule:
        json['schedule'] != null
            ? (json['schedule'] as List<dynamic>)
                .map((e) => ScheduleItemDto.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'grade': grade,
    if (numberOfLessons != null) 'numberOfLessons': numberOfLessons,
    if (startDate != null) 'startDate': startDate,
    if (endDate != null) 'endDate': endDate,
    if (schedule != null) 'schedule': schedule!.map((e) => e.toJson()).toList(),
  };
}

// Update Classroom DTO
class UpdateClassroomDto {
  final String? name;
  final String? startDate;
  final String? endDate;
  final List<ScheduleItemDto>? schedule;

  const UpdateClassroomDto({
    this.name,
    this.startDate,
    this.endDate,
    this.schedule,
  });

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (startDate != null) 'startDate': startDate,
    if (endDate != null) 'endDate': endDate,
    if (schedule != null) 'schedule': schedule!.map((e) => e.toJson()).toList(),
  };
}

// Classroom Details Teacher Response DTO
class ClassroomDetailsTeacherResponseDto {
  final String id;
  final String name;
  final String code;
  final String joinCode;
  final String grade;
  final String status;
  final int? lessonSessionCount;
  final int? lessonLearnedCount;
  final String? startDate;
  final String? endDate;
  final int? totalStudents;
  final List<ScheduleResponseDto>? schedule;
  final List<LessonSessionResponseDto>? lessonSessions;
  final TeacherDto? teacher;
  final int? studentsCount;
  final int? pendingStudentCount;
  final int? chaptersCount;
  final int? practiceSetsCount;
  final int? examsCount;

  const ClassroomDetailsTeacherResponseDto({
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
    required this.studentsCount,
    required this.pendingStudentCount,
    required this.chaptersCount,
    required this.practiceSetsCount,
    required this.examsCount,
  });

  factory ClassroomDetailsTeacherResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => ClassroomDetailsTeacherResponseDto(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String,
    joinCode: json['joinCode'] as String,
    grade: json['grade'] as String,
    status: json['status'] as String,
    lessonSessionCount: json['lessonSessionCount'] as int?,
    lessonLearnedCount: json['lessonLearnedCount'] as int?,
    startDate: json['startDate'] as String?,
    endDate: json['endDate'] as String?,
    totalStudents: json['totalStudents'] as int?,
    schedule:
        json['schedule'] != null
            ? (json['schedule'] as List<dynamic>)
                .map(
                  (e) =>
                      ScheduleResponseDto.fromJson(e as Map<String, dynamic>),
                )
                .toList()
            : null,
    lessonSessions:
        json['lessonSessions'] != null
            ? (json['lessonSessions'] as List<dynamic>)
                .map(
                  (e) => LessonSessionResponseDto.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
            : null,
    teacher:
        json['teacher'] != null
            ? TeacherDto.fromJson(json['teacher'] as Map<String, dynamic>)
            : null,
    studentsCount: json['studentsCount'] as int?,
    pendingStudentCount: json['pendingStudentCount'] as int?,
    chaptersCount: json['chaptersCount'] as int?,
    practiceSetsCount: json['practiceSetsCount'] as int?,
    examsCount: json['examsCount'] as int?,
  );

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
    if (schedule != null) 'schedule': schedule!.map((e) => e.toJson()).toList(),
    if (lessonSessions != null)
      'lessonSessions': lessonSessions!.map((e) => e.toJson()).toList(),
    if (teacher != null) 'teacher': teacher!.toJson(),
    'studentsCount': studentsCount,
    'pendingStudentCount': pendingStudentCount,
    'chaptersCount': chaptersCount,
    'practiceSetsCount': practiceSetsCount,
    'examsCount': examsCount,
  };
}

// Student Response DTO
class StudentResponseDto {
  final String id;
  final String fullName;
  final String? avatar;
  final String phone;
  final String? address;
  final String? grade;
  final DateTime jointDate;

  const StudentResponseDto({
    required this.id,
    required this.fullName,
    this.avatar,
    required this.phone,
    this.address,
    this.grade,
    required this.jointDate,
  });

  factory StudentResponseDto.fromJson(Map<String, dynamic> json) {
    return StudentResponseDto(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String,
      address: json['address'] as String? ?? '', // Handle null address
      grade: json['grade'] as String?,
      jointDate:
          json['jointDate'] != null
              ? DateTime.parse(json['jointDate'] as String)
              : DateTime.now(), // Fallback to current date if jointDate is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      if (avatar != null) 'avatar': avatar,
      'phone': phone,
      'address': address,
      if (grade != null) 'grade': grade,
      'jointDate': jointDate.toIso8601String(),
    };
  }
}

// Pending Student Response DTO
class PendingStudentResponseDto {
  final String id;
  final String fullName;
  final String? avatar;
  final String phone;
  final String? address;
  final String? grade;
  final DateTime requestDate;

  const PendingStudentResponseDto({
    required this.id,
    required this.fullName,
    this.avatar,
    required this.phone,
    this.address,
    this.grade,
    required this.requestDate,
  });

  factory PendingStudentResponseDto.fromJson(Map<String, dynamic> json) {
    return PendingStudentResponseDto(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String,
      address: json['address'] as String? ?? '', // Handle null address
      grade: json['grade'] as String?,
      requestDate:
          json['requestDate'] != null
              ? DateTime.parse(json['requestDate'] as String)
              : DateTime.now(), // Fallback to current date if requestDate is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      if (avatar != null) 'avatar': avatar,
      'phone': phone,
      'address': address,
      if (grade != null) 'grade': grade,
      'requestDate': requestDate.toIso8601String(),
    };
  }
}
