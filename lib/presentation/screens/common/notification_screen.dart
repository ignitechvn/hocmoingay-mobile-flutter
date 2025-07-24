import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../data/dto/notification_dto.dart';
import '../../../providers/notification/notification_providers.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/constants/notification_constants.dart';

class CommonNotificationScreen extends ConsumerStatefulWidget {
  const CommonNotificationScreen({super.key});

  @override
  ConsumerState<CommonNotificationScreen> createState() =>
      _CommonNotificationScreenState();
}

class _CommonNotificationScreenState
    extends ConsumerState<CommonNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadCountAsync = ref.watch(unreadCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thông báo', style: AppTextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          // Mark all as read button
          unreadCountAsync.when(
            data: (unreadCount) {
              if (unreadCount.count > 0) {
                return TextButton(
                  onPressed: _markAllAsRead,
                  child: Text(
                    'Đánh dấu đã đọc',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(notificationsProvider);
          ref.invalidate(unreadCountProvider);
        },
        child: notificationsAsync.when(
          data: (notifications) {
            if (notifications.isEmpty) {
              return const Center(
                child: EmptyStateWidget(
                  message: 'Không có thông báo nào',
                  icon: null,
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.defaultPadding),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () => _markAsRead(notification.id),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            return Center(
              child: EmptyStateWidgets.error(
                message: 'Không thể tải thông báo',
                onRetry: () {
                  ref.invalidate(notificationsProvider);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      final useCase = ref.read(markAsReadUseCaseProvider);
      await useCase(notificationId);

      // Refresh data
      ref.invalidate(notificationsProvider);
      ref.invalidate(unreadCountProvider);

      ToastUtils.showSuccess(context: context, message: 'Đã đánh dấu đã đọc');
    } catch (e) {
      ToastUtils.showFail(
        context: context,
        message: 'Không thể đánh dấu đã đọc',
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final useCase = ref.read(markAllAsReadUseCaseProvider);
      await useCase(null);

      // Refresh data
      ref.invalidate(notificationsProvider);
      ref.invalidate(unreadCountProvider);

      ToastUtils.showSuccess(
        context: context,
        message: 'Đã đánh dấu tất cả đã đọc',
      );
    } catch (e) {
      ToastUtils.showFail(
        context: context,
        message: 'Không thể đánh dấu tất cả đã đọc',
      );
    }
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationResponseDto notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.smallPadding),
        decoration: BoxDecoration(
          color: notification.isRead ? AppColors.grey50 : AppColors.grey100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent, width: 0),
        ),
        child: Row(
          children: [
            // Badge indicator
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    notification.isRead ? AppColors.grey400 : AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: AppDimensions.smallPadding),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    NotificationConstants.generateNotificationContent(
                      notification.type,
                      notification.params,
                    ),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color:
                          notification.isRead
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Time
                  Text(
                    _formatTime(notification.createdDate),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return DateFormat('dd/MM/yyyy').format(date);
      } else if (difference.inHours > 0) {
        return '${difference.inHours} giờ trước';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} phút trước';
      } else {
        return 'Vừa xong';
      }
    } catch (e) {
      return 'Không xác định';
    }
  }
}
