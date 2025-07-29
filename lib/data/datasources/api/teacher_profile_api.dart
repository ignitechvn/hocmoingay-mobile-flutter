import 'package:dio/dio.dart';

import '../../../core/error/api_error_handler.dart';
import '../../../core/error/api_exception.dart';
import '../../dto/teacher_profile_dto.dart';
import 'base_api_service.dart';

class TeacherProfileApi {
  final BaseApiService _apiService;

  TeacherProfileApi(this._apiService);

  // Create teacher profile
  Future<TeacherProfileResponseDto> createProfile(
    CreateTeacherProfileDto createDto,
  ) async {
    try {
      print('🔍 TeacherProfileApi: Creating profile...');
      print('🔍 TeacherProfileApi: DTO: ${createDto.toJson()}');

      final response = await _apiService.post(
        '/teacher-profiles',
        data: createDto.toJson(),
      );

      print('✅ TeacherProfileApi: Profile created successfully');
      print('📄 TeacherProfileApi: Response data: ${response.data}');

      final profile = TeacherProfileResponseDto.fromJson(response.data);
      return profile;
    } on DioException catch (e) {
      print('❌ TeacherProfileApi: DioException: ${e.message}');
      print('❌ TeacherProfileApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherProfileApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherProfileApi: General exception: $e');
      throw Exception('Create teacher profile failed: $e');
    }
  }

  // Get my teacher profile
  Future<TeacherProfileResponseDto?> getMyProfile() async {
    try {
      print('🔍 TeacherProfileApi: Getting my profile...');
      print(
        '🔍 TeacherProfileApi: URL: ${_apiService.dio.options.baseUrl}/teacher-profiles/my-profile',
      );
      final response = await _apiService.get('/teacher-profiles/my-profile');
      print('✅ TeacherProfileApi: Response received: ${response.statusCode}');
      print(
        '📄 TeacherProfileApi: Response data type: ${response.data.runtimeType}',
      );
      print('📄 TeacherProfileApi: Response data: "${response.data}"');

      // Handle null or empty response (no profile exists)
      if (response.data == null || response.data == '') {
        print('ℹ️ TeacherProfileApi: No profile exists (null/empty response)');
        return null;
      }

      // Check if response.data is a string (not JSON)
      if (response.data is String) {
        print(
          'ℹ️ TeacherProfileApi: Response is string, treating as no profile',
        );
        return null;
      }

      final profile = TeacherProfileResponseDto.fromJson(response.data);
      print('✅ TeacherProfileApi: Profile parsed successfully');
      return profile;
    } on DioException catch (e) {
      print('❌ TeacherProfileApi: DioException: ${e.message}');
      print('❌ TeacherProfileApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherProfileApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherProfileApi: General exception: $e');
      throw Exception('Get teacher profile failed: $e');
    }
  }

  // Update teacher profile
  Future<TeacherProfileResponseDto> updateProfile(
    UpdateTeacherProfileDto updateDto,
  ) async {
    try {
      print('🔍 TeacherProfileApi: Updating profile...');
      print('🔍 TeacherProfileApi: DTO: ${updateDto.toJson()}');
      final response = await _apiService.patch(
        '/teacher-profiles',
        data: updateDto.toJson(),
      );
      print('✅ TeacherProfileApi: Profile updated successfully');
      print('📄 TeacherProfileApi: Response data: ${response.data}');
      final profile = TeacherProfileResponseDto.fromJson(response.data);
      return profile;
    } on DioException catch (e) {
      print('❌ TeacherProfileApi: DioException: ${e.message}');
      print('❌ TeacherProfileApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherProfileApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherProfileApi: General exception: $e');
      throw Exception('Update teacher profile failed: $e');
    }
  }

  // Test method to check if API is working
  Future<void> testConnection() async {
    try {
      print('🔍 TeacherProfileApi: Testing connection...');
      final response = await _apiService.get(
        '/auth/profile',
      ); // Use a simple endpoint
      print(
        '✅ TeacherProfileApi: Test connection successful: ${response.statusCode}',
      );
    } on DioException catch (e) {
      print('❌ TeacherProfileApi: Test connection failed: ${e.message}');
      print('❌ TeacherProfileApi: Status code: ${e.response?.statusCode}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherProfileApi: Test connection general error: $e');
      throw Exception('Test connection failed: $e');
    }
  }

  // Error handling
  Exception _handleDioError(DioException e) {
    final errorResponse = ApiErrorHandler.parseErrorResponse(e);
    if (errorResponse != null) {
      return ApiException(
        message: ApiErrorHandler.getUserFriendlyMessage(errorResponse),
        statusCode: e.response?.statusCode ?? 500,
        errorCode: errorResponse.error,
      );
    }
    return ApiException(
      message: 'Network error: ${e.message}',
      statusCode: e.response?.statusCode ?? 500,
      errorCode: 'NETWORK_ERROR',
    );
  }
}
