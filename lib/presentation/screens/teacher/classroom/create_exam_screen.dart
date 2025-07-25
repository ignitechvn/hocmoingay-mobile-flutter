import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../data/dto/exam_dto.dart';
import '../../../../data/dto/teacher_classroom_dto.dart';
import '../../../../providers/teacher_exams/teacher_exams_providers.dart';
import '../../../../providers/teacher_classroom/teacher_classroom_providers.dart';

class CreateExamScreen extends ConsumerStatefulWidget {
  final String classroomId;
  final ExamTeacherResponseDto? exam; // For edit mode

  const CreateExamScreen({
    super.key,
    required this.classroomId,
    this.exam, // If null = create mode, if not null = edit mode
  });

  @override
  ConsumerState<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends ConsumerState<CreateExamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();

  DateTime? _selectedStartTime;
  TimeOfDay? _selectedTime;
  bool _assignToAll = true;
  List<String> _selectedStudentIds = [];

  @override
  void initState() {
    super.initState();
    // If in edit mode, populate fields with existing data
    if (widget.exam != null) {
      _titleController.text = widget.exam!.title;
      _descriptionController.text = widget.exam!.description ?? '';
      _durationController.text = widget.exam!.duration.toString();
      _assignToAll = widget.exam!.assignToAll;

      if (widget.exam!.startTime != null) {
        _selectedStartTime = DateTime.parse(widget.exam!.startTime!);
      }

      // Note: studentIds will be populated when students list is loaded
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
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
          widget.exam != null ? 'Chỉnh sửa bài thi' : 'Thêm bài thi',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              AppTextField(
                controller: _titleController,
                label: 'Tên bài thi',
                hint: 'Nhập tên bài thi',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên bài thi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Description
              AppTextField(
                controller: _descriptionController,
                label: 'Mô tả',
                hint: 'Nhập mô tả bài thi (tùy chọn)',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Duration
              AppTextField(
                controller: _durationController,
                label: 'Thời lượng làm bài (phút)',
                hint: 'Nhập thời lượng (ví dụ: 90)',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập thời lượng';
                  }
                  final duration = int.tryParse(value);
                  if (duration == null || duration <= 0) {
                    return 'Thời lượng phải là số dương';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Start Time
              Text(
                'Thời gian bắt đầu',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDateTime,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                        _selectedStartTime != null
                            ? DateFormat(
                              'dd/MM/yyyy HH:mm',
                            ).format(_selectedStartTime!)
                            : 'Chọn thời gian bắt đầu (tùy chọn)',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color:
                              _selectedStartTime != null
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
                'Phân phối bài thi',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

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
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _assignToAll = true;
                                  _selectedStudentIds.clear();
                                });
                              },
                              child: Row(
                                children: [
                                  Radio<bool>(
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
                                  const SizedBox(width: 4),
                                  const Text('Giao cho cả lớp'),
                                ],
                              ),
                            ),
                          ),

                          // Option 2: Assign to specific students
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _assignToAll = false;
                                });
                              },
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: false,
                                    groupValue: _assignToAll,
                                    onChanged: (value) {
                                      setState(() {
                                        _assignToAll = value!;
                                      });
                                    },
                                    activeColor: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text('Giao cho học sinh cụ thể'),
                                ],
                              ),
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

              // Create Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text:
                      widget.exam != null ? 'Cập nhật bài thi' : 'Tạo bài thi',
                  onPressed: widget.exam != null ? _updateExam : _createExam,
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            final isSelected = _selectedStudentIds.contains(student.id);
            return CheckboxListTile(
              title: Text(student.fullName),
              subtitle: Text(
                student.phone,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value!) {
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
      ],
    );
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedStartTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _createExam() async {
    if (_formKey.currentState!.validate()) {
      // Validate student selection
      if (!_assignToAll && _selectedStudentIds.isEmpty) {
        ToastUtils.showSuccess(
          context: context,
          message: 'Vui lòng chọn ít nhất một học sinh',
        );
        return;
      }

      try {
        final duration = int.parse(_durationController.text.trim());

        final dto = CreateExamDto(
          title: _titleController.text.trim(),
          description:
              _descriptionController.text.trim().isNotEmpty
                  ? _descriptionController.text.trim()
                  : null,
          startTime: _selectedStartTime?.toIso8601String(),
          duration: duration,
          classroomId: widget.classroomId,
          assignToAll: _assignToAll,
          studentIds: _assignToAll ? null : _selectedStudentIds,
        );

        final useCase = ref.read(createExamUseCaseProvider);
        await useCase(dto);

        ToastUtils.showSuccess(
          context: context,
          message: 'Tạo bài thi thành công',
        );

        Navigator.of(context).pop(true); // Return true to indicate success
      } catch (e) {
        ToastUtils.showSuccess(
          context: context,
          message: 'Có lỗi xảy ra: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _updateExam() async {
    if (_formKey.currentState!.validate()) {
      // Validate student selection
      if (!_assignToAll && _selectedStudentIds.isEmpty) {
        ToastUtils.showSuccess(
          context: context,
          message: 'Vui lòng chọn ít nhất một học sinh',
        );
        return;
      }

      try {
        final duration = int.tryParse(_durationController.text.trim());

        final dto = UpdateExamDto(
          title: _titleController.text.trim(),
          description:
              _descriptionController.text.trim().isNotEmpty
                  ? _descriptionController.text.trim()
                  : null,
          startTime: _selectedStartTime?.toIso8601String(),
          duration: duration,
          assignToAll: _assignToAll,
          studentIds: _assignToAll ? null : _selectedStudentIds,
        );

        final useCase = ref.read(updateExamUseCaseProvider);
        await useCase({'examId': widget.exam!.id, 'dto': dto});

        ToastUtils.showSuccess(
          context: context,
          message: 'Cập nhật bài thi thành công',
        );

        Navigator.of(context).pop(true); // Return true to indicate success
      } catch (e) {
        ToastUtils.showSuccess(
          context: context,
          message: 'Có lỗi xảy ra: ${e.toString()}',
        );
      }
    }
  }
}
