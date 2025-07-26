import 'package:dio/dio.dart';

import '../../../core/error/failures.dart';
import '../../dto/exam_dto.dart';
import 'base_api_service.dart';

class TeacherExamsApi {
  final BaseApiService _apiService;

  TeacherExamsApi(this._apiService);

  /// Get closed exams for teacher classroom
  Future<TeacherExamResponseListDto> getClosedExams(String classroomId) async {
    try {
      print(
        '🔍 TeacherExamsApi: Calling GET /teacher-classrooms/$classroomId/exams/closed',
      );
      final response = await _apiService.get(
        '/teacher-classrooms/$classroomId/exams/closed',
      );
      print(
        '✅ TeacherExamsApi: Get closed exams success response: ${response.data}',
      );
      return TeacherExamResponseListDto.fromList(
        response.data as List<dynamic>,
      );
    } on DioException catch (e) {
      print('❌ TeacherExamsApi: DioException: ${e.message}');
      print('❌ TeacherExamsApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherExamsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherExamsApi: General exception: $e');
      throw Exception('Failed to get closed exams: $e');
    }
  }

  /// Get exams for teacher classroom
  Future<TeacherExamResponseListDto> getExams(String classroomId) async {
    try {
      print(
        '🔍 TeacherExamsApi: Calling GET /teacher-classrooms/$classroomId/exams',
      );
      final response = await _apiService.get(
        '/teacher-classrooms/$classroomId/exams',
      );
      print('✅ TeacherExamsApi: Success response: ${response.data}');
      return TeacherExamResponseListDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherExamsApi: DioException: ${e.message}');
      print('❌ TeacherExamsApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherExamsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherExamsApi: General exception: $e');
      throw Exception('Failed to get exams: $e');
    }
  }

  /// Create exam for teacher
  Future<ExamTeacherResponseDto> createExam(CreateExamDto dto) async {
    try {
      print('🔍 TeacherExamsApi: Calling POST /teacher-exams');
      print('📝 TeacherExamsApi: Request data: ${dto.toJson()}');
      final response = await _apiService.post(
        '/teacher-exams',
        data: dto.toJson(),
      );
      print('✅ TeacherExamsApi: Success response: ${response.data}');
      return ExamTeacherResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherExamsApi: DioException: ${e.message}');
      print('❌ TeacherExamsApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherExamsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherExamsApi: General exception: $e');
      throw Exception('Failed to create exam: $e');
    }
  }

  /// Update exam for teacher
  Future<ExamTeacherResponseDto> updateExam(
    String examId,
    UpdateExamDto dto,
  ) async {
    try {
      print('🔍 TeacherExamsApi: Calling PATCH /teacher-exams/$examId');
      print('📝 TeacherExamsApi: Request data: ${dto.toJson()}');
      final response = await _apiService.patch(
        '/teacher-exams/$examId',
        data: dto.toJson(),
      );
      print('✅ TeacherExamsApi: Success response: ${response.data}');
      return ExamTeacherResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherExamsApi: DioException: ${e.message}');
      print('❌ TeacherExamsApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherExamsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherExamsApi: General exception: $e');
      throw Exception('Failed to update exam: $e');
    }
  }

  /// Delete exam for teacher
  Future<DeleteExamResponseDto> deleteExam(String examId) async {
    try {
      print('🔍 TeacherExamsApi: Calling DELETE /teacher-exams/$examId');
      final response = await _apiService.delete('/teacher-exams/$examId');
      print(
        '✅ TeacherExamsApi: Delete exam success response: ${response.data}',
      );
      return DeleteExamResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherExamsApi: DioException: ${e.message}');
      print('❌ TeacherExamsApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherExamsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherExamsApi: General exception: $e');
      throw Exception('Failed to delete exam: $e');
    }
  }

  /// Update exam status for teacher
  Future<ExamTeacherResponseDto> updateExamStatus(
    String examId,
    UpdateExamStatusDto dto,
  ) async {
    try {
      print('🔍 TeacherExamsApi: Calling PATCH /teacher-exams/$examId/status');
      print('📝 TeacherExamsApi: Request data: ${dto.toJson()}');
      final response = await _apiService.patch(
        '/teacher-exams/$examId/status',
        data: dto.toJson(),
      );
      print(
        '✅ TeacherExamsApi: Update exam status success response: ${response.data}',
      );
      return ExamTeacherResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherExamsApi: DioException: ${e.message}');
      print('❌ TeacherExamsApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherExamsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherExamsApi: General exception: $e');
      throw Exception('Failed to update exam status: $e');
    }
  }

  /// Get exam details for teacher
  Future<ExamDetailsTeacherResponseDto> getExamDetails(String examId) async {
    try {
      print('🔍 TeacherExamsApi: Calling GET /teacher-exams/$examId/details');
      final response = await _apiService.get(
        '/teacher-exams/$examId/details',
      );
      print('✅ TeacherExamsApi: Get exam details success response: ${response.data}');
      return ExamDetailsTeacherResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherExamsApi: DioException: ${e.message}');
      print('❌ TeacherExamsApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherExamsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherExamsApi: General exception: $e');
      throw Exception('Failed to get exam details: $e');
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
