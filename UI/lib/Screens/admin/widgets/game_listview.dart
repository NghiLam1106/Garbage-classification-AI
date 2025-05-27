import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/admin/widgets/game_card.dart';
import 'package:garbageClassification/common/util/dialog_utils.dart';
import 'package:garbageClassification/controllers/gameController.dart';
import 'package:garbageClassification/router/app_router.dart';

class ListviewGame extends StatelessWidget {
  const ListviewGame({
    super.key,
    required this.gamesList,
  });

  final List<DocumentSnapshot<Object?>> gamesList;

  @override
  Widget build(BuildContext context) {
    final GameController gameController = GameController();
    return ListView.builder(
        shrinkWrap: true, // ✅ giới hạn chiều cao
        physics: NeverScrollableScrollPhysics(),
        itemCount: gamesList.length,
        itemBuilder: (context, index) {
          DocumentSnapshot doc = gamesList[index];
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          return GameCard(
              title: data['title'],
              quantity: data['quantity'].toString(),
              id: doc.id,
              onDelete: () => showDeleteConfirmationDialog(
                    context: context,
                    onConfirm: () {
                      gameController.removeGameAndQuizzes(doc.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Xóa thành công')),
                      );
                    },
                  ),
              onEdit: () => {
                    Navigator.pushNamed(
                      context,
                      AppRouter.updateGame,
                      arguments: doc.id,
                    )
                  });
        });
  }
}
