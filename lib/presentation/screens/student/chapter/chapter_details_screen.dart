import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/chapter_constants.dart';
import '../../../../core/constants/question_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/dto/chapter_details_dto.dart';
import '../../../../data/dto/question_dto.dart';
import '../../../../providers/chapter/chapter_providers.dart';
import 'widgets/cloze_test_question.dart';
import 'widgets/fill_in_blank_question.dart';
import 'widgets/multiple_choice_question.dart';
import 'widgets/question_result_view.dart';
import 'widgets/sentence_rewriting_question.dart';

class ChapterDetailsScreen extends ConsumerStatefulWidget {

  const ChapterDetailsScreen({required this.chapterId, super.key});
  final String chapterId;

  @override
  ConsumerState<ChapterDetailsScreen> createState() =>
      _ChapterDetailsScreenState();
}

class _ChapterDetailsScreenState extends ConsumerState<ChapterDetailsScreen> {
  Map<String, dynamic> studentAnswers = {};
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final chapterDetailsAsync = ref.watch(
      chapterDetailsProvider(widget.chapterId),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: chapterDetailsAsync.when(
          data:
              (ChapterDetailsStudentResponseDto chapterDetails) => Text(
                chapterDetails.title ?? 'Chi tiết chủ đề',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
          loading:
              () => const Text(
                'Chi tiết chủ đề',
                style: TextStyle(color: AppColors.textPrimary),
              ),
          error:
              (_, __) => const Text(
                'Chi tiết chủ đề',
                style: TextStyle(color: AppColors.textPrimary),
              ),
        ),
        actions: [
          if (_shouldShowSubmitButton(chapterDetailsAsync))
            Padding(
              padding: const EdgeInsets.only(right: AppDimensions.paddingM),
              child: AppButton(
                text: 'Nộp bài',
                onPressed: isSubmitting ? null : _handleSubmit,
                isLoading: isSubmitting,
                isFullWidth: false,
              ),
            ),
        ],
      ),
      body: chapterDetailsAsync.when(
        data: (chapterDetails) => _buildContent(chapterDetails),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  bool _shouldShowSubmitButton(
    AsyncValue<ChapterDetailsStudentResponseDto?> asyncValue,
  ) {
    if (!asyncValue.hasValue || asyncValue.value == null) return false;
    return asyncValue.value!.status != EChapterStatus.CLOSED;
  }

  Widget _buildContent(ChapterDetailsStudentResponseDto? chapterDetails) {
    if (chapterDetails == null) {
      return _buildErrorState('Không thể tải thông tin chủ đề');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(chapterDetails),
          const SizedBox(height: AppDimensions.paddingL),
          _buildQuestionsList(chapterDetails),
        ],
      ),
    );
  }

  Widget _buildHeader(ChapterDetailsStudentResponseDto chapterDetails) => const SizedBox.shrink();

  Widget _buildQuestionsList(ChapterDetailsStudentResponseDto chapterDetails) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Danh sách câu hỏi',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        ...chapterDetails.questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingL),
            child: _buildQuestionItem(index, question, chapterDetails.status),
          );
        }),
      ],
    );

  Widget _buildQuestionItem(
    int index,
    QuestionStudentDto question,
    EChapterStatus chapterStatus,
  ) {
    final isClosed = chapterStatus == EChapterStatus.CLOSED;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Câu ${question.questionNumber}',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),
            _buildQuestionTypeTag(question.questionType),
            const Spacer(),
            if (isClosed) ...[
              Icon(
                question.isCorrect ? Icons.check_circle : Icons.cancel,
                color: question.isCorrect ? AppColors.success : AppColors.error,
                size: 20,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppDimensions.paddingM),
        _buildQuestionContent(question, chapterStatus),
      ],
    );
  }

  Widget _buildQuestionContent(
    QuestionStudentDto question,
    EChapterStatus chapterStatus,
  ) {
    final isClosed = chapterStatus == EChapterStatus.CLOSED;

    switch (question.questionType) {
      case EQuestionType.MULTIPLE_CHOICE:
        return isClosed
            ? QuestionResultView(
              question: question,
              studentAnswer: studentAnswers[question.id],
            )
            : MultipleChoiceQuestion(
              question: question,
              onAnswerSelected: (String answerId) {
                setState(() {
                  studentAnswers[question.id] = answerId;
                });
              },
              selectedAnswerId: studentAnswers[question.id],
            );

      case EQuestionType.FILL_IN_THE_BLANK:
        return isClosed
            ? QuestionResultView(
              question: question,
              studentAnswer: studentAnswers[question.id],
            )
            : FillInBlankQuestion(
              question: question,
              onAnswerChanged: (String answer) {
                setState(() {
                  studentAnswers[question.id] = answer;
                });
              },
              studentAnswer: studentAnswers[question.id] ?? '',
            );

      case EQuestionType.CLOZE_TEST:
        return isClosed
            ? QuestionResultView(
              question: question,
              studentAnswer: studentAnswers[question.id],
            )
            : ClozeTestQuestion(
              question: question,
              onAnswersChanged: (Map<String, String> answers) {
                setState(() {
                  studentAnswers[question.id] = answers;
                });
              },
              studentAnswers: studentAnswers[question.id] ?? {},
            );

      case EQuestionType.SENTENCE_REWRITING:
        return isClosed
            ? QuestionResultView(
              question: question,
              studentAnswer: studentAnswers[question.id],
            )
            : SentenceRewritingQuestion(
              question: question,
              onAnswerChanged: (String answer) {
                setState(() {
                  studentAnswers[question.id] = answer;
                });
              },
              studentAnswer: studentAnswers[question.id] ?? '',
            );

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

  Widget _buildErrorState(dynamic error) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'Không thể tải thông tin chủ đề',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            error.toString(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingL),
          AppButton(
            text: 'Thử lại',
            onPressed: () {
              ref.invalidate(chapterDetailsProvider(widget.chapterId));
            },
          ),
        ],
      ),
    );

  Future<void> _handleSubmit() async {
    if (studentAnswers.isEmpty) {
      ToastUtils.showWarning(
        context: context,
        message: 'Vui lòng trả lời ít nhất một câu hỏi',
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // TODO: Implement submit API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      ToastUtils.showSuccess(context: context, message: 'Nộp bài thành công!');
      Navigator.of(context).pop();
    } catch (error) {
      ToastUtils.showFail(
        context: context,
        message: 'Có lỗi xảy ra khi nộp bài: $error',
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }
}
