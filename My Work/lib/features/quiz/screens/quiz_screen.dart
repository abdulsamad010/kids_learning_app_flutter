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
  final Map<String, dynamic> quizResult;

  const QuizScreen({
    super.key,
    required this.subjectId,
    required this.lessonId,
    required this.quizId,
    required this.quizType,
    required this.quizResult,
  });

  @override
  State<QuizScreen> createState() =>
      _QuizScreenState();
}

class _QuizScreenState
    extends State<QuizScreen> {
  final QuizService quizService =
  QuizService();

  Quiz? quiz;

  List<Question> questions = [];

  List<Answer> answers = [];

  int currentQuestion = 0;

  int score = 0;

  int? selectedAnswerId;

  bool answerChecked = false;

  bool selectedAnswerCorrect = false;

  final Map<int, int> selectedAnswers =
  {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }

  Future<void> loadQuiz() async {
    setState(() {
      isLoading = true;
    });

    final data =
    await quizService.getQuizzes(
      widget.subjectId,
      widget.lessonId,
    );

    for (final item in data) {
      final loadedQuiz = Quiz(
        quizId: item['quizId'],
        lessonId: item['lessonId'],
        subjectId: item['subjectId'],
        title: item['title'],
        type: item['type'],
      );

      if (loadedQuiz.quizId ==
          widget.quizId &&
          loadedQuiz.type ==
              widget.quizType) {
        quiz = loadedQuiz;
        break;
      }
    }

    if (quiz != null) {
      await loadQuestions();
    }

    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadQuestions() async {
    final data =
    await quizService.getQuestions(
      widget.subjectId,
      widget.lessonId,
      widget.quizId,
    );

    final loadedQuestions =
    <Question>[];

    for (final item in data) {
      loadedQuestions.add(
        Question(
          questionId:
          item['questionId'],
          quizId: item['quizId'],
          lessonId:
          item['lessonId'],
          subjectId:
          item['subjectId'],
          questionText:
          item['questionText'],
          type: item['type'],
        ),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      questions =
          loadedQuestions;
    });

    if (questions.isNotEmpty) {
      await loadAnswers();
    }
  }

  Future<void> loadAnswers() async {
    if (questions.isEmpty) {
      return;
    }

    final question =
    questions[currentQuestion];

    final data =
    await quizService.getAnswers(
      widget.subjectId,
      widget.lessonId,
      widget.quizId,
      question.questionId,
    );

    final loadedAnswers =
    <Answer>[];

    for (final item in data) {
      loadedAnswers.add(
        Answer(
          answerId:
          item['answerId'],
          questionId:
          item['questionId'],
          quizId:
          item['quizId'],
          lessonId:
          item['lessonId'],
          subjectId:
          item['subjectId'],
          answerText:
          item['answerText'],
          isCorrect:
          item['isCorrect'],
        ),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      answers =
          loadedAnswers;
    });
  }

  void selectAnswer(
      Answer answer,
      ) {
    if (answerChecked) {
      return;
    }

    setState(() {
      selectedAnswerId =
          answer.answerId;

      selectedAnswerCorrect =
          answer.isCorrect;

      answerChecked = true;

      selectedAnswers[
      questions[currentQuestion]
          .questionId] =
          answer.answerId;

      if (answer.isCorrect) {
        score++;
      }
    });
  }

  Future<void> nextQuestion() async {
    if (currentQuestion <
        questions.length - 1) {
      setState(() {
        currentQuestion++;

        selectedAnswerId =
        null;

        selectedAnswerCorrect =
        false;

        answerChecked =
        false;

        answers = [];
      });

      await loadAnswers();
    } else {
      finishQuiz();
    }
  }

  void finishQuiz() {
    final int totalQuestions =
        questions.length;

    final int percentage =
    totalQuestions == 0
        ? 0
        : ((score /
        totalQuestions) *
        100)
        .round();

    final bool passed =
        percentage >= 50;

    final result =
    <String, dynamic>{
      'subjectId':
      widget.subjectId,
      'lessonId':
      widget.lessonId,
      'quizId':
      widget.quizId,
      'quizType':
      widget.quizType,
      'score':
      score,
      'totalQuestions':
      totalQuestions,
      'selectedAnswers':
      Map<int, int>.from(
        selectedAnswers,
      ),
      'percentage':
      percentage,
      'passed':
      passed,
    };

    Navigator.pop(
      context,
      result,
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title:
          const Text('Quiz'),
        ),
        body: Center(
          child:
          CircularProgressIndicator(
            color:
            colorScheme.primary,
          ),
        ),
      );
    }

    if (quiz == null ||
        questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title:
          const Text('Quiz'),
        ),
        body: Center(
          child: Padding(
            padding:
            const EdgeInsets.all(
              24,
            ),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  Icons
                      .quiz_outlined,
                  size: 70,
                  color: colorScheme
                      .primary,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'No quiz available',
                  textAlign:
                  TextAlign.center,
                  style: theme
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'This quiz could not be loaded. Please return and choose another quiz.',
                  textAlign:
                  TextAlign.center,
                  style: theme
                      .textTheme
                      .bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question =
    questions[currentQuestion];

    Widget quizWidget;

    if (widget.quizType ==
        'multiple_choice') {
      quizWidget =
          MultipleChoice(
            question: question,
            answers: answers,
            onAnswerSelected:
            selectAnswer,
          );
    } else if (widget.quizType ==
        'true_false') {
      quizWidget =
          TrueFalse(
            question: question,
            answers: answers,
            onAnswerSelected:
            selectAnswer,
          );
    } else {
      quizWidget =
          Matching(
            question: question,
            answers: answers,
            onAnswerSelected:
            selectAnswer,
          );
    }

    final double progress =
        (currentQuestion + 1) /
            questions.length;

    return Scaffold(
      appBar: AppBar(
        title:
        Text(quiz!.title),
      ),
      body: Padding(
        padding:
        EdgeInsets.all(
          screenWidth * 0.035,
        ),
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
              ),
              child: Padding(
                padding:
                EdgeInsets.all(
                  screenWidth * 0.04,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration:
                          BoxDecoration(
                            color: colorScheme
                                .primaryContainer,
                            borderRadius:
                            BorderRadius
                                .circular(
                              14,
                            ),
                          ),
                          child:
                          Icon(
                            getQuizIcon(
                              widget
                                  .quizType,
                            ),
                            color: colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                        SizedBox(
                          width:
                          screenWidth *
                              0.03,
                        ),
                        Expanded(
                          child:
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Text(
                                formatQuizType(
                                  widget
                                      .quizType,
                                ),
                                style: theme
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  fontWeight:
                                  FontWeight
                                      .w800,
                                ),
                              ),
                              Text(
                                'Question ${currentQuestion + 1} of ${questions.length}',
                                style: theme
                                    .textTheme
                                    .bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration:
                          BoxDecoration(
                            color: colorScheme
                                .primaryContainer,
                            borderRadius:
                            BorderRadius
                                .circular(
                              20,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .star_rounded,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '$score',
                                style: theme
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  fontWeight:
                                  FontWeight
                                      .w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ClipRRect(
                      borderRadius:
                      BorderRadius
                          .circular(
                        10,
                      ),
                      child:
                      LinearProgressIndicator(
                        value:
                        progress,
                        minHeight: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height:
              screenWidth * 0.035,
            ),
            Expanded(
              child:
              AnimatedSwitcher(
                duration:
                const Duration(
                  milliseconds: 350,
                ),
                transitionBuilder:
                    (
                    child,
                    animation,
                    ) {
                  return FadeTransition(
                    opacity:
                    animation,
                    child:
                    SlideTransition(
                      position:
                      Tween<
                          Offset>(
                        begin:
                        const Offset(
                          0.08,
                          0,
                        ),
                        end:
                        Offset.zero,
                      ).animate(
                        animation,
                      ),
                      child:
                      child,
                    ),
                  );
                },
                child:
                KeyedSubtree(
                  key: ValueKey(
                    currentQuestion,
                  ),
                  child:
                  quizWidget,
                ),
              ),
            ),
            if (answerChecked)
              Padding(
                padding:
                EdgeInsets.only(
                  top:
                  screenWidth *
                      0.025,
                  bottom:
                  screenWidth *
                      0.02,
                ),
                child:
                AnimatedSwitcher(
                  duration:
                  const Duration(
                    milliseconds:
                    250,
                  ),
                  child: Text(
                    selectedAnswerCorrect
                        ? '🎉 Correct! Great job!'
                        : '💪 Not quite! Keep learning!',
                    key: ValueKey(
                      selectedAnswerCorrect,
                    ),
                    style: theme
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w800,
                      color:
                      selectedAnswerCorrect
                          ? Colors
                          .green
                          .shade700
                          : Colors
                          .orange
                          .shade800,
                    ),
                  ),
                ),
              ),
            SizedBox(
              width:
              double.infinity,
              child:
              ElevatedButton.icon(
                onPressed:
                answerChecked
                    ? nextQuestion
                    : null,
                icon: Icon(
                  currentQuestion <
                      questions.length -
                          1
                      ? Icons
                      .arrow_forward_rounded
                      : Icons
                      .check_rounded,
                ),
                label: Text(
                  currentQuestion <
                      questions.length -
                          1
                      ? 'Next Question'
                      : 'Finish Quiz',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getQuizIcon(
      String type,
      ) {
    switch (type) {
      case 'multiple_choice':
        return Icons.quiz_rounded;
      case 'true_false':
        return Icons
            .check_circle_rounded;
      case 'matching':
        return Icons
            .compare_arrows_rounded;
      default:
        return Icons.quiz_rounded;
    }
  }

  String formatQuizType(
      String type,
      ) {
    switch (type) {
      case 'multiple_choice':
        return 'Multiple Choice';
      case 'true_false':
        return 'True or False';
      case 'matching':
        return 'Matching';
      default:
        return type;
    }
  }
}