import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import 'overview_report_screen.dart';
import 'student_report_screen.dart';
import 'chapter_report_screen.dart';
import 'practice_set_report_screen.dart';
import 'exam_report_screen.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final String classroomName;

  const ReportsScreen({
    super.key,
    required this.classroomId,
    required this.classroomName,
  });

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Báo cáo lớp học', style: AppTextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              widget.classroomName,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chọn loại báo cáo bạn muốn xem',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Report Types Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildReportCard(
                  'Báo cáo tổng quan',
                  'Tổng quan về lớp học, học sinh, tiến độ học tập',
                  Icons.analytics,
                  AppColors.primary,
                  () => _navigateToReport('overview'),
                ),
                _buildReportCard(
                  'Báo cáo theo học sinh',
                  'Chi tiết kết quả học tập của từng học sinh',
                  Icons.person,
                  AppColors.success,
                  () => _navigateToReport('student'),
                ),
                _buildReportCard(
                  'Báo cáo theo chương học',
                  'Tiến độ hoàn thành các chương học',
                  Icons.book,
                  AppColors.info,
                  () => _navigateToReport('chapter'),
                ),
                _buildReportCard(
                  'Báo cáo theo bài tập tổng hợp',
                  'Kết quả làm bài tập của học sinh',
                  Icons.assignment,
                  AppColors.warning,
                  () => _navigateToReport('practice'),
                ),
                _buildReportCard(
                  'Báo cáo theo bài thi',
                  'Kết quả các bài thi và điểm số',
                  Icons.quiz,
                  AppColors.error,
                  () => _navigateToReport('exam'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Description
              Expanded(
                child: Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Arrow indicator
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToReport(String reportType) {
    switch (reportType) {
      case 'overview':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => OverviewReportScreen(
                  classroomId: widget.classroomId,
                  classroomName: widget.classroomName,
                ),
          ),
        );
        break;
      case 'student':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => StudentReportScreen(
                  classroomId: widget.classroomId,
                  classroomName: widget.classroomName,
                ),
          ),
        );
        break;
      case 'chapter':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => ChapterReportScreen(
                  classroomId: widget.classroomId,
                  classroomName: widget.classroomName,
                ),
          ),
        );
        break;
      case 'practice':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => PracticeSetReportScreen(
                  classroomId: widget.classroomId,
                  classroomName: widget.classroomName,
                ),
          ),
        );
        break;
      case 'exam':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => ExamReportScreen(
                  classroomId: widget.classroomId,
                  classroomName: widget.classroomName,
                ),
          ),
        );
        break;
      default:
        // TODO: Navigate to other specific report screens
        // For now, show a placeholder message
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Báo cáo $reportType'),
                content: Text(
                  'Chức năng báo cáo $reportType sẽ được thêm sau.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Đóng'),
                  ),
                ],
              ),
        );
    }
  }
}
