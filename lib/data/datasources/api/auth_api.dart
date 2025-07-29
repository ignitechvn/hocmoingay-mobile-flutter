import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';

import '../../dto/auth_dto.dart';
import '../../../core/error/api_error_handler.dart';
import '../../../core/services/token_manager.dart';
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
      // Get refresh token from storage
      final refreshToken = await TokenManager.getRefreshToken();
      if (refreshToken == null) {
        print('⚠️ AuthApi: No refresh token found for logout');
        // Still proceed with logout even without refresh token
        return;
      }

      // Send logout request with refresh token
      final logoutDto = RefreshTokenDto(refreshToken: refreshToken);
      await _apiService.post('/auth/logout', data: logoutDto.toJson());

      print('✅ AuthApi: Logout successful');
    } on DioException catch (e) {
      // 401 is expected when token is expired/invalid
      if (e.response?.statusCode == 401) {
        print('ℹ️ AuthApi: Logout with expired token (401) - this is normal');
        // Don't throw error for 401, just return
        return;
      }
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

  // Update Teacher User Info
  Future<StudentUserInfoResponseDto> updateTeacherUserInfo(
    UpdateTeacherUserDto dto,
    String? imagePath,
  ) async {
    try {
      final formData = FormData.fromMap({
        if (dto.fullName != null) 'fullName': dto.fullName!,
        if (dto.address != null) 'address': dto.address!,
        if (dto.gender != null) 'gender': dto.gender!,
        if (dto.email != null) 'email': dto.email!,
      });

      // Add image file if provided
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          formData.files.add(
            MapEntry('image', await MultipartFile.fromFile(imagePath)),
          );
        }
      }

      final response = await _apiService.dio.patch(
        '/users/teachers',
        data: formData,
      );
      return StudentUserInfoResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Update teacher user info failed: $e');
    }
  }

  // Update Student User Info
  Future<StudentUserInfoResponseDto> updateStudentUserInfo(
    UpdateStudentUserDto dto,
    String? imagePath,
  ) async {
    try {
      final formData = FormData.fromMap({
        if (dto.fullName != null) 'fullName': dto.fullName!,
        if (dto.grade != null) 'grade': dto.grade!,
        if (dto.address != null) 'address': dto.address!,
        if (dto.gender != null) 'gender': dto.gender!,
        if (dto.email != null) 'email': dto.email!,
      });

      // Add image file if provided
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          formData.files.add(
            MapEntry('image', await MultipartFile.fromFile(imagePath)),
          );
        }
      }

      final response = await _apiService.dio.patch(
        '/users/students',
        data: formData,
      );
      return StudentUserInfoResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Update student user info failed: $e');
    }
  }

  // Error handling
  Exception _handleDioError(DioException e) {
    return ApiErrorHandler.createException(e);
  }
}
