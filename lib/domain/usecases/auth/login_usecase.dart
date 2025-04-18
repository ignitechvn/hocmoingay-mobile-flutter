
import 'package:hocmoingay/domain/repositories/auth_repository.dart';

class LoginUseCase {

  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<bool> execute(String phone, String password) {
    return repository.login(phone, password);
  }
}

