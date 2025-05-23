import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/GameScreen/GameScreen.dart';
import 'package:garbageClassification/Screens/GameScreen/QuizGameScreen.dart';
import 'package:garbageClassification/Screens/admin/dashboard.dart';
import 'package:garbageClassification/Screens/admin/revenue.dart';
import 'package:garbageClassification/Screens/admin/update_game.dart';
import 'package:garbageClassification/Screens/admin/user_normal.dart';
import 'package:garbageClassification/Screens/admin/user_vip.dart';
import '../Screens/LoginScreen/loginScreen.dart';
import '../Screens/HomeScreen/homeScreens.dart';
import '../Screens/registerScreen/registerScreen.dart';
import '../Screens/ChatBotScreen/chatScreen.dart';

abstract final class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String quiz = '/quiz';
  static const String game = '/game';
  static const String chat = '/chat';
  static const String admin = '/admin';
  static const String updateGame = '/updateGame';
  static const String userNormal = '/userNormal';
  static const String userVip = '/userVip';
  static const String revenue = '/revenue';
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case quiz:
        final gameId = settings.arguments as String; // Lấy gameId từ arguments
        return MaterialPageRoute(
          builder: (_) => QuizScreen(gameId: gameId), // Truyền gameId vào QuizScreen
        );
      case game:
        return MaterialPageRoute(builder: (_) => GameScreen());
      case userNormal:
        return MaterialPageRoute(builder: (_) => UserNormalScreen());
      case userVip:
        return MaterialPageRoute(builder: (_) => UserVipScreen());
      case revenue:
        return MaterialPageRoute(builder: (_) => RevenueScreen());
      case chat:
        return MaterialPageRoute(builder: (_) => ChatScreen());
      case admin:
        return MaterialPageRoute(builder: (_) => AdminGameScreen());
      case updateGame:
        final gameId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => UpdateGameScreen(id: gameId));
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
