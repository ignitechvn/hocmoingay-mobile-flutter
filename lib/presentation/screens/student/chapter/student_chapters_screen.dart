import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/chapter_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/chapter_dto.dart';
import '../../../../providers/chapter/chapter_providers.dart';
import 'widgets/chapter_status_filter_bar.dart';
import 'chapter_details_screen.dart';

class StudentChaptersScreen extends ConsumerStatefulWidget {
  const StudentChaptersScreen({super.key, required this.classroomId});
  final String classroomId;

  @override
  ConsumerState<StudentChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends ConsumerState<StudentChaptersScreen> {
  int _selectedStatusIndex = 0;

  @override
  Widget build(BuildContext context) {
    final chaptersAsync = ref.watch(chaptersProvider(widget.classroomId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Danh sách chủ đề',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Status Filter Bar
          ChapterStatusFilterBar(
            selectedIndex: _selectedStatusIndex,
            onStatusChanged: (index) {
              setState(() {
                _selectedStatusIndex = index;
              });
            },
          ),

          // Chapters List
          Expanded(
            child: chaptersAsync.when(
              data: (chapters) => _buildContent(context, chapters),
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stackTrace) => Center(
                    child: EmptyStateWidgets.error(
                      message: 'Không thể tải danh sách chủ đề',
                      onRetry: () {
                        ref.invalidate(chaptersProvider(widget.classroomId));
                      },
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<ChapterStudentResponseDto> chapters,
  ) {
    List<ChapterStudentResponseDto> filteredChapters = [];

    // Filter chapters based on selected status
    switch (_selectedStatusIndex) {
      case 0: // Đã lên lịch
        filteredChapters =
            chapters
                .where((c) => c.status == EChapterStatus.SCHEDULED)
                .toList();
        break;
      case 1: // Đang mở
        filteredChapters =
            chapters.where((c) => c.status == EChapterStatus.OPEN).toList();
        break;
      case 2: // Đã đóng
        filteredChapters =
            chapters.where((c) => c.status == EChapterStatus.CLOSED).toList();
        break;
    }

    if (filteredChapters.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message: 'Chưa có chủ đề nào',
          showAction: true,
          actionText: 'Làm mới',
          onActionPressed:
              () => ref.refresh(chaptersProvider(widget.classroomId)),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh data
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        itemCount: filteredChapters.length,
        itemBuilder: (context, index) {
          final chapter = filteredChapters[index];
          return _buildChapterCard(chapter);
        },
      ),
    );
  }

  Widget _buildChapterCard(ChapterStudentResponseDto chapter) {
    final answeredPercent =
        chapter.questionCount > 0
            ? ((chapter.answeredCount / chapter.questionCount) * 100).round()
            : 0;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChapterDetailsScreen(chapterId: chapter.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        decoration: BoxDecoration(
          color: _getStatusBackgroundColor(chapter.status),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Title
            Row(
              children: [
                Expanded(
                  child: Text(
                    chapter.title,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Row 2: Description
            if (chapter.description != null && chapter.description!.isNotEmpty)
              Text(
                chapter.description!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

            const SizedBox(height: 6),

            // Row 3: Stats and Progress
            Row(
              children: [
                // Left column: Question count and date range
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${chapter.questionCount} câu hỏi',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_formatDate(chapter.startDate ?? '')} - ${_formatDate(chapter.deadline ?? '')}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right column: Progress circle (only for OPEN and CLOSED status)
                if (chapter.status == EChapterStatus.OPEN ||
                    chapter.status == EChapterStatus.CLOSED)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Text(
                        '$answeredPercent%',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusBackgroundColor(EChapterStatus status) {
    switch (status) {
      case EChapterStatus.SCHEDULED:
        return const Color(0xFFECF4FE); // Light blue
      case EChapterStatus.OPEN:
        return const Color(0xFFE2F7F0); // Light green
      case EChapterStatus.CLOSED:
        return const Color(0xFFFDE9E9); // Light red
      case EChapterStatus.CANCELED:
        return const Color(0xFFFDE9E9); // Light red
    }
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
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
