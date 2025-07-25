import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../data/dto/practice_set_dto.dart';
import '../../../../data/dto/teacher_classroom_dto.dart';
import '../../../../providers/teacher_practice_sets/teacher_practice_sets_providers.dart';
import '../../../../providers/teacher_classroom/teacher_classroom_providers.dart';

class CreatePracticeSetScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final PracticeSetTeacherResponseDto? practiceSet; // For edit mode

  const CreatePracticeSetScreen({
    super.key,
    required this.classroomId,
    this.practiceSet, // If null = create mode, if not null = edit mode
  });

  @override
  ConsumerState<CreatePracticeSetScreen> createState() =>
      _CreatePracticeSetScreenState();
}

class _CreatePracticeSetScreenState
    extends ConsumerState<CreatePracticeSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _deadline;
  bool _assignToAll = true;
  List<String> _selectedStudentIds = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // If in edit mode, populate fields with existing data
    if (widget.practiceSet != null) {
      _titleController.text = widget.practiceSet!.title;
      _descriptionController.text = widget.practiceSet!.description ?? '';
      _assignToAll = widget.practiceSet!.assignToAll;

      if (widget.practiceSet!.startDate != null) {
        _startDate = DateTime.parse(widget.practiceSet!.startDate!);
      }
      if (widget.practiceSet!.deadline != null) {
        _deadline = DateTime.parse(widget.practiceSet!.deadline!);
      }

      // Note: studentIds will be populated when students list is loaded
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(
      approvedStudentsProvider(widget.classroomId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.practiceSet != null ? 'Chỉnh sửa bài tập' : 'Tạo bài tập mới',
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
                'Tên bài tập *',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _titleController,
                label: '',
                hint: 'Nhập tên bài tập',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên bài tập';
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
              AppTextField(
                controller: _descriptionController,
                label: '',
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
              const SizedBox(height: 24),

              // Assignment Section
              Text(
                'Phân phối bài tập',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Assignment Options
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Assignment options in a row
                      Row(
                        children: [
                          // Option 1: Assign to all
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Giao cho cả lớp'),
                              value: true,
                              groupValue: _assignToAll,
                              onChanged: (value) {
                                setState(() {
                                  _assignToAll = value!;
                                  if (_assignToAll) {
                                    _selectedStudentIds.clear();
                                  }
                                });
                              },
                              activeColor: AppColors.primary,
                            ),
                          ),

                          // Option 2: Assign to specific students
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Giao cho học sinh cụ thể'),
                              value: false,
                              groupValue: _assignToAll,
                              onChanged: (value) {
                                setState(() {
                                  _assignToAll = value!;
                                });
                              },
                              activeColor: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      // Student selection (only show when not assigning to all)
                      if (!_assignToAll) ...[
                        const SizedBox(height: 16),
                        studentsAsync.when(
                          data: (students) => _buildStudentSelection(students),
                          loading:
                              () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          error:
                              (error, stack) => Center(
                                child: Text(
                                  'Không thể tải danh sách học sinh: ${error.toString()}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                        ),
                      ],
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
                          : (widget.practiceSet != null
                              ? _updatePracticeSet
                              : _createPracticeSet),
                  text:
                      _isLoading
                          ? (widget.practiceSet != null
                              ? 'Đang cập nhật...'
                              : 'Đang tạo...')
                          : (widget.practiceSet != null
                              ? 'Cập nhật bài tập'
                              : 'Tạo bài tập'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentSelection(List<StudentResponseDto> students) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn học sinh:',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final isSelected = _selectedStudentIds.contains(student.id);

              return CheckboxListTile(
                title: Text(
                  student.fullName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  student.phone,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedStudentIds.add(student.id);
                    } else {
                      _selectedStudentIds.remove(student.id);
                    }
                  });
                },
                activeColor: AppColors.primary,
              );
            },
          ),
        ),
      ],
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

  Future<void> _createPracticeSet() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_assignToAll && _selectedStudentIds.isEmpty) {
      ToastUtils.showFail(
        context: context,
        message: 'Vui lòng chọn ít nhất một học sinh',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dto = CreatePracticeSetDto(
        title: _titleController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        classroomId: widget.classroomId,
        startDate: _startDate?.toIso8601String(),
        deadline: _deadline?.toIso8601String(),
        assignToAll: _assignToAll,
        studentIds: _assignToAll ? null : _selectedStudentIds,
      );

      final useCase = ref.read(createPracticeSetUseCaseProvider);
      await useCase(dto);

      ToastUtils.showSuccess(
        context: context,
        message: 'Tạo bài tập thành công',
      );

      Navigator.of(context).pop(true); // Return true to indicate success
    } catch (e) {
      ToastUtils.showFail(
        context: context,
        message: 'Tạo bài tập thất bại: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePracticeSet() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_assignToAll && _selectedStudentIds.isEmpty) {
      ToastUtils.showFail(
        context: context,
        message: 'Vui lòng chọn ít nhất một học sinh',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dto = UpdatePracticeSetDto(
        title: _titleController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        startDate: _startDate?.toIso8601String(),
        deadline: _deadline?.toIso8601String(),
        assignToAll: _assignToAll,
        studentIds: _assignToAll ? null : _selectedStudentIds,
      );

      final useCase = ref.read(updatePracticeSetUseCaseProvider);
      await useCase({'practiceSetId': widget.practiceSet!.id, 'dto': dto});

      ToastUtils.showSuccess(
        context: context,
        message: 'Cập nhật bài tập thành công',
      );

      Navigator.of(context).pop(true); // Return true to indicate success
    } catch (e) {
      ToastUtils.showFail(
        context: context,
        message: 'Cập nhật bài tập thất bại: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
