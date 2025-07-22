import 'package:dio/dio.dart';

import '../../dto/auth_dto.dart';
import 'base_api_service.dart';

class AuthApi {
  final BaseApiService _apiService;

  AuthApi(this._apiService);

  // Login
  Future<LoginResponseDto> login(LoginDto loginDto) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: loginDto.toJson(),
      );
      return LoginResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Register Student
  Future<RegisterResponseDto> registerStudent(
    RegisterStudentDto registerDto,
  ) async {
    try {
      final response = await _apiService.post(
        '/auth/register/student',
        data: registerDto.toJson(),
      );
      return RegisterResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Register student failed: $e');
    }
  }

  // Register Teacher
  Future<RegisterResponseDto> registerTeacher(
    RegisterTeacherDto registerDto,
  ) async {
    try {
      final response = await _apiService.post(
        '/auth/register/teacher',
        data: registerDto.toJson(),
      );
      return RegisterResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Register teacher failed: $e');
    }
  }

  // Forgot Password
  Future<void> forgotPassword(ForgotPasswordDto forgotPasswordDto) async {
    try {
      await _apiService.post(
        '/auth/forgot-password',
        data: forgotPasswordDto.toJson(),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Forgot password failed: $e');
    }
  }

  // Verify OTP
  Future<void> verifyOtp(VerifyOtpDto verifyOtpDto) async {
    try {
      await _apiService.post('/auth/verify-otp', data: verifyOtpDto.toJson());
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Verify OTP failed: $e');
    }
  }

  // Reset Password
  Future<void> resetPassword(ResetPasswordDto resetPasswordDto) async {
    try {
      await _apiService.post(
        '/auth/reset-password',
        data: resetPasswordDto.toJson(),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  // Refresh Token
  Future<RefreshTokenResponseDto> refreshToken(String refreshToken) async {
    try {
      final refreshTokenDto = RefreshTokenDto(refreshToken: refreshToken);
      final response = await _apiService.post(
        '/auth/refresh',
        data: refreshTokenDto.toJson(),
      );
      return RefreshTokenResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Refresh token failed: $e');
    }
  }

  // Error handling
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Kết nối mạng bị gián đoạn. Vui lòng thử lại.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Lỗi không xác định';

        switch (statusCode) {
          case 400:
            return Exception('Dữ liệu không hợp lệ: $message');
          case 401:
            return Exception('Thông tin đăng nhập không chính xác');
          case 403:
            return Exception('Bạn không có quyền truy cập');
          case 404:
            return Exception('Không tìm thấy tài nguyên');
          case 409:
            return Exception('Tài khoản đã tồn tại');
          case 422:
            return Exception('Dữ liệu không hợp lệ: $message');
          case 429:
            return Exception('Quá nhiều yêu cầu. Vui lòng thử lại sau.');
          case 500:
            return Exception('Lỗi máy chủ. Vui lòng thử lại sau.');
          default:
            return Exception('Lỗi: $message');
        }

      case DioExceptionType.cancel:
        return Exception('Yêu cầu bị hủy');

      case DioExceptionType.connectionError:
        return Exception('Không thể kết nối đến máy chủ');

      case DioExceptionType.badCertificate:
        return Exception('Lỗi chứng chỉ bảo mật');

      case DioExceptionType.unknown:
      default:
        return Exception('Lỗi không xác định: ${e.message}');
    }
  }
}
