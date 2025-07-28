import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/chapter_constants.dart';
import '../../../../core/constants/question_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
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
          data:
              (questionsData) => Text(
                'Danh sách câu hỏi (${questionsData.questions.length} câu)',
                style: AppTextStyles.headlineMedium,
              ),
          loading:
              () => const Text(
                'Danh sách câu hỏi',
                style: AppTextStyles.headlineMedium,
              ),
          error:
              (_, __) => const Text(
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
        actions: [
          // Add button with popup menu
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: PopupMenuButton<String>(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              onSelected: (value) => _handleAddQuestionAction(value),
              itemBuilder:
                  (context) => [
                    const PopupMenuItem<String>(
                      value: 'bank',
                      child: Row(
                        children: [
                          Icon(
                            Icons.library_books,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text('Thêm từ ngân hàng câu hỏi'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'ai',
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text('Tạo câu hỏi bằng AI'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'manual',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_note,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text('Nhập câu hỏi thủ công'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'file',
                      child: Row(
                        children: [
                          Icon(
                            Icons.file_upload,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text('Nhập từ file .docx'),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        ],
      ),
      body: questionsAsync.when(
        data: (questionsData) => _buildContent(context, questionsData),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải danh sách câu hỏi',
                onRetry: () {
                  ref.invalidate(
                    teacherChapterQuestionsProvider(widget.chapterId),
                  );
                },
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
    // TODO: Navigate to question bank screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chuyển đến ngân hàng câu hỏi'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _createWithAI() {
    // TODO: Navigate to AI question creation screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chuyển đến tạo câu hỏi bằng AI'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addManually() {
    // TODO: Navigate to manual question creation screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chuyển đến nhập câu hỏi thủ công'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _importFromFile() {
    // TODO: Navigate to file import screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chuyển đến nhập từ file .docx'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteQuestion(QuestionTeacherDto question) {
    // TODO: Show confirmation dialog and delete question
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                      content: Text(
                        'Đã xóa câu hỏi ${question.questionNumber}',
                      ),
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
}
