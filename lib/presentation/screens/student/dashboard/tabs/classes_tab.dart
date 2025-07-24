import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/error/api_error_handler.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/empty_state_widget.dart';
import '../../../../../domain/entities/classroom.dart';
import '../../../../../providers/student_classroom/student_classroom_providers.dart';
import '../widgets/status_filter_bar.dart';
import '../widgets/classroom_card_v2.dart';
import '../widgets/join_classroom_dialog.dart';

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
      backgroundColor: Colors.white,
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
        actions: [
          // Join class button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const JoinClassroomDialog(),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
          // Schedule button
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/schedule');
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today,
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
              error: (error, stack) {
                final errorMessage =
                    ApiErrorHandler.parseErrorResponse(error)?.message ??
                    'Đã xảy ra lỗi không xác định';
                return EmptyStateWidgets.error(
                  message: errorMessage,
                  onRetry: () => ref.refresh(studentClassroomsProvider),
                );
              },
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
      return EmptyStateWidgets.noClassrooms(
        onRefresh: () => ref.refresh(studentClassroomsProvider),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: selectedClassrooms.length,
      itemBuilder: (context, index) {
        final classroom = selectedClassrooms[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ClassroomCardV2(
            classroom: classroom,
            onTap: () => _handleClassroomAction(classroom),
          ),
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
