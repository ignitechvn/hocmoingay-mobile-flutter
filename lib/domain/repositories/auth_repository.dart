import '../entities/user.dart';

abstract class AuthRepository {
  Future<bool> login(String phoneNumber, String password);
  Future<bool> registerUser(User user, String password);
}
