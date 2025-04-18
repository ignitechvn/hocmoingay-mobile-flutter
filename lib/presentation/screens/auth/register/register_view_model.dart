import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routers/app_router.dart';
import '../../../../domain/usecases/auth/register_user_usecase.dart';
import '../../../../providers/auth/register_usecase_provider.dart';
import '../../../base/base_state.dart';
import '../../../base/base_view_model.dart';

final registerViewModelProvider =
StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
  final useCase = ref.read(registerUserUseCaseProvider);
  return RegisterViewModel(useCase);
});

class RegisterState extends BaseState {
  const RegisterState({super.isLoading = false, super.event});
}

class RegisterViewModel extends BaseViewModel<RegisterState> {
  final RegisterUserUseCase _registerUseCase;

  RegisterViewModel(this._registerUseCase) : super(const RegisterState());

  Future<void> register({
    required String fullName,
    required String phone,
    required String password,
    required String address,
    required String grade,
  }) async {
    setLoading(true);

    final success = await _registerUseCase.execute(
      fullName: fullName,
      phone: phone,
      password: password,
      address: address,
      grade: grade
    );

    setLoading(false);

    if (success) {
      emitEvent(const NavigateTo(AppRoutes.login));
    } else {
      emitEvent(const ShowMessage('Đăng ký thất bại'));
    }
  }
}
