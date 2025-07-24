import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/question_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/chapter_details_dto.dart';
import '../../../../data/dto/question_dto.dart';
import '../../../../providers/chapter/chapter_providers.dart';

class ChapterDetailsScreen extends ConsumerWidget {
  const ChapterDetailsScreen({super.key, required this.chapterId});
  final String chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterDetailsAsync = ref.watch(chapterDetailsProvider(chapterId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Chi tiết chủ đề',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: chapterDetailsAsync.when(
        data: (chapter) => _buildContent(context, chapter),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải chi tiết chủ đề',
                onRetry: () {
                  ref.invalidate(chapterDetailsProvider(chapterId));
                },
              ),
            ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ChapterDetailsStudentResponseDto chapter,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh data
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(chapter),

            const SizedBox(height: 16),

            // Questions List
            if (chapter.questions.isNotEmpty) ...[
              _buildQuestionsSection(chapter.questions),
            ] else ...[
              Center(
                child: EmptyStateWidget(
                  message: 'Chưa có câu hỏi nào',
                  showAction: false,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ChapterDetailsStudentResponseDto chapter) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            chapter.title,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          if (chapter.description != null &&
              chapter.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              chapter.description!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Stats
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Số câu hỏi',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${chapter.questionCount} câu',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đã trả lời',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${chapter.answeredCount} câu',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Điểm số',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chapter.questionCount > 0
                          ? '${((chapter.correctCount / chapter.questionCount) * 10).toStringAsFixed(1)}/10'
                          : '0/10',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (chapter.deadline != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Hạn nộp: ${_formatDate(chapter.deadline!)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionsSection(List<QuestionStudentDto> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh sách câu hỏi',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...questions.map((question) => _buildQuestionCard(question)),
      ],
    );
  }

  Widget _buildQuestionCard(QuestionStudentDto question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppDimensions.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number and type
          Row(
            children: [
              Text(
                'Câu ${question.questionNumber}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getQuestionTypeText(question.questionType),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Question content
          Text(_getQuestionContent(question), style: AppTextStyles.bodyMedium),

          const SizedBox(height: 8),

          // Answer status
          Row(
            children: [
              Icon(
                question.isCorrect ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: question.isCorrect ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 4),
              Text(
                question.isCorrect ? 'Đúng' : 'Sai',
                style: AppTextStyles.bodySmall.copyWith(
                  color:
                      question.isCorrect ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getQuestionTypeText(EQuestionType type) {
    switch (type) {
      case EQuestionType.MULTIPLE_CHOICE:
        return 'Trắc nghiệm';
      case EQuestionType.FILL_IN_THE_BLANK:
        return 'Điền khuyết';
      case EQuestionType.CLOZE_TEST:
        return 'Cloze test';
      case EQuestionType.SENTENCE_REWRITING:
        return 'Viết lại câu';
    }
  }

  String _getQuestionContent(QuestionStudentDto question) {
    // Get text content from content blocks
    final textBlocks = question.contentBlocks
        .whereType<TextContentBlockResponseDto>()
        .map((block) => block.content)
        .join(' ');

    return textBlocks.isNotEmpty ? textBlocks : 'Nội dung câu hỏi';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }
}
