import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/exam_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/update_exam_status_dialog.dart';
import '../../../../data/dto/exam_dto.dart';
import '../../../../providers/teacher_exams/teacher_exams_providers.dart';
import '../../../../domain/usecases/teacher_exams/delete_exam_usecase.dart';
import '../../../../domain/usecases/teacher_exams/update_exam_status_usecase.dart';
import '../widgets/exam_status_filter_bar.dart';
import 'create_exam_screen.dart';
import 'teacher_exam_details_screen.dart';

class TeacherExamsScreen extends ConsumerStatefulWidget {
  const TeacherExamsScreen({super.key, required this.classroomId});
  final String classroomId;

  @override
  ConsumerState<TeacherExamsScreen> createState() => _TeacherExamsScreenState();
}

class _TeacherExamsScreenState extends ConsumerState<TeacherExamsScreen> {
  int _selectedStatusIndex = 0;

  @override
  Widget build(BuildContext context) {
    final examsAsync = ref.watch(teacherExamsProvider(widget.classroomId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Quản lý bài thi',
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
                        (context) =>
                            CreateExamScreen(classroomId: widget.classroomId),
                  ),
                );

                // Refresh data if exam was created successfully
                if (result == true) {
                  ref.refresh(teacherExamsProvider(widget.classroomId));
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
          ExamStatusFilterBar(
            selectedIndex: _selectedStatusIndex,
            onStatusChanged: (index) {
              setState(() {
                _selectedStatusIndex = index;
              });
            },
          ),

          // Exams List
          Expanded(
            child: examsAsync.when(
              data: (exams) => _buildContent(context, exams),
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stackTrace) => Center(
                    child: EmptyStateWidgets.error(
                      message: 'Không thể tải danh sách bài thi',
                      onRetry: () {
                        ref.invalidate(
                          teacherExamsProvider(widget.classroomId),
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

  Widget _buildContent(BuildContext context, TeacherExamResponseListDto exams) {
    List<ExamTeacherResponseDto> filteredExams = [];

    // Filter exams based on selected status
    switch (_selectedStatusIndex) {
      case 0: // Đã lên lịch
        filteredExams = exams.scheduledExams;
        break;
      case 1: // Đang mở
        filteredExams = exams.openExams;
        break;
      case 2: // Đã đóng
        filteredExams = exams.closedExams;
        break;
    }

    if (filteredExams.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message: 'Chưa có bài thi nào',
          showAction: false,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(teacherExamsProvider(widget.classroomId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        itemCount: filteredExams.length,
        itemBuilder: (context, index) {
          final exam = filteredExams[index];
          return _buildExamCard(exam);
        },
      ),
    );
  }

  Widget _buildExamCard(ExamTeacherResponseDto exam) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TeacherExamDetailsScreen(examId: exam.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        decoration: BoxDecoration(
          color: Color(_getStatusBackgroundColor(exam.status)),
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
                    exam.title,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _handleExamAction(value, exam);
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'update_info',
                          child: Text('Cập nhật thông tin'),
                        ),
                        if (exam.status != EExamStatus.CLOSED)
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
            if (exam.description != null && exam.description!.isNotEmpty)
              Text(
                exam.description!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

            const SizedBox(height: 8),

            // Row 3: Stats and Assignment Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left column: Question count and date/time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${exam.questionCount} câu hỏi',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exam.startTime != null
                            ? '${_formatDatetime(exam.startTime!)} • ${exam.duration} phút'
                            : 'Chưa xác định thời gian',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right column: Assignment info (aligned to bottom)
                exam.assignToAll
                    ? RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                        children: [
                          const TextSpan(text: 'Giao cho '),
                          TextSpan(
                            text: 'cả lớp',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                    : RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                        children: [
                          const TextSpan(text: 'Giao cho '),
                          TextSpan(
                            text: '${exam.assignedStudentCount ?? 0}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: ' học sinh'),
                        ],
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExamAction(
    String action,
    ExamTeacherResponseDto exam,
  ) async {
    switch (action) {
      case 'update_info':
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => CreateExamScreen(
                  classroomId: widget.classroomId,
                  exam: exam,
                ),
          ),
        );

        // Refresh data if exam was updated successfully
        if (result == true) {
          ref.refresh(teacherExamsProvider(widget.classroomId));
        }
        break;
      case 'update_status':
        _showUpdateStatusDialog(exam);
        break;
      case 'delete':
        _showDeleteConfirmation(exam);
        break;
    }
  }

  int _getStatusBackgroundColor(EExamStatus status) {
    switch (status) {
      case EExamStatus.SCHEDULED:
        return 0xFFECF4FE; // Light blue
      case EExamStatus.OPEN:
        return 0xFFE2F7F0; // Light green
      case EExamStatus.CLOSED:
        return 0xFFFDE9E9; // Light red
    }
  }

  String _formatDatetime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('HH:mm dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  Future<void> _showUpdateStatusDialog(ExamTeacherResponseDto exam) async {
    final newStatus = await UpdateExamStatusHelper.showUpdateStatusDialog(
      context,
      examTitle: exam.title,
      currentStatus: exam.status,
    );

    if (newStatus != null && newStatus != exam.status) {
      try {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );

        // Call update status API
        final updateStatusDto = UpdateExamStatusDto(status: newStatus);
        final useCase = ref.read(updateExamStatusUseCaseProvider);
        await useCase(
          UpdateExamStatusParams(examId: exam.id, dto: updateStatusDto),
        );

        // Hide loading
        Navigator.of(context).pop();

        // Show success message
        ToastUtils.showSuccess(
          context: context,
          message: 'Cập nhật trạng thái bài thi thành công!',
        );

        // Refresh exams list
        ref.refresh(teacherExamsProvider(widget.classroomId));
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

  Future<void> _showDeleteConfirmation(ExamTeacherResponseDto exam) async {
    final shouldDelete = await ConfirmDialogHelper.showCustomConfirmation(
      context,
      title: 'Xác nhận xóa',
      content: DeleteExamContent(examTitle: exam.title),
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

        // Call delete API
        final useCase = ref.read(deleteExamUseCaseProvider);
        await useCase(exam.id);

        // Hide loading
        Navigator.of(context).pop();

        // Show success message
        ToastUtils.showSuccess(
          context: context,
          message: 'Xóa bài thi thành công',
        );

        // Refresh exams list
        ref.refresh(teacherExamsProvider(widget.classroomId));
      } catch (e) {
        // Hide loading
        Navigator.of(context).pop();

        // Show error message
        ToastUtils.showFail(
          context: context,
          message: 'Xóa bài thi thất bại: ${e.toString()}',
        );
      }
    }
  }
}

// Content widget for deleting exam confirmation
class DeleteExamContent extends StatelessWidget {
  final String examTitle;

  const DeleteExamContent({super.key, required this.examTitle});

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
              const TextSpan(text: 'Bạn có chắc chắn muốn xoá bài thi '),
              TextSpan(
                text: '"$examTitle"',
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
                text: ' đến bài thi này. Thao tác không thể hoàn tác.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
