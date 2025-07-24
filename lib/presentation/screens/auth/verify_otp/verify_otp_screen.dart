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

class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String phone;

  const VerifyOtpScreen({super.key, required this.phone});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

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
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authApi = ref.read(authApiProvider);
      final verifyOtpDto = VerifyOtpDto(
        phone: widget.phone,
        otp: _otpController.text.trim(),
        role: Role.student, // Default role for forgot password
      );

      await authApi.verifyOtp(verifyOtpDto);

      if (mounted) {
        // Navigate to reset password screen
        await Navigator.pushNamed(
          context,
          '/reset-password',
          arguments: <String, String>{'phone': widget.phone, 'otp': _otpController.text.trim()},
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xác thực OTP thất bại: ${e.toString()}'),
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

  Future<void> _handleResendOtp() async {
    try {
      final authApi = ref.read(authApiProvider);
      final forgotPasswordDto = ForgotPasswordDto(
        phone: widget.phone,
        role: Role.student, // Default role for forgot password
      );

      await authApi.forgotPassword(forgotPasswordDto);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã gửi lại mã OTP'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gửi lại OTP thất bại: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => context.pop(),
      ),
    ),
    body: SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.largePadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.defaultPadding),

                  // Title
                  Text(
                    'Xác thực OTP',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.smallPadding),

                  // Description
                  Text(
                    'Nhập mã OTP đã được gửi đến số điện thoại ${widget.phone}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.largePadding),

                  // OTP Field
                  AppTextField(
                    controller: _otpController,
                    label: 'Mã OTP',
                    hint: 'Nhập mã OTP 6 số',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mã OTP là bắt buộc';
                      }
                      if (value.length != 6) {
                        return 'Mã OTP phải có 6 số';
                      }
                      return null;
                    },
                    maxLength: 6,
                  ),
                  const SizedBox(height: AppDimensions.largePadding),

                  // Verify OTP Button
                  PrimaryButton(
                    text: 'Xác thực OTP',
                    onPressed: _handleVerifyOtp,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: AppDimensions.largePadding),

                  // Resend OTP
                  Center(
                    child: TextButton(
                      onPressed: _handleResendOtp,
                      child: Text(
                        'Gửi lại mã OTP',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
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
  );
}
