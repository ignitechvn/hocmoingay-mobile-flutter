import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/statistical_dto.dart';
import '../../../../providers/statistical/statistical_providers.dart';

class StudentProgressDetailScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final String classroomName;
  final String studentId;
  final String studentName;

  const StudentProgressDetailScreen({
    super.key,
    required this.classroomId,
    required this.classroomName,
    required this.studentId,
    required this.studentName,
  });

  @override
  ConsumerState<StudentProgressDetailScreen> createState() =>
      _StudentProgressDetailScreenState();
}

class _StudentProgressDetailScreenState
    extends ConsumerState<StudentProgressDetailScreen> {
  // Create stable provider key
  late final StudentProgressReportKey _providerKey;

  @override
  void initState() {
    super.initState();
    _providerKey = StudentProgressReportKey(
      classroomId: widget.classroomId,
      studentId: widget.studentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(
      studentProgressReportProvider(_providerKey),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Báo cáo ${widget.studentName}',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: progressAsync.when(
        data: (progress) => _buildContent(context, progress),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải báo cáo học sinh',
                onRetry: () {
                  ref.invalidate(studentProgressReportProvider(_providerKey));
                },
              ),
            ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    StudentProgressReportDto progress,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(progress),
          const SizedBox(height: 24),

          // Progress Overview
          _buildProgressOverview(progress),
          const SizedBox(height: 24),

          // Chapter Progress
          _buildChapterProgress(progress),
          const SizedBox(height: 24),

          // Practice Set Progress
          _buildPracticeSetProgress(progress),
          const SizedBox(height: 24),

          // Exam Progress
          _buildExamProgress(progress),
          const SizedBox(height: 24),

          // Weekly Charts
          _buildWeeklyCharts(progress),
        ],
      ),
    );
  }

  Widget _buildHeader(StudentProgressReportDto progress) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  progress.fullName.isNotEmpty
                      ? progress.fullName[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progress.fullName,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview(StudentProgressReportDto progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tổng quan tiến độ',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildProgressCard(
              'Chương học',
              '${progress.completedChaptersCount}/${progress.totalChaptersCount}',
              Icons.book,
              AppColors.info,
              subtitle:
                  '${_calculatePercentage(progress.completedChaptersCount, progress.totalChaptersCount)}% hoàn thành',
            ),
            _buildProgressCard(
              'Bài tập',
              '${progress.completedPracticeSetsCount}/${progress.totalPracticeSetsCount}',
              Icons.assignment,
              AppColors.warning,
              subtitle:
                  '${_calculatePercentage(progress.completedPracticeSetsCount, progress.totalPracticeSetsCount)}% hoàn thành',
            ),
            _buildProgressCard(
              'Bài thi',
              '${progress.completedExamsCount}/${progress.totalExamsCount}',
              Icons.quiz,
              AppColors.error,
              subtitle:
                  '${_calculatePercentage(progress.completedExamsCount, progress.totalExamsCount)}% hoàn thành',
            ),
            _buildProgressCard(
              'Đang làm',
              '${progress.ongoingChaptersCount + progress.ongoingPracticeSetsCount}',
              Icons.pending,
              AppColors.primary,
              subtitle: 'Chương + Bài tập',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                  child: Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChapterProgress(StudentProgressReportDto progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiến độ chương học',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (progress.chapterDetailReports.isEmpty)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: EmptyStateWidgets.noData(
              message: 'Chưa có dữ liệu chương học',
            ),
          )
        else
          ...progress.chapterDetailReports.map(
            (chapter) => _buildDetailCard(
              title: chapter.title,
              status: chapter.status,
              totalQuestions: chapter.totalQuestions,
              answered: chapter.answered,
              correctAnswers: chapter.correctAnswers,
              studentScore: chapter.studentScore,
              totalScore: chapter.totalScore,
              color: AppColors.info,
            ),
          ),
      ],
    );
  }

  Widget _buildPracticeSetProgress(StudentProgressReportDto progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiến độ bài tập',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (progress.practiceSetDetailReports.isEmpty)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: EmptyStateWidgets.noData(message: 'Chưa có dữ liệu bài tập'),
          )
        else
          ...progress.practiceSetDetailReports.map(
            (practiceSet) => _buildDetailCard(
              title: practiceSet.title,
              status: practiceSet.status,
              totalQuestions: practiceSet.totalQuestions,
              answered: practiceSet.answered,
              correctAnswers: practiceSet.correctAnswers,
              studentScore: practiceSet.studentScore,
              totalScore: practiceSet.totalScore,
              color: AppColors.warning,
            ),
          ),
      ],
    );
  }

  Widget _buildExamProgress(StudentProgressReportDto progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiến độ bài thi',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (progress.examDetailReports.isEmpty)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: EmptyStateWidgets.noData(message: 'Chưa có dữ liệu bài thi'),
          )
        else
          ...progress.examDetailReports.map(
            (exam) => _buildDetailCard(
              title: exam.title,
              status: exam.status,
              totalQuestions: exam.totalQuestions,
              answered: exam.answered,
              correctAnswers: exam.correctAnswers,
              studentScore: exam.studentScore,
              totalScore: exam.totalScore,
              color: AppColors.error,
            ),
          ),
      ],
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String status,
    required int totalQuestions,
    required int answered,
    required int correctAnswers,
    required double studentScore,
    required double totalScore,
    required Color color,
  }) {
    final percentage = totalScore > 0 ? (studentScore / totalScore) * 100 : 0.0;

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
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
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
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Câu hỏi',
                    '$answered/$totalQuestions',
                  ),
                ),
                Expanded(child: _buildDetailItem('Đúng', '$correctAnswers')),
                Expanded(
                  child: _buildDetailItem(
                    'Điểm',
                    '${studentScore.toStringAsFixed(1)}/${totalScore.toStringAsFixed(1)}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.grey200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
            const SizedBox(height: 4),
            Text(
              '${percentage.toStringAsFixed(1)}% hoàn thành',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
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

  Widget _buildWeeklyCharts(StudentProgressReportDto progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Biểu đồ tuần',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildChartCard(
                'Điểm thi tuần',
                progress.weeklyExamScores.map((e) => e.toInt()).toList(),
                AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChartCard(
                'Chuyên cần tuần',
                progress.weeklyHardWork,
                AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartCard(String title, List<int> data, Color color) {
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
              title,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child:
                  data.isEmpty
                      ? Center(
                        child: Text(
                          'Chưa có dữ liệu',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                      : BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY:
                              data.isNotEmpty
                                  ? data
                                      .reduce((a, b) => a > b ? a : b)
                                      .toDouble()
                                  : 10,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const titles = ['T1', 'T2', 'T3', 'T4'];
                                  if (value.toInt() < titles.length) {
                                    return Text(
                                      titles[value.toInt()],
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups:
                              data.asMap().entries.map((entry) {
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.toDouble(),
                                      color: color,
                                      width: 20,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                          gridData: FlGridData(show: false),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'finished':
        return AppColors.success;
      case 'ongoing':
      case 'in_progress':
        return AppColors.warning;
      case 'scheduled':
      case 'pending':
        return AppColors.info;
      case 'cancelled':
      case 'failed':
        return AppColors.error;
      default:
        return AppColors.grey300;
    }
  }

  int _calculatePercentage(int value, int total) {
    if (total == 0) return 0;
    return ((value / total) * 100).round();
  }
}
