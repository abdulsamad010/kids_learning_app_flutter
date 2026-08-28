import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kid_app/core/common/widgets/app_button.dart';
import 'package:kid_app/core/theme/app_theme.dart';
import 'package:kid_app/features/quiz/models/quiz_question_model.dart';
import 'package:kid_app/features/quiz/viewmodels/quiz_viewmodel.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late String _lessonId;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Map<String, dynamic>) {
        _lessonId = args['lessonId'] as String;
      } else if (args is String) {
        _lessonId = args;
      } else {
        _lessonId = '';
      }
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<QuizViewmodel>().loadQuestions(_lessonId);
      });
    }
  }

  void _onAnswerSelected(String answer) {
    final quiz = context.read<QuizViewmodel>();
    if (quiz.isAnswered) return;
    quiz.selectAnswer(answer);
    quiz.submitAnswer();
  }

  void _onNext() {
    final quiz = context.read<QuizViewmodel>();
    quiz.nextQuestion();
    if (quiz.isCompleted) {
      final percentage =
          quiz.totalQuestions > 0 ? (quiz.score / quiz.totalQuestions) * 100 : 0;
      int stars;
      if (percentage >= 90) {
        stars = 3;
      } else if (percentage >= 70) {
        stars = 2;
      } else if (percentage >= 50) {
        stars = 1;
      } else {
        stars = 0;
      }
      Navigator.pushReplacementNamed(
        context,
        '/quiz-result',
        arguments: {
          'totalQuestions': quiz.totalQuestions,
          'correctAnswers': quiz.score,
          'lessonId': _lessonId,
          'stars': stars,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizViewmodel>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              value: quiz.progress,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor:
                  AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
        ),
      ),
      body: quiz.isLoading
          ? const Center(child: CircularProgressIndicator())
          : quiz.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        quiz.errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.error),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        text: 'Retry',
                        onPressed: () => quiz.loadQuestions(_lessonId),
                      ),
                    ],
                  ),
                )
              : quiz.currentQuestion == null
                  ? const Center(child: Text('No questions available.'))
                  : _buildQuestionBody(context, quiz),
    );
  }

  Widget _buildQuestionBody(BuildContext context, QuizViewmodel quiz) {
    final question = quiz.currentQuestion!;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Question ${quiz.currentQuestionIndex + 1} of ${quiz.totalQuestions}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            question.question,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _buildQuestionContent(context, quiz, question),
          ),
          if (quiz.isAnswered && question.explanation != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline,
                      color: colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question.explanation!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (quiz.isAnswered)
            AppButton(
              text: quiz.currentQuestionIndex < quiz.totalQuestions - 1
                  ? 'Next'
                  : 'Finish',
              onPressed: _onNext,
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(
    BuildContext context,
    QuizViewmodel quiz,
    QuizQuestionModel question,
  ) {
    switch (question.type) {
      case 'multiple_choice':
        return _buildMCQ(context, quiz, question);
      case 'true_false':
        return _buildTrueFalse(context, quiz, question);
      case 'matching':
        return _buildMatching(context, quiz, question);
      default:
        return _buildMCQ(context, quiz, question);
    }
  }

  Widget _buildMCQ(
    BuildContext context,
    QuizViewmodel quiz,
    QuizQuestionModel question,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final options = question.options ?? [];

    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = quiz.selectedAnswer == option.id;
        final isCorrect = option.id == question.correctAnswer;
        Color? bgColor;
        Color? borderColor;

        if (quiz.isAnswered) {
          if (isCorrect) {
            bgColor = AppTheme.successColor.withValues(alpha: 0.15);
            borderColor = AppTheme.successColor;
          } else if (isSelected && !isCorrect) {
            bgColor = AppTheme.errorColor.withValues(alpha: 0.15);
            borderColor = AppTheme.errorColor;
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: bgColor ?? colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: borderColor ?? colorScheme.outline.withValues(alpha: 0.3),
                width: quiz.isAnswered && (isCorrect || isSelected) ? 2 : 1,
              ),
            ),
            child: InkWell(
              onTap: quiz.isAnswered ? null : () => _onAnswerSelected(option.id),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCorrect && quiz.isAnswered
                            ? AppTheme.successColor
                            : isSelected && !isCorrect && quiz.isAnswered
                                ? AppTheme.errorColor
                                : colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: quiz.isAnswered && isCorrect
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : quiz.isAnswered && isSelected && !isCorrect
                              ? const Icon(Icons.close,
                                  color: Colors.white, size: 18)
                              : Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option.text,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrueFalse(
    BuildContext context,
    QuizViewmodel quiz,
    QuizQuestionModel question,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildTrueFalseButton(
            context,
            quiz: quiz,
            label: 'True',
            value: 'true',
            correctAnswer: question.correctAnswer,
            color: AppTheme.successColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTrueFalseButton(
            context,
            quiz: quiz,
            label: 'False',
            value: 'false',
            correctAnswer: question.correctAnswer,
            color: AppTheme.errorColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTrueFalseButton(
    BuildContext context, {
    required QuizViewmodel quiz,
    required String label,
    required String value,
    required String correctAnswer,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = quiz.selectedAnswer == value;
    final isCorrect = value == correctAnswer.toLowerCase();
    Color? bgColor;
    Color? borderColor;

    if (quiz.isAnswered) {
      if (isCorrect) {
        bgColor = AppTheme.successColor.withValues(alpha: 0.15);
        borderColor = AppTheme.successColor;
      } else if (isSelected && !isCorrect) {
        bgColor = AppTheme.errorColor.withValues(alpha: 0.15);
        borderColor = AppTheme.errorColor;
      }
    }

    return Material(
      color: bgColor ?? colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: borderColor ?? colorScheme.outline.withValues(alpha: 0.3),
          width: quiz.isAnswered && (isCorrect || isSelected) ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: quiz.isAnswered ? null : () => _onAnswerSelected(value),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                value == 'true' ? Icons.check_circle : Icons.cancel,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatching(
    BuildContext context,
    QuizViewmodel quiz,
    QuizQuestionModel question,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final pairs = question.matchingPairs ?? [];

    return ListView.builder(
      itemCount: pairs.length,
      itemBuilder: (context, index) {
        final pair = pairs[index];
        final isCorrect =
            quiz.isAnswered && quiz.selectedAnswer?.contains(pair.left) == true;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: isCorrect
              ? AppTheme.successColor.withValues(alpha: 0.1)
              : colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      pair.left,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.arrow_forward,
                    color: colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      pair.right,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
