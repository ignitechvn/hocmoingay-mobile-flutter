class AppConstants {
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  static const String profileEndpoint = '/user/profile';
  static const String updateProfileEndpoint = '/user/profile/update';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String onboardingKey = 'onboarding_completed';

  // Validation Patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9]{10,11}$';
  static const String passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

  // Validation Messages
  static const String emailRequired = 'Email là bắt buộc';
  static const String emailInvalid = 'Email không hợp lệ';
  static const String phoneRequired = 'Số điện thoại là bắt buộc';
  static const String phoneInvalid = 'Số điện thoại không hợp lệ';
  static const String passwordRequired = 'Mật khẩu là bắt buộc';
  static const String passwordInvalid =
      'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt';
  static const String confirmPasswordRequired = 'Xác nhận mật khẩu là bắt buộc';
  static const String passwordsNotMatch = 'Mật khẩu không khớp';
  static const String nameRequired = 'Họ tên là bắt buộc';
  static const String nameMinLength = 'Họ tên phải có ít nhất 2 ký tự';

  // User Roles
  static const String roleStudent = 'student';
  static const String roleTeacher = 'teacher';
  static const String roleParent = 'parent';
  static const String roleAdmin = 'admin';

  // Class Status
  static const String classStatusActive = 'active';
  static const String classStatusInactive = 'inactive';
  static const String classStatusCompleted = 'completed';
  static const String classStatusCancelled = 'cancelled';

  // Lesson Status
  static const String lessonStatusScheduled = 'scheduled';
  static const String lessonStatusInProgress = 'in_progress';
  static const String lessonStatusCompleted = 'completed';
  static const String lessonStatusCancelled = 'cancelled';

  // File Types
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = [
    'pdf',
    'doc',
    'docx',
    'ppt',
    'pptx',
    'xls',
    'xlsx',
  ];
  static const List<String> allowedVideoTypes = ['mp4', 'avi', 'mov', 'wmv'];
  static const List<String> allowedAudioTypes = ['mp3', 'wav', 'aac', 'ogg'];

  // File Size Limits (in bytes)
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxDocumentSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB
  static const int maxAudioSize = 20 * 1024 * 1024; // 20MB

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Keys
  static const String classesCacheKey = 'classes_cache';
  static const String lessonsCacheKey = 'lessons_cache';
  static const String studentsCacheKey = 'students_cache';
  static const String teachersCacheKey = 'teachers_cache';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 8.0;
  static const double smallRadius = 4.0;
  static const double largeRadius = 16.0;

  // Error Codes
  static const String networkError = 'NETWORK_ERROR';
  static const String serverError = 'SERVER_ERROR';
  static const String unauthorizedError = 'UNAUTHORIZED';
  static const String forbiddenError = 'FORBIDDEN';
  static const String notFoundError = 'NOT_FOUND';
  static const String validationError = 'VALIDATION_ERROR';
  static const String unknownError = 'UNKNOWN_ERROR';
}

// User Role Enum
enum Role {
  teacher('teacher'),
  student('student'),
  parent('parent'),
  admin('admin');

  const Role(this.value);
  final String value;

  static Role fromString(String value) {
    return Role.values.firstWhere(
      (role) => role.value == value,
      orElse: () => Role.student,
    );
  }
}

// Grade Level Enum
enum GradeLevel {
  grade1('grade1', 'Lớp 1'),
  grade2('grade2', 'Lớp 2'),
  grade3('grade3', 'Lớp 3'),
  grade4('grade4', 'Lớp 4'),
  grade5('grade5', 'Lớp 5'),
  grade6('grade6', 'Lớp 6'),
  grade7('grade7', 'Lớp 7'),
  grade8('grade8', 'Lớp 8'),
  grade9('grade9', 'Lớp 9'),
  grade10('grade10', 'Lớp 10'),
  grade11('grade11', 'Lớp 11'),
  grade12('grade12', 'Lớp 12');

  const GradeLevel(this.value, this.label);
  final String value;
  final String label;

  static GradeLevel? fromString(String? value) {
    if (value == null) return null;
    return GradeLevel.values.firstWhere(
      (grade) => grade.value == value,
      orElse: () => GradeLevel.grade1,
    );
  }
}

// Gender Enum
enum Gender {
  male('male', 'Nam'),
  female('female', 'Nữ'),
  other('other', 'Khác');

  const Gender(this.value, this.label);
  final String value;
  final String label;

  static Gender fromString(String value) {
    return Gender.values.firstWhere(
      (gender) => gender.value == value,
      orElse: () => Gender.male,
    );
  }
}
