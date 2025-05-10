import 'package:flutter/material.dart';

class GuideDetailScreen extends StatelessWidget {
  final String title;
  final String detail;

  const GuideDetailScreen({
    super.key,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📘 Chi tiết hướng dẫn'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
            SizedBox(height: 20),
            Text(detail,
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
