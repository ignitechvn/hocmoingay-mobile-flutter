import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class WeekSelector extends StatelessWidget {
  final DateTime weekStart;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeekSelector({
    super.key,
    required this.weekStart,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Previous week button
          GestureDetector(
            onTap: () {
              final previousWeek = weekStart.subtract(const Duration(days: 7));
              onDateSelected(previousWeek);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.chevron_left,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Week days
          Expanded(
            child: Row(
              children: List.generate(7, (index) {
                final day = weekStart.add(Duration(days: index));
                final isSelected =
                    day.day == selectedDate.day &&
                    day.month == selectedDate.month &&
                    day.year == selectedDate.year;
                final isToday =
                    day.day == DateTime.now().day &&
                    day.month == DateTime.now().month &&
                    day.year == DateTime.now().year;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onDateSelected(day),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            isToday && !isSelected
                                ? Border.all(color: AppColors.primary, width: 1)
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          _getDayName(index),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color:
                                isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(width: 12),

          // Next week button
          GestureDetector(
            onTap: () {
              final nextWeek = weekStart.add(const Duration(days: 7));
              onDateSelected(nextWeek);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.chevron_right,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
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
