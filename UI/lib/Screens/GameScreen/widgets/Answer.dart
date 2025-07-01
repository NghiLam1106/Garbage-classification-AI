import 'package:flutter/material.dart';
import 'package:garbageClassification/model/quiz_model.dart';

class Answer extends StatelessWidget {
  const Answer(
      {super.key,
      required this.currentQuiz,
      required this.isAnswered,
      this.selectedAnswerIndex,
      required this.handleAnswerSelection});

  final QuizModel currentQuiz;
  final bool isAnswered;
  final int? selectedAnswerIndex;
  final Function(int) handleAnswerSelection;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: currentQuiz.answers.length,
        itemBuilder: (context, index) {
          final answer = currentQuiz.answers[index];
          final isCorrect =
              isAnswered && index == currentQuiz.correctAnswerIndex;
          final isSelected = selectedAnswerIndex == index;

          Color? cardColor;
          if (isAnswered) {
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
                  color:
                      isSelected ? Colors.green.shade700 : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => handleAnswerSelection(index),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      if (isAnswered)
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          answer,
                          style: TextStyle(
                            fontSize: 16,
                            color: isAnswered
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
    );
  }
}
