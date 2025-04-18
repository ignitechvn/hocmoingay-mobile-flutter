import '../../dto/user_dto.dart';
import 'base_api_service.dart';

class AuthApi {

  final BaseApiService api;

  AuthApi(this.api);

  Future<bool> login(String phone, String password) async {
    try {
      final response = await api.post('/auth/login', data: {
        'userName': phone,
        'password': password,
      });
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(UserDto user) async {
    try {
      final response = await api.post('/auth/register', data: user.toJson());
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}