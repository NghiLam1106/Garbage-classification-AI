import 'package:cloud_firestore/cloud_firestore.dart';

class TotalMoneyController {
  final CollectionReference totalMoney =
      FirebaseFirestore.instance.collection('totalmoney');

  Future<int> getTotalMoney() async {
    try {
      final snapshot = await totalMoney.get();
      int total = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('money')) {
          final num moneyValue = data['money'];
          total += moneyValue.toInt();
        }
      }

      return total;
    } catch (e) {
      throw Exception("Không thể lấy tổng tiền: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getRevenueUserDetails() async {
    try {
      final moneySnapshot = await totalMoney.get();
      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<Map<String, dynamic>> result = [];

      for (var moneyDoc in moneySnapshot.docs) {
        final moneyData = moneyDoc.data() as Map<String, dynamic>;
        final uid = moneyData['uid'];

        final matchedDocs = userSnapshot.docs.where((doc) => doc.id == uid);
        if (matchedDocs.isEmpty) continue; // bỏ qua nếu không tìm thấy user

        final userData = matchedDocs.first.data() as Map<String, dynamic>;

        result.add({
          'name': userData['name'] ?? '',
          'email': userData['email'] ?? '',
          'avatar': userData['avatar'] ?? '',
          'money': (moneyData['money'] as num).toInt(),
          'createdAt': (moneyData['createdAt'] as Timestamp).toDate(),
        });
      }

      return result;
    } catch (e) {
      throw Exception("Không thể lấy dữ liệu người dùng có thanh toán: $e");
    }
  }
}
