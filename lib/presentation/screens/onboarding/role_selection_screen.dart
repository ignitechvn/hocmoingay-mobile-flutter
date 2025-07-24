import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routers/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../auth/login/login_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Role? selectedRole;

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
    super.dispose();
  }

  void _selectRole(Role role) {
    setState(() {
      selectedRole = role;
    });
  }

  void _proceedToLogin() {
    if (selectedRole != null) {
      // Pass selected role to login screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(selectedRole: selectedRole),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          // Illustration Section (35-40% of screen height)
          Expanded(
            flex: 4,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.largePadding),
                  child: Center(
                    child: Image.asset(
                      'assets/images/onboarding/role_selection_illustration.jpg',
                      width: 500,
                      height: 500,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) =>
                          // Fallback to placeholder if image not found
                          Container(
                            width: 280,
                            height: 200,
                            color: AppColors.surface,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 80,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Chọn vai trò',
                                  style: AppTextStyles.titleLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content Section
          Expanded(
            flex: 3,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.largePadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main Title
                      const Text(
                        'Chọn vai trò của bạn',
                        style: AppTextStyles.onboardingTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.defaultPadding),

                      // Description
                      const Text(
                        'Xác định vai trò của bạn để tối ưu hóa trải nghiệm học tập và giảng dạy trên nền tảng',
                        style: AppTextStyles.onboardingDescription,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.largePadding),

                      // Role Selection
                      Row(
                        children: [
                          // Teacher Role
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectRole(Role.teacher),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 120,
                                decoration: BoxDecoration(
                                  color:
                                      selectedRole == Role.teacher
                                          ? AppColors.teacherLight
                                          : AppColors.surface,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.defaultRadius,
                                  ),
                                  border:
                                      selectedRole == Role.teacher
                                          ? Border.all(
                                            color: AppColors.teacherPrimary,
                                            width: 2,
                                          )
                                          : null,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.shadowLight,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/onboarding/teacher_icon.png',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      height: AppDimensions.smallPadding,
                                    ),
                                    Text(
                                      'Giáo viên',
                                      style: AppTextStyles.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: AppDimensions.defaultPadding),

                          // Student Role
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectRole(Role.student),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 120,
                                decoration: BoxDecoration(
                                  color:
                                      selectedRole == Role.student
                                          ? AppColors.teacherLight
                                          : AppColors.surface,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.defaultRadius,
                                  ),
                                  border:
                                      selectedRole == Role.student
                                          ? Border.all(
                                            color: AppColors.teacherPrimary,
                                            width: 2,
                                          )
                                          : null,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.shadowLight,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/onboarding/student_icon.png',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      height: AppDimensions.smallPadding,
                                    ),
                                    Text(
                                      'Học sinh',
                                      style: AppTextStyles.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: AppDimensions.defaultPadding),

                          // Parent Role
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectRole(Role.parent),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 120,
                                decoration: BoxDecoration(
                                  color:
                                      selectedRole == Role.parent
                                          ? AppColors.teacherLight
                                          : AppColors.surface,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.defaultRadius,
                                  ),
                                  border:
                                      selectedRole == Role.parent
                                          ? Border.all(
                                            color: AppColors.teacherPrimary,
                                            width: 2,
                                          )
                                          : null,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.shadowLight,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/onboarding/parent_icon.png',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      height: AppDimensions.smallPadding,
                                    ),
                                    Text(
                                      'Phụ huynh',
                                      style: AppTextStyles.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Action Button Section
          Expanded(
            flex: 2,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.largePadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrimaryButton(
                        text: 'Tiếp tục',
                        size: AppButtonSize.large,
                        onPressed:
                            selectedRole != null ? _proceedToLogin : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
