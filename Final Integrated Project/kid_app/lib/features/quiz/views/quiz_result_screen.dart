import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kid_app/core/common/widgets/app_button.dart';
import 'package:kid_app/core/theme/app_theme.dart';
import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/features/progress/viewmodels/progress_viewmodel.dart';
import 'package:kid_app/features/quiz/viewmodels/quiz_viewmodel.dart';

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late Map<String, dynamic> _args;
  bool _initialized = false;
  bool _progressSubmitted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _initialized = true;
      _submitProgress();
    }
  }

  Future<void> _submitProgress() async {
    if (_progressSubmitted) return;
    _progressSubmitted = true;

    final childId = context.read<ChildViewModel>().selectedChild?.id;
    if (childId == null) return;

    final lessonId = _args['lessonId'] as String;

    await context.read<ProgressViewmodel>().submitQuiz(
          childId: childId,
          quizId: lessonId,
          score: _args['correctAnswers'] as int,
        );
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = _args['totalQuestions'] as int;
    final correctAnswers = _args['correctAnswers'] as int;
    final stars = _args['stars'] as int;
    final lessonId = _args['lessonId'] as String;
    final percentage = totalQuestions > 0
        ? (correctAnswers / totalQuestions * 100).round()
        : 0;
    final colorScheme = Theme.of(context).colorScheme;

    String message;
    if (percentage >= 90) {
      message = 'Excellent!';
    } else if (percentage >= 70) {
      message = 'Good job!';
    } else if (percentage >= 50) {
      message = 'Keep practicing!';
    } else {
      message = 'Try again!';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Result')),
      body: Stack(
        children: [
          if (percentage >= 70)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primaryContainer.withValues(alpha: 0.3),
                      colorScheme.surface,
                    ],
                  ),
                ),
              ),
            ),
          if (percentage >= 90)
            Positioned.fill(
              child: CustomPaint(
                painter: _ConfettiPainter(),
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (percentage >= 70) ...[
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        size: 48,
                        color: AppTheme.accentColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    message,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$correctAnswers/$totalQuestions',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$percentage% correct',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          index < stars ? Icons.star : Icons.star_border,
                          size: 48,
                          color:
                              index < stars ? AppTheme.accentColor : colorScheme.outline,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    text: 'Retry',
                    isOutlined: true,
                    icon: Icons.refresh,
                    width: double.infinity,
                    onPressed: () {
                      context.read<QuizViewmodel>().resetQuiz();
                      Navigator.pushReplacementNamed(
                        context,
                        '/quiz',
                        arguments: lessonId,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Continue',
                    icon: Icons.arrow_forward,
                    width: double.infinity,
                    onPressed: () {
                      Navigator.of(context).popUntil((route) {
                        return route.settings.name == '/lesson' ||
                            route.settings.name == '/child-home';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = [
      {'x': 0.1, 'y': 0.1, 'color': Colors.red},
      {'x': 0.3, 'y': 0.05, 'color': Colors.blue},
      {'x': 0.5, 'y': 0.15, 'color': Colors.green},
      {'x': 0.7, 'y': 0.08, 'color': Colors.orange},
      {'x': 0.9, 'y': 0.12, 'color': Colors.purple},
      {'x': 0.2, 'y': 0.25, 'color': Colors.yellow},
      {'x': 0.8, 'y': 0.22, 'color': Colors.pink},
      {'x': 0.15, 'y': 0.35, 'color': Colors.teal},
      {'x': 0.85, 'y': 0.38, 'color': Colors.amber},
      {'x': 0.45, 'y': 0.02, 'color': Colors.cyan},
    ];

    for (final dot in random) {
      final paint = Paint()
        ..color = (dot['color'] as Color).withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;

      final center = Offset(
        (dot['x'] as double) * size.width,
        (dot['y'] as double) * size.height,
      );
      canvas.drawCircle(center, 6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
