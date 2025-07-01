import 'package:flutter/material.dart';
import 'package:garbageClassification/Screens/GameScreen/widgets/Answer.dart';
import 'package:garbageClassification/Screens/GameScreen/widgets/NextButton.dart';
import 'package:garbageClassification/Screens/GameScreen/widgets/Question.dart';
import 'package:garbageClassification/Screens/GameScreen/widgets/QuizExplanation.dart';
import 'package:garbageClassification/Screens/GameScreen/widgets/ResultDialog.dart';
import 'package:garbageClassification/controllers/gameController.dart';
import 'package:garbageClassification/controllers/quizController.dart';
import 'package:garbageClassification/model/quiz_model.dart';
import 'package:garbageClassification/router/app_router.dart';

class QuizScreen extends StatefulWidget {
  final String gameId;

  const QuizScreen({Key? key, required this.gameId}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController _controller = QuizController();
  final GameController _gameController = GameController();
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    try {
      final data = await _gameController.fetchQuizzesForGame(widget.gameId);
      setState(() {
        _controller.initializeQuestions(data);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading quizzes: $e");
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải câu hỏi. Vui lòng thử lại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Đang tải câu hỏi...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    final currentQuiz = _controller.currentQuiz;
    if (currentQuiz == null) {
      return Scaffold(
        body: Center(
          child: Text('Không có câu hỏi nào', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Câu ${_controller.currentQuestionNumber}/${_controller.quantity}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Câu hỏi
              Question(question: currentQuiz.question),
              SizedBox(height: 24),

              // Đáp án
              Answer(
                currentQuiz: currentQuiz,
                isAnswered: _isAnswered,
                selectedAnswerIndex: _selectedAnswerIndex,
                handleAnswerSelection: _handleAnswerSelection,
              ),

              // Giải thích khi đã trả lời
              if (_isAnswered)
                QuizExplanation(explanation: currentQuiz.explanation),

              // Nút tiếp tục
              if (_isAnswered)
                Nextbutton(
                  handleNextQuestion: _handleNextQuestion,
                  isEnd:
                      _controller.currentQuestionNumber < _controller.quantity,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Xử lý sự kiện khi người dùng chọn đáp án
  void _handleAnswerSelection(int index) {
    if (!_isAnswered) {
      setState(() {
        _selectedAnswerIndex = index;
        _isAnswered = true;
        final isCorrect = _controller.checkAnswer(index);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCorrect ? 'Chính xác! +1 điểm' : 'Sai rồi!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: isCorrect ? Colors.green : Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }


  void _handleNextQuestion() {
    setState(() {
      _isAnswered = false;
      _selectedAnswerIndex = null;
      if (!_controller.nextQuestion()) {
        _showResultDialog();
      }
    });
  }
  // Xử lý sự kiện khi người dùng nhấn nút "Chơi lại"
  void _handleReset() {
    Navigator.pop(context);
    _controller.reset();
    setState(() {});
  }

  // Hiển thị hộp thoại kết quả khi người dùng hoàn thành tất cả câu hỏi
  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Resultdialog(
        resultMessage: _getResultMessage(),
        score: _controller.score,
        quantity: _controller.quantity,
        resetGame: _handleReset,
      ),
    );
  }
  // Lấy thông điệp kết quả dựa trên điểm số
  String _getResultMessage() {
    final percentage = (_controller.score / _controller.quantity) * 100;
    if (percentage >= 90) return 'Xuất sắc! Bạn thực sự hiểu biết!';
    if (percentage >= 70) return 'Tốt lắm! Kiến thức của bạn rất ấn tượng!';
    if (percentage >= 50) return 'Khá đấy! Hãy ôn lại một chút nhé!';
    return 'Cần cố gắng thêm! Đừng nản chí!';
  }
}
