import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/chapter_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/chapter_dto.dart';
import '../../../../providers/teacher_chapters/teacher_chapters_providers.dart';
import 'chapter_report_detail_screen.dart';

class ChapterReportScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final String classroomName;

  const ChapterReportScreen({
    super.key,
    required this.classroomId,
    required this.classroomName,
  });

  @override
  ConsumerState<ChapterReportScreen> createState() =>
      _ChapterReportScreenState();
}

class _ChapterReportScreenState extends ConsumerState<ChapterReportScreen> {
  @override
  Widget build(BuildContext context) {
    final chaptersAsync = ref.watch(
      teacherChaptersProvider(widget.classroomId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Báo cáo theo chương học',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: chaptersAsync.when(
        data: (chapters) => _buildChaptersList(chapters),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải danh sách chương học',
                onRetry: () {
                  ref.invalidate(teacherChaptersProvider(widget.classroomId));
                },
              ),
            ),
      ),
    );
  }

  Widget _buildChaptersList(TeacherChapterResponseListDto chapters) {
    // Combine all chapters
    final allChapters = [
      ...chapters.scheduledChapters,
      ...chapters.openChapters,
      ...chapters.closedChapters,
    ];

    if (allChapters.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message: 'Chưa có chương học nào',
          showAction: false,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(teacherChaptersProvider(widget.classroomId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        itemCount: allChapters.length,
        itemBuilder: (context, index) {
          final chapter = allChapters[index];
          return _buildChapterCard(chapter);
        },
      ),
    );
  }

  Widget _buildChapterCard(ChapterTeacherResponseDto chapter) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => ChapterReportDetailScreen(
                    classroomId: widget.classroomId,
                    classroomName: widget.classroomName,
                    chapterId: chapter.id,
                    chapterName: chapter.title,
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
                      chapter.title,
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
                      color: _getStatusColor(chapter.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusLabel(chapter.status),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _getStatusColor(chapter.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              if (chapter.description != null &&
                  chapter.description!.isNotEmpty) ...[
                Text(
                  chapter.description!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

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
                    '${_formatDate(chapter.startDate ?? '')} - ${_formatDate(chapter.deadline ?? '')}',
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

  Color _getStatusColor(EChapterStatus status) {
    switch (status) {
      case EChapterStatus.SCHEDULED:
        return AppColors.info;
      case EChapterStatus.OPEN:
        return AppColors.warning;
      case EChapterStatus.CLOSED:
        return AppColors.success;
      case EChapterStatus.CANCELED:
        return AppColors.error;
    }
  }

  String _getStatusLabel(EChapterStatus status) {
    switch (status) {
      case EChapterStatus.SCHEDULED:
        return 'Đã lên lịch';
      case EChapterStatus.OPEN:
        return 'Đang diễn ra';
      case EChapterStatus.CLOSED:
        return 'Đã hoàn thành';
      case EChapterStatus.CANCELED:
        return 'Đã hủy';
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
