import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../data/dto/question_dto.dart';
import '../../../../../core/constants/question_constants.dart';

class QuestionResultView extends StatelessWidget {
  final QuestionStudentDto question;
  final dynamic studentAnswer;

  const QuestionResultView({
    super.key,
    required this.question,
    required this.studentAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionContent(),
        const SizedBox(height: AppDimensions.paddingM),
        _buildStudentAnswer(),
        const SizedBox(height: AppDimensions.paddingS),
        _buildCorrectAnswer(),
        const SizedBox(height: AppDimensions.paddingM),
        _buildExplanation(),
      ],
    );
  }

  Widget _buildQuestionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          question.contentBlocks.map((block) {
            if (block is TextContentBlockResponseDto) {
              return Text(
                _replaceBlankWithDots(block.content),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              );
            } else if (block is ImageContentBlockResponseDto) {
              return Padding(
                padding: const EdgeInsets.only(top: AppDimensions.paddingS),
                child: Image.network(
                  block.url,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.grey200,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusS,
                        ),
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                        size: 48,
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          }).toList(),
    );
  }

  Widget _buildStudentAnswer() {
    final hasStudentAnswer =
        studentAnswer != null &&
        (studentAnswer is String ? studentAnswer.isNotEmpty : true);

    if (!hasStudentAnswer) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          border: Border.all(color: AppColors.error),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
        ),
        child: Row(
          children: [
            const Icon(Icons.close, color: AppColors.error, size: 16),
            const SizedBox(width: AppDimensions.paddingS),
            Text(
              'Chưa trả lời',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color:
            question.isCorrect ? AppColors.successLight : AppColors.errorLight,
        border: Border.all(
          color: question.isCorrect ? AppColors.success : AppColors.error,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                question.isCorrect ? Icons.check_circle : Icons.cancel,
                color: question.isCorrect ? AppColors.success : AppColors.error,
                size: 16,
              ),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                question.isCorrect ? 'Đúng' : 'Sai',
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      question.isCorrect ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            'Đáp án của bạn: ${_formatStudentAnswer()}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectAnswer() {
    if (question.isCorrect) {
      return const SizedBox.shrink();
    }

    final correctAnswer = question.answers.firstWhere(
      (answer) => answer.isCorrect == true,
      orElse: () => question.answers.first,
    );

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        border: Border.all(color: AppColors.success),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 16,
              ),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'Đáp án đúng',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            _getAnswerContent(correctAnswer),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanation() {
    if (question.explanation.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        border: Border.all(color: AppColors.info),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: AppColors.info, size: 16),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'Lời giải',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),
          ...question.explanation.map((block) {
            if (block is TextContentBlockResponseDto) {
              return Text(
                block.content,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              );
            } else if (block is ImageContentBlockResponseDto) {
              return Padding(
                padding: const EdgeInsets.only(top: AppDimensions.paddingS),
                child: Image.network(
                  block.url,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.grey200,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusS,
                        ),
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                        size: 32,
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          }).toList(),
        ],
      ),
    );
  }

  String _formatStudentAnswer() {
    if (studentAnswer is String) {
      return studentAnswer as String;
    } else if (studentAnswer is Map<String, String>) {
      // For cloze test questions
      return studentAnswer.values.join(', ');
    }
    return studentAnswer.toString();
  }

  String _getAnswerContent(AnswerResponseDto answer) {
    if (answer.content is String) {
      return answer.content as String;
    } else if (answer.content is Map<String, dynamic>) {
      return answer.content.toString();
    }
    return answer.content.toString();
  }

  String _replaceBlankWithDots(String content) {
    return content.replaceAll('[BLANK]', '......');
  }
}
