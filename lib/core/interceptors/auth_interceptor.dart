import 'package:dio/dio.dart';

import '../services/token_manager.dart';
import '../../data/datasources/api/auth_api.dart';
import '../../data/dto/auth_dto.dart';

class AuthInterceptor extends Interceptor {
  final AuthApi _authApi;
  final Dio _dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  AuthInterceptor(this._authApi, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for login, register, and refresh token endpoints
    if (_shouldSkipAuth(options.path)) {
      print('🔍 AuthInterceptor: Skipping auth for path: ${options.path}');
      return handler.next(options);
    }

    // Add access token to request
    final accessToken = await TokenManager.getAccessToken();
    print(
      '🔍 AuthInterceptor: Request to ${options.path} - Token: ${accessToken != null ? 'Present' : 'Missing'}',
    );
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
      print('🔍 AuthInterceptor: Added Authorization header for ${options.path}');
    } else {
      print('⚠️ AuthInterceptor: No access token found for ${options.path}');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print(
      '❌ AuthInterceptor: Error ${err.response?.statusCode} for ${err.requestOptions.path}',
    );
    print('❌ AuthInterceptor: Error message: ${err.message}');

    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      final requestOptions = err.requestOptions;

      // Skip if this is already a refresh token request
      if (requestOptions.path.contains('/auth/refresh')) {
        print('🔍 AuthInterceptor: Skipping refresh for refresh token request');
        return handler.next(err);
      }

      print('🔄 AuthInterceptor: Attempting to refresh token...');
      // Try to refresh token
      try {
        await _refreshTokenAndRetry(requestOptions, handler);
      } catch (refreshError) {
        print('❌ AuthInterceptor: Refresh token failed: $refreshError');
        // Refresh failed, clear tokens and return original error
        await TokenManager.clearTokens();
        return handler.next(err);
      }
    } else {
      return handler.next(err);
    }
  }

  Future<void> _refreshTokenAndRetry(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isRefreshing) {
      // If already refreshing, queue this request
      print('🔍 AuthInterceptor: Already refreshing, queuing request');
      _pendingRequests.add(requestOptions);
      return;
    }

    _isRefreshing = true;
    print('🔄 AuthInterceptor: Starting token refresh...');

    try {
      // Get refresh token
      final refreshToken = await TokenManager.getRefreshToken();
      print(
        '🔍 AuthInterceptor: Refresh token: ${refreshToken != null ? 'Present' : 'Missing'}',
      );
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      // Call refresh token API
      print('🔄 AuthInterceptor: Calling refresh token API...');
      final refreshResponse = await _authApi.refreshToken(refreshToken);
      print('✅ AuthInterceptor: Refresh token API success');

      // Update tokens in storage
      await TokenManager.updateAccessToken(
        accessToken: refreshResponse.accessToken,
        expiresIn: 3600, // Default 1 hour
      );
      if (refreshResponse.refreshToken != null) {
        await TokenManager.updateRefreshToken(refreshResponse.refreshToken!);
      }
      print('✅ AuthInterceptor: Tokens updated in storage');

      // Retry the original request with new token
      final newRequestOptions = RequestOptions(
        method: requestOptions.method,
        path: requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        headers: {
          ...requestOptions.headers,
          'Authorization': 'Bearer ${refreshResponse.accessToken}',
        },
      );

      print('🔄 AuthInterceptor: Retrying original request...');
      final response = await _dio.fetch(newRequestOptions);
      print('✅ AuthInterceptor: Original request retry success');
      handler.resolve(response);

      // Retry all pending requests
      await _retryPendingRequests(refreshResponse.accessToken);
    } catch (e) {
      print('❌ AuthInterceptor: Refresh token error: $e');
      _isRefreshing = false;
      _pendingRequests.clear();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _retryPendingRequests(String newAccessToken) async {
    final requests = List<RequestOptions>.from(_pendingRequests);
    _pendingRequests.clear();

    for (final requestOptions in requests) {
      try {
        final newRequestOptions = RequestOptions(
          method: requestOptions.method,
          path: requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          headers: {
            ...requestOptions.headers,
            'Authorization': 'Bearer $newAccessToken',
          },
        );

        await _dio.fetch(newRequestOptions);
      } catch (e) {
        // Log error but don't throw to avoid breaking other requests
        print('Failed to retry request: ${e.toString()}');
      }
    }
  }

  bool _shouldSkipAuth(String path) {
    final skipPaths = [
      '/auth/login',
      '/auth/register/student',
      '/auth/register/teacher',
      '/auth/forgot-password',
      '/auth/verify-otp',
      '/auth/reset-password',
      '/auth/refresh',
      // Note: /auth/logout is NOT in skip list, so it will send token
    ];

    return skipPaths.any((skipPath) => path.contains(skipPath));
  }
}
