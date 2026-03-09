import 'package:app_with_riverpod/src/features/auth/data/model/login_responce-model.dart';

import '../../../../core/error/app_exception.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponseModel> execute(String email, String password) {
    if (!email.contains('@')) throw const ValidationException('Invalid email');
    if (password.length < 6) {
      throw const ValidationException('Password too short');
    }
    return repository.login(email, password);
  }
}
