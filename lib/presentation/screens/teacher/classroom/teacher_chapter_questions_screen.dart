import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/chapter_constants.dart';
import '../../../../core/constants/question_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/chapter_dto.dart';
import '../../../../providers/teacher_chapters/teacher_chapters_providers.dart';
import '../../../widgets/question_display_widget.dart';
import '../../../widgets/question_display_data.dart';

class TeacherChapterQuestionsScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const TeacherChapterQuestionsScreen({super.key, required this.chapterId});

  @override
  ConsumerState<TeacherChapterQuestionsScreen> createState() =>
      _TeacherChapterQuestionsScreenState();
}

class _TeacherChapterQuestionsScreenState
    extends ConsumerState<TeacherChapterQuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(
      teacherChapterQuestionsProvider(widget.chapterId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: questionsAsync.when(
          data: (questionsData) => Text(
            'Danh sách câu hỏi (${questionsData.questions.length} câu)',
            style: AppTextStyles.headlineMedium,
          ),
          loading: () => const Text(
            'Danh sách câu hỏi',
            style: AppTextStyles.headlineMedium,
          ),
          error: (_, __) => const Text(
            'Danh sách câu hỏi',
            style: AppTextStyles.headlineMedium,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: questionsAsync.when(
        data: (questionsData) => _buildContent(context, questionsData),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: EmptyStateWidgets.error(
            message: 'Không thể tải danh sách câu hỏi',
            onRetry: () {
              ref.invalidate(teacherChapterQuestionsProvider(widget.chapterId));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddQuestionOptions,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          'Thêm câu hỏi',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TeacherChapterQuestionsResponseDto questionsData,
  ) {
    if (questionsData.questions.isEmpty) {
      return Center(
        child: EmptyStateWidgets.noData(message: 'Chưa có câu hỏi nào'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Questions List
          ...questionsData.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingL),
              child: _buildQuestionItem(index, question),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(int index, QuestionTeacherDto question) {
    return QuestionDisplayWidget(
      question: QuestionDisplayData.fromQuestionTeacher(question),
      index: index,
      onEdit: () => _editQuestion(question),
      onDelete: () => _deleteQuestion(question),
    );
  }

  void _handleQuestionAction(String action, QuestionTeacherDto question) {
    switch (action) {
      case 'edit':
        _editQuestion(question);
        break;
      case 'delete':
        _deleteQuestion(question);
        break;
    }
  }

  void _editQuestion(QuestionTeacherDto question) {
    // TODO: Navigate to edit question screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chỉnh sửa câu hỏi ${question.questionNumber}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleAddQuestionAction(String action) {
    switch (action) {
      case 'bank':
        _addFromQuestionBank();
        break;
      case 'ai':
        _createWithAI();
        break;
      case 'manual':
        _addManually();
        break;
      case 'file':
        _importFromFile();
        break;
    }
  }

  void _addFromQuestionBank() {
    ToastUtils.showInfo(
      context: context,
      message: 'Tính năng thêm từ ngân hàng câu hỏi đang phát triển',
    );
  }

  void _createWithAI() {
    ToastUtils.showInfo(
      context: context,
      message: 'Tính năng tạo câu hỏi bằng AI đang phát triển',
    );
  }

  void _addManually() {
    ToastUtils.showInfo(
      context: context,
      message: 'Tính năng nhập câu hỏi thủ công đang phát triển',
    );
  }

  void _importFromFile() {
    ToastUtils.showInfo(
      context: context,
      message: 'Tính năng import từ file .docx đang phát triển',
    );
  }

  void _deleteQuestion(QuestionTeacherDto question) {
    // TODO: Show confirmation dialog and delete question
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc chắn muốn xóa câu hỏi ${question.questionNumber}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Call delete API
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã xóa câu hỏi ${question.questionNumber}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showAddQuestionOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Thêm câu hỏi',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildAddQuestionOption(
                    icon: Icons.library_books,
                    title: 'Thêm từ ngân hàng câu hỏi',
                    subtitle: 'Chọn câu hỏi từ ngân hàng câu hỏi có sẵn',
                    onTap: () {
                      Navigator.pop(context);
                      _addFromQuestionBank();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildAddQuestionOption(
                    icon: Icons.smart_toy,
                    title: 'Tạo câu hỏi bằng AI',
                    subtitle: 'Sử dụng AI để tạo câu hỏi tự động',
                    onTap: () {
                      Navigator.pop(context);
                      _createWithAI();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildAddQuestionOption(
                    icon: Icons.edit_note,
                    title: 'Nhập câu hỏi thủ công',
                    subtitle: 'Tạo câu hỏi mới bằng cách nhập trực tiếp',
                    onTap: () {
                      Navigator.pop(context);
                      _addManually();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildAddQuestionOption(
                    icon: Icons.file_upload,
                    title: 'Nhập từ file .docx',
                    subtitle: 'Import câu hỏi từ file Word',
                    onTap: () {
                      Navigator.pop(context);
                      _importFromFile();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cancel button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Hủy',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAddQuestionOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
