import '../../core/constants/app_constants.dart';
import '../../core/constants/grade_constants.dart';

// Login Request DTO
class LoginDto {
  const LoginDto({
    required this.userName,
    required this.password,
    required this.role,
  });

  factory LoginDto.fromJson(Map<String, dynamic> json) => LoginDto(
    userName: json['userName'] as String,
    password: json['password'] as String,
    role: Role.fromString(json['role'] as String),
  );
  final String userName; // User name (phone number)
  final String password;
  final Role role;

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'password': password,
    'role': role.value,
  };
}

// Base Register DTO
class RegisterBaseDto {
  const RegisterBaseDto({
    required this.phone,
    required this.fullName,
    required this.password,
    required this.address,
    required this.gender,
  });
  final String phone;
  final String fullName;
  final String password;
  final String address;
  final String gender;

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'fullName': fullName,
    'password': password,
    'address': address,
    'gender': gender,
  };
}

// Register Student DTO
class RegisterStudentDto extends RegisterBaseDto {
  const RegisterStudentDto({
    required super.phone,
    required super.fullName,
    required super.password,
    required super.address,
    required super.gender,
    required this.grade,
    this.role = Role.student,
  });

  factory RegisterStudentDto.fromJson(Map<String, dynamic> json) =>
      RegisterStudentDto(
        phone: json['phone'] as String,
        fullName: json['fullName'] as String,
        password: json['password'] as String,
        address: json['address'] as String,
        gender: json['gender'] as String,
        grade: json['grade'] as String,
        role: Role.fromString(json['role'] as String? ?? Role.student.value),
      );
  final String grade;
  final Role role;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'grade': grade,
    'role': role.value,
  };
}

// Register Teacher DTO
class RegisterTeacherDto extends RegisterBaseDto {
  const RegisterTeacherDto({
    required super.phone,
    required super.fullName,
    required super.password,
    required super.address,
    required super.gender,
    this.role = Role.teacher,
  });

  factory RegisterTeacherDto.fromJson(Map<String, dynamic> json) =>
      RegisterTeacherDto(
        phone: json['phone'] as String,
        fullName: json['fullName'] as String,
        password: json['password'] as String,
        address: json['address'] as String,
        gender: json['gender'] as String,
        role: Role.fromString(json['role'] as String? ?? Role.teacher.value),
      );
  final Role role;

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'role': role.value};
}

// User DTO
class UserDto {
  const UserDto({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.address,
    this.avatar,
    this.email,
    required this.role,
    this.grade,
    required this.gender,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'] as String,
    phone: json['phone'] as String,
    fullName: json['fullName'] as String,
    address: json['address'] as String,
    avatar: json['avatar'] as String?,
    email: json['email'] as String?,
    role: Role.fromString(json['role'] as String),
    grade: json['grade'] as String?,
    gender:
        json['gender'] as String? ??
        'male', // Default to 'male' if not provided
  );
  final String id;
  final String phone;
  final String fullName;
  final String address;
  final String? avatar;
  final String? email;
  final Role role;
  final String? grade;
  final String gender;

  Map<String, dynamic> toJson() => {
    'id': id,
    'phone': phone,
    'fullName': fullName,
    'address': address,
    if (avatar != null) 'avatar': avatar,
    if (email != null) 'email': email,
    'role': role.value,
    if (grade != null) 'grade': grade,
    'gender': gender,
  };

  // Helper methods
  EGradeLevel? get gradeEnum => EGradeLevel.fromString(grade ?? '');
  Gender get genderEnum => Gender.fromString(gender);
}

// Login Response DTO
class LoginResponseDto {
  const LoginResponseDto({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      LoginResponseDto(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String?,
        user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      );
  final String accessToken;
  final String? refreshToken;
  final UserDto user;

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    if (refreshToken != null) 'refresh_token': refreshToken,
    'user': user.toJson(),
  };
}

// Register Response DTO
class RegisterResponseDto {
  const RegisterResponseDto({required this.message, required this.user});

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      RegisterResponseDto(
        message: json['message'] as String,
        user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      );
  final String message;
  final UserDto user;

  Map<String, dynamic> toJson() => {'message': message, 'user': user.toJson()};
}

// Reset Password DTO
class ResetPasswordDto {
  const ResetPasswordDto({
    required this.password,
    required this.confirmPassword,
    required this.token,
  });

