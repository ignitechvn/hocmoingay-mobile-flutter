import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/chapter_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/chapter_dto.dart';
import '../../../../providers/teacher_classroom/teacher_classroom_providers.dart';
import '../widgets/chapter_status_filter_bar.dart';
import 'teacher_chapter_details_screen.dart';
import 'create_chapter_screen.dart';

class TeacherChaptersScreen extends ConsumerStatefulWidget {
  const TeacherChaptersScreen({super.key, required this.classroomId});
  final String classroomId;

  @override
  ConsumerState<TeacherChaptersScreen> createState() =>
      _TeacherChaptersScreenState();
}

class _TeacherChaptersScreenState extends ConsumerState<TeacherChaptersScreen> {
  int _selectedStatusIndex = 0;

  @override
  Widget build(BuildContext context) {
    final chaptersAsync = ref.watch(
      teacherChaptersProvider(widget.classroomId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Quản lý chủ đề',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Add button
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => CreateChapterScreen(
                          classroomId: widget.classroomId,
                        ),
                  ),
                );

                // Refresh data if chapter was created successfully
                if (result == true) {
                  ref.refresh(teacherChaptersProvider(widget.classroomId));
                }
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
                  Icons.add,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
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
                        ref.invalidate(
                          teacherChaptersProvider(widget.classroomId),
                        );
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
    TeacherChapterResponseListDto chapters,
  ) {
    List<ChapterTeacherResponseDto> filteredChapters = [];

    // Filter chapters based on selected status
    switch (_selectedStatusIndex) {
      case 0: // Đã lên lịch
        filteredChapters = chapters.scheduledChapters;
        break;
      case 1: // Đang mở
        filteredChapters = chapters.openChapters;
        break;
      case 2: // Đã đóng
        filteredChapters = chapters.closedChapters;
        break;
    }

    if (filteredChapters.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message: 'Chưa có chủ đề nào',
          showAction: true,
          actionText: 'Làm mới',
          onActionPressed:
              () => ref.refresh(teacherChaptersProvider(widget.classroomId)),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(teacherChaptersProvider(widget.classroomId));
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

  Widget _buildChapterCard(ChapterTeacherResponseDto chapter) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => TeacherChapterDetailsScreen(chapterId: chapter.id),
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
            // Row 1: Title and Actions
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
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _handleChapterAction(value, chapter);
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'update_info',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 8),
                              Text('Cập nhật thông tin'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'update_status',
                          child: Row(
                            children: [
                              Icon(Icons.update, size: 16),
                              SizedBox(width: 8),
                              Text('Cập nhật trạng thái'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Xóa', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                  child: const Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
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

            // Row 3: Stats and Date Range
            Column(
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
          ],
        ),
      ),
    );
  }

  void _handleChapterAction(String action, ChapterTeacherResponseDto chapter) {
    switch (action) {
      case 'update_info':
        // TODO: Navigate to update chapter info screen
        break;
      case 'update_status':
        // TODO: Show status update dialog
        break;
      case 'delete':
        // TODO: Show confirmation dialog and delete chapter
        break;
    }
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
    if (dateString.isEmpty) return 'Chưa có';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
