import 'package:flutter/material.dart';

import '../../core/constants/chapter_constants.dart';
import '../../core/constants/question_constants.dart';
import 'question_dto.dart';

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

// Chapter Teacher Response DTO
class ChapterTeacherResponseDto extends ChapterResponseDto {
  final int questionCount;

  const ChapterTeacherResponseDto({
    required super.id,
    required super.title,
    super.description,
    super.deadline,
    super.startDate,
    required super.status,
    required super.classroomId,
    required this.questionCount,
  });

  factory ChapterTeacherResponseDto.fromJson(Map<String, dynamic> json) =>
      ChapterTeacherResponseDto(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        deadline: json['deadline'] as String?,
        startDate: json['startDate'] as String?,
        status: EChapterStatus.fromString(
          json['status'] as String? ?? 'SCHEDULED',
        ),
        classroomId: json['classroomId'] as String? ?? '',
        questionCount: json['questionCount'] as int? ?? 0,
      );

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'questionCount': questionCount,
  };
}

// Teacher Chapter Response List DTO
class TeacherChapterResponseListDto {
  final List<ChapterTeacherResponseDto> scheduledChapters;
  final List<ChapterTeacherResponseDto> openChapters;
  final List<ChapterTeacherResponseDto> closedChapters;

  const TeacherChapterResponseListDto({
    required this.scheduledChapters,
    required this.openChapters,
    required this.closedChapters,
  });

