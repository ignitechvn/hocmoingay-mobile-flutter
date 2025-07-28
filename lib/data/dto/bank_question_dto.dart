import 'base_question_dto.dart';
import '../../core/constants/question_constants.dart';

class BankQuestionResponseDto extends BaseQuestionResponseDto {
  final String? topicId;

  BankQuestionResponseDto({
    required super.id,
    required super.questionNumber,
    required super.questionType,
    required super.difficulty,
    required super.contentBlocks,
    required super.answers,
    super.explanation,
    required super.point,
    required super.createdAt,
    required super.updatedAt,
    this.topicId,
  });

  factory BankQuestionResponseDto.fromJson(Map<String, dynamic> json) {
    // Parse contentBlocks with error handling
    List<ContentBlock> contentBlocksList;
    try {
      contentBlocksList =
          (json['contentBlocks'] as List)
              .map(
                (block) => ContentBlock.fromJson(block as Map<String, dynamic>),
              )
              .toList();
    } catch (e) {
      print('Error parsing contentBlocks: $e');
      contentBlocksList = [];
    }

    // Parse answers with error handling
    List<Answer> answersList;
    try {
      answersList =
          (json['answers'] as List)
              .map((answer) => Answer.fromJson(answer as Map<String, dynamic>))
              .toList();
    } catch (e) {
      print('Error parsing answers: $e');
      answersList = [];
    }

    // Parse explanation with error handling
    List<ContentBlock>? explanationBlocks;
    if (json['explanation'] != null) {
      try {
        if (json['explanation'] is List) {
          explanationBlocks =
              (json['explanation'] as List)
                  .map(
                    (block) =>
                        ContentBlock.fromJson(block as Map<String, dynamic>),
                  )
                  .toList();
        } else {
          print('Explanation is not a list, skipping');
          explanationBlocks = null;
        }
      } catch (e) {
        print('Error parsing explanation: $e');
        explanationBlocks = null;
      }
    }

    // Parse topicId with error handling
    String? topicIdText;
    if (json['topicId'] != null) {
      try {
        topicIdText = json['topicId'] as String;
      } catch (e) {
        print('Error parsing topicId: $e');
        topicIdText = null;
      }
    }

    return BankQuestionResponseDto(
      id: json['id']?.toString() ?? '',
      questionNumber: json['questionNumber'] as int? ?? 0,
      questionType: EQuestionType.fromString(
        json['questionType']?.toString() ?? '',
      ),
      difficulty: EDifficulty.fromString(json['difficulty']?.toString() ?? ''),
      contentBlocks: contentBlocksList,
      answers: answersList,
      explanation: explanationBlocks,
      point: json['point'] as int? ?? 0,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      topicId: topicIdText,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson['topicId'] = topicId;
    return baseJson;
  }
}
