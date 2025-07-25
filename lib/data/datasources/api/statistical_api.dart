import 'package:dio/dio.dart';

import '../../dto/statistical_dto.dart';
import 'base_api_service.dart';

class StatisticalApi {
  final BaseApiService _apiService;

  StatisticalApi(this._apiService);

  /// Get classroom overview statistics
  Future<ClassroomOverviewResponseDto> getClassroomOverview(
    String classroomId,
  ) async {
    try {
      print(
        '🔍 StatisticalApi: Calling GET /statistical/classrooms/$classroomId',
      );
      final response = await _apiService.get(
        '/statistical/classrooms/$classroomId',
      );
      print('✅ StatisticalApi: Success response: ${response.data}');
      return ClassroomOverviewResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ StatisticalApi: DioException: ${e.message}');
      print('❌ StatisticalApi: Status code: ${e.response?.statusCode}');
      print('❌ StatisticalApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ StatisticalApi: General exception: $e');
      throw Exception('Failed to get classroom overview: $e');
    }
  }

  /// Get student progress report
  Future<StudentProgressReportDto> getStudentProgressReport(
    String classroomId,
    String studentId,
  ) async {
    try {
      print(
        '🔍 StatisticalApi: Calling GET /statistical/classrooms/$classroomId/student/$studentId',
      );
      final response = await _apiService.get(
        '/statistical/classrooms/$classroomId/student/$studentId',
      );
      print('✅ StatisticalApi: Success response: ${response.data}');
      return StudentProgressReportDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ StatisticalApi: DioException: ${e.message}');
      print('❌ StatisticalApi: Status code: ${e.response?.statusCode}');
      print('❌ StatisticalApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ StatisticalApi: General exception: $e');
      throw Exception('Failed to get student progress report: $e');
    }
  }

  /// Get chapter report
  Future<ChapterReportDto> getChapterReport(String chapterId) async {
    try {
      print('🔍 StatisticalApi: Calling GET /statistical/chapter/$chapterId');
      final response = await _apiService.get('/statistical/chapter/$chapterId');
      print('✅ StatisticalApi: Success response: ${response.data}');
      return ChapterReportDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ StatisticalApi: DioException: ${e.message}');
      print('❌ StatisticalApi: Status code: ${e.response?.statusCode}');
      print('❌ StatisticalApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ StatisticalApi: General exception: $e');
      throw Exception('Failed to get chapter report: $e');
    }
  }

  /// Get practice set report
  Future<PracticeSetReportDto> getPracticeSetReport(
    String practiceSetId,
  ) async {
    try {
      print(
        '🔍 StatisticalApi: Calling GET /statistical/practice-set/$practiceSetId',
      );
      final response = await _apiService.get(
        '/statistical/practice-set/$practiceSetId',
      );
      print('✅ StatisticalApi: Success response: ${response.data}');
      return PracticeSetReportDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ StatisticalApi: DioException: ${e.message}');
      print('❌ StatisticalApi: Status code: ${e.response?.statusCode}');
      print('❌ StatisticalApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ StatisticalApi: General exception: $e');
      throw Exception('Failed to get practice set report: $e');
    }
  }

  /// Get exam report
  Future<ExamReportDto> getExamReport(String examId) async {
    try {
      print('🔍 StatisticalApi: Calling GET /statistical/exam/$examId');
      final response = await _apiService.get('/statistical/exam/$examId');
      print('✅ StatisticalApi: Success response: ${response.data}');
      return ExamReportDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ StatisticalApi: DioException: ${e.message}');
      print('❌ StatisticalApi: Status code: ${e.response?.statusCode}');
      print('❌ StatisticalApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ StatisticalApi: General exception: $e');
      throw Exception('Failed to get exam report: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Kết nối mạng không ổn định. Vui lòng thử lại.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Có lỗi xảy ra';
        return Exception('Lỗi $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Yêu cầu đã bị hủy');
      default:
        return Exception('Có lỗi xảy ra: ${e.message}');
    }
  }
}
