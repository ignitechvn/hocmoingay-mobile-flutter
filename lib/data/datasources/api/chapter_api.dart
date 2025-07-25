import 'package:dio/dio.dart';
import '../../dto/chapter_dto.dart';
import '../../dto/chapter_details_dto.dart';
import '../api/base_api_service.dart';
import '../../../core/error/api_error_handler.dart';

class ChapterApi {
  final BaseApiService _apiService;

  ChapterApi(this._apiService);

  // Get all chapters for a classroom
  Future<List<ChapterStudentResponseDto>> getAllByClassroom(
    String classroomId,
  ) async {
    try {
      final response = await _apiService.get(
        '/student-chapters/$classroomId/all',
      );
      return (response.data as List<dynamic>)
          .map(
            (json) => ChapterStudentResponseDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception('Get chapters failed: ${e.message}');
    } catch (e) {
      throw Exception('Get chapters failed: $e');
    }
  }

  // Get chapter details
  Future<ChapterDetailsStudentResponseDto> getDetails(String chapterId) async {
    try {
      final response = await _apiService.get(
        '/student-chapters/$chapterId/details',
      );
      return ChapterDetailsStudentResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Get chapter details failed: ${e.message}');
    } catch (e) {
      throw Exception('Get chapter details failed: $e');
    }
  }
}
