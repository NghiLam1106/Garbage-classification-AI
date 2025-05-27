import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbageClassification/model/user_model.dart';

class UserController {
  final CollectionReference user =
      FirebaseFirestore.instance.collection('users');

  // Lấy tất cả người dùng đã thanh toán (VIP)
  Future<List<UserModel>> getVipUsers() async {
    try {
      final snapshot = await user.where('payment', isEqualTo: '1').get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception("Không thể lấy danh sách người dùng VIP: $e");
    }
  }

  // Lấy tất cả người dùng thường (chưa thanh toán)
  Future<List<UserModel>> getNormalUsers() async {
    try {
      final snapshot = await user.where('payment', isEqualTo: '0').get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception("Không thể lấy danh sách người dùng thường: $e");
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await user.doc(id).delete();
    } catch (e) {
      throw Exception("Không thể xóa người dùng: $e");
    }
  }
}
