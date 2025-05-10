import 'dart:core';

abstract class Endpoints {
  static String apiUrl = 'http://localhost:8000/api';

  static String login = '$apiUrl/auth/login/';
  static String userInfo = '$apiUrl/auth/me/';
  static String register = '$apiUrl/auth/register/';
  static String chat = '$apiUrl/chat/';
}
