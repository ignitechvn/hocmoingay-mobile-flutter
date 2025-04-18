import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routers/app_router.dart';
import '../../../../domain/usecases/auth/login_usecase.dart';
import '../../../../providers/auth/login_usecase_provider.dart';
import '../../../base/base_state.dart';
import '../../../base/base_view_model.dart';

final loginViewModelProvider =
StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final useCase = ref.read(loginUseCaseProvider);
  return LoginViewModel(useCase);
});

class LoginState extends BaseState {
  const LoginState({super.isLoading = false, super.event});
}

class LoginViewModel extends BaseViewModel<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase) : super(const LoginState());

  Future<void> login(String phone, String password) async {
    setLoading(true);

    final success = await _loginUseCase.execute(phone, password);

    setLoading(false);

    if (success) {
      emitEvent(const NavigateTo(AppRoutes.home));
    } else {
      emitEvent(const ShowMessage('Đăng nhập thất bại'));
    }
  }
}
