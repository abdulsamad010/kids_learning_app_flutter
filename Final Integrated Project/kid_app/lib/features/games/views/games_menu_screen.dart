import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kid_app/core/theme/app_theme.dart';
import 'package:kid_app/features/games/viewmodels/game_viewmodel.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = context.watch<GameViewmodel>();

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

    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: games.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
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
                  return _buildGameCard(context, item);
                },
              ),
            ),
    );
  }

  Widget _buildGameCard(BuildContext context, _GameItem item) {
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
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 36,
                  color: item.color,
                ),
              ),
              const SizedBox(height: 16),
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
