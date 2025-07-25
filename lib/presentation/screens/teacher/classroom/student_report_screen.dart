import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/statistical_dto.dart';
import '../../../../data/dto/teacher_classroom_dto.dart';
import '../../../../providers/statistical/statistical_providers.dart';
import '../../../../providers/teacher_classroom/teacher_classroom_providers.dart';
import 'student_progress_detail_screen.dart';

class StudentReportScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final String classroomName;

  const StudentReportScreen({
    super.key,
    required this.classroomId,
    required this.classroomName,
  });

  @override
  ConsumerState<StudentReportScreen> createState() =>
      _StudentReportScreenState();
}

class _StudentReportScreenState extends ConsumerState<StudentReportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(
      approvedStudentsProvider(widget.classroomId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Báo cáo theo học sinh',
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
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppDimensions.defaultPadding),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm học sinh...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.grey300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.grey300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Students List
          Expanded(
            child: studentsAsync.when(
              data: (students) => _buildStudentsList(students),
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) => Center(
                    child: EmptyStateWidgets.error(
                      message: 'Không thể tải danh sách học sinh',
                      onRetry: () {
                        ref.invalidate(
                          approvedStudentsProvider(widget.classroomId),
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

  Widget _buildStudentsList(List<StudentResponseDto> students) {
    // Filter students based on search query
    final filteredStudents =
        students.where((student) {
          return student.fullName.toLowerCase().contains(_searchQuery) ||
              student.phone.toLowerCase().contains(_searchQuery);
        }).toList();

    if (filteredStudents.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message:
              _searchQuery.isEmpty
                  ? 'Chưa có học sinh nào'
                  : 'Không tìm thấy học sinh',
          showAction: false,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(approvedStudentsProvider(widget.classroomId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        itemCount: filteredStudents.length,
        itemBuilder: (context, index) {
          final student = filteredStudents[index];
          return _buildStudentCard(student);
        },
      ),
    );
  }

  Widget _buildStudentCard(StudentResponseDto student) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => StudentProgressDetailScreen(
                    classroomId: widget.classroomId,
                    classroomName: widget.classroomName,
                    studentId: student.id,
                    studentName: student.fullName,
                  ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
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
              ),
              const SizedBox(width: 16),

              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.phone,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (student.address != null &&
                        student.address!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        student.address!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
