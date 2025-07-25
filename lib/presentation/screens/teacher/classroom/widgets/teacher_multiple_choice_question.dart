import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../data/dto/chapter_dto.dart';
import '../../../../../data/dto/question_dto.dart';

class TeacherMultipleChoiceQuestion extends StatelessWidget {
  final QuestionTeacherDto question;

  const TeacherMultipleChoiceQuestion({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final correctAnswers =
        question.answers.where((answer) => answer.isCorrect == true).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Content
        if (question.contentBlocks.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: _buildContentBlock(question.contentBlocks.first),
          ),

        const SizedBox(height: AppDimensions.paddingM),

        // Options
        if (question.answers.isNotEmpty) ...[
          Text(
            'Các lựa chọn:',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          ...question.answers.map((answer) => _buildOptionItem(answer)),
        ],

        // Explanation
        if (question.explanation.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.paddingM),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.info.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.info,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Giải thích:',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.info,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...question.explanation.map(
                  (explanation) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _buildContentBlock(explanation),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContentBlock(ContentBlockResponseDto contentBlock) {
    if (contentBlock is TextContentBlockResponseDto) {
      return Text(
        _replaceBlankWithDots(contentBlock.content),
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          height: 1.4, // Reduce line height for more compact spacing
        ),
      );
    } else if (contentBlock is ImageContentBlockResponseDto) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            contentBlock.url,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 200,
                color: AppColors.grey200,
                child: const Icon(Icons.broken_image, size: 50),
              );
            },
          ),
          if (contentBlock.caption != null) ...[
            const SizedBox(height: 8),
            Text(
              contentBlock.caption!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      );
    }
    return const SizedBox.shrink();
  }

  String _replaceBlankWithDots(String content) {
    return content.replaceAll('[BLANK]', '......');
  }

  Widget _buildOptionItem(AnswerResponseDto answer) {
    final isCorrect = answer.isCorrect == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isCorrect ? AppColors.success.withOpacity(0.1) : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              isCorrect
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.grey200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCorrect ? AppColors.success : AppColors.grey300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${answer.position ?? '?'}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isCorrect ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${answer.content}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (isCorrect)
            Icon(Icons.check_circle, color: AppColors.success, size: 16),
        ],
      ),
    );
  }
}
