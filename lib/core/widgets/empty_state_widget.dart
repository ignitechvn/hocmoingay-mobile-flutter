import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.message,
    super.key,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.onActionPressed,
    this.actionText,
    this.showAction = false,
  });
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? onActionPressed;
  final String? actionText;
  final bool showAction;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppDimensions.largePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon (optional)
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize ?? 80,
              color: iconColor ?? AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.largePadding),
          ],

          // Message
          Text(
            message,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          // Action Button (optional)
          if (showAction && actionText != null && onActionPressed != null) ...[
            const SizedBox(height: AppDimensions.largePadding),
            ElevatedButton(
              onPressed: onActionPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.largePadding,
                  vertical: AppDimensions.defaultPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                actionText!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

// Predefined empty states for common use cases
class EmptyStateWidgets {
  static Widget noData({
    String message = 'Không có dữ liệu',
    IconData? icon,
    VoidCallback? onRefresh,
  }) => EmptyStateWidget(
    message: message,
    icon: icon, // Remove default icon
    showAction: onRefresh != null,
    actionText: 'Thử lại',
    onActionPressed: onRefresh,
  );

  static Widget noClassrooms({VoidCallback? onRefresh}) => EmptyStateWidget(
    message: 'Chưa có lớp học nào',
    icon: null, // Remove icon
    showAction: onRefresh != null,
    actionText: 'Làm mới',
    onActionPressed: onRefresh,
  );

  static Widget noNotifications({VoidCallback? onRefresh}) => EmptyStateWidget(
    message: 'Không có thông báo nào',
    icon: null, // Remove icon
    showAction: onRefresh != null,
    actionText: 'Làm mới',
    onActionPressed: onRefresh,
  );

  static Widget noSearchResults({
    String query = '',
    VoidCallback? onClearSearch,
  }) => EmptyStateWidget(
    message:
        query.isNotEmpty
            ? 'Không tìm thấy kết quả cho "$query"'
            : 'Không tìm thấy kết quả',
    icon: null, // Remove icon
    showAction: onClearSearch != null,
    actionText: 'Xóa tìm kiếm',
    onActionPressed: onClearSearch,
  );

  static Widget error({
    required String message,
    VoidCallback? onRetry,
    IconData? icon,
  }) => EmptyStateWidget(
    message: message,
    icon: icon, // Remove default icon
    iconColor: AppColors.error,
    showAction: onRetry != null,
    actionText: 'Thử lại',
    onActionPressed: onRetry,
  );
}
