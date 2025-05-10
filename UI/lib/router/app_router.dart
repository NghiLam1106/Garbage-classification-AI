import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/GameScreen/GameScreen.dart';
import 'package:garbageClassification/Screens/PlantIssuesScreen/PlantIssuesScreen.dart';
import '../Screens/LoginScreen/loginScreen.dart';
import '../Screens/HomeScreen/homeScreens.dart';
import '../Screens/registerScreen/registerScreen.dart';
import '../Screens/ChatBotScreen/chatScreen.dart';

abstract final class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String msg = '/msg';
  static const String plIs = '/PlIs';
  static const String myT = '/myT';
  static const String chat = '/chat';
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case plIs:
        return MaterialPageRoute(builder: (_) => PlantIssuesScreen());
      case myT:
        return MaterialPageRoute(builder: (_) => GameScreen());
      case chat:
        return MaterialPageRoute(builder: (_) => ChatScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