  factory ResetPasswordDto.fromJson(Map<String, dynamic> json) =>
      ResetPasswordDto(
        password: json['password'] as String,
        confirmPassword: json['confirmPassword'] as String,
        token: json['token'] as String,
      );
  final String password;
  final String confirmPassword;
  final String token;

  Map<String, dynamic> toJson() => {
    'password': password,
    'confirmPassword': confirmPassword,
    'token': token,
  };
}

// Forgot Password DTO
class ForgotPasswordDto {
  const ForgotPasswordDto({required this.phone, required this.role});

  factory ForgotPasswordDto.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordDto(
        phone: json['phone'] as String,
        role: Role.fromString(json['role'] as String),
      );
  final String phone;
  final Role role;

  Map<String, dynamic> toJson() => {'phone': phone, 'role': role.value};
}

// Verify OTP DTO
class VerifyOtpDto {
  const VerifyOtpDto({
    required this.phone,
    required this.otp,
    required this.role,
  });

  factory VerifyOtpDto.fromJson(Map<String, dynamic> json) => VerifyOtpDto(
    phone: json['phone'] as String,
    otp: json['otp'] as String,
    role: Role.fromString(json['role'] as String),
  );
  final String phone;
  final String otp;
  final Role role;

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'otp': otp,
    'role': role.value,
  };
}

// Refresh Token DTO
class RefreshTokenDto {
  const RefreshTokenDto({required this.refreshToken});

  factory RefreshTokenDto.fromJson(Map<String, dynamic> json) =>
      RefreshTokenDto(refreshToken: json['refresh_token'] as String);
  final String refreshToken;

  Map<String, dynamic> toJson() => {'refresh_token': refreshToken};
}

// Refresh Token Response DTO
class RefreshTokenResponseDto {
  const RefreshTokenResponseDto({required this.accessToken, this.refreshToken});

  factory RefreshTokenResponseDto.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponseDto(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String?,
      );
  final String accessToken;
  final String? refreshToken;

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    if (refreshToken != null) 'refresh_token': refreshToken,
  };
}

// Error Response DTO
class ErrorResponseDto {
  const ErrorResponseDto({required this.message, this.errors, this.statusCode});

  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) =>
      ErrorResponseDto(
        message: json['message'] as String,
        errors: json['errors'] as Map<String, dynamic>?,
        statusCode: json['statusCode'] as int?,
      );
  final String message;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  Map<String, dynamic> toJson() => {
    'message': message,
    if (errors != null) 'errors': errors,
    if (statusCode != null) 'statusCode': statusCode,
  };
}

// Update Teacher User DTO
class UpdateTeacherUserDto {
  final String? fullName;
  final String? avatar;
  final String? address;
  final String? gender;
  final String? email;

  const UpdateTeacherUserDto({
    this.fullName,
    this.avatar,
    this.address,
    this.gender,
    this.email,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (fullName != null) data['fullName'] = fullName;
    if (avatar != null) data['avatar'] = avatar;
    if (address != null) data['address'] = address;
    if (gender != null) data['gender'] = gender;
    if (email != null) data['email'] = email;
    return data;
  }
}

// Update Student User DTO
class UpdateStudentUserDto {
  final String? fullName;
  final String? avatar;
  final String? grade;
  final String? address;
  final String? gender;
  final String? email;

  const UpdateStudentUserDto({
    this.fullName,
    this.avatar,
    this.grade,
    this.address,
    this.gender,
    this.email,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (fullName != null) data['fullName'] = fullName;
    if (avatar != null) data['avatar'] = avatar;
    if (grade != null) data['grade'] = grade;
    if (address != null) data['address'] = address;
    if (gender != null) data['gender'] = gender;
    if (email != null) data['email'] = email;
    return data;
  }
}

// Student User Info Response DTO
class StudentUserInfoResponseDto {
  final String id;
  final String fullName;
  final String? avatar;
  final String phone;
  final String address;
  final String grade;
  final String? gender;
  final String? email;
  final String role;

  const StudentUserInfoResponseDto({
    required this.id,
    required this.fullName,
    this.avatar,
    required this.phone,
    required this.address,
    required this.grade,
    this.gender,
    this.email,
    required this.role,
  });

  factory StudentUserInfoResponseDto.fromJson(Map<String, dynamic> json) {
    return StudentUserInfoResponseDto(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      avatar: json['avatar'],
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      grade: json['grade'] ?? '',
      gender: json['gender'],
      email: json['email'],
      role: json['role'] ?? '',
    );
  }
}
