import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

enum AppTextFieldType { text, email, password, phone, number, multiline }

enum AppTextFieldSize { small, medium, large }

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        const SizedBox(height: AppDimensions.smallPadding),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.defaultRadius),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.defaultPadding,
              vertical: AppDimensions.defaultPadding,
            ),
            suffixIcon: suffixIcon,
          ),
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}

// Convenience constructors for common field types
class EmailTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final AppTextFieldSize size;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;

  const EmailTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.size = AppTextFieldSize.medium,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller ?? TextEditingController(),
      label: label ?? 'Email',
      hint: hint ?? 'Nhập email của bạn',
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      suffixIcon: const Icon(
        Icons.email_outlined,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final AppTextFieldSize size;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;

  const PasswordTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.size = AppTextFieldSize.medium,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller ?? TextEditingController(),
      label: label ?? 'Mật khẩu',
      hint: hint ?? 'Nhập mật khẩu của bạn',
      validator: validator,
      obscureText: true,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      suffixIcon: const Icon(
        Icons.lock_outlined,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class PhoneTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final AppTextFieldSize size;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;

  const PhoneTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.size = AppTextFieldSize.medium,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller ?? TextEditingController(),
      label: label ?? 'Số điện thoại',
      hint: hint ?? 'Nhập số điện thoại của bạn',
      validator: validator,
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      suffixIcon: const Icon(
        Icons.phone_outlined,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class NameTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final AppTextFieldSize size;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;

  const NameTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.size = AppTextFieldSize.medium,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller ?? TextEditingController(),
      label: label ?? 'Họ tên',
      hint: hint ?? 'Nhập họ tên của bạn',
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      suffixIcon: const Icon(
        Icons.person_outlined,
        color: AppColors.textSecondary,
      ),
    );
  }
}
