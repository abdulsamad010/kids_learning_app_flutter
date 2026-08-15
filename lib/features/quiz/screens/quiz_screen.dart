import 'package:flutter/material.dart';

import '../models/quiz.dart';
import '../models/question.dart';
import '../models/answer.dart';
import '../services/quiz_service.dart';
import '../widgets/multiple_choice.dart';
import '../widgets/true_false.dart';
import '../widgets/matching.dart';

class QuizScreen extends StatefulWidget {
  final int subjectId;
  final int lessonId;
  final int quizId;
  final String quizType;

  const QuizScreen({
    super.key,
    required this.subjectId,
    required this.lessonId,
    required this.quizId,
    required this.quizType,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService quizService = QuizService();

  Quiz? quiz;
  List<Question> questions = [];
  List<Answer> answers = [];

  int currentQuestion = 0;

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }

  Future<void> loadQuiz() async {
    final data = await quizService.getQuizzes(
      widget.subjectId,
      widget.lessonId,
    );

    for (var item in data) {
      Quiz loadedQuiz = Quiz(
        quizId: item['quizId'],
        lessonId: item['lessonId'],
        subjectId: item['subjectId'],
        title: item['title'],
        type: item['type'],
      );

      if (loadedQuiz.quizId == widget.quizId &&
          loadedQuiz.type == widget.quizType) {
        quiz = loadedQuiz;
        break;
      }
    }

    if (quiz != null) {
      await loadQuestions();
    }

    setState(() {});
  }

  Future<void> loadQuestions() async {
    final data = await quizService.getQuestions(
      widget.subjectId,
      widget.lessonId,
      widget.quizId,
    );

    List<Question> loadedQuestions = [];

    for (var item in data) {
      loadedQuestions.add(
        Question(
          questionId: item['questionId'],
          quizId: item['quizId'],
          lessonId: item['lessonId'],
          subjectId: item['subjectId'],
          questionText: item['questionText'],
          type: item['type'],
        ),
      );
    }

    setState(() {
      questions = loadedQuestions;
    });

    if (questions.isNotEmpty) {
      loadAnswers();
    }
  }

  Future<void> loadAnswers() async {
    final data = await quizService.getAnswers(
      widget.subjectId,
      widget.lessonId,
      widget.quizId,
      questions[currentQuestion].questionId,
    );

    List<Answer> loadedAnswers = [];

    for (var item in data) {
      loadedAnswers.add(
        Answer(
          answerId: item['answerId'],
          questionId: item['questionId'],
          quizId: item['quizId'],
          lessonId: item['lessonId'],
          subjectId: item['subjectId'],
          answerText: item['answerText'],
          isCorrect: item['isCorrect'],
        ),
      );
    }

    setState(() {
      answers = loadedAnswers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (quiz == null || questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
        ),
        body: const Center(
          child: Text('No quiz available'),
        ),
      );
    }

    Question question = questions[currentQuestion];

    Widget questionWidget;

    if (widget.quizType == 'multiple_choice') {
      questionWidget = MultipleChoice(
        question: question,
        answers: answers,
      );
    } else if (widget.quizType == 'true_false') {
      questionWidget = TrueFalse(
        question: question,
        answers: answers,
      );
    } else {
      questionWidget = Matching(
        question: question,
        answers: answers,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz!.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            Expanded(
              child: questionWidget,
            ),

            SizedBox(height: screenWidth * 0.04),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: currentQuestion < questions.length - 1
                    ? () {
                  setState(() {
                    currentQuestion++;
                    answers = [];
                  });

                  loadAnswers();
                }
                    : null,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}