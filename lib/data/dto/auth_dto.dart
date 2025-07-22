import '../../core/constants/app_constants.dart';

// Login Request DTO
class LoginDto {
  final String phone; // Phone number
  final String password;
  final String role;

  const LoginDto({
    required this.phone,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'password': password,
    'role': role,
  };

  factory LoginDto.fromJson(Map<String, dynamic> json) => LoginDto(
    phone: json['phone'] as String,
    password: json['password'] as String,
    role: json['role'] as String,
  );
}

// Base Register DTO
class RegisterBaseDto {
  final String phone;
  final String fullName;
  final String password;
  final String address;
  final String gender;

  const RegisterBaseDto({
    required this.phone,
    required this.fullName,
    required this.password,
    required this.address,
    required this.gender,
  });

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
  final String grade;
  final String role;

  const RegisterStudentDto({
    required super.phone,
    required super.fullName,
    required super.password,
    required super.address,
    required super.gender,
    required this.grade,
    this.role = 'student',
  });

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'grade': grade,
    'role': role,
  };

  factory RegisterStudentDto.fromJson(Map<String, dynamic> json) =>
      RegisterStudentDto(
        phone: json['phone'] as String,
        fullName: json['fullName'] as String,
        password: json['password'] as String,
        address: json['address'] as String,
        gender: json['gender'] as String,
        grade: json['grade'] as String,
        role: json['role'] as String? ?? 'student',
      );
}

// Register Teacher DTO
class RegisterTeacherDto extends RegisterBaseDto {
  final String role;

  const RegisterTeacherDto({
    required super.phone,
    required super.fullName,
    required super.password,
    required super.address,
    required super.gender,
    this.role = 'teacher',
  });

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'role': role};

  factory RegisterTeacherDto.fromJson(Map<String, dynamic> json) =>
      RegisterTeacherDto(
        phone: json['phone'] as String,
        fullName: json['fullName'] as String,
        password: json['password'] as String,
        address: json['address'] as String,
        gender: json['gender'] as String,
        role: json['role'] as String? ?? 'teacher',
      );
}

// User DTO
class UserDto {
  final String id;
  final String phone;
  final String fullName;
  final String address;
  final String? avatar;
  final String? email;
  final String role;
  final String? grade;
  final String gender;

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'phone': phone,
    'fullName': fullName,
    'address': address,
    if (avatar != null) 'avatar': avatar,
    if (email != null) 'email': email,
    'role': role,
    if (grade != null) 'grade': grade,
    'gender': gender,
  };

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'] as String,
    phone: json['phone'] as String,
    fullName: json['fullName'] as String,
    address: json['address'] as String,
    avatar: json['avatar'] as String?,
    email: json['email'] as String?,
    role: json['role'] as String,
    grade: json['grade'] as String?,
    gender: json['gender'] as String,
  );

  // Helper methods
  Role get roleEnum => Role.fromString(role);
  GradeLevel? get gradeEnum => GradeLevel.fromString(grade);
  Gender get genderEnum => Gender.fromString(gender);
}

// Login Response DTO
class LoginResponseDto {
  final String accessToken;
  final String? refreshToken;
  final UserDto user;

  const LoginResponseDto({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    if (refreshToken != null) 'refresh_token': refreshToken,
    'user': user.toJson(),
  };

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      LoginResponseDto(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String?,
        user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      );
}

// Register Response DTO
class RegisterResponseDto {
  final String message;
  final UserDto user;

  const RegisterResponseDto({required this.message, required this.user});

  Map<String, dynamic> toJson() => {'message': message, 'user': user.toJson()};

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      RegisterResponseDto(
        message: json['message'] as String,
        user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      );
}

// Reset Password DTO
class ResetPasswordDto {
  final String password;
  final String confirmPassword;

  const ResetPasswordDto({
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'password': password,
    'confirmPassword': confirmPassword,
  };

  factory ResetPasswordDto.fromJson(Map<String, dynamic> json) =>
      ResetPasswordDto(
        password: json['password'] as String,
        confirmPassword: json['confirmPassword'] as String,
      );
}

// Forgot Password DTO
class ForgotPasswordDto {
  final String phone;
  final String role;

  const ForgotPasswordDto({required this.phone, required this.role});

  Map<String, dynamic> toJson() => {'phone': phone, 'role': role};

  factory ForgotPasswordDto.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordDto(
        phone: json['phone'] as String,
        role: json['role'] as String,
      );
}

// Verify OTP DTO
class VerifyOtpDto {
  final String phone;
  final String otp;
  final String role;

  const VerifyOtpDto({
    required this.phone,
    required this.otp,
    required this.role,
  });

  Map<String, dynamic> toJson() => {'phone': phone, 'otp': otp, 'role': role};

  factory VerifyOtpDto.fromJson(Map<String, dynamic> json) => VerifyOtpDto(
    phone: json['phone'] as String,
    otp: json['otp'] as String,
    role: json['role'] as String,
  );
}

// Refresh Token DTO
class RefreshTokenDto {
  final String refreshToken;

  const RefreshTokenDto({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refresh_token': refreshToken};

  factory RefreshTokenDto.fromJson(Map<String, dynamic> json) =>
      RefreshTokenDto(refreshToken: json['refresh_token'] as String);
}

// Refresh Token Response DTO
class RefreshTokenResponseDto {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const RefreshTokenResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'expires_in': expiresIn,
  };

  factory RefreshTokenResponseDto.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponseDto(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        expiresIn: json['expires_in'] as int,
      );
}
