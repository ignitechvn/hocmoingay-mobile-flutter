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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _agreeToTerms = false;
  Role _selectedRole = Role.student;
  GradeLevel? _selectedGrade;
  Gender _selectedGender = Gender.male;

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
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đồng ý với điều khoản sử dụng'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Validate grade for students
    if (_selectedRole == Role.student && _selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn lớp học'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual API call
      // final authApi = AuthApi(apiService);
      
      if (_selectedRole == Role.student) {
        // Register Student
        // final registerDto = RegisterStudentDto(
        //   fullName: _nameController.text.trim(),
        //   phone: _phoneController.text.trim(),
        //   password: _passwordController.text,
        //   address: _addressController.text.trim(),
        //   gender: _selectedGender.value,
        //   grade: _selectedGrade!.value,
        // );
        // final response = await authApi.registerStudent(registerDto);
      } else if (_selectedRole == Role.teacher) {
        // Register Teacher
        // final registerDto = RegisterTeacherDto(
        //   fullName: _nameController.text.trim(),
        //   phone: _phoneController.text.trim(),
        //   password: _passwordController.text,
        //   address: _addressController.text.trim(),
        //   gender: _selectedGender.value,
        // );
        // final response = await authApi.registerTeacher(registerDto);
      }

      // Simulate API call for now
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // TODO: Save user data if needed
        // await secureStorage.write(key: AppConstants.userKey, value: response.user.toJson());

        context.push(AppRoutes.congratulations);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thất bại: ${e.toString()}'),
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

  void _handleGoogleSignUp() {
    // TODO: Implement Google sign up
  }

  void _handleBackToLogin() {
    context.pop();
  }

  void _handleTermsOfService() {
    // TODO: Navigate to terms of service page
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
                            Icons.person_add,
                            size: 60,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.largePadding),

                        // Title
                        Text(
                          'Tạo tài khoản',
                          style: AppTextStyles.displaySmall,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppDimensions.defaultPadding),

                        // Subtitle
                        Text(
                          'Tham gia cùng chúng tôi để bắt đầu hành trình học tập!',
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
                        // Name Field
                        NameTextField(
                          controller: _nameController,
                          validator: Validators.validateName,
                        ),

                        const SizedBox(height: AppDimensions.defaultPadding),

                        // Phone Field
                        PhoneTextField(
                          controller: _phoneController,
                          validator: Validators.validatePhone,
                        ),

                        const SizedBox(height: AppDimensions.defaultPadding),

                        // Email Field (Optional)
                        EmailTextField(
                          controller: _emailController,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              return Validators.validateEmail(value);
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppDimensions.defaultPadding),
                        
                        // Address Field
                        AppTextField(
                          controller: _addressController,
                          label: 'Địa chỉ',
                          hint: 'Nhập địa chỉ của bạn',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Địa chỉ là bắt buộc';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppDimensions.defaultPadding),
                        
                        // Gender Selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Giới tính',
                              style: AppTextStyles.inputLabel,
                            ),
                            const SizedBox(height: AppDimensions.smallPadding),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.defaultPadding,
                                vertical: AppDimensions.smallPadding,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
                                border: Border.all(color: AppColors.grey300),
                              ),
                              child: DropdownButtonFormField<Gender>(
                                value: _selectedGender,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                items: Gender.values.map((gender) {
                                  return DropdownMenuItem<Gender>(
                                    value: gender,
                                    child: Text(
                                      gender.label,
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (Gender? value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppDimensions.defaultPadding),

                        // Password Field
                        PasswordTextField(
                          controller: _passwordController,
                          validator: Validators.validatePassword,
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
                                items: [Role.student, Role.teacher].map((role) {
                                  return DropdownMenuItem<Role>(
                                    value: role,
                                    child: Text(
                                      role.value == 'teacher' ? 'Giáo viên' : 'Học sinh',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (Role? value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedRole = value;
                                      // Reset grade if not student
                                      if (value != Role.student) {
                                        _selectedGrade = null;
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        // Grade Selection (only for students)
                        if (_selectedRole == Role.student) ...[
                          const SizedBox(height: AppDimensions.defaultPadding),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Lớp học', style: AppTextStyles.inputLabel),
                              const SizedBox(
                                height: AppDimensions.smallPadding,
                              ),
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
                                child: DropdownButtonFormField<GradeLevel>(
                                  value: _selectedGrade,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'Chọn lớp học',
                                  ),
                                  items:
                                      GradeLevel.values.map((grade) {
                                        return DropdownMenuItem<GradeLevel>(
                                          value: grade,
                                          child: Text(
                                            grade.label,
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (GradeLevel? value) {
                                    setState(() {
                                      _selectedGrade = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: AppDimensions.defaultPadding),

                        // Terms of Service
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              activeColor: AppColors.primary,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: AppTextStyles.bodyMedium,
                                  children: [
                                    const TextSpan(
                                      text:
                                          'Bằng cách tiếp tục, bạn đồng ý với ',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: _handleTermsOfService,
                                        child: Text(
                                          'điều khoản sử dụng',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '.',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppDimensions.largePadding),

                        // Register Button
                        PrimaryButton(
                          text: 'Đăng ký',
                          size: AppButtonSize.large,
                          isLoading: _isLoading,
                          onPressed: _handleRegister,
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

                        // Google Sign Up Button
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
                          onPressed: _handleGoogleSignUp,
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

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Đã có tài khoản? ',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: _handleBackToLogin,
                              child: Text(
                                'Đăng nhập tại đây',
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
