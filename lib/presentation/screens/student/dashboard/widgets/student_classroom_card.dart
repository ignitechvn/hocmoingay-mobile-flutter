import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/classroom_constants.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/classroom_status_constants.dart';
import '../../../../../core/constants/grade_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/toast_utils.dart';
import '../../../../../domain/entities/classroom.dart';

class StudentClassroomCard extends StatelessWidget {
  final ClassroomStudent classroom;
  final VoidCallback? onTap;

  const StudentClassroomCard({super.key, required this.classroom, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isWaitingStudentConfirm =
        classroom.studentStatus == ClassroomStudentStatus.waitingStudentConfirm;
    final isApproved =
        classroom.studentStatus == ClassroomStudentStatus.actived;
    final isClassActive =
        classroom.status != EClassroomStatus.ENROLLING &&
        classroom.status != EClassroomStatus.CANCELED;

    final isHoverable = isApproved && isClassActive;

    // Get background color
    String backgroundColor = '#fff';

    // Priority: Classroom status first for specific cases, then student status
    if (classroom.status == EClassroomStatus.ENROLLING) {
      // Enrolling classrooms always use enrolling color
      backgroundColor =
          ClassroomStatusBackgroundColor.colors[ClassroomStatus.enrolling] ??
          '#fff';
    } else if (StudentClassroomStatusBackgroundColor.colors.containsKey(
      classroom.studentStatus,
    )) {
      // Use student status color for other cases
      backgroundColor =
          StudentClassroomStatusBackgroundColor.colors[classroom
              .studentStatus] ??
          '#fff';
    } else {
      // Fallback to classroom status color
      backgroundColor =
          ClassroomStatusBackgroundColor.colors[ClassroomStatus.fromString(
            classroom.status.value,
          )] ??
          '#fff';
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Color(int.parse(backgroundColor.replaceAll('#', '0xFF'))),
      child: InkWell(
        onTap: () {
          if (isWaitingStudentConfirm) {
            // TODO: Show join class dialog
            ToastUtils.showWarning(
              context: context,
              message: 'Chức năng xác nhận tham gia lớp học sẽ được thêm sau',
            );
            return;
          }

          if (!isApproved) {
            ToastUtils.showWarning(
              context: context,
              message: 'Bạn chưa được phê duyệt vào lớp học này.',
            );
            return;
          }

          // Check if classroom is in enrolling status - backend will reject this
          if (classroom.status == EClassroomStatus.ENROLLING) {
            ToastUtils.showWarning(
              context: context,
              message:
                  'Lớp học này đang trong quá trình tuyển sinh. Vui lòng đợi khi lớp học chính thức bắt đầu để xem chi tiết',
            );
            return;
          }

          if (!isClassActive) {
            if (classroom.status == EClassroomStatus.CANCELED) {
              ToastUtils.showFail(
                context: context,
                message:
                    'Lớp học này đã bị hủy bởi giáo viên hoặc quản trị viên.',
              );
            } else {
              ToastUtils.showWarning(
                context: context,
                message:
                    'Lớp học hiện tại đang trong quá trình tuyển sinh và xếp lịch, Vui lòng đợi thông báo của giáo viên khi lớp chính thức bắt đầu.',
              );
            }
            return;
          }

          // Navigate to classroom detail
          Navigator.of(context).pushNamed(
            '/classroom-details',
            arguments: {'classroomId': classroom.id},
          );

          onTap?.call();
        },
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    classroom.name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        const TextSpan(text: 'Giáo viên '),
                        TextSpan(
                          text: classroom.teacher.fullName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' phụ trách'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Class info
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        const TextSpan(text: 'Lớp học dạy môn '),
                        TextSpan(
                          text: SubjectLabels.getLabel(classroom.code),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ', cho học sinh '),
                        TextSpan(
                          text: classroom.grade.label,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ', số lượng thành viên tham gia '),
                        TextSpan(
                          text: '${classroom.totalStudents}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' học sinh'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Schedule info
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        const TextSpan(text: 'Lịch học trong tuần '),
                        TextSpan(
                          text:
                              classroom.schedule.isNotEmpty
                                  ? convertScheduleListToText(
                                    classroom.schedule,
                                  ).join(", ")
                                  : "Chưa có lịch học",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Date info
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        const TextSpan(text: 'Thời gian khóa học '),
                        TextSpan(
                          text: formatDatetimeToDDMMYYYY(classroom.startDate),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' – '),
                        TextSpan(
                          text: formatDatetimeToDDMMYYYY(classroom.endDate),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Progress indicator for ongoing classes - positioned at bottom right
            if (classroom.status == EClassroomStatus.ONGOING &&
                classroom.studentStatus == ClassroomStudentStatus.actived)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      '${classroom.lessonSessionCount > 0 ? ((classroom.lessonLearnedCount / classroom.lessonSessionCount) * 100).round() : 0}%',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
