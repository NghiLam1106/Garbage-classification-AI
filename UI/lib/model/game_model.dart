import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  final String? id;
  final String title;
  final int quantity;
  final Timestamp createdAt;

  GameModel({
    this.id,
    required this.title,
    required this.quantity,
    required this.createdAt,
  });

  // Tạo GameModel từ Firestore DocumentSnapshot
  factory GameModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GameModel(
      id: doc.id,
      title: data['title'] ?? '',
      quantity: data['quantity'] ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Chuyển thành Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'quantity': quantity,
      'createdAt': createdAt,
    };
  }
}
