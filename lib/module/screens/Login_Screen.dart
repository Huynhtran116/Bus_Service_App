
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Vui lòng nhập đầy đủ email và mật khẩu!");
      return;
    }

    setState(() => _isLoading = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(email, password);

    setState(() => _isLoading = false);

    if (success) {
      _showDialog("Đăng nhập thành công!", true);
    } else {
      _showDialog("Đăng nhập thất bại. Vui lòng kiểm tra lại!", false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter(color: Color(0xFFFFFFFF), fontSize: 15,fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF01406D),
      ),
    );
  }

  void _showDialog(String message, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isSuccess ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF),
        title: Center(
          child: Text(
            isSuccess ? "Thông báo" : "Lỗi",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isSuccess ? Colors.green[900] : Colors.red[900],
            ),
          ),
        ),
        content: SizedBox(
          height: 80,
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF333333),
              ),
            ),
          ),
        ),

        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (isSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF01406D), // màu nền
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), //  bo góc
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              "OK",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white, //  màu chữ
              ),
            ),
          ),
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/logo.png', height: 60),
              const SizedBox(height: 20),
              Text('Đăng nhập',
                  style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF01406D))),
              const SizedBox(height: 30),

              // Email field
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Địa chỉ email',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: _inputDecoration("Nhập email"),
              ),
              const SizedBox(height: 20),

              // Password field
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Mật khẩu',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: _inputDecoration("Nhập mật khẩu").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Quên mật khẩu ?',
                      style: TextStyle(color: Color(0xFFA1A2A4))),
                ),
              ),
              const SizedBox(height: 10),

              // Login button
              SizedBox(
                width: 233,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B4B4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(44),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Đăng nhập',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 40),

              // Parent button
              SizedBox(
                width: 231,
                height: 34,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01406D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Dành cho phụ huynh',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: const Color(0xFFA1A2A4),
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(width: 0.5, color: Color(0xFFA1A2A4)),
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
    );
  }
}

