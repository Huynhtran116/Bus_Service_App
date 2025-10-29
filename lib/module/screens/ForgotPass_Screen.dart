
import 'package:busservice/module/screens/Login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/auth_service.dart';
import 'OTP_Screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  void _startTrip(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Đang gửi mã xác thực...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF004A76),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    color: Color(0xFF01406D),
                    strokeWidth: 5,
                  ),
                ),
                SizedBox(height: 12),
                Text('Vui lòng chờ trong giây lát...'),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    void _showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.inter(color: Color(0xFFFFFFFF), fontSize: 15,fontWeight: FontWeight.w600)),
          backgroundColor: const Color(0xFF01406D),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text(
          "Phương thức xác thực",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: const Color(0xFF01406D),
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Color(0xFF01406D)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Nhập địa chỉ email của bạn để được nhận mã xác thực',
              style: GoogleFonts.inter(color: const Color(0xFF6D6969), fontSize: 15),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Địa chỉ email',
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'vana123@gmail.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 233,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text.trim();

                    if (email.isEmpty) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Vui lòng nhập địa chỉ email.')),
                      // );
                      _showSnackBar('Vui lòng nhập địa chỉ email.');
                      return;
                    }

                    final authService = AuthService();


                    _startTrip(context);

                    final result = await authService.forgotPassword(email);

                    Navigator.pop(context);


                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text(result['message'] ?? 'Có lỗi xảy ra')),
                    // );
                    _showSnackBar(result['message'] ?? 'Có lỗi xảy ra');

                    if (result['success'] == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VerifyOTPScreen(email: email)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C4CC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Tiếp tục',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
