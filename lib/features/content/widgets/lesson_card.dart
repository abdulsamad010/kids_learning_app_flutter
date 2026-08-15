import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;

  const LessonCard({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          children: [
            Icon(
              Icons.book_rounded,
              size: screenWidth * 0.08,
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Text(
                lesson.title,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: screenWidth * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}