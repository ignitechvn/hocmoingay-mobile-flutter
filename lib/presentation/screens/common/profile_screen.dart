import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/user.dart';
import '../../../providers/auth/auth_state_provider.dart';
import 'update_profile_screen.dart';
import '../teacher/profile/teacher_profile_screen.dart';

class CommonProfileScreen extends ConsumerWidget {
  const CommonProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Header Section with Gradient
            _buildHeaderSection(user),

            // Menu Items Section
            Expanded(child: _buildMenuSection(context, ref, user)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(user) => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.largePadding,
      vertical: AppDimensions.largePadding * 2,
    ),
    child: Column(
      children: <Widget>[
        // Profile Picture
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: user?.avatar != null && user!.avatar!.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    user!.avatar!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildAvatarWithInitial(user?.fullName),
                  ),
                )
              : _buildAvatarWithInitial(user?.fullName),
        ),

        const SizedBox(height: AppDimensions.defaultPadding),

        // Name
        Text(
          user?.fullName ?? 'Lorem Name',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.smallPadding),

        // Subtitle
        Text(
          user?.role?.displayName ?? 'Ipsum dolor',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildMenuSection(BuildContext context, WidgetRef ref, User? user) =>
      Container(
        padding: const EdgeInsets.all(AppDimensions.largePadding),
        child: Column(
          children: <Widget>[
            // Menu Items
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Thông tin cá nhân',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UpdateProfileScreen(),
                  ),
                );
              },
            ),

            // Teacher-specific menu item
            if (user?.role == Role.teacher) ...[
              _buildMenuItem(
                icon: Icons.work_outline,
                title: 'Hồ sơ năng lực',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TeacherProfileScreen(),
                    ),
                  );
                },
              ),
            ],

            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: 'Cài đặt',
              onTap: () {
                // TODO: Navigate to settings
              },
            ),

            _buildMenuItem(
              icon: Icons.security_outlined,
              title: 'Bảo mật',
              onTap: () {
                // TODO: Navigate to security
              },
            ),

            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Trợ giúp',
              onTap: () {
                // TODO: Navigate to help
              },
            ),

            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'Về ứng dụng',
              onTap: () {
                // TODO: Navigate to about
              },
            ),

            const SizedBox(height: AppDimensions.largePadding),

            // Logout Button
            _buildLogoutButton(context, ref),
          ],
        ),
      );

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) => ListTile(
    leading: Icon(icon, color: AppColors.textPrimary, size: 24),
    title: Text(
      title,
      style: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: const Icon(
      Icons.arrow_forward_ios,
      color: AppColors.textSecondary,
      size: 16,
    ),
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.defaultPadding,
      vertical: AppDimensions.smallPadding,
    ),
  );

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.defaultPadding,
    ),
    child: ElevatedButton(
      onPressed: () => _showLogoutDialog(context, ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.largePadding,
          vertical: AppDimensions.defaultPadding,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.logout, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            'Đăng xuất',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildAvatarWithInitial(String? fullName) {
    // Get the first character of the name
    String initial = '?';
    if (fullName != null && fullName.isNotEmpty) {
      // Split by space and get the first character of the first word
      final nameParts = fullName.trim().split(' ');
      if (nameParts.isNotEmpty) {
        initial = nameParts.first[0].toUpperCase();
      }
    }

    return Center(
      child: Text(
        initial,
        style: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authStateProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
