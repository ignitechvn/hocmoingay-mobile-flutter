import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routers/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';

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

  String? selectedRole;

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

  void _selectRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  void _proceedToLogin() {
    if (selectedRole != null) {
      // TODO: Save selected role to preferences
      context.push(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    child: Stack(
                      children: [
                        // Abstract background shapes
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.decorativePurple.withOpacity(
                                0.6,
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 40,
                          left: 30,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.decorativeBlue.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        // Main illustration
                        Center(
                          child: Container(
                            width: 280,
                            height: 200,
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
                            child: Stack(
                              children: [
                                // Person 1 (Teacher)
                                Positioned(
                                  left: 40,
                                  bottom: 30,
                                  child: Container(
                                    width: 80,
                                    height: 120,
                                    child: Stack(
                                      children: [
                                        // Head
                                        Positioned(
                                          top: 0,
                                          left: 20,
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: AppColors.accent,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.person,
                                                color: AppColors.textInverse,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Body
                                        Positioned(
                                          top: 35,
                                          left: 25,
                                          child: Container(
                                            width: 30,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: AppColors.accent,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                        // Arms
                                        Positioned(
                                          top: 40,
                                          left: 15,
                                          child: Container(
                                            width: 8,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: AppColors.accent,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 40,
                                          right: 15,
                                          child: Container(
                                            width: 8,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: AppColors.accent,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Laptop
                                Positioned(
                                  left: 120,
                                  bottom: 20,
                                  child: Container(
                                    width: 80,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.smallRadius,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Screen
                                        Positioned(
                                          top: 5,
                                          left: 5,
                                          right: 5,
                                          bottom: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF87CEEB),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.computer,
                                                color: AppColors.textInverse,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Person 2 (Student)
                                Positioned(
                                  right: 40,
                                  bottom: 30,
                                  child: Container(
                                    width: 80,
                                    height: 120,
                                    child: Stack(
                                      children: [
                                        // Head
                                        Positioned(
                                          top: 0,
                                          left: 20,
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: AppColors.secondary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.person,
                                                color: AppColors.textInverse,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Body
                                        Positioned(
                                          top: 35,
                                          left: 25,
                                          child: Container(
                                            width: 30,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                        // Arms
                                        Positioned(
                                          top: 40,
                                          left: 15,
                                          child: Container(
                                            width: 8,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 40,
                                          right: 15,
                                          child: Container(
                                            width: 8,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                        Text(
                          'Chọn vai trò của bạn',
                          style: AppTextStyles.onboardingTitle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.defaultPadding),

                        // Description
                        Text(
                          'Chọn "Giáo viên" nếu bạn muốn dạy hoặc "Học sinh" nếu bạn muốn học',
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
                                onTap:
                                    () => _selectRole(AppConstants.roleTeacher),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color:
                                        selectedRole == AppConstants.roleTeacher
                                            ? AppColors.teacherLight
                                            : AppColors.surface,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.defaultRadius,
                                    ),
                                    border: Border.all(
                                      color:
                                          selectedRole ==
                                                  AppConstants.roleTeacher
                                              ? AppColors.teacherPrimary
                                              : AppColors.grey300,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadowLight,
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          color: AppColors.accent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.school,
                                          color: AppColors.textInverse,
                                          size: 24,
                                        ),
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
                                onTap:
                                    () => _selectRole(AppConstants.roleStudent),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color:
                                        selectedRole == AppConstants.roleStudent
                                            ? AppColors.studentLight
                                            : AppColors.surface,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.defaultRadius,
                                    ),
                                    border: Border.all(
                                      color:
                                          selectedRole ==
                                                  AppConstants.roleStudent
                                              ? AppColors.studentPrimary
                                              : AppColors.grey300,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadowLight,
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          color: AppColors.secondary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: AppColors.textInverse,
                                          size: 24,
                                        ),
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
}
