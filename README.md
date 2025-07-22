# Học Mỗi Ngày - Mobile App

Ứng dụng quản lý lớp học và dạy học online chuyên nghiệp cho học sinh, giáo viên và phụ huynh.

## 🚀 Tính Năng Chính

### **🔐 Authentication System**
- **Login** - Đăng nhập bằng số điện thoại và mật khẩu
- **Register** - Đăng ký tài khoản cho Student/Teacher với thông tin chi tiết
- **Reset Password** - Đặt lại mật khẩu qua OTP
- **Role-based Access** - Phân quyền theo vai trò (Student/Teacher/Parent/Admin)

### **📱 UI/UX Features**
- **Onboarding Flow** - Hướng dẫn sử dụng app
- **Role Selection** - Chọn vai trò người dùng
- **Modern Design** - Material Design 3 với Roboto font
- **Responsive Layout** - Tương thích mọi kích thước màn hình
- **Smooth Animations** - Chuyển cảnh mượt mà

### **🏗️ Architecture**
- **Clean Architecture** - Tách biệt rõ ràng các layer
- **State Management** - Riverpod cho quản lý state
- **Navigation** - Go Router cho routing
- **API Integration** - Dio + Retrofit cho network calls
- **Local Storage** - Hive + Shared Preferences + Secure Storage

## 📋 Yêu Cầu Hệ Thống

- **Flutter SDK**: ^3.7.2
- **Dart**: ^3.7.2
- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 11.0+

## 🛠️ Cài Đặt & Chạy

### **1. Clone Repository**
```bash
git clone <repository-url>
cd hocmoingay-mobile-flutter
```

### **2. Cài Đặt Dependencies**
```bash
flutter pub get
```

### **3. Chạy App**
```bash
# Development
flutter run

# Build APK
flutter build apk --debug

# Build Release
flutter build apk --release
```

## 📁 Cấu Trúc Dự Án

```
lib/
├── core/
│   ├── config/           # App configuration
│   ├── constants/        # App constants & enums
│   ├── error/           # Error handling
│   ├── routers/         # Navigation routes
│   ├── theme/           # Design system
│   ├── utils/           # Utility functions
│   └── widgets/         # Reusable widgets
├── data/
│   ├── datasources/     # API & Database sources
│   ├── dto/            # Data Transfer Objects
│   ├── repositories/   # Repository implementations
│   └── models/         # Data models
├── domain/
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/      # Business logic
├── presentation/
│   ├── screens/        # UI screens
│   ├── viewmodels/     # View models
│   └── widgets/        # Screen-specific widgets
└── providers/          # Riverpod providers
```

## 🔧 API Integration

### **Authentication Endpoints**
```dart
POST /auth/login              → LoginDto → LoginResponseDto
POST /auth/register/student   → RegisterStudentDto → RegisterResponseDto
POST /auth/register/teacher   → RegisterTeacherDto → RegisterResponseDto
POST /auth/forgot-password    → ForgotPasswordDto
POST /auth/verify-otp         → VerifyOtpDto
POST /auth/reset-password     → ResetPasswordDto
POST /auth/logout             → void
POST /auth/refresh-token      → Map → LoginResponseDto
```

### **Data Models**
- **LoginDto** - Phone, password, role
- **RegisterStudentDto** - Full info + grade
- **RegisterTeacherDto** - Full info
- **UserDto** - User profile data
- **Role Enum** - Student, Teacher, Parent, Admin
- **GradeLevel Enum** - Lớp 1-12

## 🎨 Design System

### **Colors**
- **Primary**: #2196F3 (Blue)
- **Secondary**: #FF9800 (Orange)
- **Success**: #4CAF50 (Green)
- **Error**: #F44336 (Red)
- **Warning**: #FFC107 (Yellow)

### **Typography**
- **Font**: Roboto (Material Design default)
- **Display**: 32px, 28px, 24px
- **Headline**: 22px, 20px, 18px
- **Title**: 16px, 14px, 12px
- **Body**: 16px, 14px, 12px

### **Spacing**
- **Small**: 8px
- **Default**: 16px
- **Large**: 24px

## 🔐 Security Features

- **Secure Storage** - JWT tokens
- **Input Validation** - Real-time validation
- **Error Handling** - Comprehensive error management
- **Rate Limiting** - API protection
- **Password Strength** - Strong password requirements

## 📱 Screens Implemented

### **Authentication Flow**
1. **Onboarding Screen** - Welcome & introduction
2. **Role Selection** - Choose user role
3. **Login Screen** - Phone + password + role
4. **Register Screen** - Complete registration form
5. **Reset Password** - Password reset flow
6. **Congratulations** - Success screen

### **Features**
- **Form Validation** - Real-time validation
- **Loading States** - Proper loading indicators
- **Error Handling** - User-friendly error messages
- **Responsive Design** - Works on all screen sizes

## 🚀 Deployment

### **Android**
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### **iOS**
```bash
# Build iOS
flutter build ios --release
```

## 📊 Dependencies

### **Core Dependencies**
- **flutter_riverpod**: State management
- **go_router**: Navigation
- **dio**: HTTP client
- **drift**: Database
- **hive**: Local storage
- **flutter_secure_storage**: Secure storage

### **UI Dependencies**
- **cached_network_image**: Image caching
- **shimmer**: Loading effects
- **flutter_svg**: SVG support

### **Development Dependencies**
- **build_runner**: Code generation
- **flutter_lints**: Code quality
- **mockito**: Testing

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

- **Email**: support@hocmoingay.com
- **Website**: https://hocmoingay.com
- **Documentation**: [API Docs](https://docs.hocmoingay.com)

---

**Made with ❤️ by Học Mỗi Ngày Team**
