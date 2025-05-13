import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/auth/auth.dart';
import 'package:garbageClassification/router/app_router.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final bool isVip = false;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>?> getUserData() async {
    if (user == null) return null;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return doc.data();
  }

  Widget _buildUserProfile(
      Map<String, dynamic> userData, BuildContext context) {
    final String avatarUrl = userData['avatar'] ??
        'https://res.cloudinary.com/dpjpqdp71/image/upload/v1744649065/IMG_20250319_160106_f9ds8j.jpg';
    final String userName = userData['name'] ?? 'Không rõ tên';
    final String userEmail = userData['email'] ?? 'Không rõ email';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(avatarUrl),
              ),
            ),
            if (isVip)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 20),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          userEmail,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isVip ? Colors.amber : Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isVip ? 'Tài khoản VIP' : 'Tài khoản Thường',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            final authController = AuthController();
            authController.signOut(context);
          },
          icon: const Icon(Icons.logout),
          label: const Text("Đăng xuất"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:
            const Text('Trang cá nhân', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg12.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Center(
            child: user == null
                ? ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRouter.login);
                    },
                    icon: const Icon(Icons.login),
                    label: const Text("Đăng nhập"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  )
                : FutureBuilder<Map<String, dynamic>?>(
                    future: getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text("Lỗi khi tải thông tin");
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text(
                            "Không tìm thấy thông tin người dùng");
                      }
                      return _buildUserProfile(snapshot.data!, context);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
