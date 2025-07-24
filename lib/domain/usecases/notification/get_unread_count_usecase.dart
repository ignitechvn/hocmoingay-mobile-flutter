import '../../base/base_use_case.dart';
import '../../repositories/notification_repository.dart';
import '../../../data/dto/notification_dto.dart';

class GetUnreadCountUseCase extends BaseUseCase<UnreadCountResponse, void> {
  final NotificationRepository _repository;

  GetUnreadCountUseCase(this._repository);

  @override
  Future<UnreadCountResponse> call(void params) async {
    return await _repository.getUnreadCount();
  }
}
