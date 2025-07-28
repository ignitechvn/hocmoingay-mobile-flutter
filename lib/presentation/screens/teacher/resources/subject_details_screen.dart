import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/routers/app_router.dart';
import '../../../../data/dto/subject_dto.dart';
import '../../../../data/dto/bank_topic_dto.dart';
import '../../../../providers/subjects/subjects_providers.dart';

class SubjectDetailsScreen extends ConsumerStatefulWidget {
  final SubjectResponseDto subject;

  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  ConsumerState<SubjectDetailsScreen> createState() =>
      _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends ConsumerState<SubjectDetailsScreen> {
  late final Future<List<BankTopicWithCountDto>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    // Khởi tạo _topicsFuture ngay lập tức
    _topicsFuture = ref.read(
      topicsBySubjectProvider({
        'subjectCode': widget.subject.code,
        'grade': widget.subject.grade,
      }).future,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Không watch provider ở đây để tránh rebuild liên tục

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.subject.name, style: AppTextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          // Create topic button
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                context.push(
                  AppRoutes.topicTemplates,
                  extra: {'subject': widget.subject},
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
                  Icons.add,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<BankTopicWithCountDto>>(
        future: _topicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return EmptyStateWidgets.error(
              message: 'Không thể tải danh sách chủ đề',
              onRetry: () {
                setState(() {
                  _topicsFuture = ref.read(
                    topicsBySubjectProvider({
                      'subjectCode': widget.subject.code,
                      'grade': widget.subject.grade,
                    }).future,
                  );
                });
              },
            );
          } else if (snapshot.hasData) {
            return _buildTopicsList(snapshot.data!);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildTopicsList(List<BankTopicWithCountDto> topics) {
    if (topics.isEmpty) {
      return EmptyStateWidget(
        message: 'Chưa có chủ đề nào',
        iconSize: 64,
        iconColor: AppColors.textSecondary.withOpacity(0.5),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              context.push(AppRoutes.topicDetails, extra: {'topic': topic});
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          topic.title,
                          style: AppTextStyles.titleMedium.copyWith(
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
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${topic.questionCount} câu hỏi',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (topic.description != null &&
                      topic.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      topic.description!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
