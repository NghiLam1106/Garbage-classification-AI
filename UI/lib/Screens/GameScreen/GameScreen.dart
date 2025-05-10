import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbageClassification/mode/quiz_mode.dart';
import 'package:garbageClassification/router/app_router.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<QuizModel> quizList = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuizData();
  }

  Future<void> fetchQuizData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('quizzes').get();
      final quizzes =
          snapshot.docs.map((doc) => QuizModel.fromSnapshot(doc)).toList();

      setState(() {
        quizList = quizzes;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Lỗi khi lấy quiz: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void addSampleQuiz() async {
    try {
      QuizModel quiz = QuizModel(
        question: "Rác hữu cơ là gì?",
        answers: ["Lá cây", "Nhựa", "Thủy tinh", "Kim loại"],
        correctAnswerIndex: 0,
        explanation: "Lá cây là rác hữu cơ vì có thể phân hủy sinh học.",
        category: "Rác",
        difficulty: 2,
      );

      await FirebaseFirestore.instance.collection('quizzes').add(quiz.toMap());

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Đã thêm quiz mẫu")));

      fetchQuizData(); // Refresh list
    } catch (e) {
      debugPrint("Lỗi khi thêm quiz: $e");
    }
  }

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

              // Gọi dialog nhập câu hỏi đầu tiên
              showAddQuizToGameDialog(context, newGameRef.id);
            },
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final filteredQuizzes = quizList.where((quiz) {
      return quiz.question.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Trò chơi'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showAddGameDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm...',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: filteredQuizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = filteredQuizzes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, AppRouter.quiz);
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  "images/game.png",
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                quiz.question,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  'Chủ đề: ${quiz.category} | Mức độ: ${quiz.difficulty}'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
