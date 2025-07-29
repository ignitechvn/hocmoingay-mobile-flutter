import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../domain/entities/classroom.dart';
import '../student/schedule/widgets/week_selector.dart';
import 'widgets/common_schedule_event_card.dart';

class CommonScheduleScreen extends ConsumerStatefulWidget {
  const CommonScheduleScreen({
    super.key,
    required this.classrooms,
    this.title = 'Thời khóa biểu',
  });
  final List<Classroom> classrooms;
  final String title;

  @override
  ConsumerState<CommonScheduleScreen> createState() =>
      _CommonScheduleScreenState();
}

class _CommonScheduleScreenState extends ConsumerState<CommonScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _weekStart;
  late DateTime _weekEnd;

  @override
  void initState() {
    super.initState();
    _calculateWeekRange();
  }

  void _calculateWeekRange() {
    // Calculate Monday of current week
    _weekStart = _selectedDate.subtract(
      Duration(days: _selectedDate.weekday - 1),
    );
    _weekEnd = _weekStart.add(const Duration(days: 6));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.grey50,
    appBar: AppBar(
      title: Text(
        widget.title,
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    body: Column(
      children: [
        // Date Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                _getFormattedDate(),
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Week Selector
        WeekSelector(
          weekStart: _weekStart,
          selectedDate: _selectedDate,
          onDateSelected: (date) {
            setState(() {
              _selectedDate = date;
              _calculateWeekRange();
            });
          },
        ),

        // Schedule Timeline
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: _buildScheduleTimeline(),
          ),
        ),
      ],
    ),
  );

  Widget _buildScheduleTimeline() {
    // Filter classrooms that are active in current week
    final weekClassrooms = widget.classrooms
        .where(
          (Classroom classroom) =>
              classroom.startDate.isBefore(
                _weekEnd.add(const Duration(days: 1)),
              ) &&
              classroom.endDate.isAfter(
                _weekStart.subtract(const Duration(days: 1)),
              ),
        )
        .toList();

    // Group classrooms by day and time
    final scheduleMap = <int, List<Classroom>>{};
    for (final classroom in weekClassrooms) {
      for (final schedule in classroom.schedule) {
        final dayOfWeek = schedule.dayOfWeek;
        if (!scheduleMap.containsKey(dayOfWeek)) {
          scheduleMap[dayOfWeek] = [];
        }
        scheduleMap[dayOfWeek]!.add(classroom);
      }
    }

    // Sort classrooms by start time
    for (final day in scheduleMap.keys) {
      scheduleMap[day]!.sort((a, b) {
        final aSchedule = a.schedule.firstWhere((s) => s.dayOfWeek == day);
        final bSchedule = b.schedule.firstWhere((s) => s.dayOfWeek == day);
        return aSchedule.startTime.compareTo(bSchedule.startTime);
      });
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 1, // Single timeline view
      itemBuilder: (context, index) {
        return Column(children: _buildTimelineRows(scheduleMap));
      },
    );
  }

  List<Widget> _buildTimelineRows(Map<int, List<Classroom>> scheduleMap) {
    // Get the selected day of week (1 = Monday, 7 = Sunday)
    final selectedDayOfWeek = _selectedDate.weekday;

    // Extract unique time slots only for the selected day
    final Set<String> uniqueTimeSlots = {};

    // Only get classrooms for the selected day
    final classroomsForDay = scheduleMap[selectedDayOfWeek] ?? [];

    for (final classroom in classroomsForDay) {
      for (final schedule in classroom.schedule) {
        // Only include schedules for the selected day
        if (schedule.dayOfWeek == selectedDayOfWeek) {
          // Convert API time format (HH:mm:ss) to slot format (HH:mm)
          final startTime = schedule.startTime.substring(0, 5);
          final endTime = schedule.endTime.substring(0, 5);
          uniqueTimeSlots.add('$startTime-$endTime');
        }
      }
    }

    // Convert to list and sort by start time
    final timeSlots = uniqueTimeSlots.map((timeSlot) {
      final parts = timeSlot.split('-');
      return {'start': parts[0], 'end': parts[1]};
    }).toList();

    // Sort time slots by start time
    timeSlots.sort((a, b) => a['start']!.compareTo(b['start']!));

    // Debug: Print time slots
    print(
      '⏰ Time slots for ${_selectedDate.weekday == 1
          ? 'Monday'
          : _selectedDate.weekday == 2
          ? 'Tuesday'
          : _selectedDate.weekday == 3
          ? 'Wednesday'
          : _selectedDate.weekday == 4
          ? 'Thursday'
          : _selectedDate.weekday == 5
          ? 'Friday'
          : _selectedDate.weekday == 6
          ? 'Saturday'
          : 'Sunday'}: ${timeSlots.map((slot) => '${slot['start']}-${slot['end']}').join(', ')}',
    );

    if (timeSlots.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(32),
          child: EmptyStateWidget(
            message: 'Không có lịch học nào trong ngày này',
          ),
        ),
      ];
    }

    return timeSlots
        .map(
          (slot) => Container(
            margin: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                // Time column
                SizedBox(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        slot['start']!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        slot['end']!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Timeline marker
                Container(
                  width: 20,
                  child: Stack(
                    children: [
                      Container(
                        width: 2,
                        height: 100,
                        color: AppColors.grey300,
                      ),
                      Positioned(
                        top: 0,
                        left: 6,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _hasClassInTimeSlot(scheduleMap, slot)
                                ? AppColors.primary
                                : AppColors.grey300,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Schedule content (full width)
                Expanded(child: _buildScheduleContent(scheduleMap, slot)),
              ],
            ),
          ),
        )
        .toList();
  }

  bool _hasClassInTimeSlot(
    Map<int, List<Classroom>> scheduleMap,
    Map<String, String> slot,
  ) {
    // Get the selected day of week (1 = Monday, 7 = Sunday)
    final selectedDayOfWeek = _selectedDate.weekday;

    // Only check classrooms for the selected day
    final classroomsForDay = scheduleMap[selectedDayOfWeek] ?? [];

    for (final classroom in classroomsForDay) {
      if (_isClassInTimeSlot(classroom, slot)) {
        return true;
      }
    }
    return false;
  }

  bool _isClassInTimeSlot(Classroom classroom, Map<String, String> slot) {
    // Check if any schedule matches the time slot
    for (final schedule in classroom.schedule) {
      // Convert API time format (HH:mm:ss) to slot format (HH:mm)
      final apiStartTime = schedule.startTime.substring(
        0,
        5,
      ); // Take only HH:mm
      final apiEndTime = schedule.endTime.substring(0, 5); // Take only HH:mm

      print(
        '🔍 Checking: ${classroom.name} - ${apiStartTime}-${apiEndTime} vs ${slot['start']}-${slot['end']}',
      );

      if (apiStartTime == slot['start'] && apiEndTime == slot['end']) {
        print('✅ Match found: ${classroom.name}');
        return true;
      }
    }
    return false;
  }

  Widget _buildScheduleContent(
    Map<int, List<Classroom>> scheduleMap,
    Map<String, String> slot,
  ) {
    // Get the selected day of week (1 = Monday, 7 = Sunday)
    final selectedDayOfWeek = _selectedDate.weekday;

    // Find classrooms for the selected day and time slot
    final classroomsForDay = scheduleMap[selectedDayOfWeek] ?? [];
    List<Classroom> classroomsInSlot = [];

    for (final classroom in classroomsForDay) {
      if (_isClassInTimeSlot(classroom, slot)) {
        classroomsInSlot.add(classroom);
      }
    }

    if (classroomsInSlot.isEmpty) {
      return Container(); // Empty space
    }

    // Show the first classroom found for the selected day
    final classroom = classroomsInSlot.first;

    return Container(
      height: 100,
      margin: const EdgeInsets.only(left: 8),
      child: CommonScheduleEventCard(classroom: classroom),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final isToday =
        _selectedDate.day == now.day &&
        _selectedDate.month == now.month &&
        _selectedDate.year == now.year;

    final dateString = DateFormat('dd/MM/yyyy').format(_selectedDate);

    if (isToday) {
      return '$dateString (Hôm nay)';
    } else {
      return dateString;
    }
  }
}
