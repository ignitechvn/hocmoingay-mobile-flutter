import 'chapter_dto.dart';
import 'question_dto.dart';

// Chapter Details Student Response DTO
class ChapterDetailsStudentResponseDto extends ChapterStudentResponseDto {
  final List<QuestionStudentDto> questions;
  final ChapterSubmissionResponseDto? submission;

  const ChapterDetailsStudentResponseDto({
    required super.id,
    required super.title,
    super.description,
    super.deadline,
    super.startDate,
    required super.status,
    required super.classroomId,
    required super.answeredCount,
    required super.questionCount,
    required super.correctCount,
    required this.questions,
    this.submission,
  });

  factory ChapterDetailsStudentResponseDto.fromJson(Map<String, dynamic> json) {
    final base = ChapterStudentResponseDto.fromJson(json);
    return ChapterDetailsStudentResponseDto(
      id: base.id,
      title: base.title,
      description: base.description,
      deadline: base.deadline,
      startDate: base.startDate,
      status: base.status,
      classroomId: base.classroomId,
      answeredCount: base.answeredCount,
      questionCount: base.questionCount,
      correctCount: base.correctCount,
      questions:
          (json['questions'] as List<dynamic>? ?? [])
              .map(
                (e) => QuestionStudentDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      submission:
          json['submission'] != null
              ? ChapterSubmissionResponseDto.fromJson(
                json['submission'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'questions': questions.map((e) => e.toJson()).toList(),
    'submission': submission?.toJson(),
  };
}

// Chapter Submission Response DTO
class ChapterSubmissionResponseDto {
  final String id;
  final String chapterId;
  final String studentId;
  final DateTime submittedAt;
  final int totalScore;
  final int maxScore;
  final bool isCompleted;

  const ChapterSubmissionResponseDto({
    required this.id,
    required this.chapterId,
    required this.studentId,
    required this.submittedAt,
    required this.totalScore,
    required this.maxScore,
    required this.isCompleted,
  });

  factory ChapterSubmissionResponseDto.fromJson(Map<String, dynamic> json) =>
      ChapterSubmissionResponseDto(
        id: json['id'] as String? ?? '',
        chapterId: json['chapterId'] as String? ?? '',
        studentId: json['studentId'] as String? ?? '',
        submittedAt: DateTime.parse(
          json['submittedAt'] as String? ?? DateTime.now().toIso8601String(),
        ),
        totalScore: json['totalScore'] as int? ?? 0,
        maxScore: json['maxScore'] as int? ?? 0,
        isCompleted: json['isCompleted'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'chapterId': chapterId,
    'studentId': studentId,
    'submittedAt': submittedAt.toIso8601String(),
    'totalScore': totalScore,
    'maxScore': maxScore,
    'isCompleted': isCompleted,
  };
}
