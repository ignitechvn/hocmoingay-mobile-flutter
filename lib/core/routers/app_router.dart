import 'package:go_router/go_router.dart';

import '../../../presentation/screens/auth/login/login_screen.dart';
import '../../../presentation/screens/auth/register/register_screen.dart';
import '../../../presentation/screens/student/home/home_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  static final routerConfig = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
    initialLocation: AppRoutes.login,
  );
}