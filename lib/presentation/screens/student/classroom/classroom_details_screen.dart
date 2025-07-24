import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/classroom_constants.dart';
import '../../../../core/error/api_error_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/classroom_details_dto.dart';
import '../../../../data/dto/classroom_dto.dart';
import '../../../../providers/student_classroom/student_classroom_providers.dart';

class ClassroomDetailsScreen extends ConsumerWidget {
  const ClassroomDetailsScreen({super.key, required this.classroomId});
  final String classroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classroomDetailsAsync = ref.watch(
      classroomDetailsProvider(classroomId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Chi tiết lớp học',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: classroomDetailsAsync.when(
        data: (classroom) => _buildContent(context, classroom),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          // Use ApiErrorHandler to get user-friendly message
          final errorResponse = ApiErrorHandler.parseErrorResponse(error);
          String errorMessage = 'Không thể tải thông tin lớp học';

          if (errorResponse != null) {
            errorMessage = ApiErrorHandler.getUserFriendlyMessage(
              errorResponse,
            );
          }

          return Center(
            child: EmptyStateWidgets.error(
              message: errorMessage,
              onRetry: () {
                ref.invalidate(classroomDetailsProvider(classroomId));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ClassroomDetailsStudentResponseDto classroom,
  ) => RefreshIndicator(
    onRefresh: () async {
      // Refresh data
    },
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildHeaderCard(classroom),

          const SizedBox(height: 16),

          // Teacher Info Card
          _buildTeacherCard(classroom.teacher),

          const SizedBox(height: 16),

          // Statistics Cards
          _buildStatisticsCards(classroom),

          const SizedBox(height: 16),

          // Schedule Card
          if (classroom.schedule.isNotEmpty) ...[
            _buildScheduleCard(classroom.schedule),
            const SizedBox(height: 16),
          ],

          // Lesson Sessions Card
          if (classroom.lessonSessions.isNotEmpty) ...[
            _buildLessonSessionsCard(classroom.lessonSessions),
          ],
        ],
      ),
    ),
  );

  Widget _buildHeaderCard(
    ClassroomDetailsStudentResponseDto classroom,
  ) => Container(
    padding: const EdgeInsets.all(AppDimensions.defaultPadding),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ClassroomConstants.getStatusColor(
                  classroom.status.value,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                ClassroomConstants.getStatusText(classroom.status.value),
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Subject and Grade
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                classroom.code.value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Lớp ${classroom.grade.label}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Progress
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
                  Text(
                    '${classroom.lessonLearnedCount}/${classroom.lessonSessionCount} buổi học',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tổng học sinh',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${classroom.totalStudents} học sinh',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildTeacherCard(TeacherDto teacher) => Container(
    padding: const EdgeInsets.all(AppDimensions.defaultPadding),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Giáo viên phụ trách',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                teacher.fullName.isNotEmpty
                    ? teacher.fullName[0].toUpperCase()
                    : 'G',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.fullName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    teacher.phone,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildStatisticsCards(ClassroomDetailsStudentResponseDto classroom) =>
      Row(
        children: <Widget>[
          Expanded(
            child: _buildStatCard(
              'Chủ đề',
              '${classroom.chaptersCount}',
              Icons.book,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Bài tập',
              '${classroom.practiceSetsCount}',
              Icons.assignment,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Bài thi',
              '${classroom.examsCount}',
              Icons.quiz,
              AppColors.error,
            ),
          ),
        ],
      );

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) => Container(
    padding: const EdgeInsets.all(AppDimensions.defaultPadding),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildScheduleCard(List<ScheduleResponseDto> schedule) => Container(
    padding: const EdgeInsets.all(AppDimensions.defaultPadding),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lịch học',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...schedule.map(_buildScheduleItem),
      ],
    ),
  );

  Widget _buildScheduleItem(ScheduleResponseDto schedule) => Padding(
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
            '${ClassroomConstants.getDayOfWeekText(schedule.dayOfWeek)}: ${schedule.startTime} - ${schedule.endTime}',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    ),
  );

  Widget _buildLessonSessionsCard(List<LessonSessionResponseDto> sessions) =>
      Container(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Buổi học gần đây',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...sessions
                .take(5)
                .map(_buildSessionItem)
                ,
          ],
        ),
      );

  Widget _buildSessionItem(LessonSessionResponseDto session) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ClassroomConstants.getSessionStatusColor(
              session.status,
            ).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            ClassroomConstants.getSessionStatusIcon(session.status),
            color: ClassroomConstants.getSessionStatusColor(session.status),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buổi ${session.originalSessionId}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${_formatDate(session.date)} • ${session.startTime} - ${session.endTime}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (session.note != null && session.note!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  session.note!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ClassroomConstants.getSessionStatusColor(
              session.status,
            ).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            ClassroomConstants.getSessionStatusText(session.status),
            style: AppTextStyles.bodySmall.copyWith(
              color: ClassroomConstants.getSessionStatusColor(session.status),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  String _formatDate(String dateString) {
    try {
      // Handle the specific format from API
      if (dateString.contains('GMT+0000')) {
        // Extract date part from "Wed Jul 23 2025 00:00:00 GMT+0000 (Coordinated Universal Time)"
        final dateMatch = RegExp(
          r'(\w{3}\s+\w{3}\s+\d{1,2}\s+\d{4})',
        ).firstMatch(dateString);
        if (dateMatch != null) {
          final datePart = dateMatch.group(1);
          final parsedDate = DateFormat('EEE MMM dd yyyy').parse(datePart!);
          return DateFormat('dd/MM/yyyy').format(parsedDate);
        }
      }

      // Fallback to standard parsing
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
