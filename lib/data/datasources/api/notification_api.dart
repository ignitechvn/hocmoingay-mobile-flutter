import 'package:dio/dio.dart';

import '../../dto/notification_dto.dart';
import '../../../core/error/api_error_handler.dart';
import 'base_api_service.dart';

class NotificationApi {
  final BaseApiService _apiService;

  NotificationApi(this._apiService);

  // Get unread count
  Future<UnreadCountResponse> getUnreadCount() async {
    try {
      final response = await _apiService.get('/notifications/unread/count');
      return UnreadCountResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Get unread count failed: $e');
    }
  }

  // Get all notifications with pagination
  Future<List<NotificationResponseDto>> getAll({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.get(
        '/notifications',
        queryParams: {'page': page, 'limit': limit},
      );

      final List<dynamic> data = response.data;
      return data
          .map((json) => NotificationResponseDto.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Get notifications failed: $e');
    }
  }

  // Get unread notifications
  Future<List<NotificationResponseDto>> getUnread() async {
    try {
      final response = await _apiService.get('/notifications/unread');

      final List<dynamic> data = response.data;
      return data
          .map((json) => NotificationResponseDto.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Get unread notifications failed: $e');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String id) async {
    try {
      await _apiService.patch('/notifications/$id/read');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Mark as read failed: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      await _apiService.patch('/notifications/read-all');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Mark all as read failed: $e');
    }
  }

  // Error handling
  Exception _handleDioError(DioException e) {
    return ApiErrorHandler.createException(e);
  }
}
