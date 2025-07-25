import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/chapter_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/chapter_dto.dart';
import '../../../../providers/teacher_chapters/teacher_chapters_providers.dart';

class TeacherChapterDetailsScreen extends ConsumerWidget {
  final String chapterId;

  const TeacherChapterDetailsScreen({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterDetailsAsync = ref.watch(
      teacherChapterDetailsProvider(chapterId),
    );

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
        actions: [
          // Edit button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                // TODO: Navigate to edit chapter screen
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
          // Settings button
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                // TODO: Navigate to settings screen
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.settings,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: chapterDetailsAsync.when(
        data: (chapterDetails) => _buildContent(context, chapterDetails),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải chi tiết chủ đề',
                onRetry: () {
                  ref.invalidate(teacherChapterDetailsProvider(chapterId));
                },
              ),
            ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ChapterDetailsTeacherResponseDto chapter,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildHeaderCard(context, chapter),
          const SizedBox(height: 16),

          // Statistics Cards
          _buildStatisticsCards(chapter),
          const SizedBox(height: 16),

          // Theory Pages Section
          _buildTheoryPagesSection(chapter),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    ChapterDetailsTeacherResponseDto chapter,
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
            // Title and Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    chapter.title,
                    style: AppTextStyles.headlineSmall.copyWith(
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
                    color: _getStatusColor(chapter.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(chapter.status),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            if (chapter.description != null && chapter.description!.isNotEmpty)
              Text(
                chapter.description!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

            const SizedBox(height: 12),

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
                  'Thời gian: ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${_formatDate(chapter.startDate ?? '')} - ${_formatDate(chapter.deadline ?? '')}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(ChapterDetailsTeacherResponseDto chapter) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Câu hỏi',
          '${chapter.questionCount}',
          Icons.quiz,
          AppColors.primary,
        ),
        _buildStatCard(
          'Học sinh đã làm',
          '${chapter.studentProgressCount}',
          Icons.people,
          AppColors.success,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTheoryPagesSection(ChapterDetailsTeacherResponseDto chapter) {
    if (chapter.theoryPages.isEmpty) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: EmptyStateWidgets.noData(message: 'Chưa có trang lý thuyết'),
      );
    }

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
              'Trang lý thuyết',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...chapter.theoryPages.map((page) => _buildTheoryPageItem(page, 0)),
          ],
        ),
      ),
    );
  }

  Widget _buildTheoryPageItem(ChapterTheoryPageListItemDto page, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: level * 16.0),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                page.children?.isNotEmpty == true
                    ? Icons.folder
                    : Icons.description,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  page.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (page.children?.isNotEmpty == true)
          ...page.children!.map(
            (child) => _buildTheoryPageItem(child, level + 1),
          ),
      ],
    );
  }

  Color _getStatusColor(EChapterStatus status) {
    switch (status) {
      case EChapterStatus.SCHEDULED:
        return const Color(0xFF2196F3); // Blue
      case EChapterStatus.OPEN:
        return const Color(0xFF4CAF50); // Green
      case EChapterStatus.CLOSED:
        return const Color(0xFFF44336); // Red
      case EChapterStatus.CANCELED:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  String _getStatusText(EChapterStatus status) {
    switch (status) {
      case EChapterStatus.SCHEDULED:
        return 'Đã lên lịch';
      case EChapterStatus.OPEN:
        return 'Đang mở';
      case EChapterStatus.CLOSED:
        return 'Đã đóng';
      case EChapterStatus.CANCELED:
        return 'Đã hủy';
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Chưa có';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
