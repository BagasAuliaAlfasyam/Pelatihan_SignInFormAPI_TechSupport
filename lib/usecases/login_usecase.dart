import 'package:pelatihan_jagoit_1/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<String> execute(String email, String password) async {
    return await _authRepository.login(email, password);
  }
}