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
import '../../../../../data/dto/classroom_dto.dart';
import '../../../../../data/dto/teacher_classroom_dto.dart';
import '../../classroom/teacher_classroom_details_screen.dart';
import '../../classroom/create_classroom_screen.dart';

class TeacherClassroomCard extends StatelessWidget {
  final ClassroomTeacher classroom;
  final VoidCallback? onTap;

  const TeacherClassroomCard({super.key, required this.classroom, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isClassActive =
        classroom.status != EClassroomStatus.ENROLLING &&
        classroom.status != EClassroomStatus.CANCELED;

    // Get background color based on classroom status
    String backgroundColor = '#fff';
    if (ClassroomStatusBackgroundColor.colors.containsKey(
      ClassroomStatus.fromString(classroom.status.value),
    )) {
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
          if (classroom.status == EClassroomStatus.ENROLLING) {
            ToastUtils.showWarning(
              context: context,
              message: 'Lớp học này đang trong quá trình tuyển sinh.',
            );
            return;
          }

          if (!isClassActive) {
            if (classroom.status == EClassroomStatus.CANCELED) {
              ToastUtils.showFail(
                context: context,
                message: 'Lớp học này đã bị hủy.',
              );
            } else {
              ToastUtils.showWarning(
                context: context,
                message:
                    'Lớp học hiện tại đang trong quá trình tuyển sinh và xếp lịch.',
              );
            }
            return;
          }

          // Navigate to details screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) =>
                      TeacherClassroomDetailsScreen(classroomId: classroom.id),
            ),
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
                  // Header with title and dropdown menu
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          classroom.name,
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: AppColors.textSecondary,
                        ),
                        onSelected:
                            (value) => _handleMenuAction(context, value),
                        itemBuilder:
                            (context) => [
                              if (classroom.status !=
                                  EClassroomStatus.FINISHED) ...[
                                const PopupMenuItem(
                                  value: 'edit-info',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 16),
                                      SizedBox(width: 8),
                                      Text('Chỉnh sửa thông tin'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'edit-status',
                                  child: Row(
                                    children: [
                                      Icon(Icons.update, size: 16),
                                      SizedBox(width: 8),
                                      Text('Cập nhật trạng thái'),
                                    ],
                                  ),
                                ),
                              ],
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Xóa',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                      ),
                    ],
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
            if (classroom.status == EClassroomStatus.ONGOING)
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

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit-info':
        // Navigate to CreateClassroomScreen in edit mode
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => CreateClassroomScreen(
                  classroom: _convertToClassroomDetailsDto(),
                ),
          ),
        );
        break;
      case 'edit-status':
        ToastUtils.showSuccess(
          context: context,
          message: 'Chức năng cập nhật trạng thái sẽ được thêm sau',
        );
        break;
      case 'delete':
        ToastUtils.showSuccess(
          context: context,
          message: 'Chức năng xóa lớp học sẽ được thêm sau',
        );
        break;
    }
  }

  // Convert ClassroomTeacher to ClassroomDetailsTeacherResponseDto for edit mode
  ClassroomDetailsTeacherResponseDto _convertToClassroomDetailsDto() {
    return ClassroomDetailsTeacherResponseDto(
      id: classroom.id,
      name: classroom.name,
      code: classroom.code.value,
      joinCode: classroom.joinCode,
      grade: classroom.grade.value,
      status: classroom.status.value,
      lessonSessionCount: classroom.lessonSessionCount,
      lessonLearnedCount: classroom.lessonLearnedCount,
      startDate: classroom.startDate.toIso8601String(),
      endDate: classroom.endDate.toIso8601String(),
      totalStudents: classroom.totalStudents,
      schedule:
          classroom.schedule
              .map(
                (s) => ScheduleResponseDto(
                  dayOfWeek: s.dayOfWeek,
                  startTime: s.startTime,
                  endTime: s.endTime,
                ),
              )
              .toList(),
      lessonSessions:
          classroom.lessonSessions
              .map(
                (ls) => LessonSessionResponseDto(
                  id: ls.id,
                  date: ls.date.toIso8601String(),
                  startTime: ls.startTime,
                  endTime: ls.endTime,
                  status: ls.status,
                  note: ls.note,
                  originalSessionId: ls.originalSessionId,
                ),
              )
              .toList(),
      teacher: null, // Will be filled by API
      studentsCount: classroom.totalStudents,
      pendingStudentCount: 0, // Will be filled by API
      chaptersCount: 0, // Will be filled by API
      practiceSetsCount: 0, // Will be filled by API
      examsCount: 0, // Will be filled by API
    );
  }
}
