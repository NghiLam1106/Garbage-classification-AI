import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String? id;
  final String question;
  final List<String> answers;
  int correctAnswerIndex;
  final String explanation;
  final String category;
  final Timestamp? timestamp;
  final int difficulty; // 1-5 mức độ khó

  QuizModel({
    this.id,
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.category,
    this.timestamp,
    this.difficulty = 3, // Mặc định trung bình
  });

  // Convert từ Firestore document
  factory QuizModel.fromSnapshot(DocumentSnapshot doc) {
    if (!doc.exists || doc.data() == null) {
      throw Exception("Tài liệu không tồn tại hoặc không có dữ liệu.");
    }
    
    final data = doc.data() as Map<String, dynamic>;
    
    // Validate dữ liệu bắt buộc
    if (data['answers'] == null || (data['answers'] as List).length < 2) {
      throw Exception("Câu hỏi phải có ít nhất 2 đáp án");
    }
    
    if (data['correctAnswerIndex'] == null || 
        data['correctAnswerIndex'] >= (data['answers'] as List).length) {
      throw Exception("Chỉ số đáp án đúng không hợp lệ");
    }

    return QuizModel(
      id: doc.id,
      question: data['question'] ?? '[Không có câu hỏi]',
      answers: List<String>.from(data['answers'] ?? []),
      correctAnswerIndex: data['correctAnswerIndex'] ?? 0,
      explanation: data['explanation'] ?? '',
      category: data['category'] ?? 'Chung',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      difficulty: (data['difficulty'] ?? 3).toInt(),
    );
  }

  // Convert sang Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answers': answers,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'category': category,
      'timestamp': timestamp ?? Timestamp.now(),
      'difficulty': difficulty,
    };
  }

  // Kiểm tra đáp án
  bool isCorrect(int selectedIndex) {
    return selectedIndex == correctAnswerIndex;
  }

  // Lấy đáp án đúng
  String get correctAnswer {
    return answers[correctAnswerIndex];
  }
}