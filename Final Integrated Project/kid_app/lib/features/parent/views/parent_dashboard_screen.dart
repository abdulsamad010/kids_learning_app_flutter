import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kid_app/features/progress/viewmodels/progress_viewmodel.dart';
import 'package:kid_app/features/progress/models/progress_model.dart';
import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/core/theme/app_theme.dart';
import 'package:kid_app/core/common/widgets/loading_widget.dart';
import 'package:kid_app/core/common/widgets/error_display.dart';
import 'package:kid_app/core/common/widgets/empty_state.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final childId = context.read<ChildViewModel>().selectedChild?.id;
      if (childId != null) {
        context.read<ProgressViewmodel>().loadProgress(childId);
      }
    });
  }

  void _loadDataForChild(String childId) {
    context.read<ProgressViewmodel>().loadProgress(childId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final childViewModel = context.watch<ChildViewModel>();
    final children = childViewModel.children;
    final selectedChild = childViewModel.selectedChild;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Navigator.pushNamed(context, '/parent-settings'),
          ),
        ],
      ),
      body: Consumer<ProgressViewmodel>(
        builder: (context, progressVm, _) {
          if (progressVm.isLoading) {
            return const LoadingWidget(message: 'Loading dashboard...');
          }

          if (progressVm.errorMessage != null) {
            return ErrorDisplay(
              message: progressVm.errorMessage!,
              onRetry: () {
                if (selectedChild != null) {
                  _loadDataForChild(selectedChild.id);
                }
              },
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (children.length > 1) ...[
                  _buildChildSelector(children, childViewModel),
                  const SizedBox(height: 16),
                ],
                _buildSummaryCards(progressVm.progress, colorScheme),
                const SizedBox(height: 24),
                _buildRecentActivity(progressVm.progress),
                const SizedBox(height: 24),
                _buildActionButtons(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChildSelector(List<dynamic> children, ChildViewModel childVm) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final child = children[index];
          final isSelected = child.id == childVm.selectedChild?.id;
          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(child.avatar),
                const SizedBox(width: 4),
                Text(child.name),
              ],
            ),
            selected: isSelected,
            onSelected: (_) {
              childVm.selectChild(child);
              _loadDataForChild(child.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(ProgressModel? progress, ColorScheme colorScheme) {
    final lessonsCount = progress?.lessonsCompleted.length ?? 0;
    final quizzesCount = progress?.quizzesCompleted.length ?? 0;
    final gamesCount = progress?.gamesPlayed.length ?? 0;
    final totalStars = progress?.totalStars ?? 0;

    final cards = [
      _SummaryData('Total Stars', '$totalStars', Icons.star_rounded, Colors.amber),
      _SummaryData('Lessons', '$lessonsCount', Icons.menu_book_rounded, AppTheme.readingColor),
      _SummaryData('Quizzes', '$quizzesCount', Icons.quiz_rounded, AppTheme.mathColor),
      _SummaryData('Games', '$gamesCount', Icons.games_rounded, AppTheme.artColor),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(card.icon, color: card.color, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      card.value,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      card.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivity(ProgressModel? progress) {
    final activity = progress?.recentActivity ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        if (activity.isEmpty)
          EmptyState(
            icon: Icons.history_rounded,
            title: 'No Recent Activity',
            subtitle: 'Activity will show up here once your child starts learning',
          )
        else
          ...activity.take(10).map((entry) => _buildActivityTile(entry)),
      ],
    );
  }

  Widget _buildActivityTile(ActivityEntry entry) {
    final colorScheme = Theme.of(context).colorScheme;

    IconData icon;
    Color iconColor;

    switch (entry.type.toLowerCase()) {
      case 'lesson':
        icon = Icons.menu_book_rounded;
        iconColor = AppTheme.readingColor;
        break;
      case 'quiz':
        icon = Icons.quiz_rounded;
        iconColor = AppTheme.mathColor;
        break;
      case 'game':
        icon = Icons.games_rounded;
        iconColor = AppTheme.artColor;
        break;
      default:
        icon = Icons.circle;
        iconColor = colorScheme.primary;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withValues(alpha: 0.15),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(entry.title),
        subtitle: Text(entry.completedAt),
        trailing: entry.stars != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber.shade600, size: 18),
                  const SizedBox(width: 2),
                  Text(
                    '${entry.stars}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/child-selector'),
          icon: const Icon(Icons.child_care_rounded),
          label: const Text('Manage Children'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/parent-settings'),
          icon: const Icon(Icons.settings_rounded),
          label: const Text('Settings'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}

class _SummaryData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryData(this.label, this.value, this.icon, this.color);
}
