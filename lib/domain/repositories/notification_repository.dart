import '../../data/dto/notification_dto.dart';

abstract class NotificationRepository {
  Future<UnreadCountResponse> getUnreadCount();

  Future<List<NotificationResponseDto>> getAll({int page = 1, int limit = 10});

  Future<List<NotificationResponseDto>> getUnread();

  Future<void> markAsRead(String id);

  Future<void> markAllAsRead();
}
