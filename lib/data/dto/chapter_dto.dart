import '../../core/constants/chapter_constants.dart';

// Chapter Response DTO
class ChapterResponseDto {
  final String id;
  final String title;
  final String? description;
  final String? deadline;
  final String? startDate;
  final EChapterStatus status;
  final String classroomId;

  const ChapterResponseDto({
    required this.id,
    required this.title,
    this.description,
    this.deadline,
    this.startDate,
    required this.status,
    required this.classroomId,
  });

  factory ChapterResponseDto.fromJson(Map<String, dynamic> json) =>
      ChapterResponseDto(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        deadline: json['deadline'] as String?,
        startDate: json['startDate'] as String?,
        status: EChapterStatus.fromString(
          json['status'] as String? ?? 'SCHEDULED',
        ),
        classroomId: json['classroomId'] as String? ?? '',
      );

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

// Chapter Student Response DTO
class ChapterStudentResponseDto extends ChapterResponseDto {
  final int answeredCount;
  final int questionCount;
  final int correctCount;

  const ChapterStudentResponseDto({
    required super.id,
    required super.title,
    super.description,
    super.deadline,
    super.startDate,
    required super.status,
    required super.classroomId,
    required this.answeredCount,
    required this.questionCount,
    required this.correctCount,
  });

  factory ChapterStudentResponseDto.fromJson(Map<String, dynamic> json) =>
      ChapterStudentResponseDto(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        deadline: json['deadline'] as String?,
        startDate: json['startDate'] as String?,
        status: EChapterStatus.fromString(
          json['status'] as String? ?? 'SCHEDULED',
        ),
        classroomId: json['classroomId'] as String? ?? '',
        answeredCount: json['answeredCount'] as int? ?? 0,
        questionCount: json['questionCount'] as int? ?? 0,
        correctCount: json['correctCount'] as int? ?? 0,
      );

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'answeredCount': answeredCount,
    'questionCount': questionCount,
    'correctCount': correctCount,
  };
}
