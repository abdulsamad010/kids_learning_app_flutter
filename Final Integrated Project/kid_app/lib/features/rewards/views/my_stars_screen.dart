import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kid_app/features/rewards/viewmodels/reward_viewmodel.dart';

import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/core/common/widgets/loading_widget.dart';
import 'package:kid_app/core/common/widgets/error_display.dart';
import 'package:kid_app/core/common/widgets/empty_state.dart';

class MyStarsScreen extends StatefulWidget {
  const MyStarsScreen({super.key});

  @override
  State<MyStarsScreen> createState() => _MyStarsScreenState();
}

class _MyStarsScreenState extends State<MyStarsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final childId = context.read<ChildViewModel>().selectedChild?.id;
      if (childId != null) {
        context.read<RewardViewmodel>().loadRewards(childId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, color: Colors.amber.shade600),
            const SizedBox(width: 8),
            const Text('My Stars'),
          ],
        ),
      ),
      body: Consumer<RewardViewmodel>(
        builder: (context, rewardVm, _) {
          if (rewardVm.isLoading) {
            return const LoadingWidget(message: 'Loading your stars...');
          }

          if (rewardVm.errorMessage != null) {
            return ErrorDisplay(
              message: rewardVm.errorMessage!,
              onRetry: () {
                final childId = context.read<ChildViewModel>().selectedChild?.id;
                if (childId != null) {
                  rewardVm.loadRewards(childId);
                }
              },
            );
          }

          final rewards = rewardVm.rewards;
          if (rewards == null) {
            return EmptyState(
              icon: Icons.star_border_rounded,
              title: 'No Stars Yet',
              subtitle: 'Complete lessons, quizzes, and games to earn stars!',
            );
          }

          final hasAnyStars = rewards.lessonStars.isNotEmpty ||
              rewards.quizStars.isNotEmpty ||
              rewards.gameStars.isNotEmpty;

          if (!hasAnyStars) {
            return EmptyState(
              icon: Icons.star_border_rounded,
              title: 'No Stars Yet',
              subtitle: 'Start learning to earn your first stars!',
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalStars(rewards.totalStars, colorScheme),
                const SizedBox(height: 24),
                if (rewards.lessonStars.isNotEmpty) ...[
                  _buildSectionHeader('Lesson Stars', Icons.menu_book_rounded, colorScheme),
                  const SizedBox(height: 8),
                  ...rewards.lessonStars.entries.map(
                    (e) => _buildStarRow(e.key, e.value, colorScheme),
                  ),
                  const SizedBox(height: 24),
                ],
                if (rewards.quizStars.isNotEmpty) ...[
                  _buildSectionHeader('Quiz Stars', Icons.quiz_rounded, colorScheme),
                  const SizedBox(height: 8),
                  ...rewards.quizStars.entries.map(
                    (e) => _buildStarRow(e.key, e.value, colorScheme),
                  ),
                  const SizedBox(height: 24),
                ],
                if (rewards.gameStars.isNotEmpty) ...[
                  _buildSectionHeader('Game Stars', Icons.games_rounded, colorScheme),
                  const SizedBox(height: 8),
                  ...rewards.gameStars.entries.map(
                    (e) => _buildStarRow(e.key, e.value, colorScheme),
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalStars(int totalStars, ColorScheme colorScheme) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade300,
                  Colors.amber.shade700,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color:                   Colors.amber.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.star_rounded,
              size: 72,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$totalStars',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total Stars',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildStarRow(String title, int stars, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ...List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  index < stars ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 24,
                  color: index < stars ? Colors.amber.shade600 : Colors.grey.shade400,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
