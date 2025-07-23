import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routers/app_router.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';

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
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
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
                  child: Center(
                    child: Image.asset(
                      'assets/images/onboarding/welcome_illustration.jpg',
                      width: 500,
                      height: 500,
                      fit: BoxFit.contain,
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main Title
                      Text(
                        'Chào mừng đến với\nHọc Mỗi Ngày',
                        style: AppTextStyles.onboardingTitle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimensions.defaultPadding),

                      // Description
                      Text(
                        'Nền tảng giáo dục trực tuyến kết nối giáo viên và học sinh, tạo môi trường học tập hiệu quả và linh hoạt',
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
                        onPressed: () => Navigator.pushNamed(context, '/role-selection'),
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
