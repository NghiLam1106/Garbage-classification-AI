import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/GameScreen/GameScreen.dart';
import 'package:garbageClassification/Screens/GameScreen/QuizGameScreen.dart';
import 'package:garbageClassification/Screens/admin/games/dashboard.dart';
import 'package:garbageClassification/Screens/admin/games/update_game.dart';
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
