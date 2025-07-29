import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

enum ToastType { success, fail, warning, info }

class ToastUtils {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  /// Hiển thị Toast thông báo
  static void showToast({
    required BuildContext context,
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Ẩn Toast hiện tại nếu đang hiển thị
    _hideToast();

    // Tạo OverlayEntry mới
    _overlayEntry = OverlayEntry(
      builder: (context) =>
          _ToastWidget(message: message, type: type, onDismiss: _hideToast),
    );

    // Hiển thị Toast
    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;

    // Tự động ẩn sau thời gian duration
    Future.delayed(duration, () {
      _hideToast();
    });
  }

  /// Hiển thị Toast thành công
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(
      context: context,
      message: message,
      type: ToastType.success,
      duration: duration,
    );
  }

  /// Hiển thị Toast thất bại
  static void showFail({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    showToast(
      context: context,
      message: message,
      type: ToastType.fail,
      duration: duration,
    );
  }

  /// Hiển thị Toast cảnh báo
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(
      context: context,
      message: message,
      type: ToastType.warning,
      duration: duration,
    );
  }

  /// Hiển thị Toast thông tin
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(
      context: context,
      message: message,
      type: ToastType.info,
      duration: duration,
    );
  }

  /// Ẩn Toast hiện tại
  static void _hideToast() {
    if (_isShowing && _overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isShowing = false;
    }
  }

  /// Ẩn Toast thủ công (có thể gọi từ bên ngoài)
  static void hideToast() {
    _hideToast();
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case ToastType.success:
        return AppColors.success;
      case ToastType.fail:
        return AppColors.error;
      case ToastType.warning:
        return AppColors.warning;
      case ToastType.info:
        return AppColors.info;
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.white;
      case ToastType.fail:
        return Colors.white;
      case ToastType.warning:
        return Colors.white;
      case ToastType.info:
        return Colors.white;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.fail:
        return Icons.error_outline;
      case ToastType.warning:
        return Icons.warning_amber_outlined;
      case ToastType.info:
        return Icons.info_outline;
    }
  }

  String _getTitle() {
    switch (widget.type) {
      case ToastType.success:
        return 'Thành công';
      case ToastType.fail:
        return 'Thất bại';
      case ToastType.warning:
        return 'Cảnh báo';
      case ToastType.info:
        return 'Thông tin';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: AppDimensions.defaultPadding,
      right: AppDimensions.defaultPadding,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value * 100),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.defaultPadding),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.defaultRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Icon(_getIcon(), color: _getTextColor(), size: 24),
                      const SizedBox(width: AppDimensions.smallPadding),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getTitle(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: _getTextColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.message,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: _getTextColor(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Close button
                      GestureDetector(
                        onTap: widget.onDismiss,
                        child: Icon(
                          Icons.close,
                          color: _getTextColor(),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
