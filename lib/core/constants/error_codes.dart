class ErrorCodes {
  // Authentication & Authorization
  static const String userNotExist = 'USER_NOT_EXIST';
  static const String wrongPassword = 'WRONG_PASSWORD';
  static const String otpExpired = 'OTP_EXPIRED';
  static const String otpIncorrect = 'OTP_INCORRECT';
  static const String invalidToken = 'INVALID_TOKEN';
  static const String tokenExpired = 'TOKEN_EXPIRED';
  static const String roleNotAllowed = 'ROLE_NOT_ALLOWED';

  // Business Logic
  static const String objectNotExist = 'OBJECT_NOT_EXIST';
  static const String objectAlreadyExists = 'OBJECT_ALREADY_EXISTS';
  static const String dataInvalid = 'DATA_INVALID';
  static const String timeInThePast = 'TIME_IN_THE_PAST';

  // Classroom Related
  static const String classroomStatusEnrollingReject =
      'CLASSROOM_STATUS_ENROLLING_REJECT';
  static const String studentNotInClassroom = 'STUDENT_NOT_IN_CLASSROOM';
  static const String studentNotApproved = 'STUDENT_NOT_APPROVED';

  // Exam/Chapter/Practice Related
  static const String examStatusClosedReject = 'EXAM_STATUS_CLOSED_REJECT';
  static const String examAlreadySubmitted = 'EXAM_ALREADY_SUBMITTED';
  static const String chapterStatusClosedReject =
      'CHAPTER_STATUS_CLOSED_REJECT';

  // Security
  static const String rateLimitExceeded = 'RATE_LIMIT_EXCEEDED';
  static const String accountLocked = 'ACCOUNT_LOCKED';
  static const String sqlInjectionDetected = 'SQL_INJECTION_DETECTED';

  // Validation
  static const String invalidQuestionData = 'INVALID_QUESTION_DATA';
  static const String invalidFormat = 'INVALID_FORMAT';
  static const String settingValidationFailed = 'SETTING_VALIDATION_FAILED';
}
