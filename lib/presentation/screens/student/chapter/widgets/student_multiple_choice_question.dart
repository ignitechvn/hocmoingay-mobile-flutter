import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../data/dto/question_dto.dart';
import '../../../../../core/constants/question_constants.dart';

class StudentMultipleChoiceQuestion extends StatelessWidget {
  final QuestionStudentDto question;
  final String? selectedAnswerId;
  final Function(String) onAnswerSelected;

  const StudentMultipleChoiceQuestion({
    super.key,
    required this.question,
    required this.selectedAnswerId,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionContent(),
        const SizedBox(height: AppDimensions.paddingM),
        _buildAnswerOptions(),
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

  Widget _buildAnswerOptions() {
    return Column(
      children:
          question.answers.map((answer) {
            final isSelected = selectedAnswerId == answer.id;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
              child: InkWell(
                onTap: () => onAnswerSelected(answer.id),
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusS,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.grey300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusS,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.grey300,
                            width: 2,
                          ),
                          color:
                              isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                        ),
                        child:
                            isSelected
                                ? const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      Expanded(
                        child: Text(
                          _getAnswerContent(answer),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  String _getAnswerContent(AnswerResponseDto answer) {
    if (answer.content is String) {
      return answer.content as String;
    } else if (answer.content is Map<String, dynamic>) {
      // Handle complex answer content
      return answer.content.toString();
    }
    return answer.content.toString();
  }

  String _replaceBlankWithDots(String content) {
    return content.replaceAll('[BLANK]', '......');
  }
}
