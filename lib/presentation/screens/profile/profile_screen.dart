import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/auth/auth_state_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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
            Expanded(child: _buildMenuSection(context, ref)),
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
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.person, size: 50, color: Colors.white),
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

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) => Container(
    padding: const EdgeInsets.all(AppDimensions.largePadding),
    child: Column(
      children: <Widget>[
        // Menu Items
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Thông tin cá nhân',
          onTap: () {
            // TODO: Navigate to personal info
          },
        ),

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

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) => ListTile(
    leading: const Icon(Icons.logout, color: AppColors.error, size: 24),
    title: Text(
      'Đăng xuất',
      style: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.error,
        fontWeight: FontWeight.w500,
      ),
    ),
    onTap: () => _showLogoutDialog(context, ref),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.defaultPadding,
      vertical: AppDimensions.smallPadding,
    ),
  );

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
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
