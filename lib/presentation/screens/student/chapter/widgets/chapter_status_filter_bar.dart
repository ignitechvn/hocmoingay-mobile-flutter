import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class ChapterStatusFilterBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onStatusChanged;

  const ChapterStatusFilterBar({
    super.key,
    required this.selectedIndex,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final statusOptions = [
      {'label': 'Đã lên lịch', 'count': 0},
      {'label': 'Đang mở', 'count': 0},
      {'label': 'Đã đóng', 'count': 0},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children:
            statusOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final status = entry.value;
              final isSelected = index == selectedIndex;

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
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.primary
                                  : AppColors.grey300,
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
            }).toList(),
      ),
    );
  }
}
