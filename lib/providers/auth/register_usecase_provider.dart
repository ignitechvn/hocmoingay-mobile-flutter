import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/auth/register_user_usecase.dart';
import 'auth_repository_provider.dart';

final registerUserUseCaseProvider = Provider<RegisterUserUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return RegisterUserUseCase(repo);
});
