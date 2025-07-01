import 'package:flutter/material.dart';

class Nextbutton extends StatelessWidget {
  const Nextbutton({super.key, required this.handleNextQuestion, required this.isEnd});

  final bool isEnd;
  final VoidCallback handleNextQuestion;

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: handleNextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      isEnd
                          ? 'TIẾP THEO'
                          : 'XEM KẾT QUẢ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
  }
}