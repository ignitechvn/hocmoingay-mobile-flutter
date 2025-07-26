import 'package:dio/dio.dart';
import '../../../core/error/api_error_handler.dart';
import '../../../core/error/api_exception.dart';
import '../../../data/dto/chapter_dto.dart';
import 'base_api_service.dart';

class TeacherChaptersApi {
  final BaseApiService _apiService;

  TeacherChaptersApi(this._apiService);

  /// Get teacher chapters for classroom
  Future<TeacherChapterResponseListDto> getTeacherChapters(
    String classroomId,
  ) async {
    try {
      print(
        '🔍 TeacherChaptersApi: Calling GET /teacher-classrooms/$classroomId/chapters/open-or-closed',
      );
      final response = await _apiService.get(
        '/teacher-classrooms/$classroomId/chapters/open-or-closed',
      );
      print(
        '✅ TeacherChaptersApi: Get teacher chapters success response: ${response.data}',
      );
      return TeacherChapterResponseListDto.fromList(
        response.data as List<dynamic>,
      );
    } on DioException catch (e) {
      print('❌ TeacherChaptersApi: DioException: ${e.message}');
      print('❌ TeacherChaptersApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherChaptersApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherChaptersApi: General exception: $e');
      throw Exception('Failed to get teacher chapters: $e');
    }
  }

  /// Get chapter details for teacher
  Future<ChapterDetailsTeacherResponseDto> getChapterDetails(
    String chapterId,
  ) async {
    try {
      print(
        '🔍 TeacherChaptersApi: Calling GET /teacher-chapters/$chapterId/details',
      );
      final response = await _apiService.get(
        '/teacher-chapters/$chapterId/details',
      );
      print(
        '✅ TeacherChaptersApi: Get chapter details success response: ${response.data}',
      );
      return ChapterDetailsTeacherResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('❌ TeacherChaptersApi: DioException: ${e.message}');
      print('❌ TeacherChaptersApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherChaptersApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherChaptersApi: General exception: $e');
      throw Exception('Failed to get chapter details: $e');
    }
  }

  /// Create new chapter
  Future<ChapterTeacherResponseDto> createChapter(CreateChapterDto dto) async {
    try {
      print(
        '🔍 TeacherChaptersApi: Calling POST /teacher-chapters with data: ${dto.toJson()}',
      );
      final response = await _apiService.post(
        '/teacher-chapters',
        data: dto.toJson(),
      );
      print(
        '✅ TeacherChaptersApi: Create chapter success response: ${response.data}',
      );
      return ChapterTeacherResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('❌ TeacherChaptersApi: DioException: ${e.message}');
      print('❌ TeacherChaptersApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherChaptersApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherChaptersApi: General exception: $e');
      throw Exception('Failed to create chapter: $e');
    }
  }

  /// Update chapter for teacher
  Future<ChapterTeacherResponseDto> updateChapter(
    String chapterId,
    UpdateChapterDto dto,
  ) async {
    try {
      print(
        '🔍 TeacherChaptersApi: Calling PATCH /teacher-chapters/$chapterId with data: ${dto.toJson()}',
      );
      final response = await _apiService.patch(
        '/teacher-chapters/$chapterId',
        data: dto.toJson(),
      );
      print(
        '✅ TeacherChaptersApi: Update chapter success response: ${response.data}',
      );
      return ChapterTeacherResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('❌ TeacherChaptersApi: DioException: ${e.message}');
      print('❌ TeacherChaptersApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherChaptersApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherChaptersApi: General exception: $e');
      throw Exception('Failed to update chapter: $e');
    }
  }

  /// Get chapter questions for teacher
  Future<TeacherChapterQuestionsResponseDto> getChapterQuestions(
    String chapterId,
  ) async {
    try {
      print(
        '🔍 TeacherChaptersApi: Calling GET /teacher-chapters/$chapterId/questions',
      );
      final response = await _apiService.get(
        '/teacher-chapters/$chapterId/questions',
      );
      print('✅ TeacherChaptersApi: Success response: ${response.data}');
      return TeacherChapterQuestionsResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherChaptersApi: DioException: ${e.message}');
      print('❌ TeacherChaptersApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherChaptersApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherChaptersApi: General exception: $e');
      throw Exception('Failed to get chapter questions: $e');
    }
  }

  /// Delete chapter for teacher
  Future<void> deleteChapter(String chapterId) async {
    try {
      print('🔍 TeacherChaptersApi: Calling DELETE /teacher-chapters/$chapterId');
      await _apiService.delete('/teacher-chapters/$chapterId');
      print('✅ TeacherChaptersApi: Delete chapter success');
    } on DioException catch (e) {
      print('❌ TeacherChaptersApi: DioException: ${e.message}');
      print('❌ TeacherChaptersApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherChaptersApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherChaptersApi: General exception: $e');
      throw Exception('Failed to delete chapter: $e');
    }
  }

  /// Update chapter status for teacher
  Future<ChapterTeacherResponseDto> updateStatus(
    String chapterId,
    UpdateChapterStatusDto dto,
  ) async {
    try {
      print('🔍 TeacherChaptersApi: Calling PATCH /teacher-chapters/$chapterId/status');
      print('📝 TeacherChaptersApi: Request data: ${dto.toJson()}');
      final response = await _apiService.patch(
        '/teacher-chapters/$chapterId/status',
        data: dto.toJson(),
      );
      print('✅ TeacherChaptersApi: Update status success response: ${response.data}');
      return ChapterTeacherResponseDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('❌ TeacherChaptersApi: DioException: ${e.message}');
      print('❌ TeacherChaptersApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherChaptersApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherChaptersApi: General exception: $e');
      throw Exception('Failed to update chapter status: $e');
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
