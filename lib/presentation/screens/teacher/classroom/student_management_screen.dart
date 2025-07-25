import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/teacher_classroom_dto.dart';
import '../../../../providers/teacher_classroom/teacher_classroom_providers.dart';
import '../../../../core/utils/toast_utils.dart';

class StudentManagementScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final String classroomName;

  const StudentManagementScreen({
    super.key,
    required this.classroomId,
    required this.classroomName,
  });

  @override
  ConsumerState<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState
    extends ConsumerState<StudentManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Quản lý học sinh',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          labelStyle: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTextStyles.titleMedium,
          tabs: const [Tab(text: 'Đã phê duyệt'), Tab(text: 'Chờ phê duyệt')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildApprovedStudentsTab(), _buildPendingStudentsTab()],
      ),
    );
  }

  Widget _buildApprovedStudentsTab() {
    final approvedStudentsAsync = ref.watch(
      approvedStudentsProvider(widget.classroomId),
    );

    return approvedStudentsAsync.when(
      data: (approvedStudents) {
        // Filter students based on search query
        final filteredStudents =
            approvedStudents.where((student) {
              if (_searchQuery.isEmpty) return true;
              return student.fullName.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  student.phone.contains(_searchQuery) ||
                  (student.address != null &&
                      student.address!.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ));
            }).toList();

        return Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm học sinh...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey500,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon:
                      _searchQuery.isNotEmpty
                          ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                          : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            // Students List
            Expanded(
              child:
                  filteredStudents.isEmpty
                      ? _searchQuery.isNotEmpty
                          ? EmptyStateWidgets.noData(
                            message: 'Không tìm thấy học sinh nào',
                          )
                          : EmptyStateWidgets.noData(
                            message: 'Chưa có học sinh nào được phê duyệt',
                          )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = filteredStudents[index];
                          return _buildStudentCard(student, isApproved: true);
                        },
                      ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => EmptyStateWidgets.error(
            message: 'Có lỗi xảy ra\n${error.toString()}',
            onRetry:
                () => ref.refresh(approvedStudentsProvider(widget.classroomId)),
            icon: Icons.error_outline,
          ),
    );
  }

  Widget _buildPendingStudentsTab() {
    final pendingStudentsAsync = ref.watch(
      pendingStudentsProvider(widget.classroomId),
    );

    return pendingStudentsAsync.when(
      data: (pendingStudents) {
        if (pendingStudents.isEmpty) {
          return EmptyStateWidgets.noData(
            message: 'Chưa có học sinh nào chờ phê duyệt',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pendingStudents.length,
          itemBuilder: (context, index) {
            final student = pendingStudents[index];
            return _buildStudentCard(student, isApproved: false);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => EmptyStateWidgets.error(
            message: 'Có lỗi xảy ra\n${error.toString()}',
            onRetry:
                () => ref.refresh(pendingStudentsProvider(widget.classroomId)),
            icon: Icons.error_outline,
          ),
    );
  }

  Widget _buildStudentCard(dynamic student, {required bool isApproved}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                student.fullName.isNotEmpty
                    ? student.fullName[0].toUpperCase()
                    : '?',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.fullName,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student.phone,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (student.address != null &&
                      student.address!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      student.address!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // More Options Button (only for approved students)
            if (isApproved) ...[
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.textSecondary,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'remove':
                      _removeStudent(student.id);
                      break;
                  }
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem<String>(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_remove,
                              color: AppColors.error,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Xóa khỏi lớp',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
              ),
            ],

            // Action Buttons (only for pending students)
            if (!isApproved) ...[
              const SizedBox(width: 8),
              _buildActionButton(
                'Phê duyệt',
                Icons.check,
                AppColors.success,
                () => _approveStudent(student.id),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                'Từ chối',
                Icons.close,
                AppColors.error,
                () => _rejectStudent(student.id),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _approveStudent(String studentId) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Call API
      final useCase = ref.read(approveStudentUseCaseProvider);
      await useCase({
        'classroomId': widget.classroomId,
        'studentId': studentId,
      });

      // Hide loading
      Navigator.of(context).pop();

      // Show success message
      ToastUtils.showSuccess(
        context: context,
        message: 'Đã phê duyệt học sinh thành công',
      );

      // Refresh both tabs data
      ref.refresh(approvedStudentsProvider(widget.classroomId));
      ref.refresh(pendingStudentsProvider(widget.classroomId));
    } catch (e) {
      // Hide loading
      Navigator.of(context).pop();

      // Show error message
      ToastUtils.showFail(
        context: context,
        message: 'Phê duyệt học sinh thất bại: ${e.toString()}',
      );
    }
  }

  void _rejectStudent(String studentId) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Call API
      final useCase = ref.read(rejectStudentUseCaseProvider);
      await useCase({
        'classroomId': widget.classroomId,
        'studentId': studentId,
      });

      // Hide loading
      Navigator.of(context).pop();

      // Show success message
      ToastUtils.showSuccess(
        context: context,
        message: 'Đã từ chối học sinh thành công',
      );

      // Refresh pending students data
      ref.refresh(pendingStudentsProvider(widget.classroomId));
    } catch (e) {
      // Hide loading
      Navigator.of(context).pop();

      // Show error message
      ToastUtils.showFail(
        context: context,
        message: 'Từ chối học sinh thất bại: ${e.toString()}',
      );
    }
  }

  void _removeStudent(String studentId) async {
    // Show confirmation dialog
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận'),
            content: const Text(
              'Bạn có chắc chắn muốn xóa học sinh này khỏi lớp?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );

    if (shouldRemove == true) {
      try {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );

        // Call API
        final useCase = ref.read(removeStudentUseCaseProvider);
        await useCase(studentId);

        // Hide loading
        Navigator.of(context).pop();

        // Show success message
        ToastUtils.showSuccess(
          context: context,
          message: 'Đã xóa học sinh khỏi lớp thành công',
        );

        // Refresh data
        ref.refresh(approvedStudentsProvider(widget.classroomId));
      } catch (e) {
        // Hide loading
        Navigator.of(context).pop();

        // Show error message
        ToastUtils.showFail(
          context: context,
          message: 'Xóa học sinh thất bại: ${e.toString()}',
        );
      }
    }
  }
}
