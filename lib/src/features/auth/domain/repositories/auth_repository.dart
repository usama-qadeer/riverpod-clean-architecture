import 'package:app_with_riverpod/src/features/auth/data/model/login_responce-model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(String email, String password);
}
