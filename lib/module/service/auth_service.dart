import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shares/models/User_Model.dart';

class AuthService {
  final String baseUrl = "https://qlbus.onrender.com/api/auth";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['accessToken'] != null) {
      return {
        'token': data['accessToken'],
        'refreshToken': data['refreshToken'],
        'user': UserModel.fromJson(data['user']),
      };
    } else {
      throw Exception(data['message'] ?? 'Đăng nhập thất bại');
    }
  }
}
