// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class AuthProvider with ChangeNotifier {
// //   String? _token;
// //   Map<String, dynamic>? _user;
// //
// //   bool _isLoading = false;
// //
// //   String? get token => _token;
// //   Map<String, dynamic>? get user => _user;
// //   bool get isAuthenticated => _token != null;
// //
// //   bool get isLoading => _isLoading;
// //
// //   Future<bool> login(String email, String password) async {
// //     try {
// //       final url = Uri.parse('https://qlbus.onrender.com/api/auth/login');
// //       final response = await http.post(
// //         url,
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({"email": email, "password": password}),
// //       );
// //
// //       final data = jsonDecode(response.body);
// //
// //       if (response.statusCode == 200 && data["accessToken"] != null) {
// //         _token = data["accessToken"];
// //         _user = data["user"];
// //         final prefs = await SharedPreferences.getInstance();
// //         await prefs.setString('auth_token', _token!);
// //         await prefs.setString('user_info', jsonEncode(_user));
// //         notifyListeners();
// //         return true; // Đăng nhập thành công
// //       } else {
// //         debugPrint("Lỗi đăng nhập: ${data["message"] ?? "Không xác định"}");
// //         return false; // Đăng nhập thất bại
// //       }
// //     } catch (e) {
// //       debugPrint("Lỗi kết nối: $e");
// //       return false; // Có lỗi xảy ra
// //     }
// //   }
// //   Future<void> logout() async {
// //     _token = null;
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.remove('token');
// //     notifyListeners();
// //   }
// //
// //   Future<void> loadToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     _token = prefs.getString('token');
// //     notifyListeners();
// //   }
// //   Future<bool> tryAutoLogin() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     if (!prefs.containsKey('access_token')) return false;
// //
// //     _token = prefs.getString('access_token');
// //     final userJson = prefs.getString('user_info');
// //     if (userJson != null) {
// //       _user = jsonDecode(userJson);
// //     }
// //
// //     notifyListeners();
// //     return true;
// //   }
// // }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthProvider with ChangeNotifier {
//   String? _token;
//   Map<String, dynamic>? _user;
//   bool _isLoading = false;
//
//   String? get token => _token;
//   Map<String, dynamic>? get user => _user;
//   bool get isAuthenticated => _token != null;
//   bool get isLoading => _isLoading;
//
//   Future<bool> login(String email, String password) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       final url = Uri.parse('https://qlbus.onrender.com/api/auth/login');
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": email, "password": password}),
//       );
//
//       _isLoading = false;
//       notifyListeners();
//
//       final data = jsonDecode(response.body);
//
//       if (response.statusCode == 200 && data["accessToken"] != null) {
//         _token = data["accessToken"];
//         _user = data["user"];
//
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', _token!);
//         await prefs.setString('user_info', jsonEncode(_user));
//
//         notifyListeners();
//         return true;
//       } else {
//         debugPrint("Lỗi đăng nhập: ${data["message"] ?? "Không xác định"}");
//         return false;
//       }
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       debugPrint("Lỗi kết nối: $e");
//       return false;
//     }
//   }
//
//   Future<void> logout() async {
//     _token = null;
//     _user = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//     await prefs.remove('user_info');
//     notifyListeners();
//   }
//
//   Future<bool> tryAutoLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!prefs.containsKey('auth_token')) return false;
//
//     _token = prefs.getString('auth_token');
//     final userJson = prefs.getString('user_info');
//     if (userJson != null) {
//       _user = jsonDecode(userJson);
//     }
//
//     notifyListeners();
//     return true;
//   }
//   Future<void> loadUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userData = prefs.getString('user_info');
//
//     if (userData != null) {
//       _user = jsonDecode(userData);
//       debugPrint("Thông tin user: $_user");
//     } else {
//       debugPrint("Không tìm thấy thông tin user trong SharedPreferences");
//     }
//
//     notifyListeners();
//   }
//
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../module/service/auth_service.dart';
import '../module/shares/models/User_Model.dart';


class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _token;
  String? _refreshToken;
  UserModel? _user;
  bool _isLoading = false;

  String? get token => _token;
  UserModel? get user => _user;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _authService.login(email, password);
      _token = result['token'];
      _refreshToken = result['refreshToken'];
      _user = result['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('refresh_token', _refreshToken!);
      await prefs.setString('user_info', jsonEncode(_user!.toJson()));

      return true;
    } catch (e) {
      debugPrint("Lỗi đăng nhập: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('auth_token')) return false;

    _token = prefs.getString('auth_token');
    _refreshToken = prefs.getString('refresh_token');
    final userJson = prefs.getString('user_info');

    if (userJson != null) {
      _user = UserModel.fromJson(jsonDecode(userJson));
    }

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _refreshToken = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_info');

    notifyListeners();
  }
}
