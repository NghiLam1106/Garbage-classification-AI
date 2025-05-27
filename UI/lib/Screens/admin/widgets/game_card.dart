import 'package:flutter/material.dart';

class GameCard extends StatefulWidget {
  const GameCard({
    super.key,
    required this.id,
    required this.title,
    required this.quantity,
    required this.onEdit,
    required this.onDelete,
  });

  final String id, title, quantity;
  final VoidCallback onEdit, onDelete;

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: ListTile(
        leading: Image.asset('assets/game.png'),
        title: Text(widget.title, style: Theme.of(context).textTheme.titleMedium!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Số lượng: ${widget.quantity}',
              style: Theme.of(context).textTheme.titleSmall!.apply(color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: widget.onEdit,
              icon: const Icon(Icons.settings),
            ),
            IconButton(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}