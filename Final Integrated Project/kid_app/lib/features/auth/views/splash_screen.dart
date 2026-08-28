import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kid_app/features/auth/viewmodels/auth_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<AuthViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    if (!_navigated && auth.initDone && !auth.isLoading) {
      _navigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (auth.isLoggedIn) {
          Navigator.pushReplacementNamed(
            context,
            '/child-selector',
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            '/login',
          );
        }
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'KidLearn',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Learn, Play, Grow!',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 48),
            if (auth.isLoading)
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}