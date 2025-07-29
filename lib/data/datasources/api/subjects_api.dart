import 'package:dio/dio.dart';

import '../../../core/error/api_error_handler.dart';
import '../../../core/error/api_exception.dart';
import '../../dto/subject_dto.dart';
import '../../dto/bank_topic_dto.dart';
import '../../dto/topic_template_dto.dart';
import '../../dto/create_bank_topics_from_templates_dto.dart';
import '../../dto/bank_question_dto.dart';
import '../../dto/bank_theory_page_dto.dart';
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

  /// Get topics by subject code and grade
  Future<List<BankTopicWithCountDto>> getTopicsBySubjectCodeAndGrade(
    String subjectCode,
    String grade,
  ) async {
    try {
      print(
        '🔍 SubjectsApi: Calling GET /subjects/get-topics-by-code-and-grade with subjectCode: $subjectCode, grade: $grade',
      );
      final response = await _apiService.get(
        '/subjects/get-topics-by-code-and-grade',
        queryParams: {'subjectCode': subjectCode, 'grade': grade},
      );
      print('✅ SubjectsApi: Get topics success response: ${response.data}');

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => BankTopicWithCountDto.fromJson(json)).toList();
    } on DioException catch (e) {
      print('❌ SubjectsApi: DioException: ${e.message}');
      print('❌ SubjectsApi: Status code: ${e.response?.statusCode}');
      print('❌ SubjectsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ SubjectsApi: General exception: $e');
      throw Exception('Failed to get topics: $e');
    }
  }

  /// Get available topic templates for a subject
  Future<List<TopicTemplateResponseDto>> getAvailableTopicTemplates(
    String subjectId,
  ) async {
    try {
      print(
        '🔍 SubjectsApi: Calling GET /subjects/$subjectId/available-topic-templates',
      );
      final response = await _apiService.get(
        '/subjects/$subjectId/available-topic-templates',
      );
      print(
        '✅ SubjectsApi: Get available topic templates success response: ${response.data}',
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => TopicTemplateResponseDto.fromJson(json))
          .toList();
    } on DioException catch (e) {
      print('❌ SubjectsApi: DioException: ${e.message}');
      print('❌ SubjectsApi: Status code: ${e.response?.statusCode}');
      print('❌ SubjectsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ SubjectsApi: General exception: $e');
      throw Exception('Failed to get available topic templates: $e');
    }
  }

  /// Create bank topics from templates
  Future<List<BankTopicResponseDto>> createBankTopicsFromTemplates(
    CreateBankTopicsFromTemplatesDto dto,
  ) async {
    try {
      print(
        '🔍 SubjectsApi: Calling POST /bank-topics/create-from-templates with data: ${dto.toJson()}',
      );
      final response = await _apiService.post(
        '/bank-topics/create-from-templates',
        data: dto.toJson(),
      );
      print(
        '✅ SubjectsApi: Create bank topics from templates success response: ${response.data}',
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => BankTopicResponseDto.fromJson(json)).toList();
    } on DioException catch (e) {
      print('❌ SubjectsApi: DioException: ${e.message}');
      print('❌ SubjectsApi: Status code: ${e.response?.statusCode}');
      print('❌ SubjectsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ SubjectsApi: General exception: $e');
      throw Exception('Failed to create bank topics from templates: $e');
    }
  }

  /// Get questions by bank topic ID
  Future<List<BankQuestionResponseDto>> getQuestionsByBankTopicId(
    String bankTopicId,
  ) async {
    try {
      print('🔍 SubjectsApi: Calling GET /bank-topics/$bankTopicId/questions');
      final response = await _apiService.get(
        '/bank-topics/$bankTopicId/questions',
      );
      print(
        '✅ SubjectsApi: Get questions by bank topic ID success response: ${response.data}',
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => BankQuestionResponseDto.fromJson(json))
          .toList();
    } on DioException catch (e) {
      print('❌ SubjectsApi: DioException: ${e.message}');
      print('❌ SubjectsApi: Status code: ${e.response?.statusCode}');
      print('❌ SubjectsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ SubjectsApi: General exception: $e');
      throw Exception('Failed to get questions by bank topic ID: $e');
    }
  }

  /// Delete bank question by ID
  Future<void> deleteBankQuestion(String questionId) async {
    try {
      print('🔍 SubjectsApi: Calling DELETE /bank-questions/$questionId');
      await _apiService.delete('/bank-questions/$questionId');
      print('✅ SubjectsApi: Delete bank question success');
    } on DioException catch (e) {
      print('❌ SubjectsApi: DioException: ${e.message}');
      print('❌ SubjectsApi: Status code: ${e.response?.statusCode}');
      print('❌ SubjectsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ SubjectsApi: General exception: $e');
      throw Exception('Failed to delete bank question: $e');
    }
  }

  /// Get theory page sidebar items for bank topic
  Future<BankTheoryPageSidebarResponseDto> getTheoryPageSidebarItems(
    String bankTopicId,
  ) async {
    try {
      print(
        '🔍 SubjectsApi: Calling GET /bank-topics/$bankTopicId/theory-pages/sidebar',
      );
      final response = await _apiService.get(
        '/bank-topics/$bankTopicId/theory-pages/sidebar',
      );
      print(
        '✅ SubjectsApi: Get theory page sidebar items success response: ${response.data}',
      );

      return BankTheoryPageSidebarResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ SubjectsApi: DioException: ${e.message}');
      print('❌ SubjectsApi: Status code: ${e.response?.statusCode}');
      print('❌ SubjectsApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ SubjectsApi: General exception: $e');
      throw Exception('Failed to get theory page sidebar items: $e');
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
