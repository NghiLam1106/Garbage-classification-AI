import 'package:flutter/material.dart';
import 'package:garbageClassification/router/app_router.dart';

class QuizGameScreen extends StatefulWidget {
  @override
  _QuizGameScreenState createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool isAnswered = false;
  int score = 0;
  bool showScore = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Loại rác nào sau đây có thể tái chế?',
      'answers': [
        {'text': 'Vỏ hộp sữa giấy', 'isCorrect': true},
        {'text': 'Túi nilon đã qua sử dụng', 'isCorrect': false},
        {'text': 'Rau củ quả hư hỏng', 'isCorrect': false},
        {'text': 'Bã trà, cà phê', 'isCorrect': false},
      ],
      'explanation':
          'Vỏ hộp sữa giấy thuộc nhóm giấy có thể tái chế, cần làm sạch trước khi bỏ vào thùng rác tái chế.'
    },
    {
      'question': 'Rác hữu cơ KHÔNG nên dùng để làm gì?',
      'answers': [
        {'text': 'Ủ phân compost', 'isCorrect': false},
        {'text': 'Làm thức ăn cho động vật', 'isCorrect': false},
        {'text': 'Chôn lấp trực tiếp', 'isCorrect': true},
        {'text': 'Sản xuất biogas', 'isCorrect': false},
      ],
      'explanation':
          'Chôn lấp trực tiếp gây ô nhiễm đất và nước ngầm, cần xử lý qua ủ phân hoặc công nghệ khác.'
    },
    {
      'question': 'Pin đã qua sử dụng thuộc loại rác gì?',
      'answers': [
        {'text': 'Rác tái chế', 'isCorrect': false},
        {'text': 'Rác nguy hại', 'isCorrect': true},
        {'text': 'Rác thông thường', 'isCorrect': false},
        {'text': 'Rác hữu cơ', 'isCorrect': false},
      ],
      'explanation':
          'Pin chứa kim loại nặng như chì, thủy ngân - cực kỳ độc hại nếu không xử lý đúng cách.'
    },
    {
      'question': 'Màu sắc thùng rác nào dành cho rác vô cơ?',
      'answers': [
        {'text': 'Xanh lá', 'isCorrect': false},
        {'text': 'Xanh dương', 'isCorrect': false},
        {'text': 'Đỏ', 'isCorrect': false},
        {'text': 'Xám', 'isCorrect': true},
      ],
      'explanation':
          'Theo quy chuẩn Việt Nam: Xanh lá (hữu cơ), Xanh dương (tái chế), Xám/Đen (vô cơ).'
    },
  ];

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isAnswered = false;
      });
    } else {
      setState(() {
        showScore = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswerIndex = null;
      isAnswered = false;
      showScore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showScore) {
      return _buildResultScreen();
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Trò chơi phân loại rác'),
        backgroundColor: Colors.green.shade700,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Điểm: $score/${questions.length}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.grey.shade300,
              color: Colors.green,
              minHeight: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Câu hỏi
                  Card(
                    elevation: 4,
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        question['question'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Đáp án
                  ...List.generate(question['answers'].length, (index) {
                    final answer = question['answers'][index];
                    final isCorrect = answer['isCorrect'];
                    final isSelected = selectedAnswerIndex == index;

                    Color backgroundColor = Colors.white;
                    if (isAnswered) {
                      if (isSelected) {
                        backgroundColor = isCorrect
                            ? Colors.green.shade100
                            : Colors.red.shade100;
                      } else if (isCorrect) {
                        backgroundColor = Colors.green.shade50;
                      }
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () {
                          if (!isAnswered) {
                            setState(() {
                              selectedAnswerIndex = index;
                              isAnswered = true;
                              if (isCorrect) score++;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.green.shade700
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              if (isAnswered && isSelected)
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.cancel,
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                              if (isAnswered && !isSelected && isCorrect)
                                Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  answer['text'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected && isAnswered
                                        ? (isCorrect
                                            ? Colors.green.shade900
                                            : Colors.red.shade900)
                                        : Colors.black,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // Giải thích
                  if (isAnswered)
                    Card(
                      color: Colors.blue.shade50,
                      margin: EdgeInsets.only(top: 20),
                      child: Padding(
                        padding: EdgeInsets.all(16),
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
                            Text(question['explanation']),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isAnswered
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    currentQuestionIndex < questions.length - 1
                        ? 'Câu tiếp theo'
                        : 'Xem kết quả',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildResultScreen() {
    final percentage = (score / questions.length * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hoàn thành!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: percentage / 100,
                      strokeWidth: 12,
                      color: Colors.green,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                      Text(
                        '$score/${questions.length} câu đúng',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text(
                _getResultMessage(percentage),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.green.shade800),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nút "Chơi lại"
                  ElevatedButton(
                    onPressed: _restartQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Chơi lại',
                      style: TextStyle(fontSize: 18,color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 16), // Khoảng cách giữa 2 nút

                  // Nút "Trở về trang chủ"
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRouter.home);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue.shade700, // Màu khác để phân biệt
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Trang chủ',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getResultMessage(int percentage) {
    if (percentage >= 90) return 'Xuất sắc! Bạn là chuyên gia phân loại rác!';
    if (percentage >= 70) return 'Tốt lắm! Kiến thức của bạn rất ấn tượng!';
    if (percentage >= 50) return 'Khá đấy! Hãy ôn lại một chút nhé!';
    return 'Cần cố gắng thêm! Đọc kỹ hướng dẫn phân loại rác nhé!';
  }
}
