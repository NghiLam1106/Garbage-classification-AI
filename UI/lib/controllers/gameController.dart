import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/model/game_model.dart';
import 'package:garbageClassification/model/quiz_model.dart';

class GameController {
  final CollectionReference game =
      FirebaseFirestore.instance.collection('games');

  /// Thêm một game mới
  Future<String> addGame({required String title, required int quantity}) async {
    try {
      final docRef = await game.add({
        'title': title,
        'quantity': quantity,
        'createdAt': Timestamp.now(),
      });
      return docRef.id;
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
      await game.doc(gameId).collection('quizzes').add(quiz.toMap());
    } catch (e) {
      debugPrint("Lỗi khi thêm câu hỏi vào game: $e");
      throw Exception("Không thể thêm câu hỏi vào game");
    }
  }

  /// Lấy danh sách các game
  Stream<QuerySnapshot> streamGetGameList(
      {String? title, bool? isPriceDescending}) {
    Query query = game;

    if (title != null && title.isNotEmpty) {
      query = query
          .where('title', isGreaterThanOrEqualTo: title)
          .where('title', isLessThan: title + 'z');
      return query.snapshots();
    }

    if (isPriceDescending != null) {
      query = query.orderBy('quantity', descending: isPriceDescending);
    } else {
      query = query.orderBy('timestamp', descending: true);
    }

    return query.snapshots();
  }

  /// Lấy danh sách các game
  Stream<List<GameModel>> getGamesStream() {
    return game.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => GameModel.fromSnapshot(doc)).toList());
  }

  /// Lấy danh sách câu hỏi của một game
  Future<List<QuizModel>> fetchQuizzesForGame(String gameId) async {
    try {
      final snapshot = await game.doc(gameId).collection('quizzes').get();

      return snapshot.docs.map((doc) => QuizModel.fromSnapshot(doc)).toList();
    } catch (e) {
      debugPrint("Lỗi khi lấy danh sách câu hỏi: $e");
      throw Exception("Không thể tải câu hỏi");
    }
  }

    Future<GameModel> fetchGame(String gameId) async {
    try {
      final snapshot = await game.doc(gameId).get();

      return GameModel.fromSnapshot(snapshot);
    } catch (e) {
      debugPrint("Lỗi khi lấy dữ liệu về trò chơi: $e");
      throw Exception("Không thể tải trò chơi");
    }
  }

Future<void> removeGameAndQuizzes(String id) async {
  final gameRef = FirebaseFirestore.instance.collection('games').doc(id);
  final quizzesRef = gameRef.collection('quizzes');

  final quizSnapshots = await quizzesRef.get();
  for (final doc in quizSnapshots.docs) {
    await doc.reference.delete();
  }

  await gameRef.delete();
}


  Future<void> updateGame(String gameId, String title, int quantity) async {
  await FirebaseFirestore.instance.collection('games').doc(gameId).update({
    'title': title,
    'quantity': quantity,
  });
}

Future<void> updateQuiz(String gameId, List<QuizModel> quizzes) async {
  final quizCollection = FirebaseFirestore.instance
      .collection('games')
      .doc(gameId)
      .collection('quizzes');

  for (var quiz in quizzes) {
    await quizCollection.doc(quiz.id).update({
      'question': quiz.question,
      'answers': quiz.answers,
      'correctAnswerIndex': quiz.correctAnswerIndex,
      'explanation': quiz.explanation,
    });
  }
}

}
