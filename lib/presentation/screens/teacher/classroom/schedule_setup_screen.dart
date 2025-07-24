import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../domain/entities/classroom.dart';

class ScheduleSetupScreen extends StatefulWidget {
  final List<Schedule>? initialSchedule;

  const ScheduleSetupScreen({super.key, this.initialSchedule});

  @override
  State<ScheduleSetupScreen> createState() => _ScheduleSetupScreenState();
}

class _ScheduleSetupScreenState extends State<ScheduleSetupScreen> {
  final Map<int, bool> _selectedDays = {
    1: false, // Thứ 2
    2: false, // Thứ 3
    3: false, // Thứ 4
    4: false, // Thứ 5
    5: false, // Thứ 6
    6: false, // Thứ 7
    7: false, // Chủ nhật
  };

  final Map<int, String> _startTimes = {
    1: '08:00',
    2: '08:00',
    3: '08:00',
    4: '08:00',
    5: '08:00',
    6: '08:00',
    7: '08:00',
  };

  final Map<int, String> _endTimes = {
    1: '09:00',
    2: '09:00',
    3: '09:00',
    4: '09:00',
    5: '09:00',
    6: '09:00',
    7: '09:00',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialSchedule != null) {
      for (final schedule in widget.initialSchedule!) {
        _selectedDays[schedule.dayOfWeek] = true;
        _startTimes[schedule.dayOfWeek] = schedule.startTime;
        _endTimes[schedule.dayOfWeek] = schedule.endTime;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Thiết lập lịch học',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Chọn các ngày trong tuần và thiết lập thời gian học',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Days selection
            ..._selectedDays.entries.map((entry) {
              final dayOfWeek = entry.key;
              final isSelected = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.grey300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Day header with checkbox
                    ListTile(
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            _selectedDays[dayOfWeek] = value ?? false;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      title: Text(
                        _getDayName(dayOfWeek),
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Icon(
                        isSelected ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.textSecondary,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedDays[dayOfWeek] = !isSelected;
                        });
                      },
                    ),

                    // Time selection (only show if day is selected)
                    if (isSelected) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Giờ bắt đầu',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap:
                                        () => _selectTime(
                                          context,
                                          dayOfWeek,
                                          true,
                                        ),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.grey50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.grey300,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: AppColors.textSecondary,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _startTimes[dayOfWeek]!,
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Giờ kết thúc',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap:
                                        () => _selectTime(
                                          context,
                                          dayOfWeek,
                                          false,
                                        ),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.grey50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.grey300,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: AppColors.textSecondary,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _endTimes[dayOfWeek]!,
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: AppButton(text: 'Lưu lịch học', onPressed: _saveSchedule),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int dayOfWeek) {
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

  Future<void> _selectTime(
    BuildContext context,
    int dayOfWeek,
    bool isStartTime,
  ) async {
    final currentTime =
        isStartTime ? _startTimes[dayOfWeek]! : _endTimes[dayOfWeek]!;

    final timeParts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
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
        final timeString =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

        if (isStartTime) {
          _startTimes[dayOfWeek] = timeString;
          // Ensure end time is after start time
          if (_endTimes[dayOfWeek]!.compareTo(timeString) <= 0) {
            final endHour = picked.hour + 1;
            _endTimes[dayOfWeek] =
                '${endHour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
          }
        } else {
          _endTimes[dayOfWeek] = timeString;
        }
      });
    }
  }

  void _saveSchedule() {
    // Validate that at least one day is selected
    final selectedDays =
        _selectedDays.entries.where((entry) => entry.value).toList();

    if (selectedDays.isEmpty) {
      ToastUtils.showWarning(
        context: context,
        message: 'Vui lòng chọn ít nhất một ngày trong tuần',
      );
      return;
    }

    // Validate time for each selected day
    for (final entry in selectedDays) {
      final dayOfWeek = entry.key;
      final startTime = _startTimes[dayOfWeek]!;
      final endTime = _endTimes[dayOfWeek]!;

      if (endTime.compareTo(startTime) <= 0) {
        ToastUtils.showWarning(
          context: context,
          message:
              'Giờ kết thúc phải sau giờ bắt đầu cho ${_getDayName(dayOfWeek)}',
        );
        return;
      }
    }

    // Create schedule list
    final schedule =
        selectedDays.map((entry) {
          final dayOfWeek = entry.key;
          return Schedule(
            dayOfWeek: dayOfWeek,
            startTime: _startTimes[dayOfWeek]!,
            endTime: _endTimes[dayOfWeek]!,
          );
        }).toList();

    // Return schedule to previous screen
    Navigator.of(context).pop(schedule);
  }
}
