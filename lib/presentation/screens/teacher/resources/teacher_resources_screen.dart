import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/subject_dto.dart';
import '../../../../providers/subjects/subjects_providers.dart';
import 'create_subject_screen.dart';

class TeacherResourcesScreen extends ConsumerStatefulWidget {
  const TeacherResourcesScreen({super.key});

  @override
  ConsumerState<TeacherResourcesScreen> createState() =>
      _TeacherResourcesScreenState();
}

class _TeacherResourcesScreenState
    extends ConsumerState<TeacherResourcesScreen> {
  @override
  Widget build(BuildContext context) {
    final subjectsAsync = ref.watch(subjectsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kho tài liệu', style: AppTextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          // Create subject button
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateSubjectScreen(),
                  ),
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
      body: subjectsAsync.when(
        data: (subjects) => _buildSubjectsList(subjects),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải danh sách môn học',
                onRetry: () {
                  ref.invalidate(subjectsProvider);
                },
              ),
            ),
      ),
    );
  }

  Widget _buildSubjectsList(List<SubjectResponseDto> subjects) {
    if (subjects.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message: 'Chưa có môn học nào',
          showAction: false,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(subjectsProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return _buildSubjectCard(subject);
        },
      ),
    );
  }

  Widget _buildSubjectCard(SubjectResponseDto subject) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to subject details or resources
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Chức năng xem tài liệu cho ${subject.name} sẽ sớm có mặt!',
              ),
              backgroundColor: AppColors.primary,
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
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
                      subject.name,
                      style: AppTextStyles.titleMedium.copyWith(
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
                      color:
                          subject.isActive
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subject.isActive ? 'Hoạt động' : 'Không hoạt động',
                      style: AppTextStyles.bodySmall.copyWith(
                        color:
                            subject.isActive
                                ? AppColors.success
                                : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Subject Code and Grade
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      subject.code,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getGradeLabel(subject.grade),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.info,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              // Description
              if (subject.description != null &&
                  subject.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  subject.description!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Created Date
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tạo ngày: ${_formatDate(subject.createdDate)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              // Arrow
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Xem tài liệu',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGradeLabel(String grade) {
    switch (grade.toUpperCase()) {
      case 'GRADE_10':
        return 'Lớp 10';
      case 'GRADE_11':
        return 'Lớp 11';
      case 'GRADE_12':
        return 'Lớp 12';
      default:
        return grade;
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Chưa có';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
