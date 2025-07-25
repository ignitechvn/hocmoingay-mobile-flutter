import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../data/dto/chapter_dto.dart';
import '../../../../../data/dto/question_dto.dart';

class TeacherSentenceRewritingQuestion extends StatelessWidget {
  final QuestionTeacherDto question;

  const TeacherSentenceRewritingQuestion({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Content
        _buildQuestionContent(),
        const SizedBox(height: AppDimensions.paddingM),

        // Correct Answers
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.success.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Đáp án đúng:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Câu viết lại đúng sẽ được hiển thị ở đây',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          question.contentBlocks.map((block) {
            if (block is TextContentBlockResponseDto) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Text(
                  _replaceBlankWithDots(block.content),
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4, // Reduce line height for more compact spacing
                  ),
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

  String _replaceBlankWithDots(String content) {
    return content.replaceAll('[BLANK]', '......');
  }
}
