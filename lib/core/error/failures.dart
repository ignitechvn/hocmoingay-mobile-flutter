import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const Failure({required this.message, this.code, this.details});

  @override
  List<Object?> get props => [message, code, details];
}

// Network Failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Không thể kết nối mạng. Vui lòng kiểm tra lại.',
    super.code = 'NETWORK_ERROR',
    super.details,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Lỗi máy chủ. Vui lòng thử lại sau.',
    super.code = 'SERVER_ERROR',
    super.details,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Yêu cầu hết thời gian chờ. Vui lòng thử lại.',
    super.code = 'TIMEOUT_ERROR',
    super.details,
  });
}

// Authentication Failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'Xác thực thất bại. Vui lòng đăng nhập lại.',
    super.code = 'AUTH_ERROR',
    super.details,
  });
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    super.message = 'Bạn không có quyền truy cập tính năng này.',
    super.code = 'FORBIDDEN',
    super.details,
  });
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure({
    super.message = 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
    super.code = 'TOKEN_EXPIRED',
    super.details,
  });
}

// Validation Failures
class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;

  const ValidationFailure({
    super.message = 'Dữ liệu không hợp lệ.',
    super.code = 'VALIDATION_ERROR',
    super.details,
    required this.fieldErrors,
  });

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

class RequiredFieldFailure extends Failure {
  const RequiredFieldFailure({
    required String fieldName,
    super.code = 'REQUIRED_FIELD',
    super.details,
  }) : super(message: '$fieldName: Trường này là bắt buộc.');
}

// Data Failures
class DataNotFoundFailure extends Failure {
  const DataNotFoundFailure({
    super.message = 'Không tìm thấy dữ liệu.',
    super.code = 'NOT_FOUND',
    super.details,
  });
}

class DataConflictFailure extends Failure {
  const DataConflictFailure({
    super.message = 'Dữ liệu đã tồn tại.',
    super.code = 'CONFLICT',
    super.details,
  });
}

class DataCorruptionFailure extends Failure {
  const DataCorruptionFailure({
    super.message = 'Dữ liệu bị hỏng.',
    super.code = 'DATA_CORRUPTION',
    super.details,
  });
}

// Storage Failures
class StorageFailure extends Failure {
  const StorageFailure({
    super.message = 'Lỗi lưu trữ dữ liệu.',
    super.code = 'STORAGE_ERROR',
    super.details,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Lỗi cache.',
    super.code = 'CACHE_ERROR',
    super.details,
  });
}

// File Failures
class FileNotFoundFailure extends Failure {
  const FileNotFoundFailure({
    super.message = 'Không tìm thấy file.',
    super.code = 'FILE_NOT_FOUND',
    super.details,
  });
}

class FileUploadFailure extends Failure {
  const FileUploadFailure({
    super.message = 'Lỗi tải file lên.',
    super.code = 'FILE_UPLOAD_ERROR',
    super.details,
  });
}

class FileDownloadFailure extends Failure {
  const FileDownloadFailure({
    super.message = 'Lỗi tải file xuống.',
    super.code = 'FILE_DOWNLOAD_ERROR',
    super.details,
  });
}

class FileSizeExceededFailure extends Failure {
  const FileSizeExceededFailure({
    super.message = 'Kích thước file vượt quá giới hạn.',
    super.code = 'FILE_SIZE_EXCEEDED',
    super.details,
  });
}

class UnsupportedFileTypeFailure extends Failure {
  const UnsupportedFileTypeFailure({
    super.message = 'Loại file không được hỗ trợ.',
    super.code = 'UNSUPPORTED_FILE_TYPE',
    super.details,
  });
}

// Business Logic Failures
class BusinessLogicFailure extends Failure {
  const BusinessLogicFailure({
    required super.message,
    super.code = 'BUSINESS_LOGIC_ERROR',
    super.details,
  });
}

class InsufficientPermissionFailure extends Failure {
  const InsufficientPermissionFailure({
    super.message = 'Không đủ quyền để thực hiện hành động này.',
    super.code = 'INSUFFICIENT_PERMISSION',
    super.details,
  });
}

class ResourceUnavailableFailure extends Failure {
  const ResourceUnavailableFailure({
    super.message = 'Tài nguyên không khả dụng.',
    super.code = 'RESOURCE_UNAVAILABLE',
    super.details,
  });
}

// System Failures
class SystemFailure extends Failure {
  const SystemFailure({
    super.message = 'Lỗi hệ thống.',
    super.code = 'SYSTEM_ERROR',
    super.details,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Đã xảy ra lỗi không xác định.',
    super.code = 'UNKNOWN_ERROR',
    super.details,
  });
}

// Feature Failures
class FeatureNotAvailableFailure extends Failure {
  const FeatureNotAvailableFailure({
    super.message = 'Tính năng này chưa khả dụng.',
    super.code = 'FEATURE_NOT_AVAILABLE',
    super.details,
  });
}

class MaintenanceFailure extends Failure {
  const MaintenanceFailure({
    super.message = 'Hệ thống đang bảo trì. Vui lòng thử lại sau.',
    super.code = 'MAINTENANCE',
    super.details,
  });
}

// Rate Limiting Failures
class RateLimitFailure extends Failure {
  const RateLimitFailure({
    super.message = 'Bạn đã vượt quá giới hạn yêu cầu. Vui lòng thử lại sau.',
    super.code = 'RATE_LIMIT',
    super.details,
  });
}

// Version Failures
class VersionMismatchFailure extends Failure {
  const VersionMismatchFailure({
    super.message = 'Phiên bản ứng dụng không tương thích.',
    super.code = 'VERSION_MISMATCH',
    super.details,
  });
}

class UpdateRequiredFailure extends Failure {
  const UpdateRequiredFailure({
    super.message = 'Cần cập nhật ứng dụng để tiếp tục sử dụng.',
    super.code = 'UPDATE_REQUIRED',
    super.details,
  });
}
