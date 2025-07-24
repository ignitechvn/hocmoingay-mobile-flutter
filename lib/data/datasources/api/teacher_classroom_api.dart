import 'package:dio/dio.dart';

import '../../dto/classroom_dto.dart';
import '../../../core/error/api_error_handler.dart';
import 'base_api_service.dart';

class TeacherClassroomApi {
  final BaseApiService _apiService;

  TeacherClassroomApi(this._apiService);

  /// Get all classrooms for teacher
  Future<TeacherClassroomResponseListDto> getAllClassrooms() async {
    try {
      print('🔍 TeacherClassroomApi: Calling /teacher-classrooms/all');
      final response = await _apiService.get('/teacher-classrooms/all');
      print('✅ TeacherClassroomApi: Success response: ${response.data}');
      return TeacherClassroomResponseListDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherClassroomApi: DioException: ${e.message}');
      print('❌ TeacherClassroomApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherClassroomApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherClassroomApi: General exception: $e');
      throw Exception('Failed to get teacher classrooms: $e');
    }
  }

  // Error handling
  Exception _handleDioError(DioException e) {
    return ApiErrorHandler.createException(e);
  }
}
