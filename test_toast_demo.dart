// Demo file để test Toast functionality
// Chạy file này để xem các loại Toast khác nhau

import 'package:flutter/material.dart';
import 'lib/core/utils/toast_utils.dart';

void main() {
  runApp(const ToastDemoApp());
}

class ToastDemoApp extends StatelessWidget {
  const ToastDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toast Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ToastDemoScreen(),
    );
  }
}

class ToastDemoScreen extends StatelessWidget {
  const ToastDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toast Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Toast
            ElevatedButton(
              onPressed: () {
                ToastUtils.showSuccess(
                  context: context,
                  message: 'Đăng nhập thành công! Chào mừng bạn quay trở lại.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Show Success Toast'),
            ),

            const SizedBox(height: 16),

            // Fail Toast
            ElevatedButton(
              onPressed: () {
                ToastUtils.showFail(
                  context: context,
                  message:
                      'Đăng nhập thất bại: Thông tin đăng nhập không chính xác.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Show Fail Toast'),
            ),

            const SizedBox(height: 16),

            // Warning Toast
            ElevatedButton(
              onPressed: () {
                ToastUtils.showWarning(
                  context: context,
                  message:
                      'Cảnh báo: Mật khẩu của bạn sẽ hết hạn trong 7 ngày.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Show Warning Toast'),
            ),

            const SizedBox(height: 32),

            // Custom Duration
            ElevatedButton(
              onPressed: () {
                ToastUtils.showSuccess(
                  context: context,
                  message: 'Toast này sẽ hiển thị trong 5 giây',
                  duration: const Duration(seconds: 5),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Show Long Duration Toast'),
            ),

            const SizedBox(height: 16),

            // Hide Toast
            ElevatedButton(
              onPressed: () {
                ToastUtils.hideToast();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Hide Current Toast'),
            ),
          ],
        ),
      ),
    );
  }
}

// Hướng dẫn sử dụng:
// 1. Chạy: flutter run test_toast_demo.dart
// 2. Nhấn các nút để xem các loại Toast khác nhau
// 3. Toast sẽ hiển thị ở phía trên màn hình với animation đẹp
