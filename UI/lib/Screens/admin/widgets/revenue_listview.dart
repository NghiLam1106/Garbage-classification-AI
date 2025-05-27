import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListviewRevenue extends StatelessWidget {
  const ListviewRevenue({
    super.key,
    required this.name,
    required this.email,
    required this.imageURL,
    required this.money,
    required this.createdAt,
  });

  final String name, email, imageURL;
  final int money;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy – HH:mm').format(createdAt);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageURL),
          radius: 25,
        ),
        title: Text(name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $email'),
            Text('Tiền đã thanh toán: $money VNĐ'),
            Text('Ngày thanh toán: $formattedDate'),
          ],
        ),
      ),
    );
  }
}
