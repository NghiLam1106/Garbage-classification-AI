import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/model/quiz_model.dart';

class QuizController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QuizModel> _quizzes = [];
  int _currentIndex = 0;
  int _score = 0;
  int _totalCorrect = 0;
  int _totalAttempts = 0;

  /// Lấy danh sách câu hỏi từ `quizzes` toàn cục
  Future<void> fetchQuizzes({String? category, int limit = 10}) async {
    try {
      Query query = _firestore.collection('quizzes').limit(limit);
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }

      final snapshot = await query.get();
      _quizzes = snapshot.docs.map((doc) => QuizModel.fromSnapshot(doc)).toList();
      _shuffleQuizzes();
    } catch (e) {
      debugPrint('Lỗi khi lấy câu hỏi: $e');
      throw Exception('Không thể tải câu hỏi');
    }
  }

  /// Khởi tạo danh sách quiz từ bên ngoài (ví dụ: từ 1 game cụ thể)
  void initializeQuestions(List<QuizModel> quizzes) {
    _quizzes = quizzes;
    _shuffleQuizzes();
    _currentIndex = 0;
    _score = 0;
    _totalCorrect = 0;
    _totalAttempts = 0;
  }

  /// Thêm câu hỏi mới
  Future<void> addQuiz(QuizModel quiz) async {
    try {
      await _firestore.collection('quizzes').add(quiz.toMap());
    } catch (e) {
      debugPrint('Lỗi khi thêm câu hỏi: $e');
      throw Exception('Thêm câu hỏi thất bại');
    }
  }

  /// Thêm câu hỏi vào 1 game cụ thể
  Future<void> addQuizToGame({required String gameId, required QuizModel quiz}) async {
    try {
      await _firestore
          .collection('games')
          .doc(gameId)
          .collection('quizzes')
          .add(quiz.toMap());
    } catch (e) {
      debugPrint('Lỗi khi thêm câu hỏi vào game: $e');
      throw Exception('Không thể thêm câu hỏi vào game');
    }
  }

  /// Lấy câu hỏi hiện tại
  QuizModel? get currentQuiz {
    if (_currentIndex < _quizzes.length) {
      return _quizzes[_currentIndex];
    }
    return null;
  }

  /// Kiểm tra đáp án
  bool checkAnswer(int selectedIndex) {
    _totalAttempts++;
    final isCorrect = currentQuiz?.isCorrect(selectedIndex) ?? false;
    if (isCorrect) {
      _score++;
      _totalCorrect++;
    }
    return isCorrect;
  }

  /// Chuyển sang câu tiếp theo
  bool nextQuestion() {
    if (_currentIndex < _quizzes.length - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }

  /// Reset trạng thái quiz
  void reset() {
    _currentIndex = 0;
    _score = 0;
    _totalCorrect = 0;
    _totalAttempts = 0;
    _shuffleQuizzes();
  }

  void _shuffleQuizzes() {
    _quizzes.shuffle();
    _currentIndex = 0;
  }

  // Thống kê
  int get score => _score;
  int get totalQuestions => _quizzes.length;
  int get currentQuestionNumber => _currentIndex + 1;
  double get accuracyRate => _totalAttempts > 0
      ? (_totalCorrect / _totalAttempts) * 100
      : 0;
}
