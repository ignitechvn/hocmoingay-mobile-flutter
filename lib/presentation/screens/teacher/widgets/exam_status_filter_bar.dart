import 'package:flutter/material.dart';
import '../../../../core/constants/exam_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ExamStatusFilterBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onStatusChanged;

  const ExamStatusFilterBar({
    super.key,
    required this.selectedIndex,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final statusOptions = [
      {'label': 'Đã lên lịch', 'status': EExamStatus.SCHEDULED},
      {'label': 'Đang mở', 'status': EExamStatus.OPEN},
      {'label': 'Đã đóng', 'status': EExamStatus.CLOSED},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children:
            statusOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final status = entry.value;
              final isSelected = index == selectedIndex;
              final statusEnum = status['status'] as EExamStatus;
              final statusColor = _getStatusColor(statusEnum);

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
                        color: isSelected ? statusColor : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? statusColor : AppColors.grey300,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        status['label'] as String,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color:
                              isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(        ),
      ),
    );
  }

  Color _getStatusColor(EExamStatus status) {
    switch (status) {
      case EExamStatus.SCHEDULED:
        return const Color(0xFF2196F3); // Blue
      case EExamStatus.OPEN:
        return const Color(0xFF4CAF50); // Green
      case EExamStatus.CLOSED:
        return const Color(0xFFF44336); // Red
    }
  }
}
