import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kid_app/features/child/viewmodels/child_viewmodel.dart';
import 'package:kid_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:kid_app/core/common/widgets/empty_state.dart';
import 'package:kid_app/core/common/widgets/loading_widget.dart';
import 'package:kid_app/core/common/widgets/error_display.dart';

class ChildSelectorScreen extends StatefulWidget {
  const ChildSelectorScreen({super.key});

  @override
  State<ChildSelectorScreen> createState() => _ChildSelectorScreenState();
}

class _ChildSelectorScreenState extends State<ChildSelectorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChildViewModel>().loadChildren();
    });
  }

  void _showOptionsDialog(BuildContext context, childViewModel, child) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(child.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, '/edit-child', arguments: child);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_rounded, color: Theme.of(context).colorScheme.error),
              title: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, childViewModel, child);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, childViewModel, child) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text('Are you sure you want to delete ${child.name}\'s profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              childViewModel.deleteChild(child.id);
            },
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Who's Learning?"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
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
          ),
        ],
      ),
      body: Consumer<ChildViewModel>(
        builder: (context, childViewModel, _) {
          if (childViewModel.isLoading && childViewModel.children.isEmpty) {
            return const LoadingWidget(message: 'Loading children...');
          }

          if (childViewModel.errorMessage != null && childViewModel.children.isEmpty) {
            return ErrorDisplay(
              message: childViewModel.errorMessage!,
              onRetry: () => childViewModel.loadChildren(),
            );
          }

          if (childViewModel.children.isEmpty) {
            return EmptyState(
              icon: Icons.child_care_rounded,
              title: 'No Child Profiles Yet',
              subtitle: "Add your child's profile to get started",
              actionLabel: 'Add Your First Child',
              onAction: () => Navigator.pushNamed(context, '/create-child'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: childViewModel.children.length,
              itemBuilder: (context, index) {
                final child = childViewModel.children[index];
                return GestureDetector(
                  onTap: () async {
                    await childViewModel.selectChild(child);
                    if (!mounted) return;
                    Navigator.pushNamed(context, '/child-home'); // ignore: use_build_context_synchronously
                  },
                  onLongPress: () => _showOptionsDialog(context, childViewModel, child),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            child.avatar,
                            style: const TextStyle(fontSize: 56),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            child.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Age ${child.age}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-child'),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
