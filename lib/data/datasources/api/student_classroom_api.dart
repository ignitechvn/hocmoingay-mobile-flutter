import 'package:dio/dio.dart';

import '../../dto/classroom_dto.dart';
import 'base_api_service.dart';

class StudentClassroomApi {
  final BaseApiService _apiService;

  StudentClassroomApi(this._apiService);

  // Get all student classrooms
  Future<StudentClassroomResponseListDto> getAllStudentClassrooms() async {
    try {
      final response = await _apiService.get('/student-classrooms/all');
      return StudentClassroomResponseListDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to get student classrooms: $e');
    }
  }

  // Error handling
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Kết nối mạng bị gián đoạn. Vui lòng thử lại.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Lỗi không xác định';

        switch (statusCode) {
          case 400:
            return Exception('Dữ liệu không hợp lệ: $message');
          case 401:
            return Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
          case 403:
            return Exception('Bạn không có quyền truy cập');
          case 404:
            return Exception('Không tìm thấy dữ liệu lớp học');
          case 422:
            return Exception('Dữ liệu không hợp lệ: $message');
          case 429:
            return Exception('Quá nhiều yêu cầu. Vui lòng thử lại sau.');
          case 500:
            return Exception('Lỗi máy chủ. Vui lòng thử lại sau.');
          default:
            return Exception('Lỗi: $message');
        }

      case DioExceptionType.cancel:
        return Exception('Yêu cầu bị hủy');

      case DioExceptionType.connectionError:
        return Exception('Không thể kết nối đến máy chủ');

      case DioExceptionType.badCertificate:
        return Exception('Lỗi chứng chỉ bảo mật');

      case DioExceptionType.unknown:
      default:
        return Exception('Lỗi không xác định: ${e.message}');
    }
  }
} 