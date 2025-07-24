import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../data/dto/question_dto.dart';
import '../../../../../core/constants/question_constants.dart';

class FillInBlankQuestion extends StatelessWidget {
  final QuestionStudentDto question;
  final String studentAnswer;
  final Function(String) onAnswerChanged;

  const FillInBlankQuestion({
    super.key,
    required this.question,
    required this.studentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionContent(),
        const SizedBox(height: AppDimensions.paddingM),
        _buildAnswerInput(),
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

  Widget _buildAnswerInput() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
      ),
      child: TextField(
        controller: TextEditingController(text: studentAnswer),
        onChanged: onAnswerChanged,
        decoration: const InputDecoration(
          hintText: 'Nhập đáp án của bạn...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(AppDimensions.paddingM),
        ),
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        maxLines: 3,
        minLines: 1,
      ),
    );
  }

  String _replaceBlankWithDots(String content) {
    return content.replaceAll('[BLANK]', '......');
  }
}
