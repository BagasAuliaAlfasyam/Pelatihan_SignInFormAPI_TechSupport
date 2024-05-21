import 'dart:convert';

import 'package:alice/alice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:pelatihan_jagoit_1/validator/email_validator.dart';
import 'package:pelatihan_jagoit_1/validator/password_validator.dart';

Logger logger = Logger();
Alice alice = Alice();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: alice.getNavigatorKey(),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInForm(),
    );
  }
}

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
    final url = Uri.parse('https://dummyjson.com/auth/login');
    final body = jsonEncode({
      'username': _emailController.text,
      'password': _passwordController.text,
      'expiresInMins': 30,
    });
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      logger.d(jsonDecode(response.body));
      alice.onHttpResponse(response);
      _showStatusCodeDialog(response.statusCode, response.body);
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  void _showStatusCodeDialog(int statusCode, String responseBody) {
    String title = 'Status Code: $statusCode';
    String content;

    if (statusCode == 200) {
      final data = jsonDecode(responseBody);
      final token = data['token'];
      content = 'Token: $token';
    } else {
      content = 'Gagal login.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
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

class Inspector extends StatelessWidget {
  const Inspector({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Samples',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
      ),
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              child ?? const SizedBox(),
              if (kDebugMode)
                Positioned(
                  bottom: 2,
                  left: 2,
                  child: GestureDetector(
                    child: const Icon(
                      Icons.info_outline,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      size: 24,
                    ),
                    onTap: () async {
                      alice.showInspector();
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
