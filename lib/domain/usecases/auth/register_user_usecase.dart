import 'package:hocmoingay/domain/entities/user.dart';
import '../../repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;
  RegisterUserUseCase(this.repository);

  Future<bool> execute({
    required String fullName,
    required String phone,
    required String password,
    required String address,
    required String grade,
  }) {
    return repository.registerUser(User(id: "id", fullName: fullName, phone: phone, address: address, grade: grade), password);
  }
}
