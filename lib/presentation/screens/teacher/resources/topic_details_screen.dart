import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../data/dto/bank_topic_dto.dart';
import '../../../../data/dto/bank_question_dto.dart';
import '../../../../data/dto/bank_theory_page_dto.dart';
import '../../../../providers/subjects/subjects_providers.dart';
import '../../../../domain/usecases/subjects/delete_bank_question_usecase.dart';
import '../../../widgets/question_display_widget.dart';
import '../../../widgets/question_display_data.dart';

class TopicDetailsScreen extends ConsumerStatefulWidget {
  final BankTopicWithCountDto topic;

  const TopicDetailsScreen({super.key, required this.topic});

  @override
  ConsumerState<TopicDetailsScreen> createState() => _TopicDetailsScreenState();
}

class _TopicDetailsScreenState extends ConsumerState<TopicDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.topic.title, style: AppTextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTextStyles.bodyMedium,
          tabs: const [
            Tab(text: 'Câu hỏi'),
            Tab(text: 'Bài giảng'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildQuestionsTab(), _buildLessonsTab()],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
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
            )
          : null,
    );
  }

  Widget _buildQuestionsTab() {
    final questionsAsync = ref.watch(
      bankTopicQuestionsProvider(widget.topic.id),
    );

    return questionsAsync.when(
      data: (questions) => _buildQuestionsList(questions),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => EmptyStateWidgets.error(
        message: 'Không thể tải danh sách câu hỏi',
        onRetry: () {
          ref.invalidate(bankTopicQuestionsProvider(widget.topic.id));
        },
      ),
    );
  }

  Widget _buildQuestionsList(List<BankQuestionResponseDto> questions) {
    if (questions.isEmpty) {
      return EmptyStateWidget(
        message: 'Chưa có câu hỏi nào\nCâu hỏi sẽ được hiển thị ở đây khi có',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(bankTopicQuestionsProvider(widget.topic.id));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return Padding(
            padding: const EdgeInsets.only(
              bottom: AppDimensions.defaultPadding,
            ),
            child: QuestionDisplayWidget(
              question: QuestionDisplayData.fromBankQuestion(question),
              index: index,
              onEdit: () => _handleEditQuestion(question),
              onDelete: () => _handleDeleteQuestion(question),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLessonsTab() {
    final theoryPagesAsync = ref.watch(
      bankTopicTheoryPagesProvider(widget.topic.id),
    );

    return theoryPagesAsync.when(
      data: (theoryPages) => _buildTheoryPagesList(theoryPages),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => EmptyStateWidgets.error(
        message: 'Không thể tải danh sách bài giảng',
        onRetry: () {
          ref.invalidate(bankTopicTheoryPagesProvider(widget.topic.id));
        },
      ),
    );
  }

  Widget _buildTheoryPagesList(BankTheoryPageSidebarResponseDto theoryPages) {
    if (theoryPages.items.isEmpty) {
      return EmptyStateWidget(
        message:
            'Chưa có bài giảng nào\nBài giảng sẽ được hiển thị ở đây khi có',
        showAction: true,
        actionText: 'Thêm bài giảng',
        onActionPressed: _showAddLessonOptions,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(bankTopicTheoryPagesProvider(widget.topic.id));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        itemCount: theoryPages.items.length,
        itemBuilder: (context, index) {
          final item = theoryPages.items[index];
          return _buildTheoryPageItem(item);
        },
      ),
    );
  }

  Widget _buildTheoryPageItem(BankTheoryPageSidebarItemDto item) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.defaultPadding),
      child: ExpansionTile(
        title: Text(
          item.title,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        children: [
          if (item.children.isNotEmpty)
            ...item.children.map((child) => _buildTheoryPageChild(child)),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.defaultPadding),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _handleEditTheoryPage(item),
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  tooltip: 'Chỉnh sửa',
                ),
                IconButton(
                  onPressed: () => _handleDeleteTheoryPage(item),
                  icon: const Icon(Icons.delete, color: AppColors.error),
                  tooltip: 'Xóa',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTheoryPageChild(BankTheoryPageSidebarItemDto child) {
    return ListTile(
      title: Text(child.title, style: AppTextStyles.bodySmall),
      leading: const Icon(Icons.article, size: 20),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _handleEditTheoryPage(child),
            icon: const Icon(Icons.edit, size: 16, color: AppColors.primary),
            tooltip: 'Chỉnh sửa',
          ),
          IconButton(
            onPressed: () => _handleDeleteTheoryPage(child),
            icon: const Icon(Icons.delete, size: 16, color: AppColors.error),
            tooltip: 'Xóa',
          ),
        ],
      ),
    );
  }

  void _handleEditQuestion(BankQuestionResponseDto question) {
    ToastUtils.showInfo(
      context: context,
      message:
          'Tính năng đang phát triển, vui lòng đợi trong bản cập nhật tiếp theo',
    );
  }

  void _handleDeleteQuestion(BankQuestionResponseDto question) async {
    // Show confirmation dialog first
    final confirmed = await ConfirmDialogHelper.showCustomConfirmation(
      context,
      title: 'Xác nhận xóa câu hỏi',
      content: const DeleteQuestionContent(),
      confirmText: 'Xóa',
      cancelText: 'Hủy',
      confirmColor: AppColors.error,
    );

    if (!confirmed) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final deleteUseCase = ref.read(deleteBankQuestionUseCaseProvider);
      await deleteUseCase(question.id);

      // Refresh the questions list
      ref.invalidate(bankTopicQuestionsProvider(widget.topic.id));

      ToastUtils.showSuccess(
        context: context,
        message: 'Đã xóa câu hỏi thành công',
      );
    } catch (e) {
      ToastUtils.showFail(
        context: context,
        message: 'Lỗi khi xóa câu hỏi: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                    icon: Icons.edit_note,
                    title: 'Nhập câu hỏi thủ công',
                    subtitle: 'Tạo câu hỏi mới bằng cách nhập trực tiếp',
                    onTap: () {
                      Navigator.pop(context);
                      _handleManualAddQuestion();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildAddQuestionOption(
                    icon: Icons.smart_toy,
                    title: 'Tạo câu hỏi bằng AI',
                    subtitle: 'Sử dụng AI để tạo câu hỏi tự động',
                    onTap: () {
                      Navigator.pop(context);
                      _handleAIAddQuestion();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildAddQuestionOption(
                    icon: Icons.file_upload,
                    title: 'Nhập từ file .docx',
                    subtitle: 'Import câu hỏi từ file Word',
                    onTap: () {
                      Navigator.pop(context);
                      _handleImportFromFile();
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

  void _handleManualAddQuestion() {
    ToastUtils.showInfo(
      context: context,
      message: 'Tính năng nhập câu hỏi thủ công đang phát triển',
    );
  }

  void _handleAIAddQuestion() {
    ToastUtils.showInfo(
      context: context,
      message: 'Tính năng tạo câu hỏi bằng AI đang phát triển',
    );
  }

  void _handleImportFromFile() {
    ToastUtils.showInfo(
      context: context,
      message: 'Tính năng import từ file .docx đang phát triển',
    );
  }

  void _showAddLessonOptions() {
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
                'Thêm bài giảng',
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
                  _buildAddLessonOption(
                    icon: Icons.edit_note,
                    title: 'Thêm bài giảng thủ công',
                    subtitle: 'Tạo bài giảng mới bằng cách nhập trực tiếp',
                    onTap: () {
                      Navigator.pop(context);
                      _handleManualAddLesson();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildAddLessonOption(
                    icon: Icons.smart_toy,
                    title: 'Soạn thảo cùng AI',
                    subtitle: 'Sử dụng AI để tạo bài giảng tự động',
                    onTap: () {
                      Navigator.pop(context);
                      _handleAIAddLesson();
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

  Widget _buildAddLessonOption({
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

  void _handleManualAddLesson() {
    ToastUtils.showInfo(
      context: context,
      message: 'Tính năng thêm bài giảng thủ công đang phát triển',
    );
  }

  void _handleAIAddLesson() {
    ToastUtils.showInfo(
      context: context,
      message: 'Tính năng soạn thảo cùng AI đang phát triển',
    );
  }

  void _handleEditTheoryPage(BankTheoryPageSidebarItemDto item) {
    ToastUtils.showInfo(
      context: context,
      message: 'Tính năng chỉnh sửa bài giảng đang phát triển',
    );
  }

  void _handleDeleteTheoryPage(BankTheoryPageSidebarItemDto item) {
    ToastUtils.showInfo(
      context: context,
      message: 'Tính năng xóa bài giảng đang phát triển',
    );
  }
}
