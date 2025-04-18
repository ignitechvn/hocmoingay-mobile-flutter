import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocmoingay/core/widgets/text_normal.dart';

import '../../../../core/routers/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text_header.dart';
import '../../../../core/widgets/text_normal_bold.dart';
import '../../../base/base_state.dart';
import 'login_view_model.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final showPassword = ValueNotifier(false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final event = state.event;
      if (event is NavigateTo) {
        Navigator.pushNamed(context, event.route);
        viewModel.clearEvent();
      } else if (event is ShowMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextNormal(event.message)),
        );
        viewModel.clearEvent();
      }
    });

    InputDecoration customInput(String hint) => InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black87),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFEAEAEA),
                  child: Icon(Icons.school, size: 28, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                const TextHeader(
                  'Chào mừng trở lại!'
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: customInput('Nhập số điện thoại'),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder(
                  valueListenable: showPassword,
                  builder: (context, value, child) {
                    return TextField(
                      controller: passwordController,
                      obscureText: !value,
                      decoration: customInput('Nhập mật khẩu').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            showPassword.value = !showPassword.value;
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: state.isLoading
                        ? null
                        : () {
                      viewModel.login(
                        phoneController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                    child: state.isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const TextNormal(
                      'Đăng nhập', color: AppColors.textInverse,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  child: const TextNormalBold('Quên mật khẩu?'),
                ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextNormal('Chưa có tài khoản?'),
                    TextButton(
                      onPressed: () {
                        context.push(AppRoutes.register);
                      },
                      child: const TextNormalBold('Đăng ký tài khoản'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
