import 'package:app_with_riverpod/main_exports.dart';
import 'package:app_with_riverpod/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:app_with_riverpod/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:app_with_riverpod/src/features/auth/presentation/providers/login_notifier.dart';
import 'package:app_with_riverpod/src/features/auth/presentation/providers/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// AuthApi Provider
final authApiProvider = Provider<AuthApi>((ref) {
  final apiService = ref.read(baseApiServiceProvider);
  return AuthApi(apiService);
});

/// 🔥 THIS IS THE ONE YOU NEED
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.read(authApiProvider);
  return AuthRepositoryImpl(api);
});

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final useCase = ref.read(loginUseCaseProvider);
  return LoginNotifier(useCase, ref);
});

// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
//   return AuthNotifier();
// });

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier()..init(),
);
