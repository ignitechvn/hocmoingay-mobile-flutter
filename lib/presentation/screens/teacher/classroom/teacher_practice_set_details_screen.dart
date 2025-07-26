import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/practice_set_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/practice_set_dto.dart';
import '../../../../providers/teacher_practice_sets/teacher_practice_sets_providers.dart';
import 'create_practice_set_screen.dart';

class TeacherPracticeSetDetailsScreen extends ConsumerStatefulWidget {
  final String practiceSetId;

  const TeacherPracticeSetDetailsScreen({
    super.key,
    required this.practiceSetId,
  });

  @override
  ConsumerState<TeacherPracticeSetDetailsScreen> createState() =>
      _TeacherPracticeSetDetailsScreenState();
}

class _TeacherPracticeSetDetailsScreenState
    extends ConsumerState<TeacherPracticeSetDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final practiceSetDetailsAsync = ref.watch(
      practiceSetDetailsProvider(widget.practiceSetId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Chi tiết bài tập',
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
                _navigateToEditPracticeSet();
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
      body: practiceSetDetailsAsync.when(
        data:
            (practiceSetDetails) => _buildContent(context, practiceSetDetails),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải chi tiết bài tập',
                onRetry: () {
                  ref.invalidate(
                    practiceSetDetailsProvider(widget.practiceSetId),
                  );
                },
              ),
            ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PracticeSetDetailsTeacherResponseDto practiceSet,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildHeaderCard(context, practiceSet),
          const SizedBox(height: 16),

          // Statistics Cards
          _buildStatisticsCards(practiceSet),
          const SizedBox(height: 16),

          // Assignment Section
          _buildAssignmentSection(practiceSet),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    PracticeSetDetailsTeacherResponseDto practiceSet,
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
                    practiceSet.title,
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
                    color: _getStatusColor(practiceSet.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(practiceSet.status),
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
            if (practiceSet.description != null &&
                practiceSet.description!.isNotEmpty)
              Text(
                practiceSet.description!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

            const SizedBox(height: 12),

            // Date Range
            Row(
              children: [
                Text(
                  'Thời gian: ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${_formatDate(practiceSet.startDate ?? '')} - ${_formatDate(practiceSet.deadline ?? '')}',
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

  Widget _buildStatisticsCards(
    PracticeSetDetailsTeacherResponseDto practiceSet,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2, // Reduced aspect ratio to accommodate button
      children: [
        _buildStatCard(
          'Câu hỏi',
          '${practiceSet.questionCount}',
          Icons.quiz,
          AppColors.primary,
          () => _navigateToQuestionsDetails(practiceSet.id),
        ),
        _buildStatCard(
          'Học sinh đã làm',
          '${practiceSet.studentProgressCount}',
          Icons.people,
          AppColors.success,
          () => _navigateToStudentProgressDetails(practiceSet.id),
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

  Widget _buildAssignmentSection(
    PracticeSetDetailsTeacherResponseDto practiceSet,
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
              'Phân phối bài tập',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  practiceSet.assignToAll ? Icons.group : Icons.person,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  practiceSet.assignToAll
                      ? 'Giao cho cả lớp'
                      : 'Giao cho ${practiceSet.assignedStudentCount ?? 0} học sinh cụ thể',
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

  Color _getStatusColor(EPracticeSetStatus status) {
    switch (status) {
      case EPracticeSetStatus.SCHEDULED:
        return const Color(0xFF2196F3); // Blue
      case EPracticeSetStatus.OPEN:
        return const Color(0xFF4CAF50); // Green
      case EPracticeSetStatus.CLOSED:
        return const Color(0xFFF44336); // Red
    }
  }

  String _getStatusText(EPracticeSetStatus status) {
    switch (status) {
      case EPracticeSetStatus.SCHEDULED:
        return 'Đã lên lịch';
      case EPracticeSetStatus.OPEN:
        return 'Đang mở';
      case EPracticeSetStatus.CLOSED:
        return 'Đã đóng';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Chưa có';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  // Navigation methods
  void _navigateToEditPracticeSet() async {
    final practiceSetDetailsAsync = ref.read(
      practiceSetDetailsProvider(widget.practiceSetId),
    );

    practiceSetDetailsAsync.whenData((practiceSetDetails) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => CreatePracticeSetScreen(
                classroomId: practiceSetDetails.classroomId,
                practiceSet: PracticeSetTeacherResponseDto(
                  id: practiceSetDetails.id,
                  title: practiceSetDetails.title,
                  description: practiceSetDetails.description,
                  deadline: practiceSetDetails.deadline,
                  startDate: practiceSetDetails.startDate,
                  status: practiceSetDetails.status,
                  classroomId: practiceSetDetails.classroomId,
                  questionCount: practiceSetDetails.questionCount,
                  assignToAll: practiceSetDetails.assignToAll,
                  assignedStudentCount: practiceSetDetails.assignedStudentCount,
                ),
              ),
        ),
      );
    });
  }

  void _navigateToQuestionsDetails(String practiceSetId) {
    // TODO: Navigate to practice set questions screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Chuyển đến màn hình quản lý câu hỏi cho bài tập $practiceSetId',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToStudentProgressDetails(String practiceSetId) {
    // TODO: Navigate to student progress details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Chuyển đến màn hình chi tiết tiến độ học sinh cho bài tập $practiceSetId',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
