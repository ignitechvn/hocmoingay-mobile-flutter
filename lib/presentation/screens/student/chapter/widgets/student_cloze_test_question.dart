import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../data/dto/question_dto.dart';
import '../../../../../core/constants/question_constants.dart';

class StudentClozeTestQuestion extends StatelessWidget {
  final QuestionStudentDto question;
  final Map<String, String> studentAnswers;
  final Function(Map<String, String>) onAnswersChanged;

  const StudentClozeTestQuestion({
    super.key,
    required this.question,
    required this.studentAnswers,
    required this.onAnswersChanged,
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
            final selectedAnswerId = studentAnswers[position.toString()];

            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chỗ trống ${position + 1}:',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
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
                          final optionId = '${answer.id}_$optionIndex';
                          final isSelected = selectedAnswerId == optionId;

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimensions.paddingS,
                            ),
                            child: InkWell(
                              onTap: () {
                                final newAnswers = Map<String, String>.from(
                                  studentAnswers,
                                );
                                newAnswers[position.toString()] = optionId;
                                onAnswersChanged(newAnswers);
                              },
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusS,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(
                                  AppDimensions.paddingM,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? AppColors.primary
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
                                    const SizedBox(
                                      width: AppDimensions.paddingM,
                                    ),
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
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

  String _replaceBlankWithDots(String content) {
    return content.replaceAll('[BLANK]', '......');
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
}
