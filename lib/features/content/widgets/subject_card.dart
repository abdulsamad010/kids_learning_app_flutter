import 'package:flutter/material.dart';
import '../models/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({
    super.key,
    required this.subject,
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
              Icons.menu_book_rounded,
              size: screenWidth * 0.08,
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Text(
                subject.name,
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