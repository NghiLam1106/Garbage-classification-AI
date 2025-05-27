import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/admin/widgets/user_listview.dart';
import 'package:garbageClassification/common/util/dialog_utils.dart';
import 'package:garbageClassification/controllers/userController.dart';
import 'package:garbageClassification/model/user_model.dart';

class UserVipScreen extends StatefulWidget {
  const UserVipScreen({super.key});

  @override
  State<UserVipScreen> createState() => _UserVipScreenState();
}

class _UserVipScreenState extends State<UserVipScreen> {
  final UserController userController = UserController();
  final TextEditingController searchController = TextEditingController();

  bool isPriceDescending = true;
  String searchQuery = '';
  final List<UserModel> vipUsers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVipUsers();
  }

  Future<void> getVipUsers() async {
    try {
      final snapshot = await userController.getVipUsers();
      setState(() {
        vipUsers.addAll(snapshot);
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
          itemCount: vipUsers.length,
          itemBuilder: (context, index) {
            UserModel user = vipUsers[index];

            return ListviewUser(
                name: user.name,
                imageURL: user.avatar,
                id: user.uid,
                onDelete: () => showDeleteConfirmationDialog(
                      context: context,
                      onConfirm: () {
                        userController.deleteUser(user.uid);
                      },
                    ));
          },
        ));
  }
}
