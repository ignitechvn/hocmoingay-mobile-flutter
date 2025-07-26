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
import 'widgets/teacher_multiple_choice_question.dart';
import 'widgets/teacher_fill_in_blank_question.dart';
import 'widgets/teacher_cloze_test_question.dart';
import 'widgets/teacher_sentence_rewriting_question.dart';

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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              children: [
                Text(
                  'Câu ${question.questionNumber}',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingS),
                _buildQuestionTypeTag(question.questionType),
                const Spacer(),
                // Points
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.warning, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${question.point}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                  ],
                ),
                _buildDifficultyTag(question.difficulty),
                const SizedBox(width: AppDimensions.paddingS),
                // More button
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onSelected: (value) => _handleQuestionAction(value, question),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColors.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Chỉnh sửa',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: AppColors.error,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Xóa',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingM),

            // Question Content
            _buildQuestionContent(question),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContent(QuestionTeacherDto question) {
    switch (question.questionType) {
      case EQuestionType.MULTIPLE_CHOICE:
        return TeacherMultipleChoiceQuestion(question: question);
      case EQuestionType.FILL_IN_THE_BLANK:
        return TeacherFillInBlankQuestion(question: question);
      case EQuestionType.CLOZE_TEST:
        return TeacherClozeTestQuestion(question: question);
      case EQuestionType.SENTENCE_REWRITING:
        return TeacherSentenceRewritingQuestion(question: question);
    }
  }

  Widget _buildQuestionTypeTag(EQuestionType questionType) {
    String typeText;

    switch (questionType) {
      case EQuestionType.MULTIPLE_CHOICE:
        typeText = 'Trắc nghiệm';
        break;
      case EQuestionType.FILL_IN_THE_BLANK:
        typeText = 'Điền từ';
        break;
      case EQuestionType.CLOZE_TEST:
        typeText = 'Cloze test';
        break;
      case EQuestionType.SENTENCE_REWRITING:
        typeText = 'Viết lại câu';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        typeText,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDifficultyTag(EDifficulty difficulty) {
    String difficultyText;
    Color color;

    switch (difficulty) {
      case EDifficulty.VERY_EASY:
        difficultyText = 'Rất dễ';
        color = AppColors.success;
        break;
      case EDifficulty.EASY:
        difficultyText = 'Dễ';
        color = AppColors.success;
        break;
      case EDifficulty.MEDIUM:
        difficultyText = 'Trung bình';
        color = AppColors.warning;
        break;
      case EDifficulty.HARD:
        difficultyText = 'Khó';
        color = AppColors.error;
        break;
      case EDifficulty.VERY_HARD:
        difficultyText = 'Rất khó';
        color = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficultyText,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
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
