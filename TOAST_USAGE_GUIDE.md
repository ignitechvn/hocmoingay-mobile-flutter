# Toast System Guide - Học Mỗi Ngày Mobile App

## Tổng quan

Hệ thống Toast được thiết kế để hiển thị thông báo ngắn gọn ở phía trên màn hình với 3 loại chính: Success, Fail và Warning. Toast có animation đẹp mắt và tự động biến mất sau một khoảng thời gian.

## Tính năng

### ✅ Đã triển khai

1. **3 loại Toast chính**
   - Success: Thông báo thành công (màu xanh)
   - Fail: Thông báo thất bại (màu đỏ)
   - Warning: Thông báo cảnh báo (màu cam)

2. **Animation mượt mà**
   - Slide down từ trên xuống
   - Fade in/out
   - Tự động ẩn sau thời gian cấu hình

3. **Tùy chỉnh linh hoạt**
   - Thời gian hiển thị có thể điều chỉnh
   - Có thể ẩn thủ công
   - Tự động ẩn Toast cũ khi hiển thị Toast mới

4. **UI/UX tốt**
   - Hiển thị ở phía trên màn hình (không che nội dung)
   - Có icon và title phù hợp
   - Có nút đóng thủ công
   - Shadow và border radius đẹp mắt

## Cách sử dụng

### 1. Import ToastUtils

```dart
import 'package:your_app/core/utils/toast_utils.dart';
```

### 2. Hiển thị Toast

#### Success Toast
```dart
ToastUtils.showSuccess(
  context: context,
  message: 'Đăng nhập thành công!',
);
```

#### Fail Toast
```dart
ToastUtils.showFail(
  context: context,
  message: 'Đăng nhập thất bại: Thông tin không chính xác',
);
```

#### Warning Toast
```dart
ToastUtils.showWarning(
  context: context,
  message: 'Cảnh báo: Mật khẩu sẽ hết hạn sớm',
);
```

### 3. Tùy chỉnh thời gian hiển thị

```dart
ToastUtils.showSuccess(
  context: context,
  message: 'Thông báo quan trọng',
  duration: const Duration(seconds: 5), // Hiển thị 5 giây
);
```

### 4. Ẩn Toast thủ công

```dart
ToastUtils.hideToast();
```

## Ví dụ sử dụng trong Login

### Trước khi có Toast (SnackBar):
```dart
try {
  await authProvider.login(phone, password, role);
  // Navigate to home
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Đăng nhập thất bại: ${e.toString()}'),
      backgroundColor: AppColors.error,
    ),
  );
}
```

### Sau khi có Toast:
```dart
try {
  await authProvider.login(phone, password, role);
  
  // Show success toast
  ToastUtils.showSuccess(
    context: context,
    message: 'Đăng nhập thành công!',
  );
  
  // Navigate to home
  context.go(AppRoutes.home);
} catch (e) {
  ToastUtils.showFail(
    context: context,
    message: 'Đăng nhập thất bại: ${e.toString()}',
  );
}
```

## Cấu trúc Toast

### Visual Layout
```
┌─────────────────────────────────────┐
│ ✓ Thành công                        │
│ Đăng nhập thành công!              × │
└─────────────────────────────────────┘
```

### Components
- **Icon**: Phù hợp với loại Toast (✓, ⚠️, ❌)
- **Title**: Tên loại Toast (Thành công, Thất bại, Cảnh báo)
- **Message**: Nội dung thông báo
- **Close Button**: Nút đóng thủ công

## Màu sắc

### Success Toast
- Background: `AppColors.success` (xanh lá)
- Text: Trắng
- Icon: `Icons.check_circle_outline`

### Fail Toast
- Background: `AppColors.error` (đỏ)
- Text: Trắng
- Icon: `Icons.error_outline`

### Warning Toast
- Background: `AppColors.warning` (cam)
- Text: Trắng
- Icon: `Icons.warning_amber_outlined`

## Animation

### Entrance Animation
- **Duration**: 300ms
- **Slide**: Từ trên xuống (translateY: -100 → 0)
- **Fade**: Opacity 0 → 1
- **Curve**: `Curves.easeOutCubic`

### Auto Hide
- **Success**: 3 giây
- **Fail**: 4 giây (lâu hơn để user đọc)
- **Warning**: 3 giây
- **Custom**: Có thể tùy chỉnh

## Best Practices

### 1. Sử dụng đúng loại Toast
```dart
// ✅ Đúng
ToastUtils.showSuccess(context, 'Lưu thành công');
ToastUtils.showFail(context, 'Lưu thất bại');
ToastUtils.showWarning(context, 'Dữ liệu chưa hoàn chỉnh');

// ❌ Sai
ToastUtils.showSuccess(context, 'Có lỗi xảy ra');
```

### 2. Message ngắn gọn, rõ ràng
```dart
// ✅ Tốt
ToastUtils.showSuccess(context, 'Đăng nhập thành công!');

// ❌ Dài dòng
ToastUtils.showSuccess(context, 'Bạn đã đăng nhập thành công vào hệ thống Học Mỗi Ngày. Chào mừng bạn quay trở lại!');
```

### 3. Không spam Toast
```dart
// ❌ Không nên
for (int i = 0; i < 10; i++) {
  ToastUtils.showSuccess(context, 'Toast $i');
}

// ✅ Nên
ToastUtils.showSuccess(context, 'Đã xử lý 10 items');
```

### 4. Xử lý lỗi phù hợp
```dart
try {
  await apiCall();
  ToastUtils.showSuccess(context, 'Thành công');
} catch (e) {
  // Hiển thị lỗi cụ thể thay vì generic message
  String errorMessage = _getErrorMessage(e);
  ToastUtils.showFail(context, errorMessage);
}
```

## Test Toast

### Chạy Demo
```bash
flutter run test_toast_demo.dart
```

### Test trong App
```dart
// Test success
ToastUtils.showSuccess(context, 'Test success message');

// Test fail
ToastUtils.showFail(context, 'Test fail message');

// Test warning
ToastUtils.showWarning(context, 'Test warning message');
```

## Troubleshooting

### Toast không hiển thị
1. **Kiểm tra context**: Đảm bảo context hợp lệ
2. **Kiểm tra Overlay**: Đảm bảo widget có Overlay
3. **Kiểm tra import**: Đảm bảo đã import `ToastUtils`

### Toast hiển thị nhiều lần
- Toast mới sẽ tự động ẩn Toast cũ
- Sử dụng `ToastUtils.hideToast()` nếu cần

### Toast bị che khuất
- Toast hiển thị ở `top + 10` để tránh status bar
- Kiểm tra z-index của các widget khác

## Kết luận

Hệ thống Toast cung cấp:
- **UX tốt**: Thông báo rõ ràng, không xâm lấn
- **Tái sử dụng**: Dễ dàng sử dụng ở mọi nơi trong app
- **Linh hoạt**: Có thể tùy chỉnh thời gian và nội dung
- **Nhất quán**: Design thống nhất trong toàn bộ app

Với hệ thống này, bạn có thể dễ dàng thay thế SnackBar và cung cấp trải nghiệm người dùng tốt hơn! 🚀 