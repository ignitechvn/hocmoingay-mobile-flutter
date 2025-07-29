import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import 'question_display_data.dart';
import 'math_renderer.dart';

/// Helper function để xử lý nội dung câu hỏi
String _processQuestionContent(String content, List<dynamic>? equations) {
  // Replace [BLANK] with "......"
  content = content.replaceAll('[BLANK]', '......');

  return content;
}

/// Helper function để xử lý hiển thị image
Widget _buildImageWidget(Map<String, dynamic> block) {
  // Sử dụng content field cho URL nếu không có url field
  final imageUrl = block['url'] as String? ?? block['content'] as String? ?? '';
  if (imageUrl.isNotEmpty) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.grey,
                    size: 48,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  return const SizedBox.shrink();
}

Widget _buildExplanationWidget(List<dynamic> explanation) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Giải thích:',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: AppDimensions.paddingS),
      ...explanation.map((block) {
        if (block is Map<String, dynamic> && block['type'] == 'text') {
          String content = block['content'] as String? ?? '';
          final equations = block['equations'] as List<dynamic>?;
          return RichMathContent(
            content: content,
            equations: equations?.cast<Map<String, dynamic>>(),
            fontSize: AppTextStyles.bodyMedium.fontSize,
            color: AppColors.textPrimary,
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    ],
  );
}

class MultipleChoiceQuestionWidget extends StatelessWidget {
  final QuestionDisplayData question;

  const MultipleChoiceQuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question content
        _buildQuestionContent(),
        const SizedBox(height: AppDimensions.paddingM),

        // Options
        ...question.answers.asMap().entries.map((entry) {
          final index = entry.key;
          final answer = entry.value as Map<String, dynamic>;

          final isCorrect = answer['isCorrect'] as bool? ?? false;
          final content = answer['content'] as String? ?? '';

          return Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.paddingS),
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: isCorrect
                  ? AppColors.success.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCorrect
                    ? AppColors.success
                    : Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCorrect ? AppColors.success : Colors.transparent,
                    border: Border.all(
                      color: isCorrect
                          ? AppColors.success
                          : Colors.grey.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: isCorrect
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Center(
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D...
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: RichMathContent(
                    content: content,
                    equations: (answer['equations'] as List<dynamic>?)
                        ?.cast<Map<String, dynamic>>(),
                    fontSize: AppTextStyles.bodyMedium.fontSize,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500, // Thêm bold để đồng nhất
                  ),
                ),
              ],
            ),
          );
        }).toList(),

        // Explanation
        if (question.explanation.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.paddingM),
          _buildExplanationWidget(question.explanation),
        ],
      ],
    );
  }

  Widget _buildQuestionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: question.contentBlocks.map((block) {
        if (block is Map<String, dynamic>) {
          final type = block['type'] as String? ?? '';

          if (type == 'text') {
            String content = block['content'] as String? ?? '';
            final equations = block['equations'] as List<dynamic>?;

            content = _processQuestionContent(content, equations);

            return RichMathContent(
              content: content,
              equations: equations?.cast<Map<String, dynamic>>(),
              fontSize: AppTextStyles.bodyLarge.fontSize,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500, // Thêm bold để đồng nhất
            );
          } else if (type == 'image') {
            return _buildImageWidget(block);
          }
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }
}

class FillInBlankQuestionWidget extends StatelessWidget {
  final QuestionDisplayData question;

  const FillInBlankQuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question content
        _buildQuestionContent(),
        const SizedBox(height: AppDimensions.paddingM),

        // Correct answers - chỉ hiển thị khi có đáp án đúng
        Builder(
          builder: (context) {
            final correctAnswers = question.answers
                .where((answer) => (answer['isCorrect'] as bool? ?? false))
                .toList();

            if (correctAnswers.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đáp án đúng:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  Wrap(
                    spacing: AppDimensions.paddingS,
                    children: correctAnswers.map((answer) {
                      final content = answer['content'] as String? ?? '';
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingM,
                          vertical: AppDimensions.paddingS,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          content,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),

        // Explanation
        if (question.explanation.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.paddingM),
          _buildExplanationWidget(question.explanation),
        ],
      ],
    );
  }

  Widget _buildQuestionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: question.contentBlocks.map((block) {
        if (block is Map<String, dynamic>) {
          final type = block['type'] as String? ?? '';

          if (type == 'text') {
            String content = block['content'] as String? ?? '';
            final equations = block['equations'] as List<dynamic>?;

            content = _processQuestionContent(content, equations);

            return Text(
              content,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            );
          } else if (type == 'image') {
            return _buildImageWidget(block);
          }
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }
}

class ClozeTestQuestionWidget extends StatelessWidget {
  final QuestionDisplayData question;

  const ClozeTestQuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question content
        _buildQuestionContent(),
        const SizedBox(height: AppDimensions.paddingM),

        // Answer Options for each blank
        _buildAnswerOptions(),

        // Explanation
        if (question.explanation.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.paddingM),
          _buildExplanationWidget(question.explanation),
        ],
      ],
    );
  }

  Widget _buildAnswerOptions() {
    // Group answers by position for each blank
    final answersByPosition = <int, List<Map<String, dynamic>>>{};

    for (final answer in question.answers) {
      final position = answer['position'] as int? ?? 0;
      answersByPosition.putIfAbsent(position, () => []).add(answer);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: answersByPosition.entries.map((entry) {
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
              ...answers.expand((answer) {
                final options = _getAnswerOptions(answer);
                return options.asMap().entries.map((entry) {
                  final optionIndex = entry.key;
                  final option = entry.value;
                  final isCorrect = _isCorrectAnswer(answer, optionIndex);

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.paddingS,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingM),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? AppColors.success.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCorrect
                              ? AppColors.success
                              : Colors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCorrect
                                  ? AppColors.success
                                  : Colors.transparent,
                              border: Border.all(
                                color: isCorrect
                                    ? AppColors.success
                                    : Colors.grey.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: isCorrect
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : Center(
                                    child: Text(
                                      String.fromCharCode(
                                        65 + optionIndex,
                                      ), // A, B, C, D...
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
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
                });
              }).toList(),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<String> _getAnswerOptions(Map<String, dynamic> answer) {
    final content = answer['content'] as String? ?? '';
    // Bóc tách các đáp án được phân tách bằng dấu |
    final options = content.split('|');
    if (options.length > 1) {
      // Trả về danh sách các options riêng biệt
      return options.map((option) => option.trim()).toList();
    }
    return [content];
  }

  bool _isCorrectAnswer(Map<String, dynamic> answer, int optionIndex) {
    // Logic để xác định đáp án đúng
    // Có thể dựa vào answer.isCorrect hoặc answer.metadata
    return answer['isCorrect'] as bool? ?? false;
  }

  Widget _buildQuestionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: question.contentBlocks.map((block) {
        if (block is Map<String, dynamic>) {
          final type = block['type'] as String? ?? '';

          if (type == 'text') {
            String content = block['content'] as String? ?? '';
            final equations = block['equations'] as List<dynamic>?;

            content = _processQuestionContent(content, equations);

            return Text(
              content,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            );
          } else if (type == 'image') {
            return _buildImageWidget(block);
          }
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }
}

class SentenceRewritingQuestionWidget extends StatelessWidget {
  final QuestionDisplayData question;

  const SentenceRewritingQuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question content
        _buildQuestionContent(),
        const SizedBox(height: AppDimensions.paddingM),

        // Correct answers - chỉ hiển thị khi có đáp án đúng
        Builder(
          builder: (context) {
            final correctAnswers = question.answers
                .where((answer) => (answer['isCorrect'] as bool? ?? false))
                .toList();

            if (correctAnswers.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đáp án đúng:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  ...correctAnswers.map((answer) {
                    final content = answer['content'] as String? ?? '';
                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: AppDimensions.paddingS,
                      ),
                      padding: const EdgeInsets.all(AppDimensions.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        content,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),

        // Explanation
        if (question.explanation.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.paddingM),
          _buildExplanationWidget(question.explanation),
        ],
      ],
    );
  }

  Widget _buildQuestionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: question.contentBlocks.map((block) {
        if (block is Map<String, dynamic>) {
          final type = block['type'] as String? ?? '';

          if (type == 'text') {
            String content = block['content'] as String? ?? '';
            final equations = block['equations'] as List<dynamic>?;

            content = _processQuestionContent(content, equations);

            return Text(
              content,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            );
          } else if (type == 'image') {
            return _buildImageWidget(block);
          }
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }
}
