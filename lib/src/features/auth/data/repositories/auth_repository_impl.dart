import 'package:app_with_riverpod/src/features/auth/data/model/login_responce-model.dart';

import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;
  AuthRepositoryImpl(this.api);

  @override
  Future<LoginResponseModel> login(String email, String password) async {
    final res = await api.loginJson(email, password);

    if (res is! Map<String, dynamic>) {
      throw Exception('Invalid response: not a JSON object');
    }

    final data = res['data'];
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid response: data missing or not an object');
    }

    return LoginResponseModel.fromJson(data);
  }
}
