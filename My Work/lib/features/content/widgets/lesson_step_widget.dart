import 'package:flutter/material.dart';

import '../../quiz/screens/quiz_selection_screen.dart';
import '../models/lesson_step.dart';


class LessonStepWidget extends StatelessWidget {
  final LessonStep lessonStep;
  final Map<String, dynamic> quizResult;
  final Map<String, dynamic> lessonProgress;
  final Future<void> Function(
      Map<String, dynamic>,
      ) onQuizCompleted;

  const LessonStepWidget({
    super.key,
    required this.lessonStep,
    required this.quizResult,
    required this.lessonProgress,
    required this.onQuizCompleted,
  });

  Future<void> openQuiz(
      BuildContext context,
      ) async {
    final result =
    await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QuizSelectionScreen(
              subjectId:
              lessonStep.subjectId,
              lessonId:
              lessonStep.lessonId,
              quizResult:
              Map<String, dynamic>.from(
                quizResult,
              ),
            ),
      ),
    );

    if (result == null ||
        result.isEmpty) {
      return;
    }

    await onQuizCompleted(result);
  }

  @override
  Widget build(BuildContext context) {
    switch (lessonStep.type) {
      case 'quiz':
        return buildQuizStep(context);

      case 'completion':
      case 'report':
      case 'learning_report':
        return buildLearningReport(context);

      case 'reward':
        return buildRewardStep(context);

      case 'example':
        return buildContentStep(
          context,
          Icons.lightbulb_rounded,
          'Example',
        );

      case 'activity':
        return buildContentStep(
          context,
          Icons.extension_rounded,
          'Activity',
        );

      case 'text':
      default:
        return buildContentStep(
          context,
          Icons.menu_book_rounded,
          'Learn',
        );
    }
  }

  Widget buildQuizStep(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final bool quizCompleted =
        quizResult.isNotEmpty;

    return Card(
      child: Padding(
        padding:
        const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration:
              BoxDecoration(
                color: colorScheme
                    .primaryContainer,
                shape:
                BoxShape.circle,
              ),
              child: Icon(
                quizCompleted
                    ? Icons
                    .check_circle_rounded
                    : Icons.quiz_rounded,
                size: 42,
                color: colorScheme
                    .onPrimaryContainer,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              lessonStep.title,
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                fontWeight:
                FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              quizCompleted
                  ? 'You have already completed the quiz for this lesson.'
                  : 'Choose ONE quiz type and complete it. Only one quiz can be attempted for this lesson.',
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            if (quizCompleted)
              buildCompletedQuizSummary(
                context,
              )
            else
              SizedBox(
                width:
                double.infinity,
                child:
                ElevatedButton.icon(
                  onPressed: () =>
                      openQuiz(context),
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                  ),
                  label: const Text(
                    'Choose Quiz',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCompletedQuizSummary(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final int score =
        quizResult['score'] ?? 0;

    final int totalQuestions =
        quizResult['totalQuestions'] ??
            0;

    final int percentage =
        quizResult['percentage'] ?? 0;

    final bool passed =
        quizResult['passed'] ?? false;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(18),
      decoration:
      BoxDecoration(
        color: colorScheme
            .surfaceContainerHighest,
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            'Quiz Result',
            style: theme
                .textTheme
                .titleLarge
                ?.copyWith(
              fontWeight:
              FontWeight.w800,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            '$score / $totalQuestions',
            style: theme
                .textTheme
                .displaySmall
                ?.copyWith(
              fontWeight:
              FontWeight.w800,
              color:
              colorScheme.primary,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            '$percentage%',
            style: theme
                .textTheme
                .titleMedium
                ?.copyWith(
              fontWeight:
              FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            passed
                ? 'Great job! You passed the quiz.'
                : 'Keep practicing and keep learning!',
            textAlign:
            TextAlign.center,
            style: theme
                .textTheme
                .bodyLarge
                ?.copyWith(
              fontWeight:
              FontWeight.w700,
              color: passed
                  ? colorScheme.primary
                  : colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLearningReport(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final bool hasResult =
        quizResult.isNotEmpty;

    final int score =
        quizResult['score'] ?? 0;

    final int totalQuestions =
        quizResult['totalQuestions'] ??
            0;

    final int percentage =
        quizResult['percentage'] ?? 0;

    final bool passed =
        quizResult['passed'] ?? false;

    final int previousLevel =
        lessonProgress[
        'previousLevel'] ??
            1;

    final int currentLevel =
        lessonProgress[
        'currentLevel'] ??
            1;

    final String levelChange =
        lessonProgress[
        'levelChange'] ??
            'retain';

    return Card(
      child: Padding(
        padding:
        const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.assessment_rounded,
              size: 58,
              color:
              colorScheme.primary,
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              lessonStep.title.isEmpty
                  ? 'Your Learning Report'
                  : lessonStep.title,
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                fontWeight:
                FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              hasResult
                  ? 'Review your quiz performance and learning progress.'
                  : 'Complete the quiz to see your learning report.',
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            if (!hasResult)
              buildMissingResult(
                context,
              )
            else
              Column(
                children: [
                  buildReportItem(
                    context,
                    Icons.check_circle_rounded,
                    'Correct Answers',
                    '$score / $totalQuestions',
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  buildReportItem(
                    context,
                    Icons.percent_rounded,
                    'Percentage',
                    '$percentage%',
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  buildReportItem(
                    context,
                    passed
                        ? Icons
                        .emoji_events_rounded
                        : Icons
                        .menu_book_rounded,
                    'Result',
                    passed
                        ? 'Passed'
                        : 'Keep Practicing',
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  buildReportItem(
                    context,
                    Icons.history_rounded,
                    'Previous Level',
                    'Level $previousLevel',
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  buildReportItem(
                    context,
                    Icons.star_rounded,
                    'Your Level',
                    'Level $currentLevel',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    levelChange == 'up'
                        ? '🎉 You moved up a level!'
                        : levelChange == 'down'
                        ? 'Keep practicing to improve your level.'
                        : 'Keep up the good work!',
                    textAlign:
                    TextAlign.center,
                    style: theme
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w800,
                      color: colorScheme
                          .primary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildMissingResult(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(18),
      decoration:
      BoxDecoration(
        color: colorScheme
            .surfaceContainerHighest,
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 42,
            color:
            colorScheme.primary,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'No quiz result available yet.',
            textAlign:
            TextAlign.center,
            style: theme
                .textTheme
                .bodyLarge
                ?.copyWith(
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReportItem(
      BuildContext context,
      IconData icon,
      String title,
      String value,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration:
      BoxDecoration(
        color: colorScheme
            .surfaceContainerHighest,
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color:
            colorScheme.primary,
            size: 28,
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Text(
              title,
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: theme
                .textTheme
                .titleMedium
                ?.copyWith(
              fontWeight:
              FontWeight.w800,
              color:
              colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContentStep(
      BuildContext context,
      IconData icon,
      String label,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Card(
      child: Padding(
        padding:
        const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration:
              BoxDecoration(
                color: colorScheme
                    .primaryContainer,
                shape:
                BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 42,
                color: colorScheme
                    .onPrimaryContainer,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              label,
              style: theme
                  .textTheme
                  .labelLarge
                  ?.copyWith(
                color:
                colorScheme.primary,
                fontWeight:
                FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              lessonStep.title,
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                fontWeight:
                FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(
                20,
              ),
              decoration:
              BoxDecoration(
                color: colorScheme
                    .surfaceContainerHighest,
                borderRadius:
                BorderRadius.circular(
                  18,
                ),
              ),
              child: Text(
                lessonStep.content,
                textAlign:
                TextAlign.center,
                style: theme
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRewardStep(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final int percentage =
        quizResult['percentage'] ?? 0;

    return Card(
      child: Padding(
        padding:
        const EdgeInsets.all(28),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events_rounded,
              size: 78,
              color:
              colorScheme.primary,
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              lessonStep.title,
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                fontWeight:
                FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              lessonStep.content,
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                height: 1.5,
              ),
            ),
            if (quizResult.isNotEmpty) ...[
              const SizedBox(
                height: 20,
              ),
              Text(
                '$percentage%',
                style: theme
                    .textTheme
                    .displaySmall
                    ?.copyWith(
                  fontWeight:
                  FontWeight.w800,
                  color:
                  colorScheme.primary,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Quiz Score',
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}