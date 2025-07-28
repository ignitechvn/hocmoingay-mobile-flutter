import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/dto/bank_topic_dto.dart';
import '../../../../data/dto/bank_question_dto.dart';
import '../../../../providers/subjects/subjects_providers.dart';
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
          tabs: const [Tab(text: 'Câu hỏi'), Tab(text: 'Bài giảng')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildQuestionsTab(), _buildLessonsTab()],
      ),
    );
  }

  Widget _buildQuestionsTab() {
    final questionsAsync = ref.watch(
      bankTopicQuestionsProvider(widget.topic.id),
    );

    return questionsAsync.when(
      data: (questions) => _buildQuestionsList(questions),
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => EmptyStateWidgets.error(
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildLessonsTab() {
    // TODO: Implement lessons list
    return EmptyStateWidget(message: 'Chưa có bài giảng nào');
  }
}
