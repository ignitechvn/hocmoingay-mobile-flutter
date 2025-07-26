import '../../core/constants/exam_constants.dart';

// Create Exam DTO
class CreateExamDto {
  final String title;
  final String? description;
  final int? totalScore;
  final String? startTime;
  final int duration;
  final String classroomId;
  final bool assignToAll;
  final List<String>? studentIds;

  const CreateExamDto({
    required this.title,
    this.description,
    this.totalScore,
    this.startTime,
    required this.duration,
    required this.classroomId,
    this.assignToAll = true,
    this.studentIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
      if (totalScore != null) 'totalScore': totalScore,
      if (startTime != null) 'startTime': startTime,
      'duration': duration,
      'classroomId': classroomId,
      'assignToAll': assignToAll,
      if (studentIds != null) 'studentIds': studentIds,
    };
  }
}

// Update Exam DTO
class UpdateExamDto {
  final String? title;
  final String? description;
  final int? totalScore;
  final String? startTime;
  final int? duration;
  final bool? assignToAll;
  final List<String>? studentIds;

  const UpdateExamDto({
    this.title,
    this.description,
    this.totalScore,
    this.startTime,
    this.duration,
    this.assignToAll,
    this.studentIds,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (totalScore != null) 'totalScore': totalScore,
      if (startTime != null) 'startTime': startTime,
      if (duration != null) 'duration': duration,
      if (assignToAll != null) 'assignToAll': assignToAll,
      if (studentIds != null) 'studentIds': studentIds,
    };
  }
}

// Base Exam Response DTO
class ExamResponseDto {
  final String id;
  final String title;
  final String? description;
  final String? startTime;
  final int duration;
  final EExamStatus status;
  final String classroomId;

  const ExamResponseDto({
    required this.id,
    required this.title,
    this.description,
    this.startTime,
    required this.duration,
    required this.status,
    required this.classroomId,
  });

  factory ExamResponseDto.fromJson(Map<String, dynamic> json) {
    return ExamResponseDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      startTime: json['startTime'] as String?,
      duration: json['duration'] as int? ?? 0,
      status: EExamStatus.fromString(json['status'] as String? ?? 'SCHEDULED'),
      classroomId: json['classroomId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime,
      'duration': duration,
      'status': status.value,
      'classroomId': classroomId,
    };
  }
}

// Teacher Exam Response DTO (extends ExamResponseDto)
class ExamTeacherResponseDto extends ExamResponseDto {
  final int questionCount;
  final bool assignToAll;
  final int? assignedStudentCount;

  const ExamTeacherResponseDto({
    required super.id,
    required super.title,
    super.description,
    super.startTime,
    required super.duration,
    required super.status,
    required super.classroomId,
    required this.questionCount,
    required this.assignToAll,
    this.assignedStudentCount,
  });

  factory ExamTeacherResponseDto.fromJson(Map<String, dynamic> json) {
    return ExamTeacherResponseDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      startTime: json['startTime'] as String?,
      duration: json['duration'] as int? ?? 0,
      status: EExamStatus.fromString(json['status'] as String? ?? 'SCHEDULED'),
      classroomId: json['classroomId'] as String? ?? '',
      questionCount: json['questionCount'] as int? ?? 0,
      assignToAll: json['assignToAll'] as bool? ?? false,
      assignedStudentCount: json['assignedStudentCount'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'questionCount': questionCount,
      'assignToAll': assignToAll,
      'assignedStudentCount': assignedStudentCount,
    };
  }
}

// Delete Exam DTO (for API response)
class DeleteExamResponseDto {
  final String message;

  const DeleteExamResponseDto({required this.message});

  factory DeleteExamResponseDto.fromJson(Map<String, dynamic> json) {
    return DeleteExamResponseDto(
      message: json['message'] as String? ?? 'Exam deleted successfully',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

// Update Exam Status DTO
class UpdateExamStatusDto {
  final EExamStatus status;

  const UpdateExamStatusDto({required this.status});

  Map<String, dynamic> toJson() => {'status': status.value};

  factory UpdateExamStatusDto.fromJson(Map<String, dynamic> json) =>
      UpdateExamStatusDto(
        status: EExamStatus.fromString(json['status'] as String),
      );
}

// Exam Details Teacher Response DTO
class ExamDetailsTeacherResponseDto extends ExamTeacherResponseDto {
  final int studentProgressCount;

  const ExamDetailsTeacherResponseDto({
    required super.id,
    required super.title,
    super.description,
    super.startTime,
    required super.duration,
    required super.status,
    required super.classroomId,
    required super.questionCount,
    required super.assignToAll,
    super.assignedStudentCount,
    required this.studentProgressCount,
  });

  factory ExamDetailsTeacherResponseDto.fromJson(Map<String, dynamic> json) {
    return ExamDetailsTeacherResponseDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: json['startTime'] as String?,
      duration: json['duration'] as int,
      status: EExamStatus.fromString(json['status'] as String),
      classroomId: json['classroomId'] as String,
      questionCount: json['questionCount'] as int,
      assignToAll: json['assignToAll'] as bool? ?? false,
      assignedStudentCount: json['assignedStudentCount'] as int?,
      studentProgressCount: json['studentProgressCount'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'studentProgressCount': studentProgressCount,
  };
}

// Teacher Exam Response List DTO
class TeacherExamResponseListDto {
  final List<ExamTeacherResponseDto> scheduledExams;
  final List<ExamTeacherResponseDto> openExams;
  final List<ExamTeacherResponseDto> closedExams;

  const TeacherExamResponseListDto({
    required this.scheduledExams,
    required this.openExams,
    required this.closedExams,
  });

  factory TeacherExamResponseListDto.fromJson(Map<String, dynamic> json) {
    return TeacherExamResponseListDto(
      scheduledExams:
          (json['scheduledExams'] as List<dynamic>?)
              ?.map(
                (item) => ExamTeacherResponseDto.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      openExams:
          (json['openExams'] as List<dynamic>?)
              ?.map(
                (item) => ExamTeacherResponseDto.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      closedExams:
          (json['closedExams'] as List<dynamic>?)
              ?.map(
                (item) => ExamTeacherResponseDto.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  // Factory method to handle the actual API response format
  factory TeacherExamResponseListDto.fromList(List<dynamic> jsonList) {
    final exams =
        jsonList
            .map(
              (item) =>
                  ExamTeacherResponseDto.fromJson(item as Map<String, dynamic>),
            )
            .toList();

    // Categorize exams by status
    final scheduledExams =
        exams.where((e) => e.status == EExamStatus.SCHEDULED).toList();
    final openExams = exams.where((e) => e.status == EExamStatus.OPEN).toList();
    final closedExams =
        exams.where((e) => e.status == EExamStatus.CLOSED).toList();

    return TeacherExamResponseListDto(
      scheduledExams: scheduledExams,
      openExams: openExams,
      closedExams: closedExams,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduledExams': scheduledExams.map((e) => e.toJson()).toList(),
      'openExams': openExams.map((e) => e.toJson()).toList(),
      'closedExams': closedExams.map((e) => e.toJson()).toList(),
    };
  }
}
