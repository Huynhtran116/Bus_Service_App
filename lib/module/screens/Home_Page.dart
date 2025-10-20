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
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Chào mừng bạn đến EduBus!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('👤 Họ tên: ${user["profile"]?["hoten"] ?? "Không có"}'),
            Text('📧 Email: ${user["email"] ?? "Không có"}'),
            if (user["role"] != null) Text('🧩 Vai trò: ${user["role"]}'),
          ],
        )
            : const Text('Không có thông tin người dùng.'),
      ),
    );
  }
}
