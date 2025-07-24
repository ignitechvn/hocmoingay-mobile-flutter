import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_material_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'core/utils/logger.dart';
import 'presentation/widgets/auth_wrapper.dart';
import 'presentation/screens/auth/login/login_screen.dart';
import 'presentation/screens/auth/register/register_screen.dart';
import 'presentation/screens/auth/register/congratulations_screen.dart';
import 'presentation/screens/auth/reset_password/reset_password_screen.dart';
import 'presentation/screens/auth/verify_otp/verify_otp_screen.dart';
import 'presentation/screens/auth/forgot_password/forgot_password_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/onboarding/role_selection_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/student/classroom/classroom_details_screen.dart';

void main() {
  // Khởi tạo logging
  AppLogger.info('=== ỨNG DỤNG HỌC MỖI NGÀY KHỞI ĐỘNG ===');
  AppLogger.info('Environment: ${AppConfig.environment}');
  AppLogger.info('Enable Logging: ${AppConfig.enableLogging}');
  AppLogger.info('Base URL: ${AppConfig.baseUrl}');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Học Mỗi Ngày',
    theme: ThemeData(
      primarySwatch: AppMaterialColors.primaryBlue,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTextStyles.headlineSmall,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    ),
    home: const AuthWrapper(),
          onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/onboarding':
            return MaterialPageRoute(builder: (context) => const OnboardingScreen());
          case '/role-selection':
            return MaterialPageRoute(builder: (context) => const RoleSelectionScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (context) => const RegisterScreen());
          case '/congratulations':
            return MaterialPageRoute(builder: (context) => const CongratulationsScreen());
          case '/reset-password':
            return MaterialPageRoute(builder: (context) => const ResetPasswordScreen());
          case '/verify-otp':
            final args = settings.arguments as Map<String, dynamic>?;
            final phone = args?['phone'] as String? ?? '';
            return MaterialPageRoute(builder: (context) => VerifyOtpScreen(phone: phone));
          case '/forgot-password':
            return MaterialPageRoute(builder: (context) => const ForgotPasswordScreen());
          case '/profile':
            return MaterialPageRoute(builder: (context) => const ProfileScreen());
          case '/classroom-details':
            final args = settings.arguments as Map<String, dynamic>?;
            final classroomId = args?['classroomId'] as String?;
            if (classroomId != null) {
              return MaterialPageRoute(builder: (context) => ClassroomDetailsScreen(classroomId: classroomId));
            }
            return MaterialPageRoute(builder: (context) => const AuthWrapper());
          default:
            return MaterialPageRoute(builder: (context) => const AuthWrapper());
        }
      },
  );
}
