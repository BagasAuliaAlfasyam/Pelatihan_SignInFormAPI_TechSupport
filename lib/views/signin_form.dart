import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pelatihan_jagoit_1/repositories/auth_repository.dart';
import 'package:pelatihan_jagoit_1/usecases/login_usecase.dart';
import 'package:pelatihan_jagoit_1/validator/email_validator.dart';
import 'package:pelatihan_jagoit_1/validator/password_validator.dart';
import 'package:pelatihan_jagoit_1/viewmodel/login_viewmodel.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _signInformkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  final _loginViewModel = LoginViewModel(
    LoginUseCase(
      AuthRepository(
        http.Client(),
      ),
    ),
  );

  @override
  void initState() {
    _emailController.addListener(_emailValidation);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _emailValidation(){
    final email = _emailController.text;
    if(email.length > 1){
      setState(() {
        _emailError = validateEmail(email);
      });
    }
  }

  Future<void> _loginUser() async {
    try {
      await _loginViewModel.login(_emailController.text, _passwordController.text);
      _showSuccessDialog(_loginViewModel.token);
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  void _showSuccessDialog(String? token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Success'),
        content: Text('Token: $token'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignIn Form'),
      ),
      body: Form(
        key: _signInformkey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                validator: validateEmail,
                decoration: InputDecoration(
                  hintText: 'Input Your Email',
                  labelText: 'Email',
                  errorText: _emailError,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                validator: validatePassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Input Your Password',
                  labelText: 'Password',
                  errorText: _passwordError,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_signInformkey.currentState!.validate()) {
                    _loginUser();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}