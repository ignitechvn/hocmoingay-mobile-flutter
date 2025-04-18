import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocmoingay/presentation/screens/auth/register/register_view_model.dart';

import '../../../base/base_state.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerViewModelProvider);
    final viewModel = ref.read(registerViewModelProvider.notifier);

    final fullNameController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final addressController = TextEditingController();
    final gradeController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final event = state.event;
      if (event is NavigateTo) {
        Navigator.pushNamed(context, event.route);
        viewModel.clearEvent();
      } else if (event is ShowMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(event.message)),
        );
        viewModel.clearEvent();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký tài khoản')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ (không bắt buộc)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: gradeController,
                decoration: const InputDecoration(labelText: 'Lớp (không bắt buộc)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () {
                  viewModel.register(
                    fullName: fullNameController.text.trim(),
                    phone: phoneController.text.trim(),
                    password: passwordController.text.trim(),
                    address: addressController.text.trim(),
                    grade: gradeController.text.trim(),
                  );
                },
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
