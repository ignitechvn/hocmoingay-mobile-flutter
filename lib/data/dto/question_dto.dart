import '../../core/constants/question_constants.dart';

// Content Block DTOs
abstract class ContentBlockResponseDto {
  final String type;

  const ContentBlockResponseDto({required this.type});

  Map<String, dynamic> toJson();
}

class TextContentBlockResponseDto extends ContentBlockResponseDto {
  final String content;
  final List<EquationResponseDto>? equations;

  const TextContentBlockResponseDto({
    required super.type,
    required this.content,
    this.equations,
  });

  factory TextContentBlockResponseDto.fromJson(Map<String, dynamic> json) =>
      TextContentBlockResponseDto(
        type: json['type'] as String? ?? 'text',
        content: json['content'] as String? ?? '',
        equations:
            json['equations'] != null
                ? (json['equations'] as List<dynamic>)
                    .map(
                      (e) => EquationResponseDto.fromJson(
                        e as Map<String, dynamic>,
                      ),
                    )
                    .toList()
                : null,
      );

  Map<String, dynamic> toJson() => {
    'type': type,
    'content': content,
    'equations': equations?.map((e) => e.toJson()).toList(),
  };
}

class ImageContentBlockResponseDto extends ContentBlockResponseDto {
  final String url;
  final String? caption;

  const ImageContentBlockResponseDto({
    required super.type,
    required this.url,
    this.caption,
  });

  factory ImageContentBlockResponseDto.fromJson(Map<String, dynamic> json) =>
      ImageContentBlockResponseDto(
        type: json['type'] as String? ?? 'image',
        url: json['url'] as String? ?? '',
        caption: json['caption'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'type': type,
    'url': url,
    'caption': caption,
  };
}

// Equation DTO
class EquationResponseDto {
  final String placeholder;
  final String latex;

  const EquationResponseDto({required this.placeholder, required this.latex});

  factory EquationResponseDto.fromJson(Map<String, dynamic> json) =>
      EquationResponseDto(
        placeholder: json['placeholder'] as String? ?? '',
        latex: json['latex'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'placeholder': placeholder, 'latex': latex};
}

// Answer Metadata DTO
class AnswerMetadataDto {
  final String? correctAnswer;

  const AnswerMetadataDto({this.correctAnswer});

  factory AnswerMetadataDto.fromJson(Map<String, dynamic> json) =>
      AnswerMetadataDto(correctAnswer: json['correctAnswer'] as String?);

  Map<String, dynamic> toJson() => {'correctAnswer': correctAnswer};
}

// Answer DTO
class AnswerResponseDto {
  final String id;
  final String questionId;
  final dynamic content;
  final List<EquationResponseDto>? equations;
  final bool? isCorrect;
  final int? position;
  final AnswerMetadataDto? metadata;

  const AnswerResponseDto({
    required this.id,
    required this.questionId,
    required this.content,
    this.equations,
    this.isCorrect,
    this.position,
    this.metadata,
  });

  factory AnswerResponseDto.fromJson(Map<String, dynamic> json) =>
      AnswerResponseDto(
        id: json['id'] as String? ?? '',
        questionId: json['questionId'] as String? ?? '',
        content: json['content'],
        equations:
            json['equations'] != null
                ? (json['equations'] as List<dynamic>)
                    .map(
                      (e) => EquationResponseDto.fromJson(
                        e as Map<String, dynamic>,
                      ),
                    )
                    .toList()
                : null,
        isCorrect: json['isCorrect'] as bool?,
        position: json['position'] as int?,
        metadata:
            json['metadata'] != null
                ? AnswerMetadataDto.fromJson(
                  json['metadata'] as Map<String, dynamic>,
                )
                : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'questionId': questionId,
    'content': content,
    'equations': equations?.map((e) => e.toJson()).toList(),
    'isCorrect': isCorrect,
    'position': position,
    'metadata': metadata?.toJson(),
  };
}

// Base Question DTO
class BaseQuestionResponseDto {
  final String id;
  final int questionNumber;
  final EQuestionType questionType;
  final EDifficulty difficulty;
  final List<ContentBlockResponseDto> contentBlocks;
  final List<AnswerResponseDto> answers;
  final int point;
  final List<ContentBlockResponseDto> explanation;

