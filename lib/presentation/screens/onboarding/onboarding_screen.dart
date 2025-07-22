import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routers/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/text_header.dart';
import '../../../core/widgets/text_normal.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Illustration Section (40-45% of screen height)
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
                            height: 280,
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
                                // Bookshelf
                                Positioned(
                                  top: 20,
                                  right: 20,
                                  child: Container(
                                    width: 40,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8B4513),
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.smallRadius,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 35,
                                          height: 8,
                                          margin: const EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF654321),
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 35,
                                          height: 8,
                                          margin: const EdgeInsets.only(top: 3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF654321),
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Wall painting
                                Positioned(
                                  top: 15,
                                  left: 20,
                                  child: Container(
                                    width: 50,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF87CEEB),
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.smallRadius,
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFF4682B4),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                // Person with laptop
                                Positioned(
                                  bottom: 30,
                                  left: 50,
                                  child: Row(
                                    children: [
                                      // Person
                                      Container(
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
                                                    color:
                                                        AppColors.textInverse,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Glasses
                                            Positioned(
                                              top: 8,
                                              left: 18,
                                              child: Container(
                                                width: 44,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        AppColors.textPrimary,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                            // Pointing hand
                                            Positioned(
                                              top: 45,
                                              right: 5,
                                              child: Transform.rotate(
                                                angle: -0.3,
                                                child: Container(
                                                  width: 6,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.accent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          3,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      // Laptop
                                      Container(
                                        width: 100,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: AppColors.grey800,
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
                                                  color: const Color(
                                                    0xFF87CEEB,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.computer,
                                                    color:
                                                        AppColors.textInverse,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                          'Chào mừng đến với\nHọc Mỗi Ngày',
                          style: AppTextStyles.onboardingTitle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.defaultPadding),

                        // Description
                        Text(
                          'Học Mỗi Ngày là ứng dụng kết nối "Người muốn dạy" với "Người muốn học"',
                          style: AppTextStyles.onboardingDescription,
                          textAlign: TextAlign.center,
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
                          text: 'Bắt đầu',
                          size: AppButtonSize.large,
                          onPressed: () {
                            context.push(AppRoutes.roleSelection);
                          },
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
