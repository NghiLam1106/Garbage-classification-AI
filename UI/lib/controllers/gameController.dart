import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/mode/game_mode.dart';
import 'package:garbageClassification/mode/quiz_mode.dart';

class GameController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Thêm một game mới
  Future<String> addGame({required String title, required int totalQuestions}) async {
    try {
      final docRef = await _firestore.collection('games').add({
        'title': title,
        'totalQuestions': totalQuestions,
        'createdAt': Timestamp.now(),
      });
      return docRef.id; // trả về gameId
    } catch (e) {
      debugPrint("Lỗi khi thêm game: $e");
      throw Exception("Không thể thêm game");
    }
  }

  /// Thêm một câu hỏi vào game cụ thể
  Future<void> addQuestionToGame({
    required String gameId,
    required QuizModel quiz,
  }) async {
    try {
      await _firestore
          .collection('games')
          .doc(gameId)
          .collection('quizzes')
          .add(quiz.toMap());
    } catch (e) {
      debugPrint("Lỗi khi thêm câu hỏi vào game: $e");
      throw Exception("Không thể thêm câu hỏi vào game");
    }
  }

  /// Lấy danh sách các game
  Stream<List<GameModel>> getGamesStream() {
    return _firestore
        .collection('games')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GameModel.fromSnapshot(doc)).toList());
  }

  /// Lấy danh sách câu hỏi của một game
  Future<List<QuizModel>> fetchQuizzesForGame(String gameId) async {
    try {
      final snapshot = await _firestore
          .collection('games')
          .doc(gameId)
          .collection('quizzes')
          .get();

      return snapshot.docs.map((doc) => QuizModel.fromSnapshot(doc)).toList();
    } catch (e) {
      debugPrint("Lỗi khi lấy danh sách câu hỏi: $e");
      throw Exception("Không thể tải câu hỏi");
    }
  }
}
