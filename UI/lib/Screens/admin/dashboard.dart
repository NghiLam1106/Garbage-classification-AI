import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/admin/widgets/game_listview.dart';
import 'package:garbageClassification/Screens/admin/widgets/grid_dashboard.dart';
import 'package:garbageClassification/Screens/admin/widgets/menu_bar.dart';
import 'package:garbageClassification/common/util/game_dialogs.dart';
import 'package:garbageClassification/controllers/gameController.dart';
import 'package:garbageClassification/controllers/totalMoneyController.dart';
import 'package:garbageClassification/controllers/userController.dart';
import 'package:garbageClassification/model/user_model.dart';

class AdminGameScreen extends StatefulWidget {
  const AdminGameScreen({super.key});

  @override
  State<AdminGameScreen> createState() => _AdminGameScreenState();
}

class _AdminGameScreenState extends State<AdminGameScreen> {
  final GameController gameController = GameController();
  final TotalMoneyController totalMoneyController = TotalMoneyController();
  final UserController userController = UserController();  
  final TextEditingController searchController = TextEditingController();

  bool isPriceDescending = true;
  String searchQuery = '';
  final List<UserModel> vipUsers = [];
  final List<UserModel> normalUsers = [];
  late int totalMoney;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVipUsers();
    getNormalUsers();
    getTotalMoney(); 
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

    Future<void> getNormalUsers() async {
    try {
      final snapshot = await userController.getNormalUsers();
      setState(() {
        vipUsers.addAll(snapshot);
      });
    } catch (e) {
      debugPrint("Lỗi khi lấy danh sách người dùng thường: $e");
    }
  }

    Future<void> getTotalMoney() async {
    try {
      final snapshot = await totalMoneyController.getTotalMoney();
      setState(() {
        totalMoney = snapshot;
      });
    } catch (e) {
      debugPrint("Lỗi khi lấy tổng tiền: $e");
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
                  hintText: 'Tìm kiếm trò chơi...',
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
        actions: [
          MenuBarCustom(),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: gameController.streamGetGameList(
          isPriceDescending: isPriceDescending,
          title: searchController.text,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Không tìm thấy trò chơi nào."));
          }

          List<DocumentSnapshot> gamesList = snapshot.data!.docs;

          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(8),
            children: [
              GridDashboard(
                gameQuantity: gamesList.length,
                revenueQuantity: totalMoney,
                userQuantity: normalUsers.length,
                vipUserQuantity: vipUsers.length,
              ),
              const SizedBox(height: 20),
              const Text(
                'Danh sách trò chơi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListviewGame(gamesList: gamesList),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddGameDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
