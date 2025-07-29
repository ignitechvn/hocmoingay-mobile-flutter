import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final Color? confirmColor;
  final Color? cancelColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmDialog({
    super.key,
    required this.title,
    this.message = '',
    this.content,
    this.confirmText,
    this.cancelText,
    this.confirmColor,
    this.cancelColor,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content:
          content ??
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: cancelColor ?? AppColors.textSecondary,
          ),
          child: Text(
            cancelText ?? 'Hủy',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Confirm button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            confirmText ?? 'Xác nhận',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
    );
  }
}

// Rich content widgets for specific confirmations
class DeleteQuestionContent extends StatelessWidget {
  const DeleteQuestionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main question
        Text(
          'Bạn có chắc chắn muốn xóa câu hỏi này không?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Warning message
        Text(
          'Hành động này sẽ xóa vĩnh viễn câu hỏi khỏi ngân hàng câu hỏi. Thao tác không thể hoàn tác.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class DeleteClassroomContent extends StatelessWidget {
  final String className;

  const DeleteClassroomContent({
    super.key,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main question
        Text(
          'Bạn có chắc chắn muốn xóa lớp học "$className"?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Results section
        Text(
          'Kết quả của việc xóa lớp học:',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Bullet points
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBulletPoint('Tất cả dữ liệu của lớp học sẽ bị xóa vĩnh viễn'),
              _buildBulletPoint('Học sinh sẽ không thể truy cập vào lớp học này nữa'),
              _buildBulletPoint('Tất cả bài tập, bài kiểm tra, và tiến độ học tập sẽ bị mất'),
              _buildBulletPoint('Không thể khôi phục lại dữ liệu sau khi xóa'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Warning message
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.warning.withOpacity(0.3),
            ),
          ),
          child: Text(
            'Hành động này không thể hoàn tác. Vui lòng cân nhắc kỹ trước khi xác nhận!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Convenience methods for common confirm dialogs
class ConfirmDialogHelper {
  static Future<bool> showDeleteConfirmation(
    BuildContext context, {
    required String itemName,
    String? customMessage,
    Widget? customContent,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => ConfirmDialog(
                title: 'Xác nhận xóa',
                message:
                    customMessage ??
                    'Bạn có chắc chắn muốn xóa "$itemName"? Hành động này không thể hoàn tác.',
                content: customContent,
                confirmText: 'Xóa',
                cancelText: 'Hủy',
                confirmColor: AppColors.error,
              ),
        ) ??
        false;
  }

  static Future<bool> showUpdateConfirmation(
    BuildContext context, {
    required String itemName,
    String? customMessage,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => ConfirmDialog(
                title: 'Xác nhận cập nhật',
                message:
                    customMessage ??
                    'Bạn có chắc chắn muốn cập nhật "$itemName"?',
                confirmText: 'Cập nhật',
                cancelText: 'Hủy',
                confirmColor: AppColors.primary,
              ),
        ) ??
        false;
  }

  static Future<bool> showCustomConfirmation(
    BuildContext context, {
    required String title,
    String? message,
    Widget? content,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => ConfirmDialog(
                title: title,
                message: message ?? '',
                content: content,
                confirmText: confirmText,
                cancelText: cancelText,
                confirmColor: confirmColor,
              ),
        ) ??
        false;
  }
}
