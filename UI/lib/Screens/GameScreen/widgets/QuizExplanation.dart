import 'package:flutter/material.dart';

class QuizExplanation extends StatelessWidget {
  const QuizExplanation({super.key, required this.explanation});

  final String explanation;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 Giải thích:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            explanation,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
