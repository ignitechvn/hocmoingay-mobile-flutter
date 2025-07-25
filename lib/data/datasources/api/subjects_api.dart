import 'package:dio/dio.dart';

import '../../../core/error/api_error_handler.dart';
import '../../../core/error/api_exception.dart';
import '../../dto/subject_dto.dart';
import 'base_api_service.dart';

class SubjectsApi {
  final BaseApiService _apiService;

  SubjectsApi(this._apiService);

  /// Get all subjects for teacher
  Future<List<SubjectResponseDto>> getAllSubjects() async {
    try {
      print('🔍 SubjectsApi: Calling GET /subjects');
      final response = await _apiService.get('/subjects');
      print('✅ SubjectsApi: Success response: ${response.data}');

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => SubjectResponseDto.fromJson(json)).toList();
    } on DioException catch (e) {
      print('❌ SubjectsApi: DioException: ${e.message}');
      print('❌ SubjectsApi: Status code: ${e.response?.statusCode}');
      print('❌ SubjectsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ SubjectsApi: General exception: $e');
      throw Exception('Failed to get subjects: $e');
    }
  }

  /// Create new subject
  Future<SubjectResponseDto> createSubject(CreateSubjectDto dto) async {
    try {
      print(
        '🔍 SubjectsApi: Calling POST /subjects with data: ${dto.toJson()}',
      );
      final response = await _apiService.post('/subjects', data: dto.toJson());
      print('✅ SubjectsApi: Create subject success response: ${response.data}');
      return SubjectResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ SubjectsApi: DioException: ${e.message}');
      print('❌ SubjectsApi: Status code: ${e.response?.statusCode}');
      print('❌ SubjectsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ SubjectsApi: General exception: $e');
      throw Exception('Failed to create subject: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('Unauthorized');
    } else if (e.response?.statusCode == 403) {
      return Exception('Forbidden');
    } else if (e.response?.statusCode == 404) {
      return Exception('Not found');
    } else if (e.response?.statusCode == 500) {
      return Exception('Server error');
    } else {
      return Exception('Network error');
    }
  }
}
