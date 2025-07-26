import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/classroom_constants.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/classroom_status_constants.dart';
import '../../../../../core/constants/grade_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/toast_utils.dart';
import '../../../../../core/widgets/confirm_dialog.dart';
import '../../../../../core/widgets/update_classroom_status_dialog.dart';
import '../../../../../domain/entities/classroom.dart';
import '../../../../../data/dto/classroom_dto.dart';
import '../../../../../providers/teacher_classroom/teacher_classroom_providers.dart';
import '../../../../../domain/usecases/teacher_classroom/update_classroom_status_usecase.dart';
import '../../../../../data/dto/teacher_classroom_dto.dart';
import '../../classroom/teacher_classroom_details_screen.dart';
import '../../classroom/create_classroom_screen.dart';

class TeacherClassroomCard extends ConsumerWidget {
  final ClassroomTeacher classroom;
  final VoidCallback? onTap;

  const TeacherClassroomCard({super.key, required this.classroom, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          if (classroom.status == EClassroomStatus.CANCELED) {
            ToastUtils.showFail(
              context: context,
              message: 'Lớp học này đã bị hủy.',
            );
            return;
          }

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
                            (value) => _handleMenuAction(context, ref, value),
                        itemBuilder:
                            (context) => [
                              if (classroom.status !=
                                  EClassroomStatus.FINISHED) ...[
                                const PopupMenuItem(
                                  value: 'edit-info',
                                  child: Text('Chỉnh sửa thông tin'),
                                ),
                                const PopupMenuItem(
                                  value: 'edit-status',
                                  child: Text('Cập nhật trạng thái'),
                                ),
                              ],
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text(
                                  'Xóa',
                                  style: TextStyle(color: Colors.red),
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

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
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
        _showUpdateStatusDialog(context, ref);
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await ConfirmDialogHelper.showDeleteConfirmation(
      context,
      itemName: classroom.name,
      customContent: DeleteClassroomContent(className: classroom.name),
    );

    if (confirmed) {
      // TODO: Implement delete classroom functionality
      ToastUtils.showSuccess(
        context: context,
        message: 'Chức năng xóa lớp học sẽ được thêm sau',
      );
    }
  }

  Future<void> _showUpdateStatusDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final newStatus = await UpdateClassroomStatusHelper.showUpdateStatusDialog(
      context,
      className: classroom.name,
      currentStatus: classroom.status,
    );

    if (newStatus != null && newStatus != classroom.status) {
      try {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );

        // Create DTO
        final updateStatusDto = UpdateClassroomStatusDto(status: newStatus);

        // Call API
        final useCase = ref.read(updateClassroomStatusUseCaseProvider);
        final result = await useCase(
          UpdateClassroomStatusParams(
            classroomId: classroom.id,
            dto: updateStatusDto,
          ),
        );

        // Hide loading
        Navigator.of(context).pop();

        // Show success
        ToastUtils.showSuccess(
          context: context,
          message: 'Cập nhật trạng thái lớp học thành công!',
        );

        print(
          '✅ Updated classroom status: ${result.name} - ${result.status.value}',
        );

        // Refresh the classrooms list
        ref.invalidate(teacherClassroomsProvider);
      } catch (e) {
        // Hide loading
        Navigator.of(context).pop();

        // Show error
        ToastUtils.showFail(
          context: context,
          message: 'Cập nhật trạng thái thất bại: ${e.toString()}',
        );

        print('❌ Failed to update classroom status: $e');
      }
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
