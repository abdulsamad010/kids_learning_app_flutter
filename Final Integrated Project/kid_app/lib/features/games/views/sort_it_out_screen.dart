import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kid_app/core/common/widgets/app_button.dart';
import 'package:kid_app/core/theme/app_theme.dart';
import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/features/progress/viewmodels/progress_viewmodel.dart';

class SortItOutScreen extends StatefulWidget {
  const SortItOutScreen({super.key});

  @override
  State<SortItOutScreen> createState() => _SortItOutScreenState();
}

class _SortItOutScreenState extends State<SortItOutScreen> {
  late List<int> _items;
  late List<int> _correctOrder;
  int? _firstSelectedIndex;
  int _swaps = 0;
  bool _isCompleted = false;
  int _round = 0;
  int _totalScore = 0;
  static const int _totalRounds = 3;

  @override
  void initState() {
    super.initState();
    _initializeRound();
  }

  Future<void> _submitGameProgress(int score) async {
    if (!mounted) return;
    final childId = context.read<ChildViewModel>().selectedChild?.id;
    if (childId == null) return;
    await context.read<ProgressViewmodel>().submitGame(
          childId: childId,
          gameId: 'sort-it-out',
          score: score,
        );
  }

  void _initializeRound() {
    _correctOrder = List.generate(5, (i) => i + 1);
    _items = List.from(_correctOrder);
    do {
      _items.shuffle(Random());
    } while (_isSorted(_items));
    _firstSelectedIndex = null;
    _swaps = 0;
    _isCompleted = false;
  }

  bool _isSorted(List<int> list) {
    for (int i = 0; i < list.length - 1; i++) {
      if (list[i] > list[i + 1]) return false;
    }
    return true;
  }

  void _onItemTap(int index) {
    if (_isCompleted) return;

    setState(() {
      if (_firstSelectedIndex == null) {
        _firstSelectedIndex = index;
      } else if (_firstSelectedIndex == index) {
        _firstSelectedIndex = null;
      } else {
        final temp = _items[_firstSelectedIndex!];
        _items[_firstSelectedIndex!] = _items[index];
        _items[index] = temp;
        _swaps++;
        _firstSelectedIndex = null;

        if (_isSorted(_items)) {
          _isCompleted = true;
          final roundScore = max(1, 5 - _swaps);
          _totalScore += roundScore;

          if (_round < _totalRounds - 1) {
            _round++;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showRoundCompleteDialog(roundScore);
            });
          } else {
            _round++;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showFinalCompletionDialog();
            });
          }
        }
      }
    });
  }

  void _showRoundCompleteDialog(int roundScore) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 64, color: AppTheme.successColor),
            const SizedBox(height: 16),
            Text(
              'Sorted!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Completed in $_swaps swaps',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Next Round',
              icon: Icons.arrow_forward,
              width: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _initializeRound());
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFinalCompletionDialog() async {
    final colorScheme = Theme.of(context).colorScheme;
    final stars = _totalScore >= 12 ? 3 : _totalScore >= 8 ? 2 : _totalScore >= 4 ? 1 : 0;
    await _submitGameProgress(_totalScore);
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
              'All Done!',
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
                  color: i < stars ? AppTheme.accentColor : colorScheme.outline,
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Score: $_totalScore',
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
                  _round = 0;
                  _totalScore = 0;
                  _initializeRound();
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

    return Scaffold(
      appBar: AppBar(title: const Text('Sort It Out')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Round ${_round + 1}/$_totalRounds',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Swaps: $_swaps',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (_round + 1) / _totalRounds,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Tap two items to swap them into the correct order (1-5).',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Select a number to swap it.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final isSelected = _firstSelectedIndex == index;
                  final isCorrectPosition = item == _correctOrder[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _onItemTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary.withValues(alpha: 0.15)
                              : isCorrectPosition
                                  ? AppTheme.successColor.withValues(alpha: 0.1)
                                  : colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : isCorrectPosition
                                    ? AppTheme.successColor.withValues(alpha: 0.5)
                                    : colorScheme.outline.withValues(alpha: 0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colorScheme.primary
                                    : isCorrectPosition
                                        ? AppTheme.successColor
                                        : colorScheme.surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isSelected || isCorrectPosition
                                      ? Colors.white
                                      : colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                '$item',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            if (isCorrectPosition && !_isCompleted)
                              Icon(
                                Icons.check,
                                color: AppTheme.successColor,
                              ),
                            if (isSelected)
                              Icon(
                                Icons.swap_horiz,
                                color: colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
