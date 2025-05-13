import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/admin/games/widgets/game_listview.dart';
import 'package:garbageClassification/common/util/game_dialogs.dart';
import 'package:garbageClassification/controllers/gameController.dart';

class AdminGameScreen extends StatefulWidget {
  const AdminGameScreen({super.key});

  @override
  State<AdminGameScreen> createState() => _AdminGameScreenState();
}

class _AdminGameScreenState extends State<AdminGameScreen> {
  final GameController gameController = GameController();
  final TextEditingController searchController = TextEditingController();

  bool isPriceDescending = true;
  String searchQuery = '';

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
                    searchQuery = value; // ✅ Lưu lại giá trị tìm kiếm
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

          return ListviewGame(gamesList: gamesList);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddGameDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}