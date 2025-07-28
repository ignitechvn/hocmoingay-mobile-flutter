import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routers/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../data/dto/auth_dto.dart';
import '../../../../providers/api/api_providers.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? phone;
  final Role? role;
  final String? otp;

  const ResetPasswordScreen({super.key, this.phone, this.role, this.otp});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.confirmPasswordRequired;
    }
    if (value != _passwordController.text) {
      return AppConstants.passwordsNotMatch;
    }
    return null;
  }

  void _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authApi = ref.read(authApiProvider);
      final resetPasswordDto = ResetPasswordDto(
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        token: widget.otp ?? '', // Use OTP as token
      );

      await authApi.resetPassword(resetPasswordDto);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đặt lại mật khẩu thành công!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đặt lại mật khẩu thất bại: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleBackToLogin() {
    context.pop();
  }

  void _handleRegister() {
    context.push(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: _handleBackToLogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.largePadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        const SizedBox(height: AppDimensions.largePadding),

                        // Illustration
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.largeRadius,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowMedium,
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.lock_reset,
                            size: 60,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.largePadding),

                        // Title
                        Text(
                          'Đặt lại mật khẩu',
                          style: AppTextStyles.displaySmall,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppDimensions.defaultPadding),

                        // Instructions
                        Text(
                          'Nhập mật khẩu mới hai lần bên dưới để đặt lại mật khẩu',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.largePadding * 2),

                // Form Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // New Password Field
                        PasswordTextField(
                          label: 'Nhập mật khẩu mới',
                          hint: 'Nhập mật khẩu mới của bạn',
                          controller: _passwordController,
                          validator: Validators.validatePassword,
                        ),

                        const SizedBox(height: AppDimensions.defaultPadding),

                        // Confirm Password Field
                        PasswordTextField(
                          label: 'Nhập lại mật khẩu mới',
                          hint: 'Nhập lại mật khẩu mới của bạn',
                          controller: _confirmPasswordController,
                          validator: _validateConfirmPassword,
                        ),

                        const SizedBox(height: AppDimensions.largePadding),

                        // Reset Password Button
                        PrimaryButton(
                          text: 'Đặt lại mật khẩu',
                          size: AppButtonSize.large,
                          isLoading: _isLoading,
                          onPressed: _handleResetPassword,
                        ),

                        const SizedBox(height: AppDimensions.largePadding),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Chưa có tài khoản? ',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: _handleRegister,
                              child: Text(
                                'Tạo tài khoản',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
