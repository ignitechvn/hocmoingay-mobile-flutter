# API Logging Guide - Học Mỗi Ngày Mobile App

## Tổng quan

Hệ thống API logging được thiết kế để tự động theo dõi và log tất cả các API calls trong ứng dụng Flutter. Hệ thống này giúp developers debug, monitor performance và troubleshoot các vấn đề liên quan đến API.

## Tính năng

### ✅ Đã triển khai

1. **Tự động logging tất cả API calls**
   - Request details (method, URL, headers, body)
   - Response details (status code, headers, body)
   - Error details (error message, stack trace)
   - Performance metrics (thời gian thực hiện)

2. **Cấu hình thông minh**
   - Tự động bật/tắt theo environment
   - Development/Staging: Logging được bật
   - Production: Logging bị tắt để tối ưu performance

3. **Log levels phù hợp**
   - Info: Request/Response thông thường
   - Error: API errors và exceptions
   - Performance: Thời gian thực hiện

4. **Interceptor-based architecture**
   - Không cần thay đổi code API services
   - Tự động áp dụng cho tất cả API calls
   - Dễ dàng mở rộng và tùy chỉnh

## Cách sử dụng

### 1. Logging tự động

Tất cả API calls thông qua `BaseApiService` sẽ được log tự động:

```dart
// Không cần thêm code gì - logging tự động hoạt động
final authApi = AuthApi(BaseApiService());
final result = await authApi.login(loginDto);
```

### 2. API URL Configuration

API URLs đã được cấu hình để không có tiền tố `/api/v1`:

```dart
// AppConfig.apiVersion = "" (empty string)
// Base URL: http://54.179.51.171:8000
// Full URL: http://54.179.51.171:8000/auth/login
```

### 2. Xem logs

Logs sẽ xuất hiện trong:
- **Debug Console** (VS Code/Android Studio)
- **Terminal** (khi chạy `flutter run`)
- **Device logs** (khi debug trên device)

### 3. Test logging

```dart
import 'package:your_app/core/utils/api_logging_demo.dart';

// Chạy demo để test logging
ApiLoggingDemo.testApiLogging();

// Xem hướng dẫn sử dụng
ApiLoggingGuide.showUsageGuide();
```

## Cấu trúc logs

### API Request Log
```
💡 INFO: API Request: POST http://54.179.51.171:8000/auth/login
{
  "headers": {
    "Content-Type": "application/json",
    "Authorization": "Bearer token..."
  },
  "body": {
    "userName": "0912345678",
    "password": "***",
    "role": "student"
  }
}
```

### API Response Log
```
💡 INFO: API Response: POST http://54.179.51.171:8000/auth/login - 200
{
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "token": "jwt_token_here",
    "user": {...}
  }
}
```

### Performance Log
```
📊 INFO: Performance: API POST /auth/login took 245ms
```

### Error Log
```
❌ ERROR: API Error: POST http://54.179.51.171:8000/auth/login
DioException [DioExceptionType.badResponse]: HTTP 401 Unauthorized
```

## Cấu hình

### Environment-based logging

```dart
// lib/core/config/app_config.dart
static bool get enableLogging => !isProduction;
```

### Tùy chỉnh log format

```dart
// lib/core/utils/logger.dart
static Logger get logger {
  _logger ??= Logger(
    filter: AppConfig.enableLogging ? DevelopmentFilter() : ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    output: ConsoleOutput(),
  );
  return _logger!;
}
```

## Tùy chỉnh nâng cao

### 1. Thêm custom filters

```dart
class CustomApiLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Chỉ log các API calls quan trọng
    if (options.path.contains('/auth/') || options.path.contains('/user/')) {
      AppLogger.logApiRequest(
        options.method,
        '${options.baseUrl}${options.path}',
        options.headers,
        options.data,
      );
    }
    super.onRequest(options, handler);
  }
}
```

### 2. Log to file

```dart
import 'package:logger/logger.dart';

class FileOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Ghi logs vào file
    final file = File('api_logs.txt');
    file.writeAsStringSync('${event.lines.join('\n')}\n', mode: FileMode.append);
  }
}
```

### 3. Send logs to external service

```dart
class RemoteLoggingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Gửi error logs đến external service
    _sendToAnalytics(err);
    super.onError(err, handler);
  }
  
  void _sendToAnalytics(DioException error) {
    // Implementation for sending to Firebase Analytics, Crashlytics, etc.
  }
}
```

## Best Practices

### 1. Không log sensitive data

```dart
// ❌ Không nên
AppLogger.info('Password: ${loginDto.password}');

// ✅ Nên làm
AppLogger.info('Login attempt for: ${loginDto.email}');
```

### 2. Sử dụng log levels phù hợp

```dart
// Debug - thông tin chi tiết cho development
AppLogger.debug('Processing API response', response.data);

// Info - thông tin chung
AppLogger.info('API call completed', {'endpoint': '/auth/login'});

// Warning - cảnh báo
AppLogger.warning('API response time slow', {'duration': '2.5s'});

// Error - lỗi cần xử lý
AppLogger.error('API call failed', error, stackTrace);
```

### 3. Performance monitoring

```dart
// Theo dõi API performance
if (duration.inMilliseconds > 1000) {
  AppLogger.warning('Slow API call detected', {
    'endpoint': '/api/slow-endpoint',
    'duration': '${duration.inMilliseconds}ms'
  });
}
```

## Troubleshooting

### Logs không xuất hiện

1. **Kiểm tra environment**
   ```dart
   print('Enable logging: ${AppConfig.enableLogging}');
   ```

2. **Kiểm tra interceptor**
   ```dart
   print('Interceptors: ${dio.interceptors.length}');
   ```

3. **Test manual logging**
   ```dart
   AppLogger.info('Test log message');
   ```

### Performance issues

1. **Disable logging trong production**
   - Đảm bảo `AppConfig.enableLogging = false` trong production

2. **Filter logs**
   - Chỉ log các API calls quan trọng
   - Sử dụng log levels phù hợp

3. **Optimize log output**
   - Giảm `methodCount` trong PrettyPrinter
   - Sử dụng `ProductionFilter` trong production

## Monitoring và Analytics

### Firebase Analytics Integration

```dart
class AnalyticsLoggingInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Track API calls in Firebase Analytics
    FirebaseAnalytics.instance.logEvent(
      name: 'api_call',
      parameters: {
        'endpoint': response.requestOptions.path,
        'method': response.requestOptions.method,
        'status_code': response.statusCode,
        'duration': duration.inMilliseconds,
      },
    );
    super.onResponse(response, handler);
  }
}
```

### Crashlytics Integration

```dart
class CrashlyticsLoggingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Send API errors to Crashlytics
    FirebaseCrashlytics.instance.recordError(
      err,
      err.stackTrace,
      reason: 'API Error: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }
}
```

## Kết luận

Hệ thống API logging đã được thiết kế để:
- **Tự động**: Không cần thay đổi code API services
- **Thông minh**: Tự động bật/tắt theo environment
- **Chi tiết**: Log đầy đủ request, response, error và performance
- **Mở rộng**: Dễ dàng tùy chỉnh và mở rộng
- **Hiệu quả**: Không ảnh hưởng performance trong production

Với hệ thống này, bạn có thể dễ dàng debug, monitor và troubleshoot các vấn đề liên quan đến API trong ứng dụng Flutter của mình. 