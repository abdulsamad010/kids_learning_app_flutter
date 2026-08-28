import 'package:flutter/material.dart';

import '../models/quiz.dart';
import '../services/quiz_service.dart';
import 'quiz_screen.dart';

class QuizSelectionScreen extends StatefulWidget {
  final int subjectId;
  final int lessonId;
  final Map<String, dynamic> quizResult;

  const QuizSelectionScreen({
    super.key,
    required this.subjectId,
    required this.lessonId,
    required this.quizResult,
  });

  @override
  State<QuizSelectionScreen> createState() =>
      _QuizSelectionScreenState();
}

class _QuizSelectionScreenState
    extends State<QuizSelectionScreen> {
  final QuizService quizService =
  QuizService();

  List<Quiz> quizzes = [];

  Map<String, dynamic> progressData = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadQuizzes();
  }

  Future<void> loadQuizzes() async {
    final data =
    await quizService.getQuizzes(
      widget.subjectId,
      widget.lessonId,
    );

    final loadedQuizzes = <Quiz>[];

    for (final item in data) {
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

    final dataProgress =
    await quizService.getQuizProgress(
      widget.subjectId,
      widget.lessonId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      quizzes = loadedQuizzes;

      progressData =
      dataProgress is Map<String, dynamic>
          ? dataProgress
          : {};

      loading = false;
    });
  }

  bool get quizAlreadyAttempted {
    return widget.quizResult.isNotEmpty ||
        progressData['completedQuizType'] !=
            null;
  }

  String? get attemptedQuizType {
    if (widget.quizResult['quizType'] !=
        null) {
      return widget.quizResult['quizType']
          .toString();
    }

    if (progressData[
    'completedQuizType'] !=
        null) {
      return progressData[
      'completedQuizType']
          .toString();
    }

    return null;
  }

  int get score {
    return widget.quizResult['score'] ??
        progressData['score'] ??
        0;
  }

  int get totalQuestions {
    return widget.quizResult[
    'totalQuestions'] ??
        progressData[
        'quizResult']?[
        'totalQuestions'] ??
        0;
  }

  int get percentage {
    if (widget.quizResult[
    'percentage'] !=
        null) {
      return widget.quizResult[
      'percentage'];
    }

    final result =
    progressData['quizResult'];

    if (result is Map &&
        result['percentage'] !=
            null) {
      return result['percentage'];
    }

    if (totalQuestions == 0) {
      return 0;
    }

    return ((score /
        totalQuestions) *
        100)
        .round();
  }

  bool get passed {
    if (widget.quizResult[
    'passed'] !=
        null) {
      return widget.quizResult[
      'passed'];
    }

    final result =
    progressData['quizResult'];

    if (result is Map &&
        result['passed'] != null) {
      return result['passed'];
    }

    return percentage >= 50;
  }

  Future<void> startQuiz(
      Quiz quiz,
      ) async {
    if (quizAlreadyAttempted) {
      return;
    }

    final result =
    await Navigator.push<
        Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QuizScreen(
              subjectId:
              widget.subjectId,
              lessonId:
              widget.lessonId,
              quizId: quiz.quizId,
              quizType: quiz.type,
              quizResult: {},
            ),
      ),
    );

    if (!mounted) {
      return;
    }

    if (result != null &&
        result.isNotEmpty) {
      Navigator.pop(
        context,
        result,
      );

      return;
    }

    await loadQuizzes();
  }

  void returnToLesson() {
    if (widget.quizResult.isNotEmpty) {
      Navigator.pop(
        context,
        widget.quizResult,
      );
    } else {
      Navigator.pop(
        context,
      );
    }
  }

  IconData getQuizIcon(
      String type,
      ) {
    switch (type) {
      case 'multiple_choice':
        return Icons.quiz_rounded;
      case 'true_false':
        return Icons.check_circle_rounded;
      case 'matching':
        return Icons.compare_arrows_rounded;
      default:
        return Icons.extension_rounded;
    }
  }

  String getQuizTypeName(
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
        return 'Quiz';
    }
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

    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Choose Your Quiz'),
      ),
      body: loading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : quizzes.isEmpty
          ? buildEmptyState(
        screenWidth,
      )
          : ListView(
        padding:
        EdgeInsets.all(
          screenWidth * 0.05,
        ),
        children: [
          quizAlreadyAttempted
              ? buildAttemptedHeader(
            screenWidth,
          )
              : buildSelectionHeader(
            screenWidth,
          ),
          SizedBox(
            height:
            screenWidth * 0.04,
          ),
          if (quizAlreadyAttempted)
            buildLockMessage(
              screenWidth,
            ),
          if (quizAlreadyAttempted)
            SizedBox(
              height:
              screenWidth * 0.04,
            ),
          for (final quiz
          in quizzes)
            Padding(
              padding:
              EdgeInsets.only(
                bottom:
                screenWidth *
                    0.03,
              ),
              child:
              buildQuizCard(
                quiz,
                screenWidth,
                colorScheme,
                theme,
              ),
            ),
          if (quizAlreadyAttempted)
            Padding(
              padding:
              EdgeInsets.only(
                top:
                screenWidth *
                    0.02,
                bottom:
                screenWidth *
                    0.04,
              ),
              child:
              buildReturnButton(
                screenWidth,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildSelectionHeader(
      double screenWidth,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Card(
      child: Padding(
        padding:
        EdgeInsets.all(
          screenWidth * 0.05,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                buildHeaderIcon(
                  screenWidth,
                  Icons.emoji_events_rounded,
                ),
                SizedBox(
                  width:
                  screenWidth * 0.04,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ready to Learn?',
                        style: theme
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Choose one quiz and test your knowledge.',
                        style: theme
                            .textTheme
                            .bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height:
              screenWidth * 0.04,
            ),
            Container(
              padding:
              EdgeInsets.all(
                screenWidth * 0.035,
              ),
              decoration:
              BoxDecoration(
                color: colorScheme
                    .primary
                    .withValues(
                  alpha: 0.08,
                ),
                borderRadius:
                BorderRadius.circular(
                  14,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color:
                    colorScheme.primary,
                  ),
                  SizedBox(
                    width:
                    screenWidth * 0.03,
                  ),
                  Expanded(
                    child: Text(
                      'Only one quiz can be attempted for this lesson. Choose carefully because the other quiz types will be locked after your attempt.',
                      style: theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAttemptedHeader(
      double screenWidth,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Card(
      child: Padding(
        padding:
        EdgeInsets.all(
          screenWidth * 0.05,
        ),
        child: Column(
          children: [
            Container(
              width:
              screenWidth * 0.18,
              height:
              screenWidth * 0.18,
              decoration:
              BoxDecoration(
                color: colorScheme
                    .primary
                    .withValues(
                  alpha: 0.12,
                ),
                shape:
                BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size:
                screenWidth * 0.10,
                color:
                colorScheme.primary,
              ),
            ),
            SizedBox(
              height:
              screenWidth * 0.035,
            ),
            Text(
              'Quiz Completed! 🎉',
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                fontWeight:
                FontWeight.w800,
                color:
                colorScheme.primary,
              ),
            ),
            SizedBox(
              height:
              screenWidth * 0.02,
            ),
            Text(
              'You have already attempted one quiz for this lesson. The other quiz types are locked.',
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium,
            ),
            SizedBox(
              height:
              screenWidth * 0.04,
            ),
            Container(
              padding:
              EdgeInsets.symmetric(
                horizontal:
                screenWidth * 0.05,
                vertical:
                screenWidth * 0.025,
              ),
              decoration:
              BoxDecoration(
                color: colorScheme
                    .surfaceContainerHighest,
                borderRadius:
                BorderRadius.circular(
                  30,
                ),
              ),
              child: Text(
                '$score / $totalQuestions  •  $percentage%',
                style: theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
              height:
              screenWidth * 0.025,
            ),
            Text(
              passed
                  ? 'Great job! You passed the quiz.'
                  : 'Keep practicing and continue learning.',
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: passed
                    ? colorScheme.primary
                    : colorScheme
                    .onSurfaceVariant,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLockMessage(
      double screenWidth,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      padding:
      EdgeInsets.all(
        screenWidth * 0.04,
      ),
      decoration:
      BoxDecoration(
        color: colorScheme
            .surfaceContainerHighest,
        borderRadius:
        BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: colorScheme
              .outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_rounded,
            color:
            colorScheme.primary,
          ),
          SizedBox(
            width:
            screenWidth * 0.03,
          ),
          Expanded(
            child: Text(
              'This lesson allows one quiz attempt only. The remaining quiz types are locked so your lesson result stays consistent.',
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuizCard(
      Quiz quiz,
      double screenWidth,
      ColorScheme colorScheme,
      ThemeData theme,
      ) {
    final bool isAttempted =
        attemptedQuizType ==
            quiz.type;

    final bool isLocked =
        quizAlreadyAttempted;

    return Card(
      child: InkWell(
        borderRadius:
        BorderRadius.circular(
          18,
        ),
        onTap: isLocked
            ? null
            : () => startQuiz(quiz),
        child: Padding(
          padding:
          EdgeInsets.all(
            screenWidth * 0.04,
          ),
          child: Row(
            children: [
              Container(
                width:
                screenWidth * 0.15,
                height:
                screenWidth * 0.15,
                decoration:
                BoxDecoration(
                  color: isAttempted
                      ? colorScheme
                      .primary
                      .withValues(
                    alpha: 0.15,
                  )
                      : isLocked
                      ? colorScheme
                      .surfaceContainerHighest
                      : colorScheme
                      .surfaceContainerHighest,
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),
                child: Icon(
                  isAttempted
                      ? Icons
                      .check_circle_rounded
                      : isLocked
                      ? Icons.lock_rounded
                      : getQuizIcon(
                    quiz.type,
                  ),
                  size:
                  screenWidth * 0.08,
                  color:
                  colorScheme.primary,
                ),
              ),
              SizedBox(
                width:
                screenWidth * 0.04,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      getQuizTypeName(
                        quiz.type,
                      ),
                      style: theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color:
                        colorScheme
                            .primary,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      isAttempted
                          ? 'Attempted ✓'
                          : isLocked
                          ? 'Locked for this lesson'
                          : 'Tap to start',
                      style: theme
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                isAttempted
                    ? Icons
                    .check_circle_rounded
                    : isLocked
                    ? Icons.lock_rounded
                    : Icons
                    .arrow_forward_ios_rounded,
                color:
                colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReturnButton(
      double screenWidth,
      ) {
    return SizedBox(
      width: double.infinity,
      child:
      ElevatedButton.icon(
        onPressed:
        returnToLesson,
        icon: const Icon(
          Icons.arrow_back_rounded,
        ),
        label: const Text(
          'Return to Lesson',
        ),
      ),
    );
  }

  Widget buildHeaderIcon(
      double screenWidth,
      IconData icon,
      ) {
    final colorScheme =
        Theme.of(context)
            .colorScheme;

    return Container(
      width:
      screenWidth * 0.15,
      height:
      screenWidth * 0.15,
      decoration:
      BoxDecoration(
        color: colorScheme
            .primary
            .withValues(
          alpha: 0.12,
        ),
        borderRadius:
        BorderRadius.circular(
          18,
        ),
      ),
      child: Icon(
        icon,
        size:
        screenWidth * 0.08,
        color:
        colorScheme.primary,
      ),
    );
  }

  Widget buildEmptyState(
      double screenWidth,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding:
        EdgeInsets.all(
          screenWidth * 0.08,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size:
              screenWidth * 0.18,
              color:
              colorScheme.primary,
            ),
            SizedBox(
              height:
              screenWidth * 0.04,
            ),
            Text(
              'No quizzes available',
              style: theme
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight:
                FontWeight.w800,
              ),
            ),
            SizedBox(
              height:
              screenWidth * 0.02,
            ),
            Text(
              'There are no quizzes available for this lesson yet.',
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}