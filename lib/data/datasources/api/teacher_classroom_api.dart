import 'package:dio/dio.dart';

import '../../dto/classroom_dto.dart';
import '../../dto/teacher_classroom_dto.dart';
import '../../dto/chapter_dto.dart';
import '../../../core/error/api_error_handler.dart';
import 'base_api_service.dart';

class TeacherClassroomApi {
  final BaseApiService _apiService;

  TeacherClassroomApi(this._apiService);

  /// Get all classrooms for teacher
  Future<TeacherClassroomResponseListDto> getAllClassrooms() async {
    try {
      print('🔍 TeacherClassroomApi: Calling /teacher-classrooms/all');
      final response = await _apiService.get('/teacher-classrooms/all');
      print('✅ TeacherClassroomApi: Success response: ${response.data}');
      return TeacherClassroomResponseListDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherClassroomApi: DioException: ${e.message}');
      print('❌ TeacherClassroomApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherClassroomApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherClassroomApi: General exception: $e');
      throw Exception('Failed to get teacher classrooms: $e');
    }
  }

  /// Create new classroom for teacher
  Future<ClassroomTeacherResponseDto> createClassroom(
    CreateClassroomDto dto,
  ) async {
    try {
      print('🔍 TeacherClassroomApi: Calling POST /teacher-classrooms');
      print('📝 TeacherClassroomApi: Request data: ${dto.toJson()}');
      final response = await _apiService.post(
        '/teacher-classrooms',
        data: dto.toJson(),
      );
      print('✅ TeacherClassroomApi: Success response: ${response.data}');
      return ClassroomTeacherResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherClassroomApi: DioException: ${e.message}');
      print('❌ TeacherClassroomApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherClassroomApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherClassroomApi: General exception: $e');
      throw Exception('Failed to create classroom: $e');
    }
  }

  /// Get classroom details for teacher
  Future<ClassroomDetailsTeacherResponseDto> getClassroomDetails(
    String classroomId,
  ) async {
    try {
      print(
        '🔍 TeacherClassroomApi: Calling GET /teacher-classrooms/$classroomId/details/',
      );
      final response = await _apiService.get(
        '/teacher-classrooms/$classroomId/details/',
      );
      print('✅ TeacherClassroomApi: Success response: ${response.data}');
      return ClassroomDetailsTeacherResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherClassroomApi: DioException: ${e.message}');
      print('❌ TeacherClassroomApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherClassroomApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherClassroomApi: General exception: $e');
      throw Exception('Failed to get classroom details: $e');
    }
  }

  /// Update classroom for teacher
  Future<ClassroomTeacherResponseDto> updateClassroom(
    String classroomId,
    UpdateClassroomDto dto,
  ) async {
    try {
      print(
        '🔍 TeacherClassroomApi: Calling PATCH /teacher-classrooms/$classroomId',
      );
      print('📝 TeacherClassroomApi: Request data: ${dto.toJson()}');
      final response = await _apiService.patch(
        '/teacher-classrooms/$classroomId',
        data: dto.toJson(),
      );
      print('✅ TeacherClassroomApi: Success response: ${response.data}');
      return ClassroomTeacherResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ TeacherClassroomApi: DioException: ${e.message}');
      print('❌ TeacherClassroomApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherClassroomApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherClassroomApi: General exception: $e');
      throw Exception('Failed to update classroom: $e');
    }
  }

  /// Get approved students for teacher classroom
  Future<List<StudentResponseDto>> getApprovedStudents(
    String classroomId,
  ) async {
    try {
      print(
        '🔍 TeacherClassroomApi: Calling GET /teacher-classrooms/$classroomId/actived-students',
      );
      final response = await _apiService.get(
        '/teacher-classrooms/$classroomId/actived-students',
      );
      print('✅ TeacherClassroomApi: Success response: ${response.data}');
      return (response.data as List<dynamic>)
          .map(
            (json) => StudentResponseDto.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      print('❌ TeacherClassroomApi: DioException: ${e.message}');
      print('❌ TeacherClassroomApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherClassroomApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherClassroomApi: General exception: $e');
      throw Exception('Failed to get approved students: $e');
    }
  }

  /// Remove student from classroom
  Future<void> removeStudent(String studentId) async {
    try {
      print(
        '🔍 TeacherClassroomApi: Calling DELETE /teacher-classrooms/students/$studentId',
      );
      await _apiService.delete('/teacher-classrooms/students/$studentId');
      print('✅ TeacherClassroomApi: Student removed successfully');
    } on DioException catch (e) {
      print('❌ TeacherClassroomApi: DioException: ${e.message}');
      print('❌ TeacherClassroomApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherClassroomApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherClassroomApi: General exception: $e');
      throw Exception('Failed to remove student: $e');
    }
  }

  /// Get pending students for teacher classroom
  Future<List<PendingStudentResponseDto>> getPendingStudents(
    String classroomId,
  ) async {
    try {
      print(
        '🔍 TeacherClassroomApi: Calling GET /teacher-classrooms/$classroomId/pending-students',
      );
      final response = await _apiService.get(
        '/teacher-classrooms/$classroomId/pending-students',
      );
      print('✅ TeacherClassroomApi: Success response: ${response.data}');
      return (response.data as List<dynamic>)
          .map(
            (json) => PendingStudentResponseDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      print('❌ TeacherClassroomApi: DioException: ${e.message}');
      print('❌ TeacherClassroomApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherClassroomApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherClassroomApi: General exception: $e');
      throw Exception('Failed to get pending students: $e');
    }
  }

  /// Approve student join request
  Future<String> approveStudent(String classroomId, String studentId) async {
    try {
      print(
        '🔍 TeacherClassroomApi: Calling POST /teacher-classrooms/$classroomId/approve/$studentId',
      );
      final response = await _apiService.post(
        '/teacher-classrooms/$classroomId/approve/$studentId',
      );
      print(
        '✅ TeacherClassroomApi: Approve success response: ${response.data}',
      );
      return response.data as String;
    } on DioException catch (e) {
      print('❌ TeacherClassroomApi: DioException: ${e.message}');
      print('❌ TeacherClassroomApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherClassroomApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherClassroomApi: General exception: $e');
      throw Exception('Failed to approve student: $e');
    }
  }

  /// Reject student from classroom
  Future<String> rejectStudent(String classroomId, String studentId) async {
    try {
      print(
        '🔍 TeacherClassroomApi: Calling POST /teacher-classrooms/$classroomId/reject/$studentId',
      );
      final response = await _apiService.post(
        '/teacher-classrooms/$classroomId/reject/$studentId',
      );
      print('✅ TeacherClassroomApi: Reject success response: ${response.data}');
      return response.data as String;
    } on DioException catch (e) {
      print('❌ TeacherClassroomApi: DioException: ${e.message}');
      print('❌ TeacherClassroomApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherClassroomApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherClassroomApi: General exception: $e');
      throw Exception('Failed to reject student: $e');
    }
  }

  /// Get chapters for teacher classroom
  Future<TeacherChapterResponseListDto> getChapters(String classroomId) async {
    try {
      print(
        '🔍 TeacherClassroomApi: Calling GET /teacher-classrooms/$classroomId/chapters',
      );
      final response = await _apiService.get(
        '/teacher-classrooms/$classroomId/chapters',
      );
      print(
        '✅ TeacherClassroomApi: Get chapters success response: ${response.data}',
      );
      return TeacherChapterResponseListDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('❌ TeacherClassroomApi: DioException: ${e.message}');
      print('❌ TeacherClassroomApi: Status code: ${e.response?.statusCode}');
      print('❌ TeacherClassroomApi: Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ TeacherClassroomApi: General exception: $e');
      throw Exception('Failed to get chapters: $e');
    }
  }

  // Error handling
  Exception _handleDioError(DioException e) {
    return ApiErrorHandler.createException(e);
  }
}
