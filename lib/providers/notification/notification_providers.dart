import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api/notification_api.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/usecases/notification/get_notifications_usecase.dart';
import '../../domain/usecases/notification/get_unread_count_usecase.dart';
import '../../domain/usecases/notification/mark_as_read_usecase.dart';
import '../../domain/usecases/notification/mark_all_as_read_usecase.dart';
import '../../data/dto/notification_dto.dart';
import '../api/api_providers.dart';

// API Provider
final notificationApiProvider = Provider<NotificationApi>((ref) {
  final baseApiService = ref.watch(authenticatedBaseApiServiceProvider);
  return NotificationApi(baseApiService);
});

// Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepositoryImpl>((
  ref,
) {
  final api = ref.watch(notificationApiProvider);
  return NotificationRepositoryImpl(api);
});

// Use Case Providers
final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((
  ref,
) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetNotificationsUseCase(repository);
});

final getUnreadCountUseCaseProvider = Provider<GetUnreadCountUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetUnreadCountUseCase(repository);
});

final markAsReadUseCaseProvider = Provider<MarkAsReadUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkAsReadUseCase(repository);
});

final markAllAsReadUseCaseProvider = Provider<MarkAllAsReadUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkAllAsReadUseCase(repository);
});

// Data Providers
final notificationsProvider = FutureProvider<List<NotificationResponseDto>>((
  ref,
) async {
  final useCase = ref.watch(getNotificationsUseCaseProvider);
  return await useCase(GetNotificationsParams());
});

final unreadCountProvider = FutureProvider<UnreadCountResponse>((ref) async {
  final useCase = ref.watch(getUnreadCountUseCaseProvider);
  return await useCase(null);
});
