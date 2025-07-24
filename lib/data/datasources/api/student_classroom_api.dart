import 'package:dio/dio.dart';

import '../../dto/classroom_dto.dart';
import '../../dto/classroom_details_dto.dart';
import '../../dto/classroom_lookup_dto.dart';
import '../../../core/error/api_error_handler.dart';
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

  // Get classroom details
  Future<ClassroomDetailsStudentResponseDto> getDetails(
    String classroomId,
  ) async {
    try {
      final response = await _apiService.get(
        '/student-classrooms/$classroomId/details',
      );
      return ClassroomDetailsStudentResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Get classroom details failed: $e');
    }
  }

  // Lookup classroom by code
  Future<ClassroomPreviewResponseDto> lookupClassroom(String code) async {
    try {
      final response = await _apiService.get(
        '/student-classrooms/lookup-classrooms',
        queryParams: {'code': code},
      );
      return ClassroomPreviewResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Lookup classroom failed: $e');
    }
  }

  // Join classroom by code
  Future<void> joinClassroom(String joinCode) async {
    try {
      await _apiService.post(
        '/student-classrooms/join',
        data: {'joinCode': joinCode},
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Join classroom failed: $e');
    }
  }

  // Error handling
  Exception _handleDioError(DioException e) {
    return ApiErrorHandler.createException(e);
  }
}
