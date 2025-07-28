import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/dto/subject_dto.dart';
import '../../../../data/dto/topic_template_dto.dart';
import '../../../../data/dto/create_bank_topics_from_templates_dto.dart';
import '../../../../providers/subjects/subjects_providers.dart';

class TopicTemplatesScreen extends ConsumerStatefulWidget {
  final SubjectResponseDto subject;

  const TopicTemplatesScreen({super.key, required this.subject});

  @override
  ConsumerState<TopicTemplatesScreen> createState() =>
      _TopicTemplatesScreenState();
}

class _TopicTemplatesScreenState extends ConsumerState<TopicTemplatesScreen> {
  final Set<String> _selectedTemplateIds = <String>{};
  bool _isLoading = false;
  List<TopicTemplateResponseDto> _topicTemplates = [];

  bool get _isAllSelected =>
      _topicTemplates.isNotEmpty &&
      _selectedTemplateIds.length == _topicTemplates.length;

  @override
  Widget build(BuildContext context) {
    final topicTemplatesAsync = ref.watch(
      topicTemplatesProvider(widget.subject.id),
    );

    // Update local topic templates when data changes
    topicTemplatesAsync.whenData((templates) {
      if (_topicTemplates != templates) {
        setState(() {
          _topicTemplates = templates;
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chọn chủ đề', style: AppTextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          // Select all button
          TextButton(
            onPressed: _handleSelectAll,
            child: Text(
              _isAllSelected ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: topicTemplatesAsync.when(
              data:
                  (topicTemplates) => _buildTopicTemplatesList(topicTemplates),
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) => EmptyStateWidgets.error(
                    message: 'Không thể tải danh sách chủ đề',
                    onRetry: () {
                      ref.invalidate(topicTemplatesProvider(widget.subject.id));
                    },
                  ),
            ),
          ),
          // Create button at bottom
          if (_selectedTemplateIds.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(AppDimensions.defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: PrimaryButton(
                  text:
                      _isLoading
                          ? 'Đang tạo...'
                          : 'Tạo ${_selectedTemplateIds.length} chủ đề',
                  onPressed: _isLoading ? null : _handleCreateTopics,
                  size: AppButtonSize.large,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleSelectAll() {
    setState(() {
      if (_isAllSelected) {
        // Deselect all
        _selectedTemplateIds.clear();
      } else {
        // Select all
        _selectedTemplateIds.addAll(
          _topicTemplates.map((template) => template.id),
        );
      }
    });
  }

  void _handleCreateTopics() async {
    if (_selectedTemplateIds.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final useCase = ref.read(createBankTopicsFromTemplatesUseCaseProvider);
      final dto = CreateBankTopicsFromTemplatesDto(
        subjectId: widget.subject.id,
        topicTemplateIds: _selectedTemplateIds.toList(),
      );

      await useCase(dto);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã tạo thành công ${_selectedTemplateIds.length} chủ đề',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tạo chủ đề thất bại: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTopicTemplatesList(
    List<TopicTemplateResponseDto> topicTemplates,
  ) {
    if (topicTemplates.isEmpty) {
      return EmptyStateWidget(
        message: 'Không có chủ đề nào khả dụng',
        icon: Icons.folder_open,
        iconSize: 64,
        iconColor: AppColors.textSecondary.withOpacity(0.5),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(topicTemplatesProvider(widget.subject.id));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        itemCount: topicTemplates.length,
        itemBuilder: (context, index) {
          final template = topicTemplates[index];
          return _buildTopicTemplateCard(template);
        },
      ),
    );
  }

  Widget _buildTopicTemplateCard(TopicTemplateResponseDto template) {
    final isSelected = _selectedTemplateIds.contains(template.id);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedTemplateIds.remove(template.id);
            } else {
              _selectedTemplateIds.add(template.id);
            }
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child:
                    isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      template.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Description
                    if (template.description != null &&
                        template.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        template.description!,
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
            ],
          ),
        ),
      ),
    );
  }
}
