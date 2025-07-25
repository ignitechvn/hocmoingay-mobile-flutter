import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../data/dto/subject_dto.dart';
import '../../../../providers/subjects/subjects_providers.dart';
import '../../../../core/utils/toast_utils.dart';

class CreateSubjectScreen extends ConsumerStatefulWidget {
  const CreateSubjectScreen({super.key});

  @override
  ConsumerState<CreateSubjectScreen> createState() =>
      _CreateSubjectScreenState();
}

class _CreateSubjectScreenState extends ConsumerState<CreateSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedSubjectCode;
  String? _selectedGradeLevel;
  bool _isLoading = false;

  // Subject codes mapping
  final Map<String, String> _subjectCodes = {
    'MATH': 'Toán học',
    'PHYSICS': 'Vật lý',
    'CHEMISTRY': 'Hóa học',
    'BIOLOGY': 'Sinh học',
    'ENGLISH': 'Tiếng Anh',
    'LITERATURE': 'Ngữ văn',
    'HISTORY': 'Lịch sử',
    'GEOGRAPHY': 'Địa lý',
    'CIVICS': 'Giáo dục công dân',
    'INFORMATICS': 'Tin học',
  };

  // Grade levels mapping
  final Map<String, String> _gradeLevels = {
    'GRADE_10': 'Lớp 10',
    'GRADE_11': 'Lớp 11',
    'GRADE_12': 'Lớp 12',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Thêm môn học mới',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
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
              // Subject Code Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSubjectCode,
                decoration: InputDecoration(
                  labelText: 'Môn học',
                  labelStyle: AppTextStyles.inputLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                hint: const Text('Chọn môn học'),
                items:
                    _subjectCodes.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubjectCode = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn môn học';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Grade Level Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGradeLevel,
                decoration: InputDecoration(
                  labelText: 'Khối lớp',
                  labelStyle: AppTextStyles.inputLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                hint: const Text('Chọn khối lớp'),
                items:
                    _gradeLevels.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGradeLevel = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn khối lớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Subject Name
              AppTextField(
                controller: _nameController,
                label: 'Tên môn học',
                hint: 'Nhập tên môn học',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên môn học';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Description
              AppTextField(
                controller: _descriptionController,
                label: 'Mô tả',
                hint: 'Nhập mô tả môn học (không bắt buộc)',
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: _isLoading ? 'Đang tạo...' : 'Tạo môn học',
                  onPressed: _isLoading ? null : _createSubject,
                  type: AppButtonType.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createSubject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSubjectCode == null || _selectedGradeLevel == null) {
      ToastUtils.showFail(
        context: context,
        message: 'Vui lòng chọn đầy đủ thông tin',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dto = CreateSubjectDto(
        code: _selectedSubjectCode!,
        grade: _selectedGradeLevel!,
        name: _nameController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
      );

      final useCase = ref.read(createSubjectUseCaseProvider);
      await useCase(dto);

      ToastUtils.showSuccess(
        context: context,
        message: 'Tạo môn học thành công',
      );

      // Refresh subjects list
      ref.invalidate(subjectsProvider);

      // Navigate back
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ToastUtils.showFail(
        context: context,
        message: 'Tạo môn học thất bại: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
