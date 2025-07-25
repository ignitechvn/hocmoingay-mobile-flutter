import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/statistical_dto.dart';
import '../../../../providers/statistical/statistical_providers.dart';

class PracticeSetReportDetailScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final String classroomName;
  final String practiceSetId;
  final String practiceSetName;

  const PracticeSetReportDetailScreen({
    super.key,
    required this.classroomId,
    required this.classroomName,
    required this.practiceSetId,
    required this.practiceSetName,
  });

  @override
  ConsumerState<PracticeSetReportDetailScreen> createState() =>
      _PracticeSetReportDetailScreenState();
}

class _PracticeSetReportDetailScreenState
    extends ConsumerState<PracticeSetReportDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(
      practiceSetReportProvider(widget.practiceSetId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Báo cáo ${widget.practiceSetName}',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: reportAsync.when(
        data: (report) => _buildContent(context, report),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải báo cáo bài tập',
                onRetry: () {
                  ref.invalidate(
                    practiceSetReportProvider(widget.practiceSetId),
                  );
                },
              ),
            ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PracticeSetReportDto report) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(report),
          const SizedBox(height: 24),

          // Questions List
          _buildQuestionsList(report),
        ],
      ),
    );
  }

  Widget _buildHeader(PracticeSetReportDto report) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.practiceSetName,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Lớp: ${widget.classroomName}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatItem(
                  'Tổng câu hỏi',
                  '${report.questions.length}',
                  Icons.quiz,
                  AppColors.primary,
                ),
                const SizedBox(width: 16),
                _buildStatItem(
                  'Tỷ lệ đúng TB',
                  '${_calculateAverageCorrectRate(report.questions).toStringAsFixed(1)}%',
                  Icons.trending_up,
                  AppColors.success,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsList(PracticeSetReportDto report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh sách câu hỏi (${report.questions.length} câu)',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (report.questions.isEmpty)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: EmptyStateWidgets.noData(message: 'Chưa có câu hỏi nào'),
          )
        else
          ...report.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return _buildQuestionCard(index + 1, question);
          }),
      ],
    );
  }

  Widget _buildQuestionCard(int questionNumber, QuestionReportDto question) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '$questionNumber',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Câu hỏi $questionNumber',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getQuestionTypeColor(
                      question.type,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getQuestionTypeLabel(question.type),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _getQuestionTypeColor(question.type),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Question Content
            Text(
              question.content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Question Stats
            Row(
              children: [
                _buildQuestionStat(
                  'Độ khó',
                  _getDifficultyLabel(question.difficulty),
                ),
                const SizedBox(width: 16),
                _buildQuestionStat('Điểm', question.points.toStringAsFixed(1)),
                const SizedBox(width: 16),
                _buildQuestionStat(
                  'Tỷ lệ đúng',
                  '${question.correctRate.toStringAsFixed(1)}%',
                ),
              ],
            ),

            // Options (if multiple choice)
            if (question.options.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Các lựa chọn:',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...question.options.asMap().entries.map((entry) {
                final optionIndex = entry.key;
                final option = entry.value;
                final isCorrect = question.correctAnswers.contains(option);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        '${String.fromCharCode(65 + optionIndex)}. ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          option,
                          style: AppTextStyles.bodySmall.copyWith(
                            color:
                                isCorrect
                                    ? AppColors.success
                                    : AppColors.textPrimary,
                            fontWeight:
                                isCorrect ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isCorrect)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 16,
                        ),
                    ],
                  ),
                );
              }),
            ],

            // Correct Answers
            if (question.correctAnswers.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Đáp án đúng:',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                question.correctAnswers.join(', '),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            // Explanation
            if (question.explanation.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Giải thích:',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                question.explanation,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getQuestionTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'multiple_choice':
        return AppColors.primary;
      case 'fill_in_blank':
        return AppColors.warning;
      case 'cloze_test':
        return AppColors.info;
      case 'sentence_rewriting':
        return AppColors.success;
      default:
        return AppColors.grey300;
    }
  }

  String _getQuestionTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'multiple_choice':
        return 'Trắc nghiệm';
      case 'fill_in_blank':
        return 'Điền khuyết';
      case 'cloze_test':
        return 'Cloze test';
      case 'sentence_rewriting':
        return 'Viết lại câu';
      default:
        return 'Không xác định';
    }
  }

  String _getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Dễ';
      case 2:
        return 'Trung bình';
      case 3:
        return 'Khó';
      default:
        return 'Không xác định';
    }
  }

  double _calculateAverageCorrectRate(List<QuestionReportDto> questions) {
    if (questions.isEmpty) return 0.0;
    final totalRate = questions.fold<double>(
      0.0,
      (sum, q) => sum + q.correctRate,
    );
    return totalRate / questions.length;
  }
}
