import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth/auth_state_provider.dart';
import '../screens/auth/login/login_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/student/dashboard/student_dashboard_screen.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check auth status when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authStateProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return _buildScreen(authState);
  }

  Widget _buildScreen(AuthState state) {
    switch (state.status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        return _buildLoadingScreen();

      case AuthStatus.unauthenticated:
        // Show onboarding or login based on app state
        return const OnboardingScreen();

      case AuthStatus.authenticated:
        // Show appropriate dashboard based on user role
        return _buildDashboard(state.userRole);

      case AuthStatus.error:
        return _buildErrorScreen(state.error ?? 'Unknown error');
    }
  }

  Widget _buildDashboard(Role? userRole) {
    switch (userRole) {
      case Role.student:
        return const StudentDashboardScreen();
      case Role.teacher:
        // TODO: Implement TeacherDashboardScreen
        return const Scaffold(
          body: Center(child: Text('Teacher Dashboard - Coming Soon')),
        );
      case Role.parent:
        // TODO: Implement ParentDashboardScreen
        return const Scaffold(
          body: Center(child: Text('Parent Dashboard - Coming Soon')),
        );
      case Role.admin:
        // TODO: Implement AdminDashboardScreen
        return const Scaffold(
          body: Center(child: Text('Admin Dashboard - Coming Soon')),
        );
      default:
        return const LoginScreen();
    }
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.school, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 32),

            // App Name
            Text(
              'Học Mỗi Ngày',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Nền tảng học tập trực tuyến',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 48),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),

            const SizedBox(height: 16),

            Text(
              'Đang tải...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: AppColors.error),

              const SizedBox(height: 24),

              Text(
                'Có lỗi xảy ra',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                error,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  ref.read(authStateProvider.notifier).checkAuthStatus();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Thử lại',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
