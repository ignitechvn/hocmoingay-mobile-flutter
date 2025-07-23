import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/token_manager.dart';
import '../../data/datasources/api/auth_api.dart';
import '../../data/dto/auth_dto.dart';
import '../../domain/entities/user.dart';
import '../../providers/api/api_providers.dart';

// Auth State
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;
  final Role? userRole;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.userRole,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
    Role? userRole,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
      userRole: userRole ?? this.userRole,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}

// Auth State Notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthApi _authApi;

  AuthStateNotifier(this._authApi) : super(const AuthState());

  // Check if user is already logged in (from local storage)
  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final isLoggedIn = await TokenManager.isLoggedIn();

      if (isLoggedIn) {
        final userData = await TokenManager.getUserData();
        if (userData != null) {
          final user = User(
            id: userData['id'] as String,
            fullName: userData['fullName'] as String,
            phone: userData['phone'] as String,
            address: userData['address'] as String,
            email: userData['email'] as String?,
            role: Role.values.firstWhere(
              (r) => r.value == userData['role'],
              orElse: () => Role.student,
            ),
            grade:
                userData['grade'] != null
                    ? GradeLevel.values.firstWhere(
                      (g) => g.value == userData['grade'],
                      orElse: () => GradeLevel.grade9,
                    )
                    : null,
            gender: Gender.values.firstWhere(
              (g) => g.value == userData['gender'],
              orElse: () => Gender.male,
            ),
          );

          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            userRole: user.role,
            error: null,
          );
        } else {
          state = state.copyWith(status: AuthStatus.unauthenticated);
        }
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Failed to check authentication status: ${e.toString()}',
      );
    }
  }

  // Login
  Future<void> login(String phone, String password, Role role) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Create login DTO
      final loginDto = LoginDto(
        userName: phone,
        password: password,
        role: role.value,
      );

      // Call real API
      final response = await _authApi.login(loginDto);

      // Convert DTO to User entity
      final user = User(
        id: response.user.id,
        fullName: response.user.fullName,
        phone: response.user.phone,
        address: response.user.address,
        email: response.user.email,
        role: response.user.roleEnum,
        grade: response.user.gradeEnum,
        gender: response.user.genderEnum,
      );

      // Save tokens and user data
      await TokenManager.saveTokens(
        accessToken: response.accessToken,
        refreshToken:
            response.refreshToken ?? response.accessToken, // Use refresh token if available, fallback to access token
        expiresIn: 3600, // 1 hour
        userData: {
          'id': user.id,
          'fullName': user.fullName,
          'phone': user.phone,
          'address': user.address,
          'email': user.email,
          'role': user.role.value,
          'grade': user.grade?.value,
          'gender': user.gender.value,
        },
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        userRole: user.role,
        error: null,
      );
      
      // Debug log
      print('✅ Login successful - User: ${user.fullName}, Role: ${user.role}');
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  // Logout
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Call logout API
      await _authApi.logout();

      // Clear all tokens and user data
      await TokenManager.clearTokens();

      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Logout failed: ${e.toString()}',
      );
    }
  }

  // Refresh token
  Future<void> refreshToken() async {
    try {
      final refreshToken = await TokenManager.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      // Call refresh token API
      final response = await _authApi.refreshToken(refreshToken);

      // Update tokens
      await TokenManager.updateAccessToken(
        accessToken: response.accessToken,
        expiresIn: response.expiresIn,
      );
      await TokenManager.updateRefreshToken(response.refreshToken);
    } catch (e) {
      // If refresh fails, clear tokens and logout
      await TokenManager.clearTokens();
      state = const AuthState(status: AuthStatus.unauthenticated);
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }
}

// Provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  final authApi = ref.watch(authApiProvider);
  return AuthStateNotifier(authApi);
});
