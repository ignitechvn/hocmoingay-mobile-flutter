import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/grade_constants.dart';
import '../../../../core/constants/subject_constants.dart';
import '../../../../core/constants/classroom_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../domain/entities/classroom.dart';
import '../../../../data/dto/teacher_classroom_dto.dart';
import '../../../../providers/teacher_classroom/teacher_classroom_providers.dart';
import 'schedule_setup_screen.dart';

class CreateClassroomScreen extends ConsumerStatefulWidget {
  const CreateClassroomScreen({super.key});

  @override
  ConsumerState<CreateClassroomScreen> createState() =>
      _CreateClassroomScreenState();
}

class _CreateClassroomScreenState extends ConsumerState<CreateClassroomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _expectedSessionsController = TextEditingController();

  EGradeLevel _selectedGrade = EGradeLevel.GRADE_1;
  ESubjectCode _selectedSubject = ESubjectCode.MATH;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  List<Schedule> _schedule = [];

  @override
  void dispose() {
    _nameController.dispose();
    _expectedSessionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Thêm lớp học',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tên lớp học
              Text(
                'Tên lớp học',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _nameController,
                label: '',
                hint: 'Nhập tên lớp học',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên lớp học';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Khối lớp
              Text(
                'Khối lớp',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: DropdownButtonFormField<EGradeLevel>(
                  value: _selectedGrade,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  items:
                      EGradeLevel.values.map((grade) {
                        return DropdownMenuItem(
                          value: grade,
                          child: Text(
                            grade.label,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedGrade = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Môn học
              Text(
                'Môn học',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: DropdownButtonFormField<ESubjectCode>(
                  value: _selectedSubject,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  items:
                      ESubjectCode.values.map((subject) {
                        return DropdownMenuItem(
                          value: subject,
                          child: Text(
                            SubjectLabels.getLabel(subject),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSubject = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Số buổi học dự kiến
              Text(
                'Số buổi học dự kiến',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _expectedSessionsController,
                label: '',
                hint: 'Nhập số buổi học',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số buổi học';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Số buổi học phải là số nguyên dương';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Ngày bắt đầu
              Text(
                'Ngày bắt đầu',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context, true),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
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
                        DateFormat('dd/MM/yyyy').format(_startDate),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Ngày kết thúc
              Text(
                'Ngày kết thúc',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context, false),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
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
                        DateFormat('dd/MM/yyyy').format(_endDate),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Thiết lập lịch học
              Text(
                'Lịch học',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Nút thiết lập lịch học
              InkWell(
                onTap: _setupSchedule,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _schedule.isEmpty
                              ? 'Thiết lập lịch học'
                              : '${_schedule.length} ngày đã thiết lập',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
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
              ),

              // Hiển thị thông tin lịch học đã thiết lập
              if (_schedule.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lịch học đã thiết lập:',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._schedule
                          .map(
                            (schedule) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '${schedule.dayOfWeekText}: ${schedule.startTime} - ${schedule.endTime}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Nút tạo lớp học
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Tạo lớp học',
                  onPressed: _createClassroom,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Nếu ngày kết thúc trước ngày bắt đầu, cập nhật ngày kết thúc
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _setupSchedule() async {
    final result = await Navigator.of(context).push<List<Schedule>>(
      MaterialPageRoute(
        builder:
            (context) => ScheduleSetupScreen(
              initialSchedule: _schedule.isNotEmpty ? _schedule : null,
            ),
      ),
    );

    if (result != null) {
      setState(() {
        _schedule = result;
      });
    }
  }

  Future<void> _createClassroom() async {
    if (_formKey.currentState!.validate()) {
      // Validate dates
      if (_endDate.isBefore(_startDate)) {
        ToastUtils.showFail(
          context: context,
          message: 'Ngày kết thúc phải sau ngày bắt đầu',
        );
        return;
      }

      // Validate schedule
      if (_schedule.isEmpty) {
        ToastUtils.showWarning(
          context: context,
          message: 'Vui lòng thiết lập lịch học',
        );
        return;
      }

      try {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );

        // Create DTO
        final createClassroomDto = CreateClassroomDto(
          name: _nameController.text.trim(),
          code: _selectedSubject.value,
          grade: _selectedGrade.value,
          numberOfLessons: int.parse(_expectedSessionsController.text),
          startDate: _startDate.toIso8601String(),
          endDate: _endDate.toIso8601String(),
          schedule:
              _schedule
                  .map(
                    (s) => ScheduleItemDto(
                      dayOfWeek: s.dayOfWeek,
                      startTime: s.startTime,
                      endTime: s.endTime,
                    ),
                  )
                  .toList(),
        );

        // Call API
        final useCase = ref.read(createClassroomUseCaseProvider);
        final result = await useCase(createClassroomDto);

        // Hide loading
        Navigator.of(context).pop();

        // Show success
        ToastUtils.showSuccess(
          context: context,
          message: 'Tạo lớp học thành công!',
        );

        print('✅ Created classroom: ${result.name}');

        // Navigate back
        Navigator.of(context).pop();
      } catch (e) {
        // Hide loading
        Navigator.of(context).pop();

        // Show error
        ToastUtils.showFail(
          context: context,
          message: 'Tạo lớp học thất bại: ${e.toString()}',
        );

        print('❌ Failed to create classroom: $e');
      }
    }
  }
}
