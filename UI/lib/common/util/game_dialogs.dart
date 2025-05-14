import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbageClassification/controllers/gameController.dart';
import 'package:garbageClassification/controllers/quizController.dart';
import 'package:garbageClassification/model/quiz_model.dart';

  Future<void> showAddGameDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final quantityController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm trò chơi mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Tên trò chơi'),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Số lượng câu hỏi'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Tiếp tục'),
            onPressed: () async {
              final title = titleController.text.trim();
              final quantity =
                  int.tryParse(quantityController.text.trim()) ?? 0;

              if (title.isEmpty || quantity <= 0) return;

              // Lưu game vào Firestore
              final newGameRef =
                  await FirebaseFirestore.instance.collection('games').add({
                'title': title,
                'quantity': quantity,
                'createdAt': Timestamp.now(),
              });

              Navigator.pop(context); // Đóng dialog thêm game

              // Tiến hành thêm câu hỏi cho game
              await addQuestionsToGame(context, newGameRef.id, quantity);
            },
          ),
        ],
      ),
    );
  }

  Future<void> addQuestionsToGame(
      BuildContext context, String gameId, int quantity) async {
    int questionsAdded = 0;

    // Lặp lại cho đến khi đủ số câu hỏi
    while (questionsAdded < quantity) {
      showAddQuizToGameDialog(context, gameId);
      questionsAdded++; // Tăng số câu hỏi đã thêm
    }

    // Sau khi thêm đủ số câu hỏi, thông báo hoặc thực hiện hành động khác
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Đã thêm $quantity câu hỏi')));
  }

  void showAddQuizToGameDialog(BuildContext context, String gameId) {
    final questionController = TextEditingController();
    final explanationController = TextEditingController();
    final answerControllers = List.generate(4, (_) => TextEditingController());
    int correctIndex = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm câu hỏi'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: 'Câu hỏi'),
              ),
              ...List.generate(4, (i) {
                return RadioListTile(
                  value: i,
                  groupValue: correctIndex,
                  onChanged: (val) {
                    correctIndex = val!;
                    (context as Element).markNeedsBuild(); // cập nhật lại UI
                  },
                  title: TextField(
                    controller: answerControllers[i],
                    decoration: InputDecoration(labelText: 'Đáp án ${i + 1}'),
                  ),
                );
              }),
              TextField(
                controller: explanationController,
                decoration: InputDecoration(labelText: 'Giải thích (tuỳ chọn)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Lưu'),
            onPressed: () async {
              final question = questionController.text.trim();
              final answers =
                  answerControllers.map((c) => c.text.trim()).toList();
              final explanation = explanationController.text.trim();

              if (question.isEmpty || answers.any((a) => a.isEmpty)) return;

              final quiz = QuizModel(
                question: question,
                answers: answers,
                correctAnswerIndex: correctIndex,
                explanation: explanation,
                category: 'Chung',
                timestamp: Timestamp.now(),
                difficulty: 3,
              );

              await FirebaseFirestore.instance
                  .collection('games')
                  .doc(gameId)
                  .collection('quizzes')
                  .add(quiz.toMap());

              Navigator.pop(context); // Đóng dialog sau khi lưu
            },
          ),
        ],
      ),
    );
  }