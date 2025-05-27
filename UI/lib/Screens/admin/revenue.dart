import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/admin/widgets/revenue_listview.dart';
import 'package:garbageClassification/Screens/admin/widgets/user_listview.dart';
import 'package:garbageClassification/common/util/dialog_utils.dart';
import 'package:garbageClassification/controllers/totalMoneyController.dart';
import 'package:garbageClassification/controllers/userController.dart';
import 'package:garbageClassification/model/user_model.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  final TotalMoneyController totalMoneyController = TotalMoneyController();
  final TextEditingController searchController = TextEditingController();

  bool isPriceDescending = true;
  String searchQuery = '';
  final List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVipUsers();
  }

  Future<void> getVipUsers() async {
    try {
      final snapshot = await totalMoneyController.getRevenueUserDetails();
      setState(() {
        data.addAll(snapshot);
      });
    } catch (e) {
      debugPrint("Lỗi khi lấy danh sách người dùng VIP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm tên người dùng...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Icon(Icons.filter_alt),
                onPressed: () {
                  setState(() {
                    isPriceDescending = !isPriceDescending;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final user = data[index];

          return ListviewRevenue(
            name: user['name'],
            email: user['email'],
            imageURL: user['avatar'],
            money: user['money'],
            createdAt: user['createdAt'],
          );
        },
      ),
    );
  }
}
