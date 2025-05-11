import 'package:flutter/material.dart';
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
          'Câu ${_controller.currentQuestionNumber}/${_controller.totalQuestions}',
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
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    currentQuiz.question,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Đáp án
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: currentQuiz.answers.length,
                  itemBuilder: (context, index) {
                    final answer = currentQuiz.answers[index];
                    final isCorrect = _isAnswered && 
                        index == currentQuiz.correctAnswerIndex;
                    final isSelected = _selectedAnswerIndex == index;
                    
                    Color? cardColor;
                    if (_isAnswered) {
                      cardColor = isCorrect 
                          ? Colors.green.shade100 
                          : (isSelected ? Colors.red.shade100 : null);
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        elevation: 2,
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected 
                                ? Colors.green.shade700 
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _handleAnswerSelection(index),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                if (_isAnswered)
                                  Icon(
                                    isCorrect 
                                        ? Icons.check_circle 
                                        : Icons.cancel,
                                    color: isCorrect 
                                        ? Colors.green 
                                        : Colors.red,
                                  ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    answer,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _isAnswered
                                          ? (isCorrect 
                                              ? Colors.green.shade900 
                                              : (isSelected 
                                                  ? Colors.red.shade900 
                                                  : Colors.black))
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
                      ),
                    );
                  },
                ),
              ),

              // Giải thích khi đã trả lời
              if (_isAnswered)
                AnimatedContainer(
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
                        currentQuiz.explanation,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),

              // Nút tiếp tục
              if (_isAnswered)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: _handleNextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      _controller.currentQuestionNumber < _controller.totalQuestions
                          ? 'TIẾP THEO'
                          : 'XEM KẾT QUẢ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

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

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'HOÀN THÀNH!',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: _controller.score / _controller.totalQuestions,
                    strokeWidth: 10,
                    color: Colors.green,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${_controller.score}/${_controller.totalQuestions}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    Text(
                      'câu đúng',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              _getResultMessage(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _controller.reset();
                  setState(() {});
                },
                child: Text(
                  'CHƠI LẠI',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRouter.home);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                ),
                child: Text(
                  'TRANG CHỦ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  String _getResultMessage() {
    final percentage = (_controller.score / _controller.totalQuestions) * 100;
    if (percentage >= 90) return 'Xuất sắc! Bạn thực sự hiểu biết!';
    if (percentage >= 70) return 'Tốt lắm! Kiến thức của bạn rất ấn tượng!';
    if (percentage >= 50) return 'Khá đấy! Hãy ôn lại một chút nhé!';
    return 'Cần cố gắng thêm! Đừng nản chí!';
  }
}