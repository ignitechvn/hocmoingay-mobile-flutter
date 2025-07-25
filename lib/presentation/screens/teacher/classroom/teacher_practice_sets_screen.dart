import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/practice_set_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/practice_set_dto.dart';
import '../../../../providers/teacher_practice_sets/teacher_practice_sets_providers.dart';
import '../widgets/practice_set_status_filter_bar.dart';
import 'create_practice_set_screen.dart';

class TeacherPracticeSetsScreen extends ConsumerStatefulWidget {
  const TeacherPracticeSetsScreen({super.key, required this.classroomId});
  final String classroomId;

  @override
  ConsumerState<TeacherPracticeSetsScreen> createState() =>
      _TeacherPracticeSetsScreenState();
}

class _TeacherPracticeSetsScreenState
    extends ConsumerState<TeacherPracticeSetsScreen> {
  int _selectedStatusIndex = 0;

  @override
  Widget build(BuildContext context) {
    final practiceSetsAsync = ref.watch(
      teacherPracticeSetsProvider(widget.classroomId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Quản lý bài tập',
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
                        (context) => CreatePracticeSetScreen(
                          classroomId: widget.classroomId,
                        ),
                  ),
                );

                // Refresh data if practice set was created successfully
                if (result == true) {
                  ref.refresh(teacherPracticeSetsProvider(widget.classroomId));
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
          PracticeSetStatusFilterBar(
            selectedIndex: _selectedStatusIndex,
            onStatusChanged: (index) {
              setState(() {
                _selectedStatusIndex = index;
              });
            },
          ),

          // Practice Sets List
          Expanded(
            child: practiceSetsAsync.when(
              data: (practiceSets) => _buildContent(context, practiceSets),
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stackTrace) => Center(
                    child: EmptyStateWidgets.error(
                      message: 'Không thể tải danh sách bài tập',
                      onRetry: () {
                        ref.invalidate(
                          teacherPracticeSetsProvider(widget.classroomId),
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
    TeacherPracticeSetResponseListDto practiceSets,
  ) {
    List<PracticeSetTeacherResponseDto> filteredPracticeSets = [];

    // Filter practice sets based on selected status
    switch (_selectedStatusIndex) {
      case 0: // Đã lên lịch
        filteredPracticeSets = practiceSets.scheduledPracticeSets;
        break;
      case 1: // Đang mở
        filteredPracticeSets = practiceSets.openPracticeSets;
        break;
      case 2: // Đã đóng
        filteredPracticeSets = practiceSets.closedPracticeSets;
        break;
    }

    if (filteredPracticeSets.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message: 'Chưa có bài tập nào',
          showAction: true,
          actionText: 'Làm mới',
          onActionPressed:
              () =>
                  ref.refresh(teacherPracticeSetsProvider(widget.classroomId)),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(teacherPracticeSetsProvider(widget.classroomId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        itemCount: filteredPracticeSets.length,
        itemBuilder: (context, index) {
          final practiceSet = filteredPracticeSets[index];
          return _buildPracticeSetCard(practiceSet);
        },
      ),
    );
  }

  Widget _buildPracticeSetCard(PracticeSetTeacherResponseDto practiceSet) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to practice set details screen
        ToastUtils.showSuccess(
          context: context,
          message: 'Chức năng xem chi tiết bài tập sẽ được thêm sau',
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        decoration: BoxDecoration(
          color: Color(_getStatusBackgroundColor(practiceSet.status)),
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
                    practiceSet.title,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _handlePracticeSetAction(value, practiceSet);
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
                        if (practiceSet.status != EPracticeSetStatus.CLOSED)
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
            if (practiceSet.description != null &&
                practiceSet.description!.isNotEmpty)
              Text(
                practiceSet.description!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

            const SizedBox(height: 12),

            // Row 3: Stats and Assignment Info
            Row(
              children: [
                // Left column: Question count and date range
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${practiceSet.questionCount} câu hỏi',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_formatDate(practiceSet.startDate ?? '')} - ${_formatDate(practiceSet.deadline ?? '')}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right column: Assignment info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    practiceSet.assignToAll
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
                                text:
                                    '${practiceSet.assignedStudentCount ?? 0}',
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
          ],
        ),
      ),
    );
  }

  Future<void> _handlePracticeSetAction(
    String action,
    PracticeSetTeacherResponseDto practiceSet,
  ) async {
    switch (action) {
      case 'update_info':
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => CreatePracticeSetScreen(
                  classroomId: widget.classroomId,
                  practiceSet: practiceSet,
                ),
          ),
        );

        // Refresh data if practice set was updated successfully
        if (result == true) {
          ref.refresh(teacherPracticeSetsProvider(widget.classroomId));
        }
        break;
      case 'update_status':
        // TODO: Show status update dialog
        ToastUtils.showSuccess(
          context: context,
          message: 'Chức năng cập nhật trạng thái sẽ được thêm sau',
        );
        break;
      case 'delete':
        // TODO: Show confirmation dialog and delete practice set
        ToastUtils.showSuccess(
          context: context,
          message: 'Chức năng xóa bài tập sẽ được thêm sau',
        );
        break;
    }
  }

  int _getStatusBackgroundColor(EPracticeSetStatus status) {
    switch (status) {
      case EPracticeSetStatus.SCHEDULED:
        return 0xFFECF4FE; // Light blue
      case EPracticeSetStatus.OPEN:
        return 0xFFE2F7F0; // Light green
      case EPracticeSetStatus.CLOSED:
        return 0xFFFDE9E9; // Light red
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Chưa xác định';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
