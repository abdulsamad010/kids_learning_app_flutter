import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kid_app/core/common/widgets/app_button.dart';
import 'package:kid_app/core/theme/app_theme.dart';
import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/features/progress/viewmodels/progress_viewmodel.dart';

class MatchingPairsScreen extends StatefulWidget {
  const MatchingPairsScreen({super.key});

  @override
  State<MatchingPairsScreen> createState() => _MatchingPairsScreenState();
}

class _MatchingPairsScreenState extends State<MatchingPairsScreen> {
  static const _emojis = ['\u{1F43B}', '\u{1F431}', '\u{1F436}', '\u{1F981}', '\u{1F438}', '\u{1F43C}'];

  late List<_CardData> _cards;
  int? _firstSelectedIndex;
  bool _isProcessing = false;
  int _moves = 0;
  int _matchesFound = 0;
  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final pairs = [..._emojis, ..._emojis];
    pairs.shuffle(Random());
    _cards = pairs
        .asMap()
        .entries
        .map((e) => _CardData(id: e.key, emoji: e.value))
        .toList();
    _firstSelectedIndex = null;
    _isProcessing = false;
    _moves = 0;
    _matchesFound = 0;
  }

  void _onCardTap(int index) {
    if (_isProcessing) return;
    if (_cards[index].isFaceUp) return;

    setState(() {
      _cards[index].isFaceUp = true;

      if (_firstSelectedIndex == null) {
        _firstSelectedIndex = index;
      } else {
        _moves++;
        final firstCard = _cards[_firstSelectedIndex!];

        if (firstCard.emoji == _cards[index].emoji && firstCard.id != _cards[index].id) {
          _matchesFound++;
          _cards[index].isMatched = true;
          _cards[_firstSelectedIndex!].isMatched = true;
          _firstSelectedIndex = null;

          if (_matchesFound == _emojis.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showCompletionDialog();
            });
          }
        } else {
          _isProcessing = true;
          final firstIdx = _firstSelectedIndex!;
          _firstSelectedIndex = null;

          Future.delayed(const Duration(milliseconds: 800), () {
            setState(() {
              _cards[firstIdx].isFaceUp = false;
              _cards[index].isFaceUp = false;
              _isProcessing = false;
            });
          });
        }
      }
    });
  }

  int get _score => _moves <= 8 ? 3 : _moves <= 12 ? 2 : _moves <= 18 ? 1 : 0;

  Future<void> _submitGameProgress() async {
    if (!mounted) return;
    final childId = context.read<ChildViewModel>().selectedChild?.id;
    if (childId == null) return;
    final score = _score;
    await context.read<ProgressViewmodel>().submitGame(
          childId: childId,
          gameId: 'matching-pairs',
          score: score,
        );
  }

  void _showCompletionDialog() async {
    await _submitGameProgress();
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Congratulations!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Icon(
                  i < _score ? Icons.star : Icons.star_border,
                  size: 40,
                  color: i < _score ? AppTheme.accentColor : colorScheme.outline,
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              'Completed in $_moves moves',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Play Again',
              icon: Icons.refresh,
              width: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _initializeGame());
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
      appBar: AppBar(title: const Text('Matching Pairs')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatChip(
                  context,
                  icon: Icons.touch_app,
                  label: 'Moves',
                  value: '$_moves',
                  color: colorScheme.primary,
                ),
                _buildStatChip(
                  context,
                  icon: Icons.check_circle,
                  label: 'Matches',
                  value: '$_matchesFound/${_emojis.length}',
                  color: AppTheme.successColor,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return _buildCard(context, card, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, _CardData card, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: card.isFaceUp
              ? colorScheme.primaryContainer.withValues(alpha: 0.3)
              : colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          border: card.isFaceUp && card.isMatched
              ? Border.all(color: AppTheme.successColor, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: card.isFaceUp
              ? Text(
                  card.emoji,
                  key: ValueKey('face_up_${card.id}'),
                  style: const TextStyle(fontSize: 36),
                )
              : Icon(
                  Icons.help_outline,
                  key: ValueKey('face_down_${card.id}'),
                  color: colorScheme.onPrimary,
                  size: 36,
                ),
        ),
      ),
    );
  }
}

class _CardData {
  final int id;
  final String emoji;
  bool isFaceUp = false;
  bool isMatched = false;

  _CardData({
    required this.id,
    required this.emoji,
  });
}
