import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../shares/models/User_Model.dart';

class AuthService {
  final String baseUrl = "https://qlbus.onrender.com/api";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
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

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password');

    try {
      final response = await http
          .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      )
          .timeout(const Duration(seconds: 10));

      debugPrint(" Forgot password response: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200) {
        return {"success": true, "message": "OTP đã được gửi qua email"};
      } else if (response.statusCode == 404) {
        return {"success": false, "message": "Email không tồn tại"};
      } else {
        return {
          "success": false,
          "message": "Lỗi không xác định (${response.statusCode})"
        };
      }
    } on TimeoutException {
      return {"success": false, "message": "Kết nối quá chậm, vui lòng thử lại"};
    } catch (e) {
      debugPrint("Lỗi forgot password: $e");
      return {"success": false, "message": "Lỗi hệ thống: $e"};
    }
  }
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/reset-password');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "otp": otp,
        "newPassword": newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'OTP không hợp lệ hoặc thiếu dữ liệu');
    }
  }
}

