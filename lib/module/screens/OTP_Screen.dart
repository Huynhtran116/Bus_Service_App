

//=================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../widgets/BusIcon.dart';
import '../service/auth_service.dart';
import 'Login_Screen.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String email; // Nhận email từ màn trước

  const VerifyOTPScreen({super.key, required this.email});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> handleResetPassword() async {
    final otp = otpController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (otp.isEmpty || newPassword.isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin.')),
      // );
      _showSnackBar('Vui lòng nhập đầy đủ thông tin.');
      return;
    }

    if (newPassword.length < 6) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Mật khẩu phải có ít nhất 6 ký tự.')),
      // );
      _showSnackBar('Mật khẩu phải có ít nhất 6 ký tự.');
      return;
    }


    setState(() => isLoading = true);
    _startTrip();
    try {
      final success = await AuthService().resetPassword(
        email: widget.email,
        otp: otp,
        newPassword: newPassword,
      );
      Navigator.pop(context);
       if (success) {

      _showSuccessDialog();
      }
    } catch (e) {
      Navigator.pop(context);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Lỗi: $e')),
      // );
      _showSnackBar(e.toString());
    } finally {
      setState(() => isLoading = false);
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
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 2), () async {
          if (!mounted) return;
          // Đóng dialog
          if (Navigator.canPop(dialogContext)) Navigator.pop(dialogContext);

          // Chuyển hướng về Login (thay thế trang hiện tại)
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
        });

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Thay mật khẩu thành công",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF004A75),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2EF977),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Xác thực mã",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: const Color(0xFF01406D),
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Color(0xFF01406D)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chúng tôi đã gửi mã qua email cho bạn. Hãy nhập mã ngay.',
              style: GoogleFonts.inter(color: const Color(0xFF6D6969), fontSize: 15),
            ),
            const SizedBox(height: 25),
            Text(
              'Nhập mã',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Nhập mã',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'Mật khẩu mới',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                hintText: 'Nhập mật khẩu mới ',
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF01406D),
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 35),
            Center(
              child: SizedBox(
                width: 233,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleResetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C4CC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Xác nhận',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _startTrip() {
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
                  'Đang xử lý...',
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
                  child: AnimatedBusIcon(), // Hoặc CircularProgressIndicator()
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

}

