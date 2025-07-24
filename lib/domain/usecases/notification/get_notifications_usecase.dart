import '../../base/base_use_case.dart';
import '../../repositories/notification_repository.dart';
import '../../../data/dto/notification_dto.dart';

class GetNotificationsUseCase
    extends BaseUseCase<List<NotificationResponseDto>, GetNotificationsParams> {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  @override
  Future<List<NotificationResponseDto>> call(
    GetNotificationsParams params,
  ) async {
    return await _repository.getAll(page: params.page, limit: params.limit);
  }
}

class GetNotificationsParams {
  final int page;
  final int limit;

  GetNotificationsParams({this.page = 1, this.limit = 10});
}
