import 'package:dio/dio.dart';
import '../utils/logger.dart';

class ApiLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final startTime = DateTime.now();

    // Log request details
    AppLogger.logApiRequest(
      options.method,
      '${options.baseUrl}${options.path}',
      options.headers,
      options.data,
    );

    // Add start time to options for response logging
    options.extra['startTime'] = startTime;

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as DateTime?;
    final duration =
        startTime != null
            ? DateTime.now().difference(startTime)
            : Duration.zero;

    // Log response details
    AppLogger.logApiResponse(
      response.requestOptions.method,
      '${response.requestOptions.baseUrl}${response.requestOptions.path}',
      response.statusCode ?? 0,
      response.headers.map,
      response.data,
    );

    // Log performance
    AppLogger.logPerformance(
      'API ${response.requestOptions.method} ${response.requestOptions.path}',
      duration,
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['startTime'] as DateTime?;
    final duration =
        startTime != null
            ? DateTime.now().difference(startTime)
            : Duration.zero;

    // Log error details with response body
    AppLogger.logApiError(
      err.requestOptions.method,
      '${err.requestOptions.baseUrl}${err.requestOptions.path}',
      err,
      err.stackTrace,
    );

    // Log detailed error response
    if (err.response?.data != null) {
      AppLogger.error('Error Response Body: ${err.response!.data}');
    }

    // Log performance even for errors
    AppLogger.logPerformance(
      'API ${err.requestOptions.method} ${err.requestOptions.path} (ERROR)',
      duration,
    );

    super.onError(err, handler);
  }
}
