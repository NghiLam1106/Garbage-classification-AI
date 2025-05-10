import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/LoginScreen/loginScreen.dart';
import 'package:garbageClassification/router/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  final bool isLoggedIn = false;
  final bool isVip = false;

  Widget _buildUserProfile() {
    const String avatarUrl = 'https://i.pravatar.cc/150?img=10';
    const String userName = 'Lê Minh Hoàng';
    const String userEmail = 'hoang@example.com';

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
            debugPrint("Đăng xuất");
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
        title: const Text('Trang cá nhân'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/bg5.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Center(
            child:
                isLoggedIn
                    ? _buildUserProfile()
                    : ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRouter.login,
                        );
                      },
                      icon: const Icon(Icons.login),
                      label: const Text("Đăng nhập"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
