import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../domain/entities/classroom.dart';

class ClassroomCard extends StatelessWidget {
  final ClassroomStudent classroom;
  final int selectedStatusIndex;
  final VoidCallback? onActionPressed;

  const ClassroomCard({
    super.key,
    required this.classroom,
    required this.selectedStatusIndex,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Left side - Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _getSubjectIcon(classroom.code.value),
                size: 28,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 16),

            // Right side - Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    classroom.name,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Teacher info
                  Text(
                    'GV: ${classroom.teacher.fullName}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Progress bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tiến độ học tập',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${classroom.lessonLearnedCount}/${classroom.lessonSessionCount}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: classroom.progressPercentage / 100,
                        backgroundColor: AppColors.grey300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Action button (if applicable)
                  if (_shouldShowActionButton())
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onActionPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          _getActionButtonText(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSubjectIcon(String code) {
    switch (code.toLowerCase()) {
      case 'math':
      case 'toan':
        return Icons.functions;
      case 'physics':
      case 'vatly':
        return Icons.science;
      case 'chemistry':
      case 'hoahoc':
        return Icons.science_outlined;
      case 'biology':
      case 'sinhhoc':
        return Icons.biotech;
      case 'literature':
      case 'van':
        return Icons.book;
      case 'english':
      case 'tienganh':
        return Icons.language;
      case 'history':
      case 'lichsu':
        return Icons.history_edu;
      case 'geography':
      case 'dialy':
        return Icons.public;
      default:
        return Icons.school;
    }
  }

  bool _shouldShowActionButton() {
    // Show button for enrolling classrooms that need confirmation
    if (selectedStatusIndex == 0) {
      return classroom.isWaitingConfirmation;
    }
    // Show button for ongoing classrooms
    if (selectedStatusIndex == 1) {
      return classroom.isEnrolled;
    }
    return false;
  }

  String _getActionButtonText() {
    if (selectedStatusIndex == 0) {
      if (classroom.studentStatus ==
          ClassroomStudentStatus.waitingStudentConfirm) {
        return 'Xác nhận tham gia';
      }
      return 'Chờ xác nhận';
    }
    if (selectedStatusIndex == 1) {
      return 'Vào học';
    }
    return 'Xem chi tiết';
  }
}
