import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/answer.dart';

class TrueFalse extends StatelessWidget {
  final Question question;
  final List<Answer> answers;

  const TrueFalse({
    super.key,
    required this.question,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.questionText),
            SizedBox(height: screenWidth * 0.04),

            for (Answer answer in answers)
              Padding(
                padding: EdgeInsets.only(
                  bottom: screenWidth * 0.02,
                ),
                child: Text(answer.answerText),
              ),
          ],
        ),
      ),
    );
  }
}