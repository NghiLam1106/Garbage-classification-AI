import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  final String? id;
  final String title;
  final int totalQuestions;
  final Timestamp createdAt;

  GameModel({
    this.id,
    required this.title,
    required this.totalQuestions,
    required this.createdAt,
  });

  // Tạo GameModel từ Firestore DocumentSnapshot
  factory GameModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GameModel(
      id: doc.id,
      title: data['title'] ?? '',
      totalQuestions: data['totalQuestions'] ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Chuyển thành Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'totalQuestions': totalQuestions,
      'createdAt': createdAt,
    };
  }
}
