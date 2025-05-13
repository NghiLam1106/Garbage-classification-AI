import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/controllers/gameController.dart';
import 'package:garbageClassification/model/quiz_model.dart';
import 'package:garbageClassification/widgets/appbar.dart';

class UpdateGameScreen extends StatefulWidget {
  const UpdateGameScreen({super.key, required this.id});

  final String id;

  @override
  State<UpdateGameScreen> createState() => _UpdateGameScreenState();
}

class _UpdateGameScreenState extends State<UpdateGameScreen> {
  final GameController gameController = GameController();

  late TextEditingController _titleController;
  late TextEditingController _quantityController;

  List<QuizModel> _quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final quizzesList = await gameController.fetchQuizzesForGame(widget.id);
    final gameData = await gameController.fetchGame(widget.id);
    _quizzes = quizzesList;
    _titleController = TextEditingController(text: gameData.title);
    _quantityController = TextEditingController(text: gameData.quantity.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: Text('Cập nhật trò chơi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Tên trò chơi"),
            ),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Số lượng câu hỏi"),
            ),
            const SizedBox(height: 20),
            Text("Danh sách câu hỏi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._quizzes.asMap().entries.map((entry) {
              int index = entry.key;
              QuizModel quiz = entry.value;
              return ExpansionTile(
                title: Text("Câu hỏi ${index + 1}: ${quiz.question}"),
                children: [
                  ...quiz.answers.asMap().entries.map((ansEntry) => ListTile(
                        title: Text(ansEntry.value),
                        leading: Radio<int>(
                          value: ansEntry.key,
                          groupValue: quiz.correctAnswerIndex,
                          onChanged: (val) {
                            setState(() {
                              quiz.correctAnswerIndex = val!;
                            });
                          },
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Giải thích: ${quiz.explanation}"),
                  ),
                ],
              );
            }).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Gửi dữ liệu cập nhật lên server hoặc local
                String newTitle = _titleController.text;
                int newQuantity = int.tryParse(_quantityController.text) ?? 0;
              },
              child: Text("Lưu cập nhật"),
            )
          ],
        ),
      ),
    );
  }
}
