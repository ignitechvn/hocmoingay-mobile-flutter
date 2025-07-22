import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

enum AppCardType { default_, elevated, outlined, filled }

enum AppCardSize { small, medium, large }

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardType type;
  final AppCardSize size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget? loadingWidget;

  const AppCard({
    super.key,
    required this.child,
    this.type = AppCardType.default_,
    this.size = AppCardSize.medium,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = _buildCard();

    if (onTap != null) {
      return InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: borderRadius ?? _getBorderRadius(),
        child: cardWidget,
      );
    }

    return cardWidget;
  }

  Widget _buildCard() {
    switch (type) {
      case AppCardType.default_:
        return _buildDefaultCard();
      case AppCardType.elevated:
        return _buildElevatedCard();
      case AppCardType.outlined:
        return _buildOutlinedCard();
      case AppCardType.filled:
        return _buildFilledCard();
    }
  }

  Widget _buildDefaultCard() {
    return Container(
      margin: margin ?? _getMargin(),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius ?? _getBorderRadius(),
        border: Border.all(color: borderColor ?? AppColors.grey200, width: 1),
      ),
      child: _buildCardContent(),
    );
  }

  Widget _buildElevatedCard() {
    return Card(
      margin: margin ?? _getMargin(),
      elevation: elevation ?? 4,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? _getBorderRadius(),
      ),
      color: backgroundColor ?? AppColors.surface,
      child: _buildCardContent(),
    );
  }

  Widget _buildOutlinedCard() {
    return Container(
      margin: margin ?? _getMargin(),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius ?? _getBorderRadius(),
        border: Border.all(color: borderColor ?? AppColors.primary, width: 2),
      ),
      child: _buildCardContent(),
    );
  }

  Widget _buildFilledCard() {
    return Container(
      margin: margin ?? _getMargin(),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceVariant,
        borderRadius: borderRadius ?? _getBorderRadius(),
      ),
      child: _buildCardContent(),
    );
  }

  Widget _buildCardContent() {
    return Container(
      padding: padding ?? _getPadding(),
      child: isLoading ? _buildLoadingContent() : child,
    );
  }

  Widget _buildLoadingContent() {
    return loadingWidget ??
        const Center(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.defaultPadding),
            child: CircularProgressIndicator(),
          ),
        );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case AppCardSize.small:
        return const EdgeInsets.all(AppDimensions.smallPadding);
      case AppCardSize.medium:
        return const EdgeInsets.all(AppDimensions.defaultPadding);
      case AppCardSize.large:
        return const EdgeInsets.all(AppDimensions.largePadding);
    }
  }

  EdgeInsetsGeometry _getMargin() {
    switch (size) {
      case AppCardSize.small:
        return const EdgeInsets.all(AppDimensions.smallPadding);
      case AppCardSize.medium:
        return const EdgeInsets.all(AppDimensions.defaultPadding);
      case AppCardSize.large:
        return const EdgeInsets.all(AppDimensions.largePadding);
    }
  }

  BorderRadius _getBorderRadius() {
    switch (size) {
      case AppCardSize.small:
        return BorderRadius.circular(AppDimensions.smallRadius);
      case AppCardSize.medium:
        return BorderRadius.circular(AppDimensions.defaultRadius);
      case AppCardSize.large:
        return BorderRadius.circular(AppDimensions.largeRadius);
    }
  }
}

// Convenience constructors for common card types
class ElevatedCard extends StatelessWidget {
  final Widget child;
  final AppCardSize size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final double? elevation;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget? loadingWidget;

  const ElevatedCard({
    super.key,
    required this.child,
    this.size = AppCardSize.medium,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.elevation,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: child,
      type: AppCardType.elevated,
      size: size,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      elevation: elevation,
      onTap: onTap,
      isLoading: isLoading,
      loadingWidget: loadingWidget,
    );
  }
}

class OutlinedCard extends StatelessWidget {
  final Widget child;
  final AppCardSize size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget? loadingWidget;

  const OutlinedCard({
    super.key,
    required this.child,
    this.size = AppCardSize.medium,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: child,
      type: AppCardType.outlined,
      size: size,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      onTap: onTap,
      isLoading: isLoading,
      loadingWidget: loadingWidget,
    );
  }
}

class FilledCard extends StatelessWidget {
  final Widget child;
  final AppCardSize size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget? loadingWidget;

  const FilledCard({
    super.key,
    required this.child,
    this.size = AppCardSize.medium,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: child,
      type: AppCardType.filled,
      size: size,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      onTap: onTap,
      isLoading: isLoading,
      loadingWidget: loadingWidget,
    );
  }
}

// Specialized card components
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isLoading;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedCard(
      onTap: onTap,
      isLoading: isLoading,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppDimensions.defaultPadding),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimensions.smallPadding),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppDimensions.defaultPadding),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isLoading;

  const ActionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedCard(
      onTap: onTap,
      isLoading: isLoading,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppDimensions.defaultPadding),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimensions.smallPadding),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppDimensions.defaultPadding),
            trailing!,
          ],
        ],
      ),
    );
  }
}
