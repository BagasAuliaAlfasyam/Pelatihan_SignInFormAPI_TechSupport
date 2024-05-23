import 'dart:convert';
import 'package:alice/alice.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

Logger logger = Logger();
Alice alice = Alice();

class AuthRepository {
  final http.Client _client;

  AuthRepository(this._client);

  Future<String> login(String email, String password) async {
    final url = Uri.parse('https://dummyjson.com/auth/login');
    final body = jsonEncode({
      'username': email,
      'password': password,
      'expiresInMins': 30,
    });

    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    logger.d(jsonDecode(response.body));
    alice.onHttpResponse(response);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Gagal login');
    }
  }
}