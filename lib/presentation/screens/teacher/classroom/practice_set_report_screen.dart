import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/practice_set_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/practice_set_dto.dart';
import '../../../../providers/teacher_practice_sets/teacher_practice_sets_providers.dart';
import 'practice_set_report_detail_screen.dart';

class PracticeSetReportScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final String classroomName;

  const PracticeSetReportScreen({
    super.key,
    required this.classroomId,
    required this.classroomName,
  });

  @override
  ConsumerState<PracticeSetReportScreen> createState() =>
      _PracticeSetReportScreenState();
}

class _PracticeSetReportScreenState
    extends ConsumerState<PracticeSetReportScreen> {
  @override
  Widget build(BuildContext context) {
    final practiceSetsAsync = ref.watch(
      teacherOpenOrClosedPracticeSetsProvider(widget.classroomId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Báo cáo theo bài tập tổng hợp',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: practiceSetsAsync.when(
        data: (practiceSets) => _buildPracticeSetsList(practiceSets),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải danh sách bài tập',
                onRetry: () {
                  ref.invalidate(
                    teacherOpenOrClosedPracticeSetsProvider(widget.classroomId),
                  );
                },
              ),
            ),
      ),
    );
  }

  Widget _buildPracticeSetsList(
    TeacherPracticeSetResponseListDto practiceSets,
  ) {
    // Combine all practice sets
    final allPracticeSets = [
      ...practiceSets.scheduledPracticeSets,
      ...practiceSets.openPracticeSets,
      ...practiceSets.closedPracticeSets,
    ];

    if (allPracticeSets.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message: 'Chưa có bài tập nào',
          showAction: false,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(
          teacherOpenOrClosedPracticeSetsProvider(widget.classroomId),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        itemCount: allPracticeSets.length,
        itemBuilder: (context, index) {
          final practiceSet = allPracticeSets[index];
          return _buildPracticeSetCard(practiceSet);
        },
      ),
    );
  }

  Widget _buildPracticeSetCard(PracticeSetTeacherResponseDto practiceSet) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => PracticeSetReportDetailScreen(
                    classroomId: widget.classroomId,
                    classroomName: widget.classroomName,
                    practiceSetId: practiceSet.id,
                    practiceSetName: practiceSet.title,
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
                      practiceSet.title,
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
                      color: _getStatusColor(
                        practiceSet.status,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusLabel(practiceSet.status),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _getStatusColor(practiceSet.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              if (practiceSet.description != null &&
                  practiceSet.description!.isNotEmpty) ...[
                Text(
                  practiceSet.description!,
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
                    practiceSet.assignToAll ? Icons.people : Icons.person,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    practiceSet.assignToAll
                        ? 'Giao cho cả lớp'
                        : 'Giao cho ${practiceSet.assignedStudentCount ?? 0} học sinh',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date Range
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_formatDate(practiceSet.startDate ?? '')} - ${_formatDate(practiceSet.deadline ?? '')}',
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

  Color _getStatusColor(EPracticeSetStatus status) {
    switch (status) {
      case EPracticeSetStatus.SCHEDULED:
        return AppColors.info;
      case EPracticeSetStatus.OPEN:
        return AppColors.warning;
      case EPracticeSetStatus.CLOSED:
        return AppColors.success;
    }
  }

  String _getStatusLabel(EPracticeSetStatus status) {
    switch (status) {
      case EPracticeSetStatus.SCHEDULED:
        return 'Đã lên lịch';
      case EPracticeSetStatus.OPEN:
        return 'Đang diễn ra';
      case EPracticeSetStatus.CLOSED:
        return 'Đã hoàn thành';
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Chưa có';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
