import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../models/lesson_step.dart';
import '../services/content_service.dart';
import '../widgets/lesson_step_widget.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final ContentService contentService =
  ContentService();

  List<LessonStep> lessonSteps = [];

  int currentStep = 0;

  bool isLoading = true;
  bool isSavingProgress = false;

  Map<String, dynamic> quizResult = {};

  Map<String, dynamic> lessonProgress = {
    'previousLevel': 1,
    'currentLevel': 1,
    'levelChange': 'retain',
    'percentage': 0,
    'passed': false,
    'resultSaved': false,
  };

  @override
  void initState() {
    super.initState();
    loadLessonSteps();
  }

  Future<void> loadLessonSteps() async {
    try {
      final data =
      await contentService.getLessonSteps(
        widget.lesson.subjectId,
        widget.lesson.lessonId,
      );

      final loadedSteps = <LessonStep>[];

      for (final item in data) {
        loadedSteps.add(
          LessonStep(
            lessonStepId: item['lessonStepId'],
            lessonId: item['lessonId'],
            subjectId: item['subjectId'],
            type: item['type'],
            title: item['title'],
            content: item['content'],
          ),
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        lessonSteps = loadedSteps;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        lessonSteps = [];
        isLoading = false;
      });
    }
  }

  Future<void> handleQuizCompleted(
      Map<String, dynamic> result,
      ) async {
    if (result.isEmpty) {
      return;
    }

    final int score =
        result['score'] ?? 0;

    final int totalQuestions =
        result['totalQuestions'] ?? 0;

    if (totalQuestions <= 0) {
      return;
    }

    final int percentage =
        result['percentage'] ??
            ((score / totalQuestions) * 100).round();

    final bool passed =
        result['passed'] ??
            percentage >= 50;

    setState(() {
      quizResult
        ..clear()
        ..addAll(result);

      quizResult['percentage'] =
          percentage;

      quizResult['passed'] =
          passed;

      calculateQuizProgress();
    });

    await saveProgress();
  }

  int calculateLevel(int percentage) {
    if (percentage >= 80) {
      return 4;
    }

    if (percentage >= 60) {
      return 3;
    }

    if (percentage >= 40) {
      return 2;
    }

    return 1;
  }

  void calculateQuizProgress() {
    final int score =
        quizResult['score'] ?? 0;

    final int totalQuestions =
        quizResult['totalQuestions'] ?? 0;

    if (totalQuestions <= 0) {
      return;
    }

    final int percentage =
        quizResult['percentage'] ??
            ((score / totalQuestions) * 100).round();

    final bool passed =
        quizResult['passed'] ??
            percentage >= 50;

    final int previousLevel =
        lessonProgress['currentLevel'] ?? 1;

    final int currentLevel =
    calculateLevel(percentage);

    String levelChange = 'retain';

    if (currentLevel > previousLevel) {
      levelChange = 'up';
    } else if (currentLevel < previousLevel) {
      levelChange = 'down';
    }

    lessonProgress['previousLevel'] =
        previousLevel;

    lessonProgress['currentLevel'] =
        currentLevel;

    lessonProgress['levelChange'] =
        levelChange;

    lessonProgress['percentage'] =
        percentage;

    lessonProgress['passed'] =
        passed;
  }

  Future<void> saveProgress() async {
    if (quizResult.isEmpty) {
      return;
    }

    if (lessonProgress['resultSaved'] ==
        true) {
      return;
    }

    if (isSavingProgress) {
      return;
    }

    calculateQuizProgress();

    if (!mounted) {
      return;
    }

    setState(() {
      isSavingProgress = true;
    });

    final bool saved =
    await contentService.saveLessonProgress(
      widget.lesson.subjectId,
      widget.lesson.lessonId,
      quizResult,
      lessonProgress,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      isSavingProgress = false;
      lessonProgress['resultSaved'] =
          saved;
    });
  }

  bool isResultStep(String type) {
    return type == 'completion' ||
        type == 'report' ||
        type == 'learning_report' ||
        type == 'reward';
  }

  Future<void> moveToNextStep() async {
    if (lessonSteps.isEmpty) {
      return;
    }

    if (currentStep >=
        lessonSteps.length - 1) {
      return;
    }

    if (isSavingProgress) {
      return;
    }

    final int nextStep =
        currentStep + 1;

    final String nextStepType =
        lessonSteps[nextStep].type;

    if (isResultStep(nextStepType) &&
        quizResult.isNotEmpty &&
        lessonProgress['resultSaved'] !=
            true) {
      await saveProgress();
    }

    if (!mounted) {
      return;
    }

    setState(() {
      currentStep = nextStep;
    });
  }

  void moveToPreviousStep() {
    if (currentStep <= 0) {
      return;
    }

    if (isSavingProgress) {
      return;
    }

    setState(() {
      currentStep--;
    });
  }

  double get stepProgress {
    if (lessonSteps.isEmpty) {
      return 0;
    }

    return (currentStep + 1) /
        lessonSteps.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lesson.title,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
          child:
          CircularProgressIndicator(
            color:
            colorScheme.primary,
          ),
        )
            : lessonSteps.isEmpty
            ? buildEmptyState(
          theme,
          colorScheme,
        )
            : Column(
          children: [
            buildProgressHeader(
              theme,
              colorScheme,
            ),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets
                    .fromLTRB(
                  16,
                  4,
                  16,
                  8,
                ),
                child:
                SingleChildScrollView(
                  physics:
                  const BouncingScrollPhysics(),
                  padding:
                  const EdgeInsets
                      .only(
                    bottom: 12,
                  ),
                  child:
                  AnimatedSwitcher(
                    duration:
                    const Duration(
                      milliseconds:
                      350,
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
                              0.04,
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
                    LessonStepWidget(
                      key: ValueKey(
                        currentStep,
                      ),
                      lessonStep:
                      lessonSteps[
                      currentStep],
                      quizResult:
                      quizResult,
                      lessonProgress:
                      lessonProgress,
                      onQuizCompleted:
                      handleQuizCompleted,
                    ),
                  ),
                ),
              ),
            ),
            buildNavigation(
              theme,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProgressHeader(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        18,
        14,
        18,
        8,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 21,
                color:
                colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Lesson Progress',
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 11,
                  vertical: 5,
                ),
                decoration:
                BoxDecoration(
                  color: colorScheme
                      .primaryContainer,
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),
                child: Text(
                  '${currentStep + 1} / ${lessonSteps.length}',
                  style: theme
                      .textTheme
                      .labelLarge
                      ?.copyWith(
                    color: colorScheme
                        .onPrimaryContainer,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius:
            BorderRadius.circular(20),
            child:
            LinearProgressIndicator(
              value: stepProgress,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavigation(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    final bool canGoBack =
        currentStep > 0;

    final bool canGoNext =
        currentStep <
            lessonSteps.length - 1;

    return Container(
      padding:
      const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        16,
      ),
      decoration:
      BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withValues(
              alpha: 0.08,
            ),
            blurRadius: 12,
            offset:
            const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child:
            OutlinedButton.icon(
              onPressed: canGoBack
                  ? moveToPreviousStep
                  : null,
              icon: const Icon(
                Icons.arrow_back_rounded,
              ),
              label:
              const Text('Back'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child:
            ElevatedButton.icon(
              onPressed:
              canGoNext &&
                  !isSavingProgress
                  ? moveToNextStep
                  : null,
              icon: isSavingProgress
                  ? const SizedBox(
                width: 18,
                height: 18,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : Icon(
                canGoNext
                    ? Icons
                    .arrow_forward_rounded
                    : Icons
                    .check_rounded,
              ),
              label: Text(
                isSavingProgress
                    ? 'Saving...'
                    : canGoNext
                    ? 'Next'
                    : 'Completed',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState(
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(28),
        child: Card(
          child: Padding(
            padding:
            const EdgeInsets.all(30),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration:
                  BoxDecoration(
                    color: colorScheme
                        .surfaceContainerHighest,
                    shape:
                    BoxShape.circle,
                  ),
                  child: Icon(
                    Icons
                        .menu_book_outlined,
                    size: 42,
                    color: colorScheme
                        .onSurfaceVariant,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  'No Lesson Content',
                  textAlign:
                  TextAlign.center,
                  style: theme.textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  'There is no content available for this lesson yet.',
                  textAlign:
                  TextAlign.center,
                  style: theme.textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}