import 'package:flutter/material.dart';
import 'package:garbageClassification/controllers/quizController.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController _controller = QuizController();
  int? _selectedAnswerIndex;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    await _controller.fetchQuizzes(category: 'Phân loại rác');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentQuiz = _controller.currentQuiz;

    if (currentQuiz == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Câu ${_controller.currentQuestionNumber}/${_controller.totalQuestions}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hiển thị câu hỏi
            Text(
              currentQuiz.question,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            
            // Hiển thị đáp án
            ...currentQuiz.answers.asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;
              final isCorrect = _isAnswered && index == currentQuiz.correctAnswerIndex;
              final isSelected = _selectedAnswerIndex == index;

              return Card(
                color: _isAnswered
                    ? (isCorrect 
                        ? Colors.green.shade100 
                        : (isSelected ? Colors.red.shade100 : null))
                    : null,
                child: ListTile(
                  title: Text(answer),
                  onTap: () {
                    if (!_isAnswered) {
                      setState(() {
                        _selectedAnswerIndex = index;
                        _isAnswered = true;
                        final isCorrect = _controller.checkAnswer(index);
                        
                        if (isCorrect) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Chính xác!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sai rồi! Đáp án đúng: ${currentQuiz.correctAnswer}')),
                          );
                        }
                      });
                    }
                  },
                ),
              );
            }).toList(),

            // Nút tiếp tục
            if (_isAnswered)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isAnswered = false;
                    _selectedAnswerIndex = null;
                    if (!_controller.nextQuestion()) {
                      // Hiển thị kết quả cuối cùng
                      _showResultDialog();
                    }
                  });
                },
                child: Text(_controller.currentQuestionNumber < _controller.totalQuestions
                    ? 'Tiếp theo'
                    : 'Xem kết quả'),
              ),
          ],
        ),
      ),
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Kết quả'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Điểm số: ${_controller.score}/${_controller.totalQuestions}'),
            Text('Tỷ lệ chính xác: ${_controller.accuracyRate.toStringAsFixed(1)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controller.reset();
              setState(() {});
            },
            child: Text('Chơi lại'),
          ),
        ],
      ),
    );
  }
}