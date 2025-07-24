import '../../base/base_use_case.dart';
import '../../repositories/notification_repository.dart';

class MarkAllAsReadUseCase extends BaseUseCase<void, void> {
  final NotificationRepository _repository;

  MarkAllAsReadUseCase(this._repository);

  @override
  Future<void> call(void params) async {
    await _repository.markAllAsRead();
  }
} 