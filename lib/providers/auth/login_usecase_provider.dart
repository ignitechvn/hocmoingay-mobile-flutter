import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import 'auth_repository_provider.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginUseCase(repo);
});
