import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/services/token_manager.dart';
import '../../../../data/dto/statistical_dto.dart';
import '../../../../providers/statistical/statistical_providers.dart';

class OverviewReportScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final String classroomName;

  const OverviewReportScreen({
    super.key,
    required this.classroomId,
    required this.classroomName,
  });

  @override
  ConsumerState<OverviewReportScreen> createState() =>
      _OverviewReportScreenState();
}

class _OverviewReportScreenState extends ConsumerState<OverviewReportScreen> {
  @override
  Widget build(BuildContext context) {
    final overviewAsync = ref.watch(
      classroomOverviewProvider(widget.classroomId),
    );

    // Debug: Check authentication status
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final accessToken = await TokenManager.getAccessToken();
      final refreshToken = await TokenManager.getRefreshToken();
      print(
        '🔍 OverviewReportScreen: Access token: ${accessToken != null ? 'Present' : 'Missing'}',
      );
      print(
        '🔍 OverviewReportScreen: Refresh token: ${refreshToken != null ? 'Present' : 'Missing'}',
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Báo cáo tổng quan',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: overviewAsync.when(
        data: (overview) => _buildContent(context, overview),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: EmptyStateWidgets.error(
                message:
                    error.toString().contains('401')
                        ? 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'
                        : 'Không thể tải báo cáo tổng quan',
                onRetry: () {
                  if (error.toString().contains('401')) {
                    // Navigate to login if authentication failed
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  } else {
                    ref.invalidate(
                      classroomOverviewProvider(widget.classroomId),
                    );
                  }
                },
              ),
            ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ClassroomOverviewResponseDto overview,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(classroomOverviewProvider(widget.classroomId));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(overview),
            const SizedBox(height: 24),

            // Key Statistics
            _buildKeyStatistics(overview),
            const SizedBox(height: 24),

            // Progress Sections
            _buildProgressSections(overview),
            const SizedBox(height: 24),

            // Student Rankings
            _buildStudentRankings(overview),
            const SizedBox(height: 24),

            // Charts
            _buildCharts(overview),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ClassroomOverviewResponseDto overview) {
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
              overview.classroomName,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Báo cáo tổng quan lớp học',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyStatistics(ClassroomOverviewResponseDto overview) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Tổng học sinh',
          '${overview.totalStudents}',
          Icons.people,
          AppColors.primary,
          subtitle:
              '${overview.approvedStudents} đã duyệt • ${overview.pendingStudents} chờ duyệt',
        ),
        _buildStatCard(
          'Buổi học',
          '${overview.lessonsConducted}/${overview.totalLessonsPlanned}',
          Icons.school,
          AppColors.success,
          subtitle:
              '${_calculatePercentage(overview.lessonsConducted, overview.totalLessonsPlanned)}% hoàn thành',
        ),
        _buildStatCard(
          'Chương học',
          '${overview.completedChapters}/${overview.totalChapters}',
          Icons.book,
          AppColors.info,
          subtitle:
              '${_calculatePercentage(overview.completedChapters, overview.totalChapters)}% hoàn thành',
        ),
        _buildStatCard(
          'Bài tập',
          '${overview.completedPracticeSets}/${overview.totalPracticeSets}',
          Icons.assignment,
          AppColors.warning,
          subtitle:
              '${_calculatePercentage(overview.completedPracticeSets, overview.totalPracticeSets)}% hoàn thành',
        ),
      ],
    );
  }

  Widget _buildStatCard(
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
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
            const SizedBox(height: 12),
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
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

  Widget _buildProgressSections(ClassroomOverviewResponseDto overview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiến độ học tập',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildProgressCard(
          'Chương học',
          overview.totalChapters,
          overview.scheduledChapters,
          overview.ongoingChapters,
          overview.completedChapters,
          AppColors.info,
        ),
        const SizedBox(height: 12),
        _buildProgressCard(
          'Bài tập',
          overview.totalPracticeSets,
          overview.scheduledPracticeSets,
          overview.ongoingPracticeSets,
          overview.completedPracticeSets,
          AppColors.warning,
        ),
        const SizedBox(height: 12),
        _buildProgressCard(
          'Bài thi',
          overview.totalExams,
          overview.scheduledExams,
          overview.ongoingExams,
          overview.completedExams,
          AppColors.error,
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    String title,
    int total,
    int scheduled,
    int ongoing,
    int completed,
    Color color,
  ) {
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem(
                    'Đã lên lịch',
                    scheduled,
                    total,
                    AppColors.grey300,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildProgressItem(
                    'Đang diễn ra',
                    ongoing,
                    total,
                    AppColors.warning,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildProgressItem(
                    'Hoàn thành',
                    completed,
                    total,
                    color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, int value, int total, Color color) {
    final percentage = total > 0 ? (value / total) : 0.0;
    return Column(
      children: [
        Text(
          '$value',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: AppColors.grey200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildStudentRankings(ClassroomOverviewResponseDto overview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xếp hạng học sinh',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildRankingCard(
                'Điểm cao nhất',
                overview.topExamAverageStudents,
                Icons.trending_up,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRankingCard(
                'Điểm thấp nhất',
                overview.lowestExamAverageStudents,
                Icons.trending_down,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRankingCard(
                'Chuyên cần cao nhất',
                overview.topAttendanceStudents,
                Icons.people,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRankingCard(
                'Chuyên cần thấp nhất',
                overview.lowestAttendanceStudents,
                Icons.person_off,
                AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRankingCard(
    String title,
    List<StudentScoreDto> students,
    IconData icon,
    Color color,
  ) {
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
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (students.isEmpty)
              Text(
                'Chưa có dữ liệu',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            else
              ...students
                  .take(3)
                  .map(
                    (student) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              student.fullName,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${student.score.toStringAsFixed(1)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts(ClassroomOverviewResponseDto overview) {
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
                'Chuyên cần tuần',
                overview.weeklyAttendance,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChartCard(
                'Điểm trung bình tuần',
                overview.weeklyExamAverage.map((e) => e.toInt()).toList(),
                AppColors.success,
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

  int _calculatePercentage(int value, int total) {
    if (total == 0) return 0;
    return ((value / total) * 100).round();
  }
}
