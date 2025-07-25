import 'package:dio/dio.dart';
import '../../../core/error/api_error_handler.dart';
import '../../../core/error/api_exception.dart';
import '../../../data/dto/practice_set_dto.dart';
import 'base_api_service.dart';

class TeacherPracticeSetsApi {
  final BaseApiService _apiService;

  TeacherPracticeSetsApi(this._apiService);

  /// Get open or closed practice sets for teacher classroom
  Future<TeacherPracticeSetResponseListDto> getOpenOrClosedPracticeSets(
    String classroomId,
  ) async {
    try {
      print(
        '🔍 TeacherPracticeSetsApi: Calling GET /teacher-classrooms/$classroomId/practice-sets/open-or-closed',
      );
      final response = await _apiService.get(
        '/teacher-classrooms/$classroomId/practice-sets/open-or-closed',
      );
      print(
        '✅ TeacherPracticeSetsApi: Get open or closed practice sets success response: ${response.data}',
      );
      return TeacherPracticeSetResponseListDto.fromList(
        response.data as List<dynamic>,
      );
    } on DioException catch (e) {
      print('❌ TeacherPracticeSetsApi: DioException: ${e.message}');
      print('❌ TeacherPracticeSetsApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherPracticeSetsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherPracticeSetsApi: General exception: $e');
      throw Exception('Failed to get open or closed practice sets: $e');
    }
  }

  /// Get practice sets for teacher classroom
  Future<TeacherPracticeSetResponseListDto> getPracticeSets(
    String classroomId,
  ) async {
    try {
      print(
        '🔍 TeacherPracticeSetsApi: Calling GET /teacher-classrooms/$classroomId/practice-sets',
      );
      final response = await _apiService.get(
        '/teacher-classrooms/$classroomId/practice-sets',
      );
      print(
        '✅ TeacherPracticeSetsApi: Get practice sets success response: ${response.data}',
      );
      return TeacherPracticeSetResponseListDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('❌ TeacherPracticeSetsApi: DioException: ${e.message}');
      print('❌ TeacherPracticeSetsApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherPracticeSetsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherPracticeSetsApi: General exception: $e');
      throw Exception('Failed to get practice sets: $e');
    }
  }

  /// Create new practice set
  Future<PracticeSetTeacherResponseDto> createPracticeSet(
    CreatePracticeSetDto dto,
  ) async {
    try {
      print(
        '🔍 TeacherPracticeSetsApi: Calling POST /teacher-practice-sets with data: ${dto.toJson()}',
      );
      final response = await _apiService.post(
        '/teacher-practice-sets',
        data: dto.toJson(),
      );
      print(
        '✅ TeacherPracticeSetsApi: Create practice set success response: ${response.data}',
      );
      return PracticeSetTeacherResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('❌ TeacherPracticeSetsApi: DioException: ${e.message}');
      print('❌ TeacherPracticeSetsApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherPracticeSetsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherPracticeSetsApi: General exception: $e');
      throw Exception('Failed to create practice set: $e');
    }
  }

  /// Update practice set
  Future<PracticeSetTeacherResponseDto> updatePracticeSet(
    String practiceSetId,
    UpdatePracticeSetDto dto,
  ) async {
    try {
      print(
        '🔍 TeacherPracticeSetsApi: Calling PATCH /teacher-practice-sets/$practiceSetId with data: ${dto.toJson()}',
      );
      final response = await _apiService.patch(
        '/teacher-practice-sets/$practiceSetId',
        data: dto.toJson(),
      );
      print(
        '✅ TeacherPracticeSetsApi: Update practice set success response: ${response.data}',
      );
      return PracticeSetTeacherResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('❌ TeacherPracticeSetsApi: DioException: ${e.message}');
      print('❌ TeacherPracticeSetsApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherPracticeSetsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherPracticeSetsApi: General exception: $e');
      throw Exception('Failed to update practice set: $e');
    }
  }

  // Error handling
  Exception _handleDioError(DioException e) {
    final errorResponse = ApiErrorHandler.parseErrorResponse(e);
    if (errorResponse != null) {
      return ApiException(
        message: ApiErrorHandler.getUserFriendlyMessage(errorResponse),
        errorCode: errorResponse.error,
        statusCode: errorResponse.statusCode,
      );
    }
    return Exception('Network error: ${e.message}');
  }
}
