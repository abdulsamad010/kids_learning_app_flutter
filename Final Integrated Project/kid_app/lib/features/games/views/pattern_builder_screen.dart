import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kid_app/core/common/widgets/app_button.dart';
import 'package:kid_app/core/theme/app_theme.dart';
import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/features/progress/viewmodels/progress_viewmodel.dart';

class PatternBuilderScreen extends StatefulWidget {
  const PatternBuilderScreen({super.key});

  @override
  State<PatternBuilderScreen> createState() => _PatternBuilderScreenState();
}

class _PatternBuilderScreenState extends State<PatternBuilderScreen> {
  late List<_PatternRound> _rounds;
  int _currentRound = 0;
  int _correctAnswers = 0;
  bool _answered = false;
  String? _selectedAnswer;
  static const int _totalRounds = 5;

  @override
  void initState() {
    super.initState();
    _generateRounds();
  }

  Future<void> _submitGameProgress(int score) async {
    if (!mounted) return;
    final childId = context.read<ChildViewModel>().selectedChild?.id;
    if (childId == null) return;
    await context.read<ProgressViewmodel>().submitGame(
          childId: childId,
          gameId: 'pattern-builder',
          score: score,
        );
  }

  void _generateRounds() {
    final patterns = [
      _PatternRound(
        sequence: const ['🔴', '🔵', '🔴', '🔵', '🔴'],
        answer: '🔵',
        options: const ['🔴', '🔵', '🟡', '🟢'],
      ),
      _PatternRound(
        sequence: const ['⭐', '🌟', '⭐', '🌟', '⭐'],
        answer: '🌟',
        options: const ['⭐', '🌟', '🌈', '✨'],
      ),
      _PatternRound(
        sequence: const ['🍎', '🍎', '🍊', '🍎', '🍎'],
        answer: '🍊',
        options: const ['🍎', '🍊', '🍋', '🍓'],
      ),
      _PatternRound(
        sequence: const ['🧩', '🧪', '🔬', '🧩', '🧪'],
        answer: '🔬',
        options: const ['🧩', '🧪', '🔬', '🧬'],
      ),
      _PatternRound(
        sequence: const ['💧', '💨', '💦', '💧', '💨'],
        answer: '💦',
        options: const ['💧', '💨', '💦', '🌧'],
      ),
    ];

    patterns.shuffle(Random());
    _rounds = patterns.take(_totalRounds).toList();
  }

  void _onAnswerSelected(String answer) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      if (answer == _rounds[_currentRound].answer) {
        _correctAnswers++;
      }
    });
  }

  void _nextRound() {
    if (_currentRound < _totalRounds - 1) {
      setState(() {
        _currentRound++;
        _answered = false;
        _selectedAnswer = null;
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCompletionDialog();
      });
    }
  }

  void _showCompletionDialog() async {
    final colorScheme = Theme.of(context).colorScheme;
    final stars = _correctAnswers >= 4
        ? 3
        : _correctAnswers >= 3
            ? 2
            : _correctAnswers >= 2
                ? 1
                : 0;
    await _submitGameProgress(_correctAnswers);
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pattern Complete!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Icon(
                  i < stars ? Icons.star : Icons.star_border,
                  size: 40,
                  color:
                      i < stars ? AppTheme.accentColor : colorScheme.outline,
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              '$_correctAnswers/$_totalRounds correct',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Play Again',
              icon: Icons.refresh,
              width: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentRound = 0;
                  _correctAnswers = 0;
                  _answered = false;
                  _selectedAnswer = null;
                  _generateRounds();
                });
              },
            ),
            const SizedBox(height: 8),
            AppButton(
              text: 'Back',
              isOutlined: true,
              width: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final round = _rounds[_currentRound];

    return Scaffold(
      appBar: AppBar(title: const Text('Pattern Builder')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Round ${_currentRound + 1}/$_totalRounds',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Score: $_correctAnswers',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (_currentRound + 1) / _totalRounds,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            const SizedBox(height: 40),
            Text(
              'Complete the pattern:',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...round.sequence.map((emoji) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(emoji,
                            style: const TextStyle(fontSize: 40)),
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('❓',
                        style: TextStyle(fontSize: 40)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Choose the missing element:',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: round.options.map((option) {
                  final isSelected = _selectedAnswer == option;
                  final isCorrect = option == round.answer;
                  Color bgColor = colorScheme.surface;
                  Color borderColor = colorScheme.outline.withValues(alpha: 0.3);

                  if (_answered) {
                    if (isCorrect) {
                      bgColor = AppTheme.successColor.withValues(alpha: 0.15);
                      borderColor = AppTheme.successColor;
                    } else if (isSelected && !isCorrect) {
                      bgColor = AppTheme.errorColor.withValues(alpha: 0.15);
                      borderColor = AppTheme.errorColor;
                    }
                  }

                  return GestureDetector(
                    onTap: () => _onAnswerSelected(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: borderColor,
                          width: isSelected || (_answered && isCorrect) ? 2 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (_answered) ...[
              const SizedBox(height: 16),
              Text(
                _selectedAnswer == round.answer
                    ? 'Correct!'
                    : 'The answer was ${round.answer}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _selectedAnswer == round.answer
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              AppButton(
                text: _currentRound < _totalRounds - 1
                    ? 'Next Pattern'
                    : 'See Results',
                icon: Icons.arrow_forward,
                width: double.infinity,
                onPressed: _nextRound,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PatternRound {
  final List<String> sequence;
  final String answer;
  final List<String> options;

  const _PatternRound({
    required this.sequence,
    required this.answer,
    required this.options,
  });
}
