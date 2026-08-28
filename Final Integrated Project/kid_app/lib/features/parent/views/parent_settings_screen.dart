import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kid_app/features/auth/viewmodels/auth_viewmodel.dart';


class ParentSettingsScreen extends StatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  bool _soundEnabled = true;

  void _showLogoutDialog(BuildContext context) {
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
            child: Text(
              'Logout',
              style: TextStyle(color: colorScheme.error),
            ),
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
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildSectionHeader('Sound'),
            SwitchListTile(
              title: const Text('Sound Effects'),
              subtitle: const Text('Enable or disable sound effects'),
              secondary: Icon(
                _soundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                color: _soundEnabled ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
              },
            ),
            const Divider(indent: 16, endIndent: 16),
            _buildSectionHeader('App Info'),
            ListTile(
              leading: Icon(Icons.info_outline_rounded, color: colorScheme.primary),
              title: const Text('Kid App'),
              subtitle: const Text('Version 1.0.0'),
            ),
            const Divider(indent: 16, endIndent: 16),
            _buildSectionHeader('Account'),
            ListTile(
              leading: Icon(Icons.swap_horiz_rounded, color: colorScheme.primary),
              title: const Text('Switch Child'),
              subtitle: const Text('Change the active child profile'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pushNamed(context, '/child-selector');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_rounded, color: colorScheme.error),
              title: Text(
                'Logout',
                style: TextStyle(color: colorScheme.error),
              ),
              subtitle: const Text('Sign out of your account'),
              onTap: () => _showLogoutDialog(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
