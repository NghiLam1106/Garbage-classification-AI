import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbageClassification/mode/quiz_mode.dart';

class QuizRepository {
  final CollectionReference _quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');

  // Lấy danh sách quiz
  Stream<List<QuizModel>> getQuizzes() {
    return _quizzesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => QuizModel.fromSnapshot(doc)).toList());
  }

  // Lọc quiz theo danh mục
  Stream<List<QuizModel>> getQuizzesByCategory(String category) {
    return _quizzesCollection
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => QuizModel.fromSnapshot(doc)).toList());
  }

  // Thêm quiz mới
  Future<void> addQuiz(QuizModel quiz) async {
    await _quizzesCollection.add(quiz.toMap());
  }

  // Xóa quiz
  Future<void> deleteQuiz(String id) async {
    await _quizzesCollection.doc(id).delete();
  }
}