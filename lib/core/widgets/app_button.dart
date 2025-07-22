import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

enum AppButtonType { primary, secondary, outline, text, danger }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Widget? trailingIcon;
  final Color? customColor;
  final double? customHeight;
  final double? customWidth;
  final BorderRadius? customBorderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.trailingIcon,
    this.customColor,
    this.customHeight,
    this.customWidth,
    this.customBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : customWidth,
      height: customHeight ?? _getButtonHeight(),
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (type) {
      case AppButtonType.primary:
        return _buildFilledButton();
      case AppButtonType.secondary:
        return _buildSecondaryButton();
      case AppButtonType.outline:
        return _buildOutlinedButton();
      case AppButtonType.text:
        return _buildTextButton();
      case AppButtonType.danger:
        return _buildDangerButton();
    }
  }

  Widget _buildFilledButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: customColor ?? AppColors.primary,
        foregroundColor: AppColors.textInverse,
        shape: RoundedRectangleBorder(
          borderRadius:
              customBorderRadius ??
              BorderRadius.circular(AppDimensions.defaultRadius),
        ),
        elevation: onPressed != null ? 2 : 0,
        disabledBackgroundColor:
            customColor ?? AppColors.primary, // Keep color when disabled
        disabledForegroundColor:
            AppColors.textInverse, // Keep text color when disabled
      ),
      onPressed: isLoading ? null : onPressed,
      child: _buildButtonContent(),
    );
  }

  Widget _buildSecondaryButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: customColor ?? AppColors.secondary,
        foregroundColor: AppColors.textInverse,
        shape: RoundedRectangleBorder(
          borderRadius:
              customBorderRadius ??
              BorderRadius.circular(AppDimensions.defaultRadius),
        ),
        elevation: onPressed != null ? 2 : 0,
        disabledBackgroundColor:
            customColor ?? AppColors.secondary, // Keep color when disabled
        disabledForegroundColor:
            AppColors.textInverse, // Keep text color when disabled
      ),
      onPressed: isLoading ? null : onPressed,
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: customColor ?? AppColors.primary,
        side: BorderSide(color: customColor ?? AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius:
              customBorderRadius ??
              BorderRadius.circular(AppDimensions.defaultRadius),
        ),
        disabledForegroundColor:
            customColor ?? AppColors.primary, // Keep color when disabled
      ),
      onPressed: isLoading ? null : onPressed,
      child: _buildButtonContent(),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: customColor ?? AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius:
              customBorderRadius ??
              BorderRadius.circular(AppDimensions.defaultRadius),
        ),
        disabledForegroundColor:
            customColor ?? AppColors.primary, // Keep color when disabled
      ),
      onPressed: isLoading ? null : onPressed,
      child: _buildButtonContent(),
    );
  }

  Widget _buildDangerButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: customColor ?? AppColors.error,
        foregroundColor: AppColors.textInverse,
        shape: RoundedRectangleBorder(
          borderRadius:
              customBorderRadius ??
              BorderRadius.circular(AppDimensions.defaultRadius),
        ),
        elevation: onPressed != null ? 2 : 0,
        disabledBackgroundColor: customColor ?? AppColors.error, // Keep color when disabled
        disabledForegroundColor: AppColors.textInverse, // Keep text color when disabled
      ),
      onPressed: isLoading ? null : onPressed,
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    final hasIcon = icon != null;
    final hasTrailingIcon = trailingIcon != null;

    // Show loading spinner with text
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: _getIconSize(),
            width: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == AppButtonType.outline || type == AppButtonType.text
                    ? (customColor ?? AppColors.primary)
                    : AppColors.textInverse,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.smallPadding),
          Text(text, style: _getTextStyle(), textAlign: TextAlign.center),
        ],
      );
    }

    // Show normal content with icons
    if (hasIcon || hasTrailingIcon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasIcon) ...[
            Icon(icon, size: _getIconSize()),
            const SizedBox(width: AppDimensions.smallPadding),
          ],
          Flexible(
            child: Text(
              text,
              style: _getTextStyle(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasTrailingIcon) ...[
            const SizedBox(width: AppDimensions.smallPadding),
            SizedBox(
              height: _getIconSize(),
              width: _getIconSize(),
              child: trailingIcon!,
            ),
          ],
        ],
      );
    }

    // Show text only
    return Text(text, style: _getTextStyle(), textAlign: TextAlign.center);
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTextStyles.buttonSmall;
      case AppButtonSize.medium:
        return AppTextStyles.buttonMedium;
      case AppButtonSize.large:
        return AppTextStyles.buttonLarge;
    }
  }

  double _getButtonHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }
}

// Convenience constructors for common button types
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.primary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.secondary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? color;

  const OutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.outline,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      customColor: color,
    );
  }
}

class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const DangerButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.danger,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
    );
  }
}
