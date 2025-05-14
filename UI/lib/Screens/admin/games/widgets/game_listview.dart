import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/admin/games/widgets/game_card.dart';
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
                    Navigator.pushReplacementNamed(
                      context,
                      AppRouter.updateGame,
                      arguments: doc.id,
                    )
                  });
        });
  }
}
