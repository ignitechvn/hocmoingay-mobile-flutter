import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/exam_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/exam_dto.dart';
import '../../../../providers/teacher_exams/teacher_exams_providers.dart';
import 'create_exam_screen.dart';

class TeacherExamDetailsScreen extends ConsumerStatefulWidget {
  final String examId;

  const TeacherExamDetailsScreen({super.key, required this.examId});

  @override
  ConsumerState<TeacherExamDetailsScreen> createState() =>
      _TeacherExamDetailsScreenState();
}

class _TeacherExamDetailsScreenState
    extends ConsumerState<TeacherExamDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final examDetailsAsync = ref.watch(examDetailsProvider(widget.examId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Chi tiết bài thi',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Edit button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                _navigateToEditExam();
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
                // TODO: Navigate to settings screen
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
      body: examDetailsAsync.when(
        data: (examDetails) => _buildContent(context, examDetails),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải chi tiết bài thi',
                onRetry: () {
                  ref.invalidate(examDetailsProvider(widget.examId));
                },
              ),
            ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ExamDetailsTeacherResponseDto exam,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildHeaderCard(context, exam),
          const SizedBox(height: 16),

          // Statistics Cards
          _buildStatisticsCards(exam),
          const SizedBox(height: 16),

          // Assignment Section
          _buildAssignmentSection(exam),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    ExamDetailsTeacherResponseDto exam,
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
                    exam.title,
                    style: AppTextStyles.headlineSmall.copyWith(
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
                    color: _getStatusColor(exam.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(exam.status),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            if (exam.description != null && exam.description!.isNotEmpty)
              Text(
                exam.description!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

            const SizedBox(height: 12),

            // Date and Duration
            Row(
              children: [
                Text(
                  'Thời gian: ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  exam.startTime != null
                      ? '${_formatDatetime(exam.startTime!)} • ${exam.duration} phút'
                      : 'Chưa xác định thời gian • ${exam.duration} phút',
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

  Widget _buildStatisticsCards(ExamDetailsTeacherResponseDto exam) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Câu hỏi',
          '${exam.questionCount}',
          Icons.quiz,
          AppColors.primary,
          () => _navigateToQuestionsDetails(exam.id),
        ),
        _buildStatCard(
          'Học sinh đã làm',
          '${exam.studentProgressCount}',
          Icons.people,
          AppColors.success,
          () => _navigateToStudentProgressDetails(exam.id),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback? onDetailsTap,
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
            const SizedBox(height: 8),
            // Chi tiết button
            InkWell(
              onTap: onDetailsTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  'Chi tiết',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentSection(ExamDetailsTeacherResponseDto exam) {
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
              'Phân phối bài thi',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  exam.assignToAll ? Icons.group : Icons.person,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  exam.assignToAll
                      ? 'Giao cho cả lớp'
                      : 'Giao cho ${exam.assignedStudentCount ?? 0} học sinh cụ thể',
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

  Color _getStatusColor(EExamStatus status) {
    switch (status) {
      case EExamStatus.SCHEDULED:
        return const Color(0xFF2196F3); // Blue
      case EExamStatus.OPEN:
        return const Color(0xFF4CAF50); // Green
      case EExamStatus.CLOSED:
        return const Color(0xFFF44336); // Red
    }
  }

  String _getStatusText(EExamStatus status) {
    switch (status) {
      case EExamStatus.SCHEDULED:
        return 'Đã lên lịch';
      case EExamStatus.OPEN:
        return 'Đang mở';
      case EExamStatus.CLOSED:
        return 'Đã đóng';
    }
  }

  String _formatDatetime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('HH:mm dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  // Navigation methods
  void _navigateToEditExam() async {
    final examDetailsAsync = ref.read(examDetailsProvider(widget.examId));

    examDetailsAsync.whenData((examDetails) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => CreateExamScreen(
                classroomId: examDetails.classroomId,
                exam: ExamTeacherResponseDto(
                  id: examDetails.id,
                  title: examDetails.title,
                  description: examDetails.description,
                  startTime: examDetails.startTime,
                  duration: examDetails.duration,
                  status: examDetails.status,
                  classroomId: examDetails.classroomId,
                  questionCount: examDetails.questionCount,
                  assignToAll: examDetails.assignToAll,
                  assignedStudentCount: examDetails.assignedStudentCount,
                ),
              ),
        ),
      );
    });
  }

  void _navigateToQuestionsDetails(String examId) {
    // TODO: Navigate to exam questions screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Chuyển đến màn hình quản lý câu hỏi cho bài thi $examId',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToStudentProgressDetails(String examId) {
    // TODO: Navigate to student progress details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Chuyển đến màn hình chi tiết tiến độ học sinh cho bài thi $examId',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
