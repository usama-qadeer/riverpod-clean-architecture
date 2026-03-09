import 'package:app_with_riverpod/src/features/auth/data/model/auth_model.dart';

class LoginState {
  final bool isLoading;
  final String? error;
  final UserModel? user;

  const LoginState({this.isLoading = false, this.error, this.user});

  LoginState copyWith({bool? isLoading, String? error, UserModel? user}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}
