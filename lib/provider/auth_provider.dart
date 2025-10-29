

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
