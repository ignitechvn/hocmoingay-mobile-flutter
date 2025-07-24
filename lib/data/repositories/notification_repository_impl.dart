import '../../domain/repositories/notification_repository.dart';
import '../datasources/api/notification_api.dart';
import '../dto/notification_dto.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApi _notificationApi;

  NotificationRepositoryImpl(this._notificationApi);

  @override
  Future<UnreadCountResponse> getUnreadCount() async {
    return await _notificationApi.getUnreadCount();
  }

  @override
  Future<List<NotificationResponseDto>> getAll({
    int page = 1,
    int limit = 10,
  }) async {
    return await _notificationApi.getAll(page: page, limit: limit);
  }

  @override
  Future<List<NotificationResponseDto>> getUnread() async {
    return await _notificationApi.getUnread();
  }

  @override
  Future<void> markAsRead(String id) async {
    await _notificationApi.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() async {
    await _notificationApi.markAllAsRead();
  }
}
