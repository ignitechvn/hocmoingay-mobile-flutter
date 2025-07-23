import 'package:go_router/go_router.dart';

import '../../../presentation/screens/auth/login/login_screen.dart';
import '../../../presentation/screens/auth/register/register_screen.dart';
import '../../../presentation/screens/auth/register/congratulations_screen.dart';
import '../../../presentation/screens/auth/reset_password/reset_password_screen.dart';
import '../../../presentation/screens/auth/verify_otp/verify_otp_screen.dart';
import '../../../presentation/screens/auth/forgot_password/forgot_password_screen.dart';
import '../../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../../presentation/screens/onboarding/role_selection_screen.dart';
import '../../../presentation/screens/student/home/home_screen.dart';
import '../../../core/constants/app_constants.dart';

class AppRoutes {
  static const onboarding = '/onboarding';
  static const roleSelection = '/role-selection';
  static const login = '/login';
  static const register = '/register';
  static const congratulations = '/congratulations';
  static const resetPassword = '/reset-password';
  static const verifyOtp = '/verify-otp';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';

  static final routerConfig = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.congratulations,
        builder: (context, state) => const CongratulationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra != null &&
              extra.containsKey('phone') &&
              extra.containsKey('role')) {
            // If we have phone and role, this is from forgot password flow
            return const ResetPasswordScreen();
          }
          // Default reset password screen
          return const ResetPasswordScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyOtp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra != null && extra.containsKey('phone')) {
            return VerifyOtpScreen(
              phone: extra['phone'] as String,
            );
          }
          // Fallback - redirect to forgot password
          return const ForgotPasswordScreen();
        },
      ),
    ],
    initialLocation: AppRoutes.onboarding,
  );
}
