import 'package:flutter/material.dart';
import '../../core/constants/chapter_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class UpdateChapterStatusDialog extends StatefulWidget {
  final String chapterTitle;
  final EChapterStatus currentStatus;

  const UpdateChapterStatusDialog({
    super.key,
    required this.chapterTitle,
    required this.currentStatus,
  });

  @override
  State<UpdateChapterStatusDialog> createState() =>
      _UpdateChapterStatusDialogState();
}

class _UpdateChapterStatusDialogState extends State<UpdateChapterStatusDialog> {
  late EChapterStatus _selectedStatus;

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
          'Cập nhật trạng thái chủ đề',
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
              'Chủ đề: ${widget.chapterTitle}',
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
            ...EChapterStatus.values.map(
              (status) => _buildStatusOption(status),
            ),
          ],
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
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

  Widget _buildStatusOption(EChapterStatus status) {
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

  Color _getStatusColor(EChapterStatus status) {
    switch (status) {
      case EChapterStatus.SCHEDULED:
        return const Color(0xFF2196F3); // Blue
      case EChapterStatus.OPEN:
        return const Color(0xFF4CAF50); // Green
      case EChapterStatus.CLOSED:
        return const Color(0xFFF44336); // Red
      case EChapterStatus.CANCELED:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  String _getStatusLabel(EChapterStatus status) {
    switch (status) {
      case EChapterStatus.SCHEDULED:
        return 'Đã lên lịch';
      case EChapterStatus.OPEN:
        return 'Đang mở';
      case EChapterStatus.CLOSED:
        return 'Đã đóng';
      case EChapterStatus.CANCELED:
        return 'Đã hủy';
    }
  }
}

class UpdateChapterStatusHelper {
  static Future<EChapterStatus?> showUpdateStatusDialog(
    BuildContext context, {
    required String chapterTitle,
    required EChapterStatus currentStatus,
  }) async {
    return await showDialog<EChapterStatus>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => UpdateChapterStatusDialog(
            chapterTitle: chapterTitle,
            currentStatus: currentStatus,
          ),
    );
  }
}
