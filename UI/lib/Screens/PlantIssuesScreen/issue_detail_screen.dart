import 'package:flutter/material.dart';

class IssueDetailScreen extends StatelessWidget {
  final String title;
  final String image;
  final String longDescription;

  const IssueDetailScreen({
    Key? key,
    required this.title,
    required this.image,
    required this.longDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(image),
            ),
            SizedBox(height: 20),
            Text(
              longDescription,
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
