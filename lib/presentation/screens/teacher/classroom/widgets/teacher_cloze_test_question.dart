import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../data/dto/chapter_dto.dart';
import '../../../../../data/dto/question_dto.dart';

class TeacherClozeTestQuestion extends StatelessWidget {
  final QuestionTeacherDto question;

  const TeacherClozeTestQuestion({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Content
        _buildQuestionContent(),
        const SizedBox(height: AppDimensions.paddingM),

        // Answer Options for each blank
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

  Widget _buildAnswerOptions() {
    // Group answers by position for each blank
    final answersByPosition = <int, List<AnswerResponseDto>>{};

    for (final answer in question.answers) {
      final position = answer.position ?? 0;
      answersByPosition.putIfAbsent(position, () => []).add(answer);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          answersByPosition.entries.map((entry) {
            final position = entry.key;
            final answers = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chỗ trống ${position + 1}:',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  ...answers
                      .expand(
                        (answer) => _getAnswerOptions(
                          answer,
                        ).asMap().entries.map((entry) {
                          final optionIndex = entry.key;
                          final option = entry.value;
                          final isCorrect = _isCorrectAnswer(
                            answer,
                            optionIndex,
                          );

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimensions.paddingS,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(
                                AppDimensions.paddingM,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isCorrect
                                        ? AppColors.success.withOpacity(0.1)
                                        : Colors.white,
                                border: Border.all(
                                  color:
                                      isCorrect
                                          ? AppColors.success.withOpacity(0.3)
                                          : AppColors.grey300,
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
                                      color:
                                          isCorrect
                                              ? AppColors.success
                                              : AppColors.grey300,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(
                                          65 + optionIndex,
                                        ), // A, B, C, D...
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color:
                                              isCorrect
                                                  ? Colors.white
                                                  : AppColors.textSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppDimensions.paddingM),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (isCorrect)
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.success,
                                      size: 16,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      )
                      .toList(),
                ],
              ),
            );
          }).toList(),
    );
  }

  String _getAnswerContent(AnswerResponseDto answer) {
    if (answer.content is String) {
      final content = answer.content as String;
      // Bóc tách các đáp án được phân tách bằng dấu |
      final options = content.split('|');
      if (options.length > 1) {
        // Nếu có nhiều đáp án, hiển thị dạng "A) requires, B) requiring, C) require, D) to require"
        return options
            .asMap()
            .entries
            .map((entry) {
              final index = entry.key;
              final option = entry.value.trim();
              final letter = String.fromCharCode(65 + index); // A, B, C, D...
              return '$letter) $option';
            })
            .join(', ');
      }
      return content;
    } else if (answer.content is Map<String, dynamic>) {
      return answer.content.toString();
    }
    return answer.content.toString();
  }

  List<String> _getAnswerOptions(AnswerResponseDto answer) {
    if (answer.content is String) {
      final content = answer.content as String;
      // Bóc tách các đáp án được phân tách bằng dấu |
      final options = content.split('|');
      if (options.length > 1) {
        // Trả về danh sách các options riêng biệt
        return options.map((option) => option.trim()).toList();
      }
      return [content];
    }
    return [answer.content.toString()];
  }

  bool _isCorrectAnswer(AnswerResponseDto answer, int optionIndex) {
    // Logic để xác định đáp án đúng
    // Có thể dựa vào answer.isCorrect hoặc answer.metadata
    return answer.isCorrect == true;
  }

  String _replaceBlankWithDots(String content) {
    return content.replaceAll('[BLANK]', '......');
  }
}
