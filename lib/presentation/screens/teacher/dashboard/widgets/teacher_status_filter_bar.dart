import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/classroom_constants.dart';
import '../../../../../core/theme/app_text_styles.dart';

class TeacherStatusFilterBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onStatusChanged;

  const TeacherStatusFilterBar({
    super.key,
    required this.selectedIndex,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final statusOptions = [
      {'label': 'Đang tuyển sinh', 'status': ClassroomStatus.enrolling},
      {'label': 'Đang diễn ra', 'status': ClassroomStatus.ongoing},
      {'label': 'Đã kết thúc', 'status': ClassroomStatus.finished},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children:
            statusOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final status = entry.value;
              final isSelected = index == selectedIndex;
              final statusEnum = status['status'] as ClassroomStatus;

              // Get the darker color for this status
              final statusColor =
                  ClassroomStatusFilterBarColor.colors[statusEnum] ?? "#2196F3";
              final color = Color(
                int.parse(statusColor.replaceAll('#', '0xFF')),
              );

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < statusOptions.length - 1 ? 8 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => onStatusChanged(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? color : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? color : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        status['label'] as String,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
