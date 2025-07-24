import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/classroom.dart';
import '../../../../providers/student_classroom/student_classroom_providers.dart';
import 'widgets/schedule_event_card.dart';
import 'widgets/week_selector.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
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
  Widget build(BuildContext context) {
    final classroomsAsync = ref.watch(studentClassroomsProvider);

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text(
          'Thời khóa biểu',
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
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: classroomsAsync.when(
                data: (classrooms) => _buildScheduleTimeline(classrooms),
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stack) => Center(
                      child: Text(
                        'Đã xảy ra lỗi khi tải thời khóa biểu',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTimeline(StudentClassrooms classrooms) {
    // Get all active classrooms (ongoing and enrolling)
    final activeClassrooms = [
      ...classrooms.ongoingClassrooms,
      ...classrooms.enrollingClassrooms,
    ];

    // Filter classrooms that are active in current week
    final weekClassrooms =
        activeClassrooms.where((classroom) {
          return classroom.startDate.isBefore(
                _weekEnd.add(const Duration(days: 1)),
              ) &&
              classroom.endDate.isAfter(
                _weekStart.subtract(const Duration(days: 1)),
              );
        }).toList();

    // Debug: Print week range and classrooms
    print(
      '🕐 Week range: ${_weekStart.toString().split(' ')[0]} to ${_weekEnd.toString().split(' ')[0]}',
    );
    print('📚 Active classrooms: ${activeClassrooms.length}');
    print('📅 Week classrooms: ${weekClassrooms.length}');
    for (final classroom in activeClassrooms) {
      print(
        '  - ${classroom.name}: ${classroom.startDate.toString().split(' ')[0]} to ${classroom.endDate.toString().split(' ')[0]}',
      );
      print(
        '    Schedule: ${classroom.schedule.map((s) => '${s.dayOfWeekText} ${s.startTime}-${s.endTime}').join(', ')}',
      );
    }

    // Group classrooms by day and time
    final scheduleMap = <int, List<ClassroomStudent>>{};
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

  List<Widget> _buildTimelineRows(
    Map<int, List<ClassroomStudent>> scheduleMap,
  ) {
    // Define time slots based on actual API data
    final timeSlots = [
      {'start': '12:00', 'end': '15:00'}, // Thứ 3: Lớp toán 12 ca tối
      {'start': '15:00', 'end': '17:00'}, // Thứ 4: Lớp toán 12 ca chiều
      {'start': '17:00', 'end': '22:00'}, // Thứ 5: Lớp học tiếng Anh lớp 8
    ];

    // Debug: Print time slots
    print(
      '⏰ Time slots: ${timeSlots.map((slot) => '${slot['start']}-${slot['end']}').join(', ')}',
    );

    return timeSlots.map((slot) {
      return Container(
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
                  Container(width: 2, height: 100, color: AppColors.grey300),
                  Positioned(
                    top: 0,
                    left: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            _hasClassInTimeSlot(scheduleMap, slot)
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
      );
    }).toList();
  }

  bool _hasClassInTimeSlot(
    Map<int, List<ClassroomStudent>> scheduleMap,
    Map<String, String> slot,
  ) {
    for (final day in scheduleMap.keys) {
      final classrooms = scheduleMap[day]!;
      for (final classroom in classrooms) {
        if (_isClassInTimeSlot(classroom, slot)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isClassInTimeSlot(
    ClassroomStudent classroom,
    Map<String, String> slot,
  ) {
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
    Map<int, List<ClassroomStudent>> scheduleMap,
    Map<String, String> slot,
  ) {
    // Get the selected day of week (1 = Monday, 7 = Sunday)
    final selectedDayOfWeek = _selectedDate.weekday;

    // Find classrooms for the selected day and time slot
    final classroomsForDay = scheduleMap[selectedDayOfWeek] ?? [];
    List<ClassroomStudent> classroomsInSlot = [];

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
      child: ScheduleEventCard(classroom: classroom),
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

  String _getDayName(int index) {
    switch (index) {
      case 0:
        return 'T2';
      case 1:
        return 'T3';
      case 2:
        return 'T4';
      case 3:
        return 'T5';
      case 4:
        return 'T6';
      case 5:
        return 'T7';
      case 6:
        return 'CN';
      default:
        return '';
    }
  }
}
