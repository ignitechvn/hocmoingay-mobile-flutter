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

import '../../../../data/dto/auth_dto.dart';
import '../../../../providers/api/api_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
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
      ToastUtils.showWarning(
        context: context,
        message: 'Vui lòng đồng ý với điều khoản sử dụng',
      );
      return;
    }

    // Validate grade for students
    if (_selectedRole == Role.student && _selectedGrade == null) {
      ToastUtils.showWarning(
        context: context,
        message: 'Vui lòng chọn lớp học',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authApi = ref.read(authApiProvider);

      if (_selectedRole == Role.student) {
        // Register Student
        final registerDto = RegisterStudentDto(
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          address: _addressController.text.trim(),
          gender: _selectedGender.value,
          grade: _selectedGrade!.value,
        );
        final response = await authApi.registerStudent(registerDto);

        if (mounted) {
          // Show success toast
          ToastUtils.showSuccess(
            context: context,
            message: 'Đăng ký thành công!',
          );
          // Save user data if needed
          // await secureStorage.write(key: AppConstants.userKey, value: response.user.toJson());
          Navigator.pushNamed(context, '/congratulations');
        }
      } else if (_selectedRole == Role.teacher) {
        // Register Teacher
        final registerDto = RegisterTeacherDto(
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          address: _addressController.text.trim(),
          gender: _selectedGender.value,
        );
        final response = await authApi.registerTeacher(registerDto);

        if (mounted) {
          // Show success toast
          ToastUtils.showSuccess(
            context: context,
            message: 'Đăng ký thành công!',
          );
          // Save user data if needed
          // await secureStorage.write(key: AppConstants.userKey, value: response.user.toJson());
          Navigator.pushNamed(context, '/congratulations');
        }
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

  void _handleBackToLogin() {
    context.pop();
  }

  void _handleTermsOfService() {
    // TODO: Navigate to terms of service page
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
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
                          Text('Giới tính', style: AppTextStyles.inputLabel),
                          const SizedBox(height: AppDimensions.smallPadding),
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
                            child: DropdownButtonFormField<Gender>(
                              value: _selectedGender,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              items:
                                  Gender.values.map((gender) {
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
                                  [Role.student, Role.teacher].map((role) {
                                    return DropdownMenuItem<Role>(
                                      value: role,
                                      child: Text(
                                        role.displayName,
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
                            const SizedBox(height: AppDimensions.smallPadding),
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
                              child: DropdownButtonFormField<GradeLevel>(
                                value: _selectedGrade,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: 'Chọn lớp học',
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.grey500,
                                  ),
                                ),
                                style: AppTextStyles.bodyMedium,
                                dropdownColor: AppColors.surface,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.textSecondary,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: GestureDetector(
                                onTap: _handleTermsOfService,
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
                                      TextSpan(
                                        text: 'điều khoản sử dụng',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
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
