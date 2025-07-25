import 'package:dio/dio.dart';
import '../../../core/error/api_error_handler.dart';
import '../../../core/error/api_exception.dart';
import '../../../data/dto/chapter_dto.dart';
import 'base_api_service.dart';

class TeacherChaptersApi {
  final BaseApiService _apiService;

  TeacherChaptersApi(this._apiService);

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
