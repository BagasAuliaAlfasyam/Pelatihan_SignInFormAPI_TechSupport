import 'package:flutter/foundation.dart';
import 'package:pelatihan_jagoit_1/usecases/login_usecase.dart';

class LoginViewModel with ChangeNotifier {
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  String? _token;
  String? get token => _token;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    try {
      _token = await _loginUseCase.execute(email, password);
      notifyListeners();
    } catch (e) {
      throw Exception('Terjadi kesalahan saat login: $e');
    }
  }
}
