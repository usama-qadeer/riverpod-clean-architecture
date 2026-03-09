import 'package:app_with_riverpod/main_exports.dart';
import 'package:app_with_riverpod/src/core/error/app_exception.dart';
import 'package:app_with_riverpod/src/core/routes/routes_export.dart';
import 'package:app_with_riverpod/src/features/auth/presentation/providers/login_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase useCase;
  final Ref ref;

  LoginNotifier(this.useCase, this.ref) : super(const LoginState());

  Future<void> login(
    String email,
    String password, {
    VoidCallback? onLoggedIn,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await useCase.execute(email, password);

      // Save session in AuthState
      await ref
          .read(authProvider.notifier)
          .setSession(
            token: result.token.toString(),
            role: result.userDetails?.role?.toString() ?? "user",
          );

      state = state.copyWith(isLoading: false, user: result.userDetails);

      onLoggedIn?.call();
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: "Something went wrong");
    }
  }
}
