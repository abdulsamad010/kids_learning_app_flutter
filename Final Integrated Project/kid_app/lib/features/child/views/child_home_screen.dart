import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/features/content/viewmodels/content_viewmodel.dart';
import 'package:kid_app/features/content/models/subject_model.dart';
import 'package:kid_app/features/rewards/viewmodels/reward_viewmodel.dart';
import 'package:kid_app/features/progress/viewmodels/progress_viewmodel.dart';
import 'package:kid_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:kid_app/core/theme/app_theme.dart';
import 'package:kid_app/core/common/widgets/loading_widget.dart';
import 'package:kid_app/core/common/widgets/empty_state.dart';

class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({super.key});

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen> {
  int _currentNavIndex = 0;
  bool _dataLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataLoaded) {
      _dataLoaded = true;
      final contentVm = context.read<ContentViewmodel>();
      contentVm.loadSubjects();
      final childId = context.read<ChildViewModel>().selectedChild?.id;
      if (childId != null) {
        context.read<ProgressViewmodel>().loadProgress(childId);
        context.read<RewardViewmodel>().loadRewards(childId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final childViewModel = context.watch<ChildViewModel>();
    final child = childViewModel.selectedChild;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pushReplacementNamed(context, '/child-selector'),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (child != null) ...[
              Text(child.avatar, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
            ],
            Text(child?.name ?? 'Child Home'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            tooltip: 'Parent Area',
            onPressed: () => Navigator.pushNamed(context, '/parent-gate'),
          ),
        ],
      ),
      body: _buildBody(_currentNavIndex, child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.games_rounded),
            label: 'Games',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_rounded),
            label: 'Stars',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(int index, child) {
    switch (index) {
      case 0:
        return _buildSubjectsGrid();
      case 1:
        return _buildGamesTab();
      case 2:
        return _buildStarsTab();
      case 3:
        return _buildSettingsTab();
      default:
        return _buildSubjectsGrid();
    }
  }

  Widget _buildSubjectsGrid() {
    return Consumer<ContentViewmodel>(
      builder: (context, contentVm, _) {
        if (contentVm.isLoading && contentVm.subjects.isEmpty) {
          return const LoadingWidget(message: 'Loading subjects...');
        }

        if (contentVm.subjects.isEmpty) {
          return const EmptyState(
            icon: Icons.school_rounded,
            title: 'No Subjects',
            subtitle: 'Subjects will appear here soon.',
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Subjects',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: contentVm.subjects.length,
                  itemBuilder: (context, index) {
                    final subject = contentVm.subjects[index];
                    return _buildSubjectCard(subject);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubjectCard(SubjectModel subject) {
    final subjectColor = _parseHexColor(subject.color);
    final iconData = _getIconData(subject.icon);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/subject',
          arguments: subject.id,
        );
      },
      child: Card(
        color: subjectColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                subject.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseHexColor(String hex) {
    try {
      hex = hex.replaceFirst('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return AppTheme.primaryColor;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'calculate':
        return Icons.calculate_rounded;
      case 'science':
        return Icons.science_rounded;
      case 'psychology':
        return Icons.psychology_rounded;
      case 'school':
        return Icons.school_rounded;
      default:
        return Icons.subject_rounded;
    }
  }

  Widget _buildGamesTab() {
    final gameItems = [
      _GameItem(
        title: 'Matching Pairs',
        description: 'Find matching pairs!',
        icon: Icons.extension,
        color: AppTheme.infoColor,
        route: '/matching-pairs',
      ),
      _GameItem(
        title: 'Sort It Out',
        description: 'Put items in order!',
        icon: Icons.sort,
        color: AppTheme.successColor,
        route: '/sort-it-out',
      ),
      _GameItem(
        title: 'Pattern Builder',
        description: 'Complete the pattern!',
        icon: Icons.grid_view,
        color: AppTheme.readingColor,
        route: '/pattern-builder',
      ),
      _GameItem(
        title: 'Counting Tap',
        description: 'Count the objects!',
        icon: Icons.touch_app,
        color: AppTheme.accentColor,
        route: '/counting-tap',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Games',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: gameItems.length,
              itemBuilder: (context, index) {
                final item = gameItems[index];
                return _buildGameCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(_GameItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, item.route),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                item.color.withValues(alpha: 0.15),
                item.color.withValues(alpha: 0.05),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 32, color: item.color),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarsTab() {
    final colorScheme = Theme.of(context).colorScheme;
    return Consumer<RewardViewmodel>(
      builder: (context, rewardVm, _) {
        if (rewardVm.isLoading) {
          return const LoadingWidget(message: 'Loading your stars...');
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
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.amber.shade300, Colors.amber.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.star_rounded, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${rewards.totalStars}',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
              ),
              const SizedBox(height: 24),
              if (rewards.lessonStars.isNotEmpty) ...[
                _buildStarSection('Lesson Stars', Icons.menu_book_rounded, rewards.lessonStars),
                const SizedBox(height: 16),
              ],
              if (rewards.quizStars.isNotEmpty) ...[
                _buildStarSection('Quiz Stars', Icons.quiz_rounded, rewards.quizStars),
                const SizedBox(height: 16),
              ],
              if (rewards.gameStars.isNotEmpty) ...[
                _buildStarSection('Game Stars', Icons.games_rounded, rewards.gameStars),
                const SizedBox(height: 16),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildStarSection(String title, IconData icon, Map<String, int> starMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...starMap.entries.map((e) => Card(
              margin: const EdgeInsets.symmetric(vertical: 3),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(e.key, style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    ...List.generate(5, (index) {
                      return Icon(
                        index < e.value ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 22,
                        color: index < e.value ? Colors.amber.shade600 : Colors.grey.shade400,
                      );
                    }),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildSettingsTab() {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person_add_rounded, color: colorScheme.primary),
                  title: const Text('Switch Child'),
                  subtitle: const Text('Change the active child profile'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.pushNamed(context, '/child-selector'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.person_rounded, color: colorScheme.primary),
                  title: const Text('Parent Area'),
                  subtitle: const Text('Access parent controls'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.pushNamed(context, '/parent-gate'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline_rounded, color: colorScheme.primary),
                  title: const Text('KidLearn'),
                  subtitle: const Text('Version 1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout_rounded, color: colorScheme.error),
                  title: Text('Logout', style: TextStyle(color: colorScheme.error)),
                  subtitle: const Text('Sign out of your account'),
                  onTap: () => _showLogoutDialog(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (!mounted) return;
              final authViewModel = context.read<AuthViewModel>();
              final navigator = Navigator.of(context);
              await authViewModel.logout();
              if (mounted) {
                navigator.pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            child: Text('Logout', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }
}

class _GameItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;

  const _GameItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
}
