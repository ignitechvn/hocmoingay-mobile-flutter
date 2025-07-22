import 'package:go_router/go_router.dart';

import '../../../presentation/screens/auth/login/login_screen.dart';
import '../../../presentation/screens/auth/register/register_screen.dart';
import '../../../presentation/screens/auth/register/congratulations_screen.dart';
import '../../../presentation/screens/auth/reset_password/reset_password_screen.dart';
import '../../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../../presentation/screens/onboarding/role_selection_screen.dart';
import '../../../presentation/screens/student/home/home_screen.dart';

class AppRoutes {
  static const onboarding = '/onboarding';
  static const roleSelection = '/role-selection';
  static const login = '/login';
  static const register = '/register';
  static const congratulations = '/congratulations';
  static const resetPassword = '/reset-password';
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
        builder: (context, state) => const ResetPasswordScreen(),
      ),
    ],
    initialLocation: AppRoutes.onboarding,
  );
}
