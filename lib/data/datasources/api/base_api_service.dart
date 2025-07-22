import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../../core/interceptors/auth_interceptor.dart';
import 'auth_api.dart';

class BaseApiService {
  final Dio dio;

  BaseApiService({Dio? dioClient, AuthApi? authApi})
    : dio =
          dioClient ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.baseUrl + AppConfig.apiVersion,
              connectTimeout: AppConfig.connectionTimeout,
              receiveTimeout: AppConfig.receiveTimeout,
              sendTimeout: AppConfig.receiveTimeout,
            ),
          ) {
    // Add auth interceptor if authApi is provided
    if (authApi != null) {
      dio.interceptors.add(AuthInterceptor(authApi, dio));
    }
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return await dio.post(path, data: data);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await dio.get(path, queryParameters: queryParams);
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? data}) async {
    return await dio.delete(path, data: data);
  }
}
