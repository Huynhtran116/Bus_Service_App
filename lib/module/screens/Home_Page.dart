import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busservice/provider/auth_provider.dart';
import 'Login_Screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user; // Lấy thông tin user đã lưu

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chính'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              // Chuyển về trang đăng nhập
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: user != null
            ? SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar người dùng
              CircleAvatar(
                radius: 50,
                backgroundImage: user.profile.avatar.isNotEmpty
                    ? NetworkImage(user.profile.avatar)
                    : const AssetImage('assets/images/default_avatar.png')
                as ImageProvider,
              ),
              const SizedBox(height: 16),
              const Text(
                'Chào mừng bạn đến EduBus!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Hiển thị thông tin tài khoản
              infoRow("Họ tên", user.profile.hoten),
              infoRow("Email", user.email),
              infoRow("Vai trò", user.role),
              infoRow("SĐT", user.profile.sdt),
              infoRow("Địa chỉ", user.profile.diachi),
              infoRow("CCCD", user.profile.cccd),
            ],
          ),
        )
            : const Text(
          'Không có thông tin người dùng.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }


  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              value.isNotEmpty ? value : "Không có",
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
