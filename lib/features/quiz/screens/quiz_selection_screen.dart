import 'package:flutter/material.dart';

import '../models/quiz.dart';
import '../services/quiz_service.dart';
import 'quiz_screen.dart';

class QuizSelectionScreen extends StatefulWidget {
  final int subjectId;
  final int lessonId;

  const QuizSelectionScreen({
    super.key,
    required this.subjectId,
    required this.lessonId,
  });

  @override
  State<QuizSelectionScreen> createState() => _QuizSelectionScreenState();
}

class _QuizSelectionScreenState extends State<QuizSelectionScreen> {
  final QuizService quizService = QuizService();

  List<Quiz> quizzes = [];

  @override
  void initState() {
    super.initState();
    loadQuizzes();
  }

  Future<void> loadQuizzes() async {
    final data = await quizService.getQuizzes(
      widget.subjectId,
      widget.lessonId,
    );

    List<Quiz> loadedQuizzes = [];

    for (var item in data) {
      loadedQuizzes.add(
        Quiz(
          quizId: item['quizId'],
          lessonId: item['lessonId'],
          subjectId: item['subjectId'],
          title: item['title'],
          type: item['type'],
        ),
      );
    }

    setState(() {
      quizzes = loadedQuizzes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Quiz'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: quizzes.isEmpty
            ? const Center(
          child: Text('No quizzes available'),
        )
            : ListView.builder(
          itemCount: quizzes.length,
          itemBuilder: (context, index) {
            Quiz quiz = quizzes[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: screenWidth * 0.03,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        subjectId: widget.subjectId,
                        lessonId: widget.lessonId,
                        quizId: quiz.quizId,
                        quizType: quiz.type,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(quiz.title),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
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
    );
  }
}