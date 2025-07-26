import 'package:flutter/material.dart';

import '../constants/classroom_status_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class UpdateClassroomStatusDialog extends StatefulWidget {
  final String className;
  final EClassroomStatus currentStatus;

  const UpdateClassroomStatusDialog({
    super.key,
    required this.className,
    required this.currentStatus,
  });

  @override
  State<UpdateClassroomStatusDialog> createState() =>
      _UpdateClassroomStatusDialogState();
}

class _UpdateClassroomStatusDialogState
    extends State<UpdateClassroomStatusDialog> {
  late EClassroomStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Cập nhật trạng thái lớp học',
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lớp học: ${widget.className}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Chọn trạng thái mới:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...EClassroomStatus.values.map(
            (status) => _buildStatusOption(status),
          ),
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
          child: Text(
            'Hủy',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Update button
        ElevatedButton(
          onPressed:
              _selectedStatus == widget.currentStatus
                  ? null // Disable if no change
                  : () => Navigator.of(context).pop(_selectedStatus),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            'Cập nhật',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
    ),
  );
  }

  Widget _buildStatusOption(EClassroomStatus status) {
    final isSelected = _selectedStatus == status;
    final isCurrentStatus = status == widget.currentStatus;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap:
            isCurrentStatus
                ? null
                : () {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.grey300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Radio button
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.grey400,
                    width: 2,
                  ),
                ),
                child:
                    isSelected
                        ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                        : null,
              ),
              const SizedBox(width: 12),
              // Status text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusLabel(status),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color:
                            isCurrentStatus
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isCurrentStatus) ...[
                      const SizedBox(height: 2),
                      Text(
                        '(Trạng thái hiện tại)',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusLabel(EClassroomStatus status) {
    switch (status) {
      case EClassroomStatus.ENROLLING:
        return 'Đang tuyển sinh';
      case EClassroomStatus.ONGOING:
        return 'Đang diễn ra';
      case EClassroomStatus.FINISHED:
        return 'Đã kết thúc';
      case EClassroomStatus.CANCELED:
        return 'Đã hủy';
    }
  }
}

// Helper class for showing the dialog
class UpdateClassroomStatusHelper {
  static Future<EClassroomStatus?> showUpdateStatusDialog(
    BuildContext context, {
    required String className,
    required EClassroomStatus currentStatus,
  }) async {
    return await showDialog<EClassroomStatus>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => UpdateClassroomStatusDialog(
            className: className,
            currentStatus: currentStatus,
          ),
    );
  }
}