  factory TeacherChapterResponseListDto.fromJson(
    Map<String, dynamic> json,
  ) => TeacherChapterResponseListDto(
    scheduledChapters:
        (json['scheduledChapters'] as List<dynamic>?)
            ?.map(
              (item) => ChapterTeacherResponseDto.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [],
    openChapters:
        (json['openChapters'] as List<dynamic>?)
            ?.map(
              (item) => ChapterTeacherResponseDto.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [],
    closedChapters:
        (json['closedChapters'] as List<dynamic>?)
            ?.map(
              (item) => ChapterTeacherResponseDto.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [],
  );

  // Factory method to handle the actual API response format
  factory TeacherChapterResponseListDto.fromList(List<dynamic> jsonList) {
    final chapters =
        jsonList
            .map(
              (item) => ChapterTeacherResponseDto.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();

    // Categorize chapters by status
    final scheduledChapters =
        chapters.where((c) => c.status == EChapterStatus.SCHEDULED).toList();
    final openChapters =
        chapters.where((c) => c.status == EChapterStatus.OPEN).toList();
    final closedChapters =
        chapters.where((c) => c.status == EChapterStatus.CLOSED).toList();

    return TeacherChapterResponseListDto(
      scheduledChapters: scheduledChapters,
      openChapters: openChapters,
      closedChapters: closedChapters,
    );
  }

  Map<String, dynamic> toJson() => {
    'scheduledChapters': scheduledChapters.map((e) => e.toJson()).toList(),
    'openChapters': openChapters.map((e) => e.toJson()).toList(),
    'closedChapters': closedChapters.map((e) => e.toJson()).toList(),
  };
}

// Chapter Theory Page List Item DTO
class ChapterTheoryPageListItemDto {
  final String id;
  final String title;
  final String? parentId;
  final List<ChapterTheoryPageListItemDto>? children;

  const ChapterTheoryPageListItemDto({
    required this.id,
    required this.title,
    this.parentId,
    this.children,
  });

  factory ChapterTheoryPageListItemDto.fromJson(Map<String, dynamic> json) =>
      ChapterTheoryPageListItemDto(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        parentId: json['parentId'] as String?,
        children:
            (json['children'] as List<dynamic>?)
                ?.map(
                  (item) => ChapterTheoryPageListItemDto.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList() ??
            null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'parentId': parentId,
    'children': children?.map((e) => e.toJson()).toList(),
  };
}

// Chapter Details Teacher Response DTO
class ChapterDetailsTeacherResponseDto extends ChapterTeacherResponseDto {
  final int studentProgressCount;
  final List<ChapterTheoryPageListItemDto> theoryPages;

  const ChapterDetailsTeacherResponseDto({
    required super.id,
    required super.title,
    super.description,
    super.deadline,
    super.startDate,
    required super.status,
    required super.classroomId,
    required super.questionCount,
    required this.studentProgressCount,
    required this.theoryPages,
  });

  factory ChapterDetailsTeacherResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => ChapterDetailsTeacherResponseDto(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    description: json['description'] as String?,
    deadline: json['deadline'] as String?,
    startDate: json['startDate'] as String?,
    status: EChapterStatus.fromString(json['status'] as String? ?? 'SCHEDULED'),
    classroomId: json['classroomId'] as String? ?? '',
    questionCount: json['questionCount'] as int? ?? 0,
    studentProgressCount: json['studentProgressCount'] as int? ?? 0,
    theoryPages:
        (json['theoryPages'] as List<dynamic>?)
            ?.map(
              (item) => ChapterTheoryPageListItemDto.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [],
  );

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'studentProgressCount': studentProgressCount,
    'theoryPages': theoryPages.map((e) => e.toJson()).toList(),
  };
}

// Create Chapter DTO
class CreateChapterDto {
  final String title;
  final String? description;
  final String classroomId;
  final String? deadline;
  final String? startDate;

  const CreateChapterDto({
    required this.title,
    this.description,
    required this.classroomId,
    this.deadline,
    this.startDate,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'classroomId': classroomId,
    'deadline': deadline,
    'startDate': startDate,
  };
}

// Update Chapter DTO
class UpdateChapterDto {
  final String? title;
  final String? description;
  final String? deadline;
  final String? startDate;

  const UpdateChapterDto({
    this.title,
    this.description,
    this.deadline,
    this.startDate,
  });

  Map<String, dynamic> toJson() => {
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (deadline != null) 'deadline': deadline,
    if (startDate != null) 'startDate': startDate,
  };
}

// Teacher Chapter Questions Response DTO
class TeacherChapterQuestionsResponseDto {
  final String id;
  final EChapterStatus status;
  final List<QuestionTeacherDto> questions;

  const TeacherChapterQuestionsResponseDto({
    required this.id,
    required this.status,
    required this.questions,
  });

  factory TeacherChapterQuestionsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => TeacherChapterQuestionsResponseDto(
    id: json['id'] as String? ?? '',
    status: EChapterStatus.fromString(json['status'] as String? ?? 'SCHEDULED'),
    questions:
        (json['questions'] as List<dynamic>?)
            ?.map(
              (item) =>
                  QuestionTeacherDto.fromJson(item as Map<String, dynamic>),
            )
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status.value,
    'questions': questions.map((e) => e.toJson()).toList(),
  };
}

// Question Teacher DTO (extends QuestionResponseDto)
class QuestionTeacherDto extends QuestionResponseDto {
  const QuestionTeacherDto({
    required super.id,
    required super.questionNumber,
    required super.questionType,
    required super.difficulty,
    required super.contentBlocks,
    required super.answers,
    required super.point,
    required super.explanation,
    super.bankQuestionId,
    super.chapterId,
    super.practiceSetId,
    super.examId,
  });

  factory QuestionTeacherDto.fromJson(Map<String, dynamic> json) {
    final base = QuestionResponseDto.fromJson(json);
    return QuestionTeacherDto(
      id: base.id,
      questionNumber: base.questionNumber,
      questionType: base.questionType,
      difficulty: base.difficulty,
      contentBlocks: base.contentBlocks,
      answers: base.answers,
      point: base.point,
      explanation: base.explanation,
      bankQuestionId: base.bankQuestionId,
      chapterId: base.chapterId,
      practiceSetId: base.practiceSetId,
      examId: base.examId,
    );
  }
}

// Update Chapter Status DTO
class UpdateChapterStatusDto {
  final EChapterStatus status;

  const UpdateChapterStatusDto({required this.status});

  Map<String, dynamic> toJson() => {'status': status.value};

  factory UpdateChapterStatusDto.fromJson(Map<String, dynamic> json) =>
      UpdateChapterStatusDto(
        status: EChapterStatus.fromString(json['status'] as String),
      );
}
