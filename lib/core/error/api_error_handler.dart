import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/dto/error_response_dto.dart';
import '../utils/toast_utils.dart';
import 'api_exception.dart';

class ApiErrorHandler {
  static ErrorResponseDto? parseErrorResponse(dynamic error) {
    if (error is DioException && error.response?.data != null) {
      try {
        return ErrorResponseDto.fromJson(error.response!.data);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static String getUserFriendlyMessage(ErrorResponseDto error) {
    // Create key like frontend: statusCode + error
    final key = '${error.statusCode}${error.error}';

    // Map error codes to user-friendly messages (matching frontend errorMap)
    switch (key) {
      // Authentication & Authorization
      case '401INVALID_TOKEN':
        return 'Token không hợp lệ hoặc đã hết hạn';
      case '401TOKEN_EXPIRED':
        return 'Token đã hết hạn';
      case '401USER_NOT_EXIST':
        return 'Tài khoản không tồn tại';
      case '400WRONG_PASSWORD':
        return 'Mật khẩu không đúng';
      case '403ROLE_NOT_ALLOWED':
        return 'Bạn không có quyền truy cập';

      // OTP related
      case '400OTP_EXPIRED':
        return 'Mã OTP đã hết hạn';
      case '400OTP_INCORRECT':
        return 'Mã OTP không đúng';

      // Business Logic
      case '404OBJECT_NOT_EXIST':
        return 'Dữ liệu không tồn tại';
      case '409OBJECT_ALREADY_EXISTS':
        return 'Dữ liệu đã tồn tại';
      case '400DATA_INVALID':
        return 'Dữ liệu không hợp lệ';
      case '400TIME_IN_THE_PAST':
        return 'Thời gian không hợp lệ';

      // Classroom Related
      case '400CLASSROOM_STATUS_ENROLLING_REJECT':
        return 'Không thể thực hiện thao tác này với trạng thái lớp học hiện tại';
      case '400STUDENT_NOT_IN_CLASSROOM':
        return 'Học sinh không thuộc lớp học này';
      case '400STUDENT_NOT_APPROVED':
        return 'Học sinh chưa được phê duyệt';

      // Exam/Chapter Related
      case '400EXAM_STATUS_CLOSED_REJECT':
        return 'Không thể thực hiện thao tác này với trạng thái bài thi hiện tại';
      case '400EXAM_ALREADY_SUBMITTED':
        return 'Bài thi đã được nộp';
      case '400CHAPTER_STATUS_CLOSED_REJECT':
        return 'Không thể thực hiện thao tác này với trạng thái chương hiện tại';

      // Security
      case '429RATE_LIMIT_EXCEEDED':
        return 'Bạn đã vượt quá giới hạn gửi tin nhắn';
      case '403ACCOUNT_LOCKED':
        return 'Tài khoản đã bị khóa';
      case '400SQL_INJECTION_DETECTED':
        return 'Phát hiện tấn công SQL injection';

      // Validation
      case '400INVALID_QUESTION_DATA':
        return 'Dữ liệu câu hỏi không hợp lệ';
      case '400INVALID_FORMAT':
        return 'Định dạng dữ liệu không hợp lệ';
      case '400SETTING_VALIDATION_FAILED':
        return 'Cài đặt không hợp lệ';

      default:
        // Fallback to backend message
        return error.message;
    }
  }

  static ToastType getToastType(ErrorResponseDto error) {
    switch (error.statusCode) {
      case 400:
      case 422:
        return ToastType.warning;
      case 401:
      case 403:
      case 404:
      case 409:
      case 429:
      case 500:
        return ToastType.fail;
      default:
        return ToastType.fail;
    }
  }

  static void handleError(BuildContext context, dynamic error) {
    final errorResponse = parseErrorResponse(error);

    if (errorResponse != null) {
      final message = getUserFriendlyMessage(errorResponse);
      final toastType = getToastType(errorResponse);

      ToastUtils.showToast(context: context, message: message, type: toastType);
    } else {
      // Fallback for generic errors
      ToastUtils.showFail(
        context: context,
        message: 'Đã xảy ra lỗi không xác định',
      );
    }
  }

  static Exception createException(dynamic error) {
    final errorResponse = parseErrorResponse(error);

    if (errorResponse != null) {
      return ApiException(
        message: errorResponse.message,
        errorCode: errorResponse.error,
        statusCode: errorResponse.statusCode,
        details: errorResponse.details,
      );
    }

    // Handle network errors (matching frontend logic)
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Yêu cầu đã vượt quá thời gian chờ');
        case DioExceptionType.connectionError:
          final msg = (error.message ?? '').toString().toLowerCase();
          if (msg.contains('refused')) {
            return Exception('Không thể kết nối tới máy chủ');
          }
          return Exception(
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra mạng hoặc thử lại sau',
          );
        case DioExceptionType.cancel:
          return Exception('Yêu cầu đã bị hủy');
        case DioExceptionType.badCertificate:
          return Exception('Lỗi chứng chỉ bảo mật');
        default:
          return Exception('Lỗi không xác định từ máy chủ');
      }
    }

    return Exception('Lỗi không xác định từ máy chủ');
  }
}
