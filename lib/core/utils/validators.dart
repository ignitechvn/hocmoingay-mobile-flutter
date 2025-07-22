import '../constants/app_constants.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emailRequired;
    }

    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return AppConstants.emailInvalid;
    }

    return null;
  }

  // Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.phoneRequired;
    }

    final phoneRegex = RegExp(AppConstants.phonePattern);
    if (!phoneRegex.hasMatch(value)) {
      return AppConstants.phoneInvalid;
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.passwordRequired;
    }

    if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 chữ hoa';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 chữ thường';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 số';
    }

    if (!RegExp(r'[@$!%*?&]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 ký tự đặc biệt (@\$!%*?&)';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppConstants.confirmPasswordRequired;
    }

    if (value != password) {
      return AppConstants.passwordsNotMatch;
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.nameRequired;
    }

    if (value.length < 2) {
      return AppConstants.nameMinLength;
    }

    if (value.length > 50) {
      return 'Họ tên không được vượt quá 50 ký tự';
    }

    // Check for valid characters (letters, spaces, Vietnamese characters)
    final nameRegex = RegExp(r'^[a-zA-ZÀ-ỹ\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Họ tên chỉ được chứa chữ cái và khoảng trắng';
    }

    return null;
  }

  // Student ID validation
  static String? validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mã học sinh là bắt buộc';
    }

    if (value.length < 5 || value.length > 20) {
      return 'Mã học sinh phải có từ 5 đến 20 ký tự';
    }

    // Check for alphanumeric characters
    final studentIdRegex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!studentIdRegex.hasMatch(value)) {
      return 'Mã học sinh chỉ được chứa chữ cái và số';
    }

    return null;
  }

  // Class name validation
  static String? validateClassName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên lớp là bắt buộc';
    }

    if (value.length < 2) {
      return 'Tên lớp phải có ít nhất 2 ký tự';
    }

    if (value.length > 100) {
      return 'Tên lớp không được vượt quá 100 ký tự';
    }

    return null;
  }

  // Class description validation
  static String? validateClassDescription(String? value) {
    if (value != null && value.length > 500) {
      return 'Mô tả lớp không được vượt quá 500 ký tự';
    }

    return null;
  }

  // Lesson title validation
  static String? validateLessonTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tiêu đề bài học là bắt buộc';
    }

    if (value.length < 5) {
      return 'Tiêu đề bài học phải có ít nhất 5 ký tự';
    }

    if (value.length > 200) {
      return 'Tiêu đề bài học không được vượt quá 200 ký tự';
    }

    return null;
  }

  // Lesson content validation
  static String? validateLessonContent(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nội dung bài học là bắt buộc';
    }

    if (value.length < 10) {
      return 'Nội dung bài học phải có ít nhất 10 ký tự';
    }

    if (value.length > 10000) {
      return 'Nội dung bài học không được vượt quá 10,000 ký tự';
    }

    return null;
  }

  // File name validation
  static String? validateFileName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên file là bắt buộc';
    }

    if (value.length > 255) {
      return 'Tên file không được vượt quá 255 ký tự';
    }

    // Check for invalid characters in file names
    final invalidChars = RegExp(r'[<>:"/\\|?*]');
    if (invalidChars.hasMatch(value)) {
      return 'Tên file không được chứa ký tự đặc biệt: < > : " / \\ | ? *';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return 'URL không hợp lệ';
      }
    } catch (e) {
      return 'URL không hợp lệ';
    }

    return null;
  }

  // Date validation
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ngày tháng là bắt buộc';
    }

    try {
      DateTime.parse(value);
    } catch (e) {
      return 'Định dạng ngày tháng không hợp lệ';
    }

    return null;
  }

  // Time validation
  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Thời gian là bắt buộc';
    }

    try {
      // Expected format: HH:mm
      final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
      if (!timeRegex.hasMatch(value)) {
        return 'Định dạng thời gian không hợp lệ (HH:mm)';
      }
    } catch (e) {
      return 'Định dạng thời gian không hợp lệ';
    }

    return null;
  }

  // Duration validation (in minutes)
  static String? validateDuration(int? value) {
    if (value == null) {
      return 'Thời lượng là bắt buộc';
    }

    if (value <= 0) {
      return 'Thời lượng phải lớn hơn 0';
    }

    if (value > 480) {
      // 8 hours
      return 'Thời lượng không được vượt quá 8 giờ';
    }

    return null;
  }

  // Capacity validation (number of students)
  static String? validateCapacity(int? value) {
    if (value == null) {
      return 'Sĩ số lớp là bắt buộc';
    }

    if (value <= 0) {
      return 'Sĩ số lớp phải lớn hơn 0';
    }

    if (value > 100) {
      return 'Sĩ số lớp không được vượt quá 100 học sinh';
    }

    return null;
  }

  // Price validation
  static String? validatePrice(double? value) {
    if (value == null) {
      return 'Giá là bắt buộc';
    }

    if (value < 0) {
      return 'Giá không được âm';
    }

    if (value > 10000000) {
      // 10 million VND
      return 'Giá không được vượt quá 10,000,000 VNĐ';
    }

    return null;
  }

  // Comment validation
  static String? validateComment(String? value) {
    if (value != null && value.length > 1000) {
      return 'Bình luận không được vượt quá 1,000 ký tự';
    }

    return null;
  }

  // Search query validation
  static String? validateSearchQuery(String? value) {
    if (value != null && value.length > 100) {
      return 'Từ khóa tìm kiếm không được vượt quá 100 ký tự';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName là bắt buộc';
    }

    return null;
  }

  // Min length validation
  static String? validateMinLength(
    String? value,
    int minLength,
    String fieldName,
  ) {
    if (value != null && value.length < minLength) {
      return '$fieldName phải có ít nhất $minLength ký tự';
    }

    return null;
  }

  // Max length validation
  static String? validateMaxLength(
    String? value,
    int maxLength,
    String fieldName,
  ) {
    if (value != null && value.length > maxLength) {
      return '$fieldName không được vượt quá $maxLength ký tự';
    }

    return null;
  }

  // Numeric validation
  static String? validateNumeric(String? value, String fieldName) {
    if (value != null && value.isNotEmpty) {
      if (double.tryParse(value) == null) {
        return '$fieldName phải là số';
      }
    }

    return null;
  }

  // Integer validation
  static String? validateInteger(String? value, String fieldName) {
    if (value != null && value.isNotEmpty) {
      if (int.tryParse(value) == null) {
        return '$fieldName phải là số nguyên';
      }
    }

    return null;
  }

  // Positive number validation
  static String? validatePositiveNumber(String? value, String fieldName) {
    final numericError = validateNumeric(value, fieldName);
    if (numericError != null) {
      return numericError;
    }

    if (value != null && value.isNotEmpty) {
      final number = double.parse(value);
      if (number <= 0) {
        return '$fieldName phải lớn hơn 0';
      }
    }

    return null;
  }
}
