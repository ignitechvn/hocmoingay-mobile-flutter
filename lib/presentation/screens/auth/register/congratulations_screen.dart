import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routers/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class CongratulationsScreen extends StatefulWidget {
  const CongratulationsScreen({super.key});

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    context.push(AppRoutes.login);
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
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.largePadding),
          child: Column(
            children: [
              // Illustration Section
              Expanded(
                flex: 3,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(
                          AppDimensions.largePadding,
                        ),
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
                                  color: AppColors.decorativeBlue.withOpacity(
                                    0.7,
                                  ),
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
                                    // Person 1 (Male)
                                    Positioned(
                                      left: 60,
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
                                                  color: AppColors.primary,
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
                                            // Body
                                            Positioned(
                                              top: 35,
                                              left: 25,
                                              child: Container(
                                                width: 30,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                            ),
                                            // Arms (raised)
                                            Positioned(
                                              top: 25,
                                              left: 15,
                                              child: Transform.rotate(
                                                angle: -0.5,
                                                child: Container(
                                                  width: 8,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 25,
                                              right: 15,
                                              child: Transform.rotate(
                                                angle: 0.5,
                                                child: Container(
                                                  width: 8,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Person 2 (Female)
                                    Positioned(
                                      right: 60,
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
                                                    color:
                                                        AppColors.textInverse,
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
                                            // Arms (raised)
                                            Positioned(
                                              top: 25,
                                              left: 15,
                                              child: Transform.rotate(
                                                angle: -0.5,
                                                child: Container(
                                                  width: 8,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 25,
                                              right: 15,
                                              child: Transform.rotate(
                                                angle: 0.5,
                                                child: Container(
                                                  width: 8,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
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
              ),

              // Content Section
              Expanded(
                flex: 2,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          'Chúc mừng!',
                          style: AppTextStyles.displaySmall,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppDimensions.defaultPadding),

                        // Message
                        Text(
                          'Chúng tôi đã gửi email xác thực, vui lòng kiểm tra hộp thư và làm theo hướng dẫn để xác thực tài khoản.',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppDimensions.defaultPadding),

                        // Closing
                        Text(
                          'Cảm ơn bạn đã đăng ký với chúng tôi!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Section
              Expanded(
                flex: 1,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryButton(
                          text: 'Đăng nhập tại đây',
                          size: AppButtonSize.large,
                          onPressed: _handleSignIn,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
