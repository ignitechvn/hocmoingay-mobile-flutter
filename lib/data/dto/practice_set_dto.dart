import '../../core/constants/practice_set_constants.dart';

// Base Practice Set DTO
class PracticeSetResponseDto {
  final String id;
  final String title;
  final String? description;
  final String? deadline;
  final String? startDate;
  final EPracticeSetStatus status;
  final String classroomId;

  const PracticeSetResponseDto({
    required this.id,
    required this.title,
    this.description,
    this.deadline,
    this.startDate,
    required this.status,
    required this.classroomId,
  });

  factory PracticeSetResponseDto.fromJson(Map<String, dynamic> json) {
    return PracticeSetResponseDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      deadline: json['deadline'] as String?,
      startDate: json['startDate'] as String?,
      status: EPracticeSetStatus.fromString(json['status'] as String),
      classroomId: json['classroomId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'deadline': deadline,
    'startDate': startDate,
    'status': status.value,
    'classroomId': classroomId,
  };
}

// Teacher Practice Set DTO
class PracticeSetTeacherResponseDto extends PracticeSetResponseDto {
  final int questionCount;
  final bool assignToAll;
  final int? assignedStudentCount;

  const PracticeSetTeacherResponseDto({
    required super.id,
    required super.title,
    super.description,
    super.deadline,
    super.startDate,
    required super.status,
    required super.classroomId,
    required this.questionCount,
    required this.assignToAll,
    this.assignedStudentCount,
  });

  factory PracticeSetTeacherResponseDto.fromJson(Map<String, dynamic> json) {
    return PracticeSetTeacherResponseDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      deadline: json['deadline'] as String?,
      startDate: json['startDate'] as String?,
      status: EPracticeSetStatus.fromString(json['status'] as String),
      classroomId: json['classroomId'] as String,
      questionCount: json['questionCount'] as int,
      assignToAll: json['assignToAll'] as bool,
      assignedStudentCount: json['assignedStudentCount'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'questionCount': questionCount,
    'assignToAll': assignToAll,
    'assignedStudentCount': assignedStudentCount,
  };
}

// Teacher Practice Set Response List DTO
class TeacherPracticeSetResponseListDto {
  final List<PracticeSetTeacherResponseDto> scheduledPracticeSets;
  final List<PracticeSetTeacherResponseDto> openPracticeSets;
  final List<PracticeSetTeacherResponseDto> closedPracticeSets;

  const TeacherPracticeSetResponseListDto({
    required this.scheduledPracticeSets,
    required this.openPracticeSets,
    required this.closedPracticeSets,
  });

  factory TeacherPracticeSetResponseListDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherPracticeSetResponseListDto(
      scheduledPracticeSets:
          (json['scheduledPracticeSets'] as List<dynamic>)
              .map(
                (e) => PracticeSetTeacherResponseDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      openPracticeSets:
          (json['openPracticeSets'] as List<dynamic>)
              .map(
                (e) => PracticeSetTeacherResponseDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      closedPracticeSets:
          (json['closedPracticeSets'] as List<dynamic>)
              .map(
                (e) => PracticeSetTeacherResponseDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  // Factory method to handle the actual API response format
  factory TeacherPracticeSetResponseListDto.fromList(List<dynamic> jsonList) {
    final practiceSets =
        jsonList
            .map(
              (item) => PracticeSetTeacherResponseDto.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();

    // Categorize practice sets by status
    final scheduledPracticeSets =
        practiceSets
            .where((p) => p.status == EPracticeSetStatus.SCHEDULED)
            .toList();
    final openPracticeSets =
        practiceSets.where((p) => p.status == EPracticeSetStatus.OPEN).toList();
    final closedPracticeSets =
        practiceSets
            .where((p) => p.status == EPracticeSetStatus.CLOSED)
            .toList();

    return TeacherPracticeSetResponseListDto(
      scheduledPracticeSets: scheduledPracticeSets,
      openPracticeSets: openPracticeSets,
      closedPracticeSets: closedPracticeSets,
    );
  }

  Map<String, dynamic> toJson() => {
    'scheduledPracticeSets':
        scheduledPracticeSets.map((e) => e.toJson()).toList(),
    'openPracticeSets': openPracticeSets.map((e) => e.toJson()).toList(),
    'closedPracticeSets': closedPracticeSets.map((e) => e.toJson()).toList(),
  };
}

// Create Practice Set DTO
class CreatePracticeSetDto {
  final String title;
  final String? description;
  final String? startDate;
  final String? deadline;
  final String classroomId;
  final bool assignToAll;
  final List<String>? studentIds;

  const CreatePracticeSetDto({
    required this.title,
    this.description,
    this.startDate,
    this.deadline,
    required this.classroomId,
    this.assignToAll = false,
    this.studentIds,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'startDate': startDate,
    'deadline': deadline,
    'classroomId': classroomId,
    'assignToAll': assignToAll,
    'studentIds': studentIds,
  };
}

// Update Practice Set DTO
class UpdatePracticeSetDto {
  final String? title;
  final String? description;
  final String? startDate;
  final String? deadline;
  final bool? assignToAll;
  final List<String>? studentIds;

  const UpdatePracticeSetDto({
    this.title,
    this.description,
    this.startDate,
    this.deadline,
    this.assignToAll,
    this.studentIds,
  });

  Map<String, dynamic> toJson() => {
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (startDate != null) 'startDate': startDate,
    if (deadline != null) 'deadline': deadline,
    if (assignToAll != null) 'assignToAll': assignToAll,
    if (studentIds != null) 'studentIds': studentIds,
  };
}
