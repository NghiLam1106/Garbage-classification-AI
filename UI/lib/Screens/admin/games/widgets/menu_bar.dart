import 'package:flutter/material.dart';
import 'package:garbageClassification/auth/auth.dart';

class MenuBarCustom extends StatelessWidget {
  const MenuBarCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu),
      onSelected: (value) {
        switch (value) {
          case 'logout':
            final authController = AuthController();
            authController.signOut(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Đăng xuất'),
        ),
      ],
    );
  }
}