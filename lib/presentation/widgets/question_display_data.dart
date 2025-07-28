import '../../core/constants/question_constants.dart';
import '../../data/dto/bank_question_dto.dart';
import '../../data/dto/question_dto.dart';
import '../../data/dto/chapter_dto.dart';

/// Interface chung cho dữ liệu hiển thị câu hỏi
/// Cho phép QuestionDisplayWidget nhận bất kỳ loại question nào
class QuestionDisplayData {
  final String id;
  final int questionNumber;
  final EQuestionType questionType;
  final EDifficulty difficulty;
  final List<dynamic> contentBlocks;
  final List<dynamic> answers;
  final int point;
  final List<dynamic> explanation;

  const QuestionDisplayData({
    required this.id,
    required this.questionNumber,
    required this.questionType,
    required this.difficulty,
    required this.contentBlocks,
    required this.answers,
    required this.point,
    required this.explanation,
  });

  /// Tạo từ BankQuestionResponseDto
  factory QuestionDisplayData.fromBankQuestion(
    BankQuestionResponseDto question,
  ) {
    return QuestionDisplayData(
      id: question.id,
      questionNumber: question.questionNumber,
      questionType: question.questionType,
      difficulty: question.difficulty,
      contentBlocks:
          question.contentBlocks.map((block) => block.toJson()).toList(),
      answers: question.answers.map((answer) => answer.toJson()).toList(),
      point: question.point,
      explanation:
          question.explanation?.map((block) => block.toJson()).toList() ?? [],
    );
  }

  /// Tạo từ QuestionResponseDto
  factory QuestionDisplayData.fromQuestionResponse(
    QuestionResponseDto question,
  ) {
    return QuestionDisplayData(
      id: question.id,
      questionNumber: question.questionNumber,
      questionType: question.questionType,
      difficulty: question.difficulty,
      contentBlocks:
          question.contentBlocks.map((block) => block.toJson()).toList(),
      answers: question.answers.map((answer) => answer.toJson()).toList(),
      point: question.point,
      explanation: question.explanation.map((block) => block.toJson()).toList(),
    );
  }

  /// Tạo từ QuestionTeacherDto
  factory QuestionDisplayData.fromQuestionTeacher(QuestionTeacherDto question) {
    return QuestionDisplayData(
      id: question.id,
      questionNumber: question.questionNumber,
      questionType: question.questionType,
      difficulty: question.difficulty,
      contentBlocks:
          question.contentBlocks.map((block) => block.toJson()).toList(),
      answers: question.answers.map((answer) => answer.toJson()).toList(),
      point: question.point,
      explanation: question.explanation.map((block) => block.toJson()).toList(),
    );
  }
}
