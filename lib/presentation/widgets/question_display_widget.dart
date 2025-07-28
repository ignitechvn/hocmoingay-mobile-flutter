import 'package:flutter/material.dart';

import '../../core/constants/question_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import 'question_components.dart';
import 'question_display_data.dart';

class QuestionDisplayWidget extends StatelessWidget {
  final QuestionDisplayData question;
  final int index;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const QuestionDisplayWidget({
    super.key,
    required this.question,
    required this.index,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              children: [
                Text(
                  'Câu ${question.questionNumber}',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingS),
                _buildQuestionTypeTag(question.questionType),
                const Spacer(),
                // Points
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.warning, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${question.point}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                  ],
                ),
                _buildDifficultyTag(question.difficulty),
                const SizedBox(width: AppDimensions.paddingS),
                // More button (if actions are provided)
                if (onEdit != null || onDelete != null)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onSelected: (value) => _handleAction(value),
                    itemBuilder:
                        (context) => [
                          if (onEdit != null)
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Chỉnh sửa',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (onDelete != null)
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: AppColors.error,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Xóa',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                  ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingM),

            // Question Content
            _buildQuestionContent(question),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContent(QuestionDisplayData question) {
    switch (question.questionType) {
      case EQuestionType.MULTIPLE_CHOICE:
        return MultipleChoiceQuestionWidget(question: question);
      case EQuestionType.FILL_IN_THE_BLANK:
        return FillInBlankQuestionWidget(question: question);
      case EQuestionType.CLOZE_TEST:
        return ClozeTestQuestionWidget(question: question);
      case EQuestionType.SENTENCE_REWRITING:
        return SentenceRewritingQuestionWidget(question: question);
      default:
        return Text(
          'Loại câu hỏi không được hỗ trợ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        );
    }
  }

  Widget _buildQuestionTypeTag(EQuestionType questionType) {
    String typeText;

    switch (questionType) {
      case EQuestionType.MULTIPLE_CHOICE:
        typeText = 'Trắc nghiệm';
        break;
      case EQuestionType.FILL_IN_THE_BLANK:
        typeText = 'Điền từ';
        break;
      case EQuestionType.CLOZE_TEST:
        typeText = 'Cloze test';
        break;
      case EQuestionType.SENTENCE_REWRITING:
        typeText = 'Viết lại câu';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        typeText,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDifficultyTag(EDifficulty difficulty) {
    String difficultyText;
    Color color;

    switch (difficulty) {
      case EDifficulty.VERY_EASY:
        difficultyText = 'Rất dễ';
        color = AppColors.success;
        break;
      case EDifficulty.EASY:
        difficultyText = 'Dễ';
        color = AppColors.success;
        break;
      case EDifficulty.MEDIUM:
        difficultyText = 'Trung bình';
        color = AppColors.warning;
        break;
      case EDifficulty.HARD:
        difficultyText = 'Khó';
        color = AppColors.error;
        break;
      case EDifficulty.VERY_HARD:
        difficultyText = 'Rất khó';
        color = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficultyText,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleAction(String action) {
    switch (action) {
      case 'edit':
        onEdit?.call();
        break;
      case 'delete':
        onDelete?.call();
        break;
    }
  }
}
