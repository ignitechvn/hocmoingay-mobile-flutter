import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/classroom_constants.dart';
import '../../../../core/constants/classroom_status_constants.dart';
import '../../../../core/constants/grade_constants.dart';
import '../../../../core/constants/subject_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/dto/classroom_dto.dart';
import '../../../../data/dto/teacher_classroom_dto.dart';
import '../../../../providers/teacher_classroom/teacher_classroom_providers.dart';
import '../../../../providers/teacher_chapters/teacher_chapters_providers.dart';
import '../../../../providers/teacher_practice_sets/teacher_practice_sets_providers.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../widgets/chapter_status_filter_bar.dart';
import '../widgets/practice_set_status_filter_bar.dart';
import 'teacher_chapters_screen.dart';
import 'teacher_practice_sets_screen.dart';
import 'create_classroom_screen.dart';
import 'student_management_screen.dart';

class TeacherClassroomDetailsScreen extends ConsumerStatefulWidget {
  final String classroomId;

  const TeacherClassroomDetailsScreen({super.key, required this.classroomId});

  @override
  ConsumerState<TeacherClassroomDetailsScreen> createState() =>
      _TeacherClassroomDetailsScreenState();
}

class _TeacherClassroomDetailsScreenState
    extends ConsumerState<TeacherClassroomDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final classroomDetailsAsync = ref.watch(
      teacherClassroomDetailsProvider(widget.classroomId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Chi tiết lớp học',
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
        actions: [
          // Edit button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                classroomDetailsAsync.whenData((classroom) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              CreateClassroomScreen(classroom: classroom),
                    ),
                  );
                });
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
                  Icons.edit,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
          // Settings button
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                ToastUtils.showSuccess(
                  context: context,
                  message: 'Chức năng cài đặt sẽ được thêm sau',
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
                  Icons.settings,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: classroomDetailsAsync.when(
        data: (classroomDetails) => _buildContent(context, classroomDetails),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => EmptyStateWidgets.error(
              message: 'Có lỗi xảy ra\n${error.toString()}',
              onRetry:
                  () => ref.refresh(
                    teacherClassroomDetailsProvider(widget.classroomId),
                  ),
              icon: Icons.error_outline,
            ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ClassroomDetailsTeacherResponseDto classroom,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildHeaderCard(context, classroom),
          const SizedBox(height: 16),

          // Statistics Cards
          _buildStatisticsCards(classroom),
          const SizedBox(height: 16),

          // Schedule Section
          _buildScheduleSection(classroom),
          const SizedBox(height: 16),

          // Actions Section
          _buildActionsSection(context, classroom),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    ClassroomDetailsTeacherResponseDto classroom,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
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
                    classroom.name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(classroom.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusLabel(classroom.status),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Subject and Grade
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
                    SubjectLabels.getLabel(
                      ESubjectCode.fromString(classroom.code),
                    ),
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
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    EGradeLevel.fromString(classroom.grade).label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Join Code
            Row(
              children: [
                const Icon(
                  Icons.link,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mã tham gia: ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  classroom.joinCode,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: classroom.joinCode));
                    ToastUtils.showSuccess(
                      context: context,
                      message: 'Đã copy mã tham gia vào clipboard',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.copy,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date Range
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Thời gian: ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${_formatDate(classroom.startDate ?? '')} - ${_formatDate(classroom.endDate ?? '')}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(ClassroomDetailsTeacherResponseDto classroom) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Học sinh',
          '${classroom.studentsCount ?? 0}',
          Icons.people,
          AppColors.primary,
        ),
        _buildStatCard(
          'Chờ xác nhận',
          '${classroom.pendingStudentCount ?? 0}',
          Icons.pending,
          AppColors.warning,
        ),
        _buildStatCard(
          'Chủ đề',
          '${classroom.chaptersCount ?? 0}',
          Icons.book,
          AppColors.success,
        ),
        _buildStatCard(
          'Bài tập',
          '${classroom.practiceSetsCount ?? 0}',
          Icons.assignment,
          AppColors.info,
        ),
        _buildStatCard(
          'Bài kiểm tra',
          '${classroom.examsCount ?? 0}',
          Icons.quiz,
          AppColors.error,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection(ClassroomDetailsTeacherResponseDto classroom) {
    if (classroom.schedule?.isEmpty ?? true) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: EmptyStateWidgets.noData(message: 'Chưa có lịch học'),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lịch học',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...(classroom.schedule?.map(
                  (schedule) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${_getDayOfWeekText(schedule.dayOfWeek)}: ${schedule.startTime} - ${schedule.endTime}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ) ??
                []),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(
    BuildContext context,
    ClassroomDetailsTeacherResponseDto classroom,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hành động',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => StudentManagementScreen(
                                classroomId: classroom.id,
                                classroomName: classroom.name,
                              ),
                        ),
                      );
                    },
                    text: 'Quản lý học sinh',
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()), // Empty space for alignment
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => TeacherChaptersScreen(
                                classroomId: classroom.id,
                              ),
                        ),
                      );
                    },
                    text: 'Quản lý chủ đề',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => TeacherPracticeSetsScreen(
                                classroomId: classroom.id,
                              ),
                        ),
                      );
                    },
                    text: 'Quản lý bài tập',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      ToastUtils.showSuccess(
                        context: context,
                        message: 'Chức năng quản lý bài thi sẽ được thêm sau',
                      );
                    },
                    text: 'Quản lý bài thi',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      ToastUtils.showSuccess(
                        context: context,
                        message: 'Chức năng xem báo cáo sẽ được thêm sau',
                      );
                    },
                    text: 'Xem báo cáo',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Removed settings button - moved to AppBar
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ENROLLING':
        return AppColors.warning;
      case 'ONGOING':
        return AppColors.success;
      case 'FINISHED':
        return AppColors.info;
      case 'CANCELED':
        return AppColors.error;
      default:
        return AppColors.grey300;
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Chưa có';
    try {
      // Handle JavaScript Date format: "Wed Jul 23 2025 17:00:00 GMT+0000(Coordinated ...)"
      if (dateString.contains('GMT')) {
        // Extract date part and parse
        final parts = dateString.split(' ');
        if (parts.length >= 4) {
          final day = parts[2];
          final month = _getMonthNumber(parts[1]);
          final year = parts[3];
          return '${day.padLeft(2, '0')}/$month/$year';
        }
      }

      // Try parsing as ISO string
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthNumber(String monthName) {
    switch (monthName.toLowerCase()) {
      case 'jan':
        return '01';
      case 'feb':
        return '02';
      case 'mar':
        return '03';
      case 'apr':
        return '04';
      case 'may':
        return '05';
      case 'jun':
        return '06';
      case 'jul':
        return '07';
      case 'aug':
        return '08';
      case 'sep':
        return '09';
      case 'oct':
        return '10';
      case 'nov':
        return '11';
      case 'dec':
        return '12';
      default:
        return '01';
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'ENROLLING':
        return 'Đang tuyển sinh';
      case 'ONGOING':
        return 'Đang học';
      case 'FINISHED':
        return 'Đã kết thúc';
      case 'CANCELED':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  String _getDayOfWeekText(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Thứ 2';
      case 2:
        return 'Thứ 3';
      case 3:
        return 'Thứ 4';
      case 4:
        return 'Thứ 5';
      case 5:
        return 'Thứ 6';
      case 6:
        return 'Thứ 7';
      case 7:
        return 'Chủ nhật';
      default:
        return 'Không xác định';
    }
  }
}
