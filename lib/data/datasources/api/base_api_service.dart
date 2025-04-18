import 'package:dio/dio.dart';

class BaseApiService {
  final Dio dio;

  BaseApiService({Dio? dioClient})
    : dio =
          dioClient ??
          Dio(
            BaseOptions(baseUrl: 'https://hocmoingay-web-backend.onrender.com'),
          );

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
