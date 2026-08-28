import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kid_app/core/common/widgets/app_button.dart';
import 'package:kid_app/core/theme/app_theme.dart';
import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/features/progress/viewmodels/progress_viewmodel.dart';

class CountingTapScreen extends StatefulWidget {
  const CountingTapScreen({super.key});

  @override
  State<CountingTapScreen> createState() => _CountingTapScreenState();
}

class _CountingTapScreenState extends State<CountingTapScreen> {
  late List<_CountingRound> _rounds;
  int _currentRound = 0;
  int _correctAnswers = 0;
  int _selectedCount = 0;
  bool _answered = false;
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
          gameId: 'counting-tap',
          score: score,
        );
  }

  void _generateRounds() {
    final items = [
      _CountingItem(emoji: '🍎', name: 'apples'),
      _CountingItem(emoji: '🐱', name: 'cats'),
      _CountingItem(emoji: '⭐', name: 'stars'),
      _CountingItem(emoji: '🌸', name: 'flowers'),
      _CountingItem(emoji: '🦋', name: 'butterflies'),
      _CountingItem(emoji: '🎈', name: 'balloons'),
      _CountingItem(emoji: '🍓', name: 'strawberries'),
      _CountingItem(emoji: '🐟', name: 'fish'),
    ];

    items.shuffle(Random());
    final selected = items.take(_totalRounds).toList();

    _rounds = selected.map((item) {
      final count = Random().nextInt(6) + 3;
      final positions = <Offset>[];
      final rng = Random();

      for (int i = 0; i < count; i++) {
        positions.add(Offset(
          0.1 + rng.nextDouble() * 0.7,
          0.1 + rng.nextDouble() * 0.6,
        ));
      }

      return _CountingRound(
        item: item,
        count: count,
        positions: positions,
      );
    }).toList();
  }

  void _submitAnswer() {
    if (_answered) return;

    setState(() {
      _answered = true;
      if (_selectedCount == _rounds[_currentRound].count) {
        _correctAnswers++;
      }
    });
  }

  void _nextRound() {
    if (_currentRound < _totalRounds - 1) {
      setState(() {
        _currentRound++;
        _selectedCount = 0;
        _answered = false;
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
              'Great Counting!',
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
                  _selectedCount = 0;
                  _answered = false;
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
      appBar: AppBar(title: const Text('Counting Tap')),
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
            const SizedBox(height: 24),
            Text(
              'How many ${round.item.name}?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Stack(
                  children: [
                    ...List.generate(round.count, (index) {
                      final pos = round.positions[index];
                      return Positioned(
                        left: pos.dx * MediaQuery.of(context).size.width * 0.6,
                        top: pos.dy * 300,
                        child: Text(
                          round.item.emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCountButton(
                  context,
                  icon: Icons.remove,
                  onTap: _selectedCount > 0 && !_answered
                      ? () => setState(() => _selectedCount--)
                      : null,
                ),
                const SizedBox(width: 24),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _answered
                        ? _selectedCount == round.count
                            ? AppTheme.successColor.withValues(alpha: 0.15)
                            : AppTheme.errorColor.withValues(alpha: 0.15)
                        : colorScheme.primaryContainer.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _answered
                          ? _selectedCount == round.count
                              ? AppTheme.successColor
                              : AppTheme.errorColor
                          : colorScheme.primary,
                      width: 3,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$_selectedCount',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                  ),
                ),
                const SizedBox(width: 24),
                _buildCountButton(
                  context,
                  icon: Icons.add,
                  onTap: !_answered
                      ? () => setState(() => _selectedCount++)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_answered)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _selectedCount == round.count
                      ? 'Correct!'
                      : 'The answer was ${round.count}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _selectedCount == round.count
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            AppButton(
              text: _answered
                  ? (_currentRound < _totalRounds - 1
                      ? 'Next Round'
                      : 'See Results')
                  : 'Submit',
              icon: _answered ? Icons.arrow_forward : Icons.check,
              width: double.infinity,
              onPressed: _answered ? _nextRound : _submitAnswer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: onTap != null
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 28,
          color: onTap != null
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _CountingItem {
  final String emoji;
  final String name;

  const _CountingItem({required this.emoji, required this.name});
}

class _CountingRound {
  final _CountingItem item;
  final int count;
  final List<Offset> positions;

  const _CountingRound({
    required this.item,
    required this.count,
    required this.positions,
  });
}
