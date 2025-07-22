import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routers/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
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
      // TODO: Implement actual API call
      // final authApi = AuthApi(apiService);
      // final loginDto = LoginDto(
      //   userName: _phoneController.text.trim(),
      //   password: _passwordController.text,
      //   role: _selectedRole.value,
      // );
      // final response = await authApi.login(loginDto);

      // Simulate API call for now
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // TODO: Save token and user data to secure storage
        // await secureStorage.write(key: AppConstants.tokenKey, value: response.accessToken);
        // await secureStorage.write(key: AppConstants.userKey, value: response.user.toJson());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thành công!'),
            backgroundColor: AppColors.success,
          ),
        );

        context.push(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập thất bại: ${e.toString()}'),
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

  void _handleForgotPassword() {
    context.push(AppRoutes.resetPassword);
  }

  void _handleRegister() {
    context.push(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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

                        // Logo/Illustration
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
                            Icons.school,
                            size: 60,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.largePadding),

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
                            const SizedBox(height: AppDimensions.smallPadding),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.defaultPadding,
                                vertical: AppDimensions.smallPadding,
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
                                items:
                                    Role.values.map((role) {
                                      return DropdownMenuItem<Role>(
                                        value: role,
                                        child: Text(
                                          role.value == 'teacher'
                                              ? 'Giáo viên'
                                              : role.value == 'student'
                                              ? 'Học sinh'
                                              : role.value == 'parent'
                                              ? 'Phụ huynh'
                                              : 'Admin',
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (Role? value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedRole = value;
                                    });
                                  }
                                },
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

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.grey300,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.defaultPadding,
                              ),
                              child: Text(
                                'hoặc',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.grey300,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppDimensions.largePadding),

                        // Google Sign In Button
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.grey300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.defaultRadius,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.defaultPadding,
                            ),
                          ),
                          onPressed: () {
                            // TODO: Implement Google sign in
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google Icon
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    'G',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: AppDimensions.defaultPadding,
                              ),
                              Text(
                                'Tiếp tục với Google',
                                style: AppTextStyles.buttonMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
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
                                'Đăng ký ngay',
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
