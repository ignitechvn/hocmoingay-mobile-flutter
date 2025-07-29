import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routers/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/error/api_error_handler.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/services/login_memory_service.dart';
import '../../../../providers/auth/auth_state_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final Role? selectedRole;

  const LoginScreen({super.key, this.selectedRole});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;
  Role _selectedRole = Role.student;

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

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    // Set selected role from constructor if provided
    if (widget.selectedRole != null) {
      _selectedRole = widget.selectedRole!;
    }

    // Load saved login information
    _loadSavedLoginInfo();
  }

  Future<void> _loadSavedLoginInfo() async {
    try {
      final savedLogin = await LoginMemoryService.getLastLogin();
      if (savedLogin != null) {
        setState(() {
          _phoneController.text = savedLogin['phone'] ?? '';
          _passwordController.text = savedLogin['password'] ?? '';
          _selectedRole = Role.values.firstWhere(
            (role) => role.value == savedLogin['role'],
            orElse: () => Role.student,
          );
          _rememberMe = true;
        });
      }
    } catch (e) {
      print('Error loading saved login info: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(authStateProvider.notifier)
          .login(
            _phoneController.text.trim(),
            _passwordController.text,
            _selectedRole,
          );

      // Save login information if remember me is enabled
      if (_rememberMe) {
        await LoginMemoryService.saveLastLogin(
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          role: _selectedRole.value,
          rememberMe: true,
        );
      } else {
        // Clear saved login info if remember me is disabled
        await LoginMemoryService.clearLastLogin();
      }
    } catch (e) {
      if (mounted) {
        // Use enhanced error handler
        ApiErrorHandler.handleError(context, e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleForgotPassword() {
    context.push(AppRoutes.forgotPassword);
  }

  void _handleRegister() {
    context.push(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.isAuthenticated && mounted) {
        // Show success toast
        ToastUtils.showSuccess(
          context: context,
          message: 'Đăng nhập thành công!',
        );

        // Navigate to home and clear all previous routes
        context.go(AppRoutes.root);
      } else if (next.hasError && mounted) {
        // Show error message using enhanced error handler
        ApiErrorHandler.handleError(context, next.error);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
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
                          // Title
                          Text(
                            'Đăng nhập',
                            style: AppTextStyles.displaySmall,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: AppDimensions.defaultPadding),

                          // Subtitle
                          Text(
                            'Chào mừng bạn quay trở lại!',
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
                          // Phone Field
                          PhoneTextField(
                            controller: _phoneController,
                            validator: Validators.validatePhone,
                          ),

                          const SizedBox(height: AppDimensions.defaultPadding),

                          // Password Field
                          PasswordTextField(
                            controller: _passwordController,
                            validator: Validators.validatePassword,
                            onSubmitted: (_) => _handleLogin(),
                          ),

                          const SizedBox(height: AppDimensions.defaultPadding),

                          // Role Selection
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Vai trò', style: AppTextStyles.inputLabel),
                              const SizedBox(
                                height: AppDimensions.smallPadding,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.defaultPadding,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.defaultRadius,
                                  ),
                                  border: Border.all(color: AppColors.grey300),
                                ),
                                child: DropdownButtonFormField<Role>(
                                  value: _selectedRole,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  items: Role.values
                                      .map(
                                        (role) => DropdownMenuItem<Role>(
                                          value: role,
                                          child: Text(
                                            role.displayName,
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (Role? value) => value != null
                                      ? setState(() => _selectedRole = value)
                                      : null,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppDimensions.defaultPadding),

                          // Remember Me & Forgot Password
                          Row(
                            children: [
                              // Remember Me
                              Expanded(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                        // Save remember me preference
                                        LoginMemoryService.setRememberMe(
                                          _rememberMe,
                                        );
                                      },
                                      activeColor: AppColors.primary,
                                    ),
                                    Text(
                                      'Ghi nhớ đăng nhập',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),

                              // Forgot Password
                              TextButton(
                                onPressed: _handleForgotPassword,
                                child: Text(
                                  'Quên mật khẩu?',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppDimensions.largePadding),

                          // Login Button
                          PrimaryButton(
                            text: 'Đăng nhập',
                            size: AppButtonSize.large,
                            isLoading: _isLoading,
                            onPressed: _handleLogin,
                          ),

                          const SizedBox(height: AppDimensions.largePadding),

                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Chưa có tài khoản?',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              TextButton(
                                onPressed: _handleRegister,
                                child: Text(
                                  'Đăng ký ngay',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: AppDimensions.largePadding * 2,
                          ),

                          // Copyright Footer
                          Column(
                            children: [
                              Text(
                                'Phiên bản 1.0.0',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '© 2024 ',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    'Ignitech',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '. Phát triển bởi Ignitech.',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}
