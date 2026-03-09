import 'package:app_with_riverpod/main_exports.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> init() async {
    state = state.copyWith(status: AuthStatus.checking);

    final token = AppLocalStorage.getUserToken();
    final roleStr = AppLocalStorage.getUserRole();

    if (token != null && token.isNotEmpty) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        role: roleStr == 'admin' ? UserRole.admin : UserRole.user,
      );
    } else {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        role: UserRole.user,
      );
    }
  }

  Future<void> setSession({required String token, required String role}) async {
    await AppLocalStorage.saveUserToken(token);
    await AppLocalStorage.saveUserRole(role);

    state = state.copyWith(
      status: AuthStatus.authenticated,
      role: role == 'admin' ? UserRole.admin : UserRole.user,
    );
  }

  void setRedirectIfNull(String location) {
    if (state.redirectLocation == null) {
      state = state.copyWith(redirectLocation: location);
    }
  }

  String consumeRedirectOrDefault(String fallback) {
    final loc = state.redirectLocation;
    state = state.copyWith(redirectLocation: null);
    return loc ?? fallback;
  }

  Future<void> logout() async {
    await AppLocalStorage.clearUserToken();
    await AppLocalStorage.clearUserRole();

    state = const AuthState(
      status: AuthStatus.unauthenticated,
      role: UserRole.user,
    );
  }
}
