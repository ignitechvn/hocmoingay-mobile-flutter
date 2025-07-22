import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../domain/entities/classroom.dart';
import '../../../../../providers/student_classroom/student_classroom_providers.dart';
import '../widgets/status_filter_bar.dart';
import '../widgets/classroom_card.dart';

class ClassesTab extends ConsumerStatefulWidget {
  const ClassesTab({super.key});

  @override
  ConsumerState<ClassesTab> createState() => _ClassesTabState();
}

class _ClassesTabState extends ConsumerState<ClassesTab> {
  int _selectedStatusIndex = 0;

  @override
  Widget build(BuildContext context) {
    final classroomsAsync = ref.watch(studentClassroomsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Lớp học của tôi',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Status Filter Bar
          StatusFilterBar(
            selectedIndex: _selectedStatusIndex,
            onStatusChanged: (index) {
              setState(() {
                _selectedStatusIndex = index;
              });
            },
          ),

          // Classrooms List
          Expanded(
            child: classroomsAsync.when(
              data: (classrooms) => _buildClassroomsList(classrooms),
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Có lỗi xảy ra',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Vui lòng thử lại sau',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassroomsList(StudentClassrooms classrooms) {
    List<ClassroomStudent> selectedClassrooms = [];

    switch (_selectedStatusIndex) {
      case 0:
        selectedClassrooms = classrooms.enrollingClassrooms;
        break;
      case 1:
        selectedClassrooms = classrooms.ongoingClassrooms;
        break;
      case 2:
        selectedClassrooms = classrooms.finishedClassrooms;
        break;
    }

    if (selectedClassrooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.class_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có lớp học nào',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy đăng ký lớp học đầu tiên',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: selectedClassrooms.length,
      itemBuilder: (context, index) {
        final classroom = selectedClassrooms[index];
        return ClassroomCard(
          classroom: classroom,
          selectedStatusIndex: _selectedStatusIndex,
          onActionPressed: () => _handleClassroomAction(classroom),
        );
      },
    );
  }

  void _handleClassroomAction(ClassroomStudent classroom) {
    // TODO: Implement classroom actions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chức năng đang được phát triển'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
