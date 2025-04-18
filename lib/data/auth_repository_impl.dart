
import 'package:hocmoingay/data/dto/user_dto.dart';
import 'package:hocmoingay/domain/repositories/auth_repository.dart';

import '../domain/entities/user.dart';
import 'datasources/api/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<bool> login(String phoneNumber, String password) {
    return api.login(phoneNumber, password);
  }

  @override
  Future<bool> registerUser(User user, password) async {
    final userDto = UserDto(
      id: "",
      fullName: user.fullName,
      phone: user.phone,
      address: user.address,
      grade: user.grade,
      password: password
    );
    return api.register(userDto);
  }
}
