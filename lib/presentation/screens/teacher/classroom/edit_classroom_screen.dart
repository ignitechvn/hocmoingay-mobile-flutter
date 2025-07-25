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
import '../../../../data/dto/teacher_classroom_dto.dart';
import '../../../../domain/entities/classroom.dart';
import 'schedule_setup_screen.dart';

class EditClassroomScreen extends ConsumerStatefulWidget {
  final ClassroomDetailsTeacherResponseDto classroom;

  const EditClassroomScreen({super.key, required this.classroom});

  @override
  ConsumerState<EditClassroomScreen> createState() =>
      _EditClassroomScreenState();
}

class _EditClassroomScreenState extends ConsumerState<EditClassroomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _expectedSessionsController = TextEditingController();

  EGradeLevel _selectedGrade = EGradeLevel.GRADE_1;
  ESubjectCode _selectedSubject = ESubjectCode.MATH;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  List<Schedule> _schedule = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Pre-populate form with existing classroom data
    _nameController.text = widget.classroom.name;
    _selectedSubject = ESubjectCode.fromString(widget.classroom.code);
    _selectedGrade = EGradeLevel.fromString(widget.classroom.grade);

    if (widget.classroom.startDate != null) {
      try {
        _startDate = DateTime.parse(widget.classroom.startDate!);
      } catch (e) {
        _startDate = DateTime.now();
      }
    }

    if (widget.classroom.endDate != null) {
      try {
        _endDate = DateTime.parse(widget.classroom.endDate!);
      } catch (e) {
        _endDate = DateTime.now().add(const Duration(days: 30));
      }
    }

    // Convert schedule from DTO to entity
    if (widget.classroom.schedule != null) {
      _schedule =
          widget.classroom.schedule!
              .map(
                (s) => Schedule(
                  dayOfWeek: s.dayOfWeek,
                  startTime: s.startTime,
                  endTime: s.endTime,
                ),
              )
              .toList();
    }
  }

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
          'Chỉnh sửa lớp học',
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
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
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
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
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
              TextFormField(
                controller: _expectedSessionsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số buổi học';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Số buổi học phải là số dương';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Nhập số buổi học',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey500,
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
                  contentPadding: const EdgeInsets.all(16),
                ),
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
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _startDate = date;
                    });
                  }
                },
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
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.textSecondary,
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
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: _startDate,
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _endDate = date;
                    });
                  }
                },
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
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.textSecondary,
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
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => ScheduleSetupScreen(
                                  initialSchedule: _schedule,
                                ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _schedule = result;
                          });
                        }
                      },
                      text: 'Thiết lập lịch học',
                      type: AppButtonType.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Hiển thị lịch học đã thiết lập
              if (_schedule.isNotEmpty) ...[
                Text(
                  'Lịch học đã thiết lập',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children:
                          _schedule.map((schedule) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${_getDayOfWeekText(schedule.dayOfWeek)}: ${schedule.startTime} - ${schedule.endTime}',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Nút cập nhật
              AppButton(onPressed: _updateClassroom, text: 'Cập nhật lớp học'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateClassroom() async {
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

        // TODO: Call API to update classroom
        // For now, just show success message
        await Future.delayed(const Duration(seconds: 1));

        // Hide loading
        Navigator.of(context).pop();

        // Show success
        ToastUtils.showSuccess(
          context: context,
          message: 'Cập nhật lớp học thành công!',
        );

        // Navigate back
        Navigator.of(context).pop();
      } catch (e) {
        // Hide loading
        Navigator.of(context).pop();

        // Show error
        ToastUtils.showFail(
          context: context,
          message: 'Cập nhật lớp học thất bại: ${e.toString()}',
        );
      }
    }
  }

  String _getDayOfWeekText(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Thứ 2';
      case 2:
        return 'Thứ 3';
      case 3:
        return 'Thứ 4';
      case 4:
        return 'Thứ 5';
      case 5:
        return 'Thứ 6';
      case 6:
        return 'Thứ 7';
      case 7:
        return 'Chủ nhật';
      default:
        return 'Không xác định';
    }
  }
}
