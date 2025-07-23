import 'package:dio/dio.dart';

import '../../dto/auth_dto.dart';
import '../../../core/error/api_error_handler.dart';
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
    return ApiErrorHandler.createException(e);
  }
}
