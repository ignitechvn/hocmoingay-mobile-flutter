import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository_impl.dart';
import '../../data/datasources/api/auth_api.dart';
import '../../data/datasources/api/base_api_service.dart';
import '../../domain/repositories/auth_repository.dart';

final baseApiServiceProvider = Provider<BaseApiService>((ref) => BaseApiService());

final authApiProvider = Provider<AuthApi>((ref) {
  final api = ref.read(baseApiServiceProvider);
  return AuthApi(api);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.read(authApiProvider);
  return AuthRepositoryImpl(api);
});
