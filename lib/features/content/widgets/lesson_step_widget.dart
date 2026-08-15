import 'package:flutter/material.dart';
import '../models/lesson_step.dart';

class LessonStepWidget extends StatelessWidget {
  final LessonStep lessonStep;

  const LessonStepWidget({
    super.key,
    required this.lessonStep,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lessonStep.title,
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              lessonStep.content,
            ),
          ],
        ),
      ),
    );
  }
}