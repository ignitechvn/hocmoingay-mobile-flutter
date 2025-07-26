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
import '../../../../domain/usecases/teacher_chapters/update_chapter_usecase.dart';

class CreateChapterScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final ChapterTeacherResponseDto? chapterToEdit; // For editing mode

  const CreateChapterScreen({
    super.key,
    required this.classroomId,
    this.chapterToEdit,
  });

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
  void initState() {
    super.initState();
    // If editing, populate fields with existing data
    if (widget.chapterToEdit != null) {
      _titleController.text = widget.chapterToEdit!.title;
      _descriptionController.text = widget.chapterToEdit!.description ?? '';
      if (widget.chapterToEdit!.startDate != null) {
        _startDate = DateTime.parse(widget.chapterToEdit!.startDate!);
      }
      if (widget.chapterToEdit!.deadline != null) {
        _deadline = DateTime.parse(widget.chapterToEdit!.deadline!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.chapterToEdit != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Chỉnh sửa chủ đề' : 'Tạo chủ đề mới',
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
              Text(
                'Tên chủ đề *',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Nhập tên chủ đề',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: AppTextStyles.bodyMedium,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên chủ đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              Text(
                'Mô tả',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Nhập mô tả (không bắt buộc)',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: AppTextStyles.bodyMedium,
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

              // Create/Update Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed:
                      _isLoading
                          ? null
                          : (isEditing ? _updateChapter : _createChapter),
                  text:
                      _isLoading
                          ? (isEditing ? 'Đang cập nhật...' : 'Đang tạo...')
                          : (isEditing ? 'Cập nhật chủ đề' : 'Tạo chủ đề'),
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

  Future<void> _updateChapter() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dto = UpdateChapterDto(
        title: _titleController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        startDate: _startDate?.toIso8601String(),
        deadline: _deadline?.toIso8601String(),
      );

      final useCase = ref.read(updateChapterUseCaseProvider);
      await useCase(
        UpdateChapterParams(chapterId: widget.chapterToEdit!.id, dto: dto),
      );

      ToastUtils.showSuccess(
        context: context,
        message: 'Cập nhật chủ đề thành công',
      );

      Navigator.of(context).pop(true); // Return true to indicate success
    } catch (e) {
      ToastUtils.showFail(
        context: context,
        message: 'Cập nhật chủ đề thất bại: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