  const BaseQuestionResponseDto({
    required this.id,
    required this.questionNumber,
    required this.questionType,
    required this.difficulty,
    required this.contentBlocks,
    required this.answers,
    required this.point,
    required this.explanation,
  });

  factory BaseQuestionResponseDto.fromJson(Map<String, dynamic> json) {
    return BaseQuestionResponseDto(
      id: json['id'] as String? ?? '',
      questionNumber: json['questionNumber'] as int? ?? 0,
      questionType: EQuestionType.fromString(
        json['questionType'] as String? ?? '',
      ),
      difficulty: EDifficulty.fromString(json['difficulty'] as String? ?? ''),
      contentBlocks: _parseContentBlocks(
        json['contentBlocks'] as List<dynamic>? ?? [],
      ),
      answers:
          (json['answers'] as List<dynamic>? ?? [])
              .map((e) => AnswerResponseDto.fromJson(e as Map<String, dynamic>))
              .toList(),
      point: json['point'] as int? ?? 1,
      explanation: _parseContentBlocks(
        json['explanation'] as List<dynamic>? ?? [],
      ),
    );
  }

  static List<ContentBlockResponseDto> _parseContentBlocks(
    List<dynamic> blocks,
  ) {
    return blocks.map((block) {
      final blockMap = block as Map<String, dynamic>;
      final type = blockMap['type'] as String? ?? '';

      switch (type) {
        case 'text':
          return TextContentBlockResponseDto.fromJson(blockMap);
        case 'image':
          return ImageContentBlockResponseDto.fromJson(blockMap);
        default:
          return TextContentBlockResponseDto.fromJson(blockMap);
      }
    }).toList();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'questionNumber': questionNumber,
    'questionType': questionType.value,
    'difficulty': difficulty.value,
    'contentBlocks': contentBlocks.map((e) => e.toJson()).toList(),
    'answers': answers.map((e) => e.toJson()).toList(),
    'point': point,
    'explanation': explanation.map((e) => e.toJson()).toList(),
  };
}

// Question Response DTO
class QuestionResponseDto extends BaseQuestionResponseDto {
  final String? bankQuestionId;
  final String? chapterId;
  final String? practiceSetId;
  final String? examId;

  const QuestionResponseDto({
    required super.id,
    required super.questionNumber,
    required super.questionType,
    required super.difficulty,
    required super.contentBlocks,
    required super.answers,
    required super.point,
    required super.explanation,
    this.bankQuestionId,
    this.chapterId,
    this.practiceSetId,
    this.examId,
  });

  factory QuestionResponseDto.fromJson(Map<String, dynamic> json) {
    final base = BaseQuestionResponseDto.fromJson(json);
    return QuestionResponseDto(
      id: base.id,
      questionNumber: base.questionNumber,
      questionType: base.questionType,
      difficulty: base.difficulty,
      contentBlocks: base.contentBlocks,
      answers: base.answers,
      point: base.point,
      explanation: base.explanation,
      bankQuestionId: json['bankQuestionId'] as String?,
      chapterId: json['chapterId'] as String?,
      practiceSetId: json['practiceSetId'] as String?,
      examId: json['examId'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'bankQuestionId': bankQuestionId,
    'chapterId': chapterId,
    'practiceSetId': practiceSetId,
    'examId': examId,
  };
}

// Question Student DTO
class QuestionStudentDto extends QuestionResponseDto {
  final bool isCorrect;
  final dynamic studentAnswer;

  const QuestionStudentDto({
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
    required this.isCorrect,
    required this.studentAnswer,
  });

  factory QuestionStudentDto.fromJson(Map<String, dynamic> json) {
    final base = QuestionResponseDto.fromJson(json);
    return QuestionStudentDto(
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
      isCorrect: json['isCorrect'] as bool? ?? false,
      studentAnswer: json['studentAnswer'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'isCorrect': isCorrect,
    'studentAnswer': studentAnswer,
  };
}
