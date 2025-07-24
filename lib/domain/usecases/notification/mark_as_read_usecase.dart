import '../../base/base_use_case.dart';
import '../../repositories/notification_repository.dart';

class MarkAsReadUseCase extends BaseUseCase<void, String> {
  final NotificationRepository _repository;

  MarkAsReadUseCase(this._repository);

  @override
  Future<void> call(String notificationId) async {
    await _repository.markAsRead(notificationId);
  }
}
