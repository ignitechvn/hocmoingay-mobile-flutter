import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../data/dto/chapter_dto.dart';
import '../../../../providers/teacher_chapters/teacher_chapters_providers.dart';

class CreateChapterScreen extends ConsumerStatefulWidget {
  final String classroomId;

  const CreateChapterScreen({super.key, required this.classroomId});

  @override
  ConsumerState<CreateChapterScreen> createState() =>
      _CreateChapterScreenState();
}

class _CreateChapterScreenState extends ConsumerState<CreateChapterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _deadline;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Tạo chủ đề mới',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              AppTextField(
                controller: _titleController,
                label: 'Tên chủ đề *',
                hint: 'Nhập tên chủ đề',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên chủ đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              AppTextField(
                controller: _descriptionController,
                label: 'Mô tả',
                hint: 'Nhập mô tả (không bắt buộc)',
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Start Date Field
              Text(
                'Ngày bắt đầu',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectStartDate(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _startDate != null
                            ? DateFormat('dd/MM/yyyy').format(_startDate!)
                            : 'Chọn ngày bắt đầu',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color:
                              _startDate != null
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Deadline Field
              Text(
                'Ngày kết thúc',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDeadline(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _deadline != null
                            ? DateFormat('dd/MM/yyyy').format(_deadline!)
                            : 'Chọn ngày kết thúc',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color:
                              _deadline != null
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: _isLoading ? null : _createChapter,
                  text: _isLoading ? 'Đang tạo...' : 'Tạo chủ đề',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  Future<void> _createChapter() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dto = CreateChapterDto(
        title: _titleController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        classroomId: widget.classroomId,
        startDate: _startDate?.toIso8601String(),
        deadline: _deadline?.toIso8601String(),
      );

      final useCase = ref.read(createChapterUseCaseProvider);
      await useCase(dto);

      ToastUtils.showSuccess(
        context: context,
        message: 'Tạo chủ đề thành công',
      );

      Navigator.of(context).pop(true); // Return true to indicate success
    } catch (e) {
      ToastUtils.showFail(
        context: context,
        message: 'Tạo chủ đề thất bại: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
