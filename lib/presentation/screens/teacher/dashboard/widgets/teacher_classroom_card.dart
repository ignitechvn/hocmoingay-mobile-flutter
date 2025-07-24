import 'package:flutter/material.dart';
import 'package:hocmoingay/core/constants/app_constants.dart';
import 'package:hocmoingay/core/constants/grade_constants.dart';
import 'package:hocmoingay/core/constants/classroom_status_constants.dart';
import 'package:hocmoingay/core/constants/classroom_constants.dart';
import 'package:hocmoingay/core/theme/app_colors.dart';
import 'package:hocmoingay/core/theme/app_text_styles.dart';
import 'package:hocmoingay/domain/entities/classroom.dart';

class TeacherClassroomCard extends StatelessWidget {
  final ClassroomTeacher classroom;
  final VoidCallback? onTap;

  const TeacherClassroomCard({super.key, required this.classroom, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.grey300.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with subject and status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      SubjectLabels.getLabel(classroom.code),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      classroom.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 12),

              // Grade and students info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      classroom.grade.label,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${classroom.totalStudents} học sinh',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress and lessons info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tiến độ học tập',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: classroom.progressPercentage / 100,
                          backgroundColor: AppColors.grey300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getStatusColor(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${classroom.lessonLearnedCount}/${classroom.lessonSessionCount} buổi học',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Thời gian',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatDate(classroom.startDate)} - ${_formatDate(classroom.endDate)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(),
        style: AppTextStyles.bodySmall.copyWith(
          color: _getStatusColor(),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (classroom.status) {
      case EClassroomStatus.ENROLLING:
        return AppColors.warning;
      case EClassroomStatus.ONGOING:
        return AppColors.success;
      case EClassroomStatus.FINISHED:
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText() {
    switch (classroom.status) {
      case EClassroomStatus.ENROLLING:
        return 'Đang đăng ký';
      case EClassroomStatus.ONGOING:
        return 'Đang học';
      case EClassroomStatus.FINISHED:
        return 'Đã kết thúc';
      default:
        return 'Không xác định';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}
