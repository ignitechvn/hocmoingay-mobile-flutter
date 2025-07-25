import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/exam_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/exam_dto.dart';
import '../../../../providers/teacher_exams/teacher_exams_providers.dart';
import 'exam_report_detail_screen.dart';

class ExamReportScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final String classroomName;

  const ExamReportScreen({
    super.key,
    required this.classroomId,
    required this.classroomName,
  });

  @override
  ConsumerState<ExamReportScreen> createState() => _ExamReportScreenState();
}

class _ExamReportScreenState extends ConsumerState<ExamReportScreen> {
  @override
  Widget build(BuildContext context) {
    final examsAsync = ref.watch(
      teacherClosedExamsProvider(widget.classroomId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Báo cáo theo bài thi',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: examsAsync.when(
        data: (exams) => _buildExamsList(exams),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải danh sách bài thi',
                onRetry: () {
                  ref.invalidate(
                    teacherClosedExamsProvider(widget.classroomId),
                  );
                },
              ),
            ),
      ),
    );
  }

  Widget _buildExamsList(TeacherExamResponseListDto exams) {
    // Combine all exams
    final allExams = [
      ...exams.scheduledExams,
      ...exams.openExams,
      ...exams.closedExams,
    ];

    if (allExams.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message: 'Chưa có bài thi nào',
          showAction: false,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(teacherClosedExamsProvider(widget.classroomId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        itemCount: allExams.length,
        itemBuilder: (context, index) {
          final exam = allExams[index];
          return _buildExamCard(exam);
        },
      ),
    );
  }

  Widget _buildExamCard(ExamTeacherResponseDto exam) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => ExamReportDetailScreen(
                    classroomId: widget.classroomId,
                    classroomName: widget.classroomName,
                    examId: exam.id,
                    examName: exam.title,
                  ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      exam.title,
                      style: AppTextStyles.titleMedium.copyWith(
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
                      color: _getStatusColor(exam.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusLabel(exam.status),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _getStatusColor(exam.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              if (exam.description != null && exam.description!.isNotEmpty) ...[
                Text(
                  exam.description!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              // Assignment Info
              Row(
                children: [
                  Icon(
                    exam.assignToAll ? Icons.people : Icons.person,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    exam.assignToAll
                        ? 'Giao cho cả lớp'
                        : 'Giao cho ${exam.assignedStudentCount ?? 0} học sinh',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Exam Time and Duration
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_formatDateTime(exam.startTime ?? '')} - ${exam.duration} phút',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              // Arrow
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Xem báo cáo',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(EExamStatus status) {
    switch (status) {
      case EExamStatus.SCHEDULED:
        return AppColors.info;
      case EExamStatus.OPEN:
        return AppColors.warning;
      case EExamStatus.CLOSED:
        return AppColors.success;
    }
  }

  String _getStatusLabel(EExamStatus status) {
    switch (status) {
      case EExamStatus.SCHEDULED:
        return 'Đã lên lịch';
      case EExamStatus.OPEN:
        return 'Đang diễn ra';
      case EExamStatus.CLOSED:
        return 'Đã hoàn thành';
    }
  }

  String _formatDateTime(String dateTimeString) {
    if (dateTimeString.isEmpty) return 'Chưa có';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }
}
