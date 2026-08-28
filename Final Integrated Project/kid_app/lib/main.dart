import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'features/child/viewmodels/child_viewmodel.dart';
import 'features/content/viewmodels/content_viewmodel.dart';
import 'features/quiz/viewmodels/quiz_viewmodel.dart';
import 'features/games/viewmodels/game_viewmodel.dart';
import 'features/progress/viewmodels/progress_viewmodel.dart';
import 'features/rewards/viewmodels/reward_viewmodel.dart';
import 'features/parent/viewmodels/parent_viewmodel.dart';
import 'features/auth/views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KidsLearningApp());
}

class KidsLearningApp extends StatelessWidget {
  const KidsLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ChildViewModel()),
        ChangeNotifierProvider(create: (_) => ContentViewmodel()),
        ChangeNotifierProvider(create: (_) => QuizViewmodel()),
        ChangeNotifierProvider(create: (_) => GameViewmodel()),
        ChangeNotifierProvider(create: (_) => ProgressViewmodel()),
        ChangeNotifierProvider(create: (_) => RewardViewmodel()),
        ChangeNotifierProvider(create: (_) => ParentViewmodel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KidLearn',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
