import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/chapter_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/update_chapter_status_dialog.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../data/dto/chapter_dto.dart';
import '../../../../providers/teacher_classroom/teacher_classroom_providers.dart';
import '../../../../providers/teacher_chapters/teacher_chapters_providers.dart'
    as chapter_providers;
import '../../../../domain/usecases/teacher_chapters/delete_chapter_usecase.dart';
import '../../../../domain/usecases/teacher_chapters/update_chapter_status_usecase.dart';
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
          showAction: false,
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
                          child: Text('Cập nhật thông tin'),
                        ),
                        const PopupMenuItem(
                          value: 'update_status',
                          child: Text('Cập nhật trạng thái'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Xóa',
                            style: TextStyle(color: Colors.red),
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
        _navigateToEditChapter(chapter);
        break;
      case 'update_status':
        _showUpdateStatusDialog(chapter);
        break;
      case 'delete':
        _showDeleteConfirmation(chapter);
        break;
    }
  }

  void _navigateToEditChapter(ChapterTeacherResponseDto chapter) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => CreateChapterScreen(
              classroomId: widget.classroomId,
              chapterToEdit: chapter,
            ),
      ),
    );

    // Refresh data if chapter was updated successfully
    if (result == true) {
      ref.refresh(teacherChaptersProvider(widget.classroomId));
    }
  }

  Future<void> _showUpdateStatusDialog(
    ChapterTeacherResponseDto chapter,
  ) async {
    final newStatus = await UpdateChapterStatusHelper.showUpdateStatusDialog(
      context,
      chapterTitle: chapter.title,
      currentStatus: chapter.status,
    );

    if (newStatus != null && newStatus != chapter.status) {
      try {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );

        // Call API
        final updateStatusDto = UpdateChapterStatusDto(status: newStatus);
        final useCase = ref.read(
          chapter_providers.updateChapterStatusUseCaseProvider,
        );
        await useCase(
          UpdateChapterStatusParams(
            chapterId: chapter.id,
            dto: updateStatusDto,
          ),
        );

        // Hide loading
        Navigator.of(context).pop();

        // Show success message
        ToastUtils.showSuccess(
          context: context,
          message: 'Cập nhật trạng thái chủ đề thành công!',
        );

        // Refresh chapters list
        ref.refresh(teacherChaptersProvider(widget.classroomId));
      } catch (e) {
        // Hide loading
        Navigator.of(context).pop();

        // Show error message
        ToastUtils.showFail(
          context: context,
          message: 'Cập nhật trạng thái thất bại: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _showDeleteConfirmation(
    ChapterTeacherResponseDto chapter,
  ) async {
    final shouldDelete = await ConfirmDialogHelper.showCustomConfirmation(
      context,
      title: 'Xác nhận xóa',
      content: DeleteChapterContent(chapterTitle: chapter.title),
      confirmText: 'Xóa',
      cancelText: 'Hủy',
      confirmColor: AppColors.error,
    );

    if (shouldDelete) {
      try {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );

        // Call API
        final useCase = ref.read(
          chapter_providers.deleteChapterUseCaseProvider,
        );
        await useCase(DeleteChapterParams(chapterId: chapter.id));

        // Hide loading
        Navigator.of(context).pop();

        // Show success message
        ToastUtils.showSuccess(
          context: context,
          message: 'Xóa chủ đề thành công',
        );

        // Refresh chapters list
        ref.refresh(teacherChaptersProvider(widget.classroomId));
      } catch (e) {
        // Hide loading
        Navigator.of(context).pop();

        // Show error message
        ToastUtils.showFail(
          context: context,
          message: 'Xóa chủ đề thất bại: ${e.toString()}',
        );
      }
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
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}

// Content widget for deleting chapter confirmation
class DeleteChapterContent extends StatelessWidget {
  final String chapterTitle;

  const DeleteChapterContent({super.key, required this.chapterTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            children: [
              const TextSpan(text: 'Bạn có chắc chắn muốn xoá chương học '),
              TextSpan(
                text: '"$chapterTitle"',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: ' không?'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            children: [
              const TextSpan(text: 'Hành động này sẽ '),
              const TextSpan(
                text: 'xóa toàn bộ câu hỏi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' và '),
              const TextSpan(
                text: 'kết quả học tập liên quan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: ' đến chương học này. Thao tác không thể hoàn tác.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
