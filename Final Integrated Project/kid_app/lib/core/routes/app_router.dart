import 'package:flutter/material.dart';

import 'package:kid_app/features/auth/views/splash_screen.dart';
import 'package:kid_app/features/auth/views/login_screen.dart';
import 'package:kid_app/features/auth/views/register_screen.dart';
import 'package:kid_app/features/auth/views/forgot_password_screen.dart';
import 'package:kid_app/features/auth/views/reset_password_screen.dart';
import 'package:kid_app/features/child/views/child_selector_screen.dart';
import 'package:kid_app/features/child/views/create_child_screen.dart';
import 'package:kid_app/features/child/views/edit_child_screen.dart';
import 'package:kid_app/features/child/views/child_home_screen.dart';
import 'package:kid_app/features/content/views/subject_screen.dart';
import 'package:kid_app/features/content/views/lesson_list_screen.dart';
import 'package:kid_app/features/content/views/lesson_player_screen.dart';
import 'package:kid_app/features/quiz/views/quiz_screen.dart';
import 'package:kid_app/features/quiz/views/quiz_result_screen.dart';
import 'package:kid_app/features/games/views/games_menu_screen.dart';
import 'package:kid_app/features/games/views/matching_pairs_screen.dart';
import 'package:kid_app/features/games/views/sort_it_out_screen.dart';
import 'package:kid_app/features/games/views/pattern_builder_screen.dart';
import 'package:kid_app/features/games/views/counting_tap_screen.dart';
import 'package:kid_app/features/rewards/views/my_stars_screen.dart';
import 'package:kid_app/features/parent/views/parent_gate_screen.dart';
import 'package:kid_app/features/parent/views/parent_dashboard_screen.dart';
import 'package:kid_app/features/parent/views/parent_settings_screen.dart';
import 'package:kid_app/features/child/models/child_model.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String childSelector = '/child-selector';
  static const String createChild = '/create-child';
  static const String editChild = '/edit-child';
  static const String childHome = '/child-home';
  static const String subject = '/subject';
  static const String lessonList = '/lesson-list';
  static const String lessonPlayer = '/lesson';
  static const String quiz = '/quiz';
  static const String quizResult = '/quiz-result';
  static const String gamesMenu = '/games-menu';
  static const String matchingPairs = '/matching-pairs';
  static const String sortItOut = '/sort-it-out';
  static const String patternBuilder = '/pattern-builder';
  static const String countingTap = '/counting-tap';
  static const String myStars = '/my-stars';
  static const String parentGate = '/parent-gate';
  static const String parentDashboard = '/parent-dashboard';
  static const String parentSettings = '/parent-settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case resetPassword:
        final token = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(token: token));
      case childSelector:
        return MaterialPageRoute(builder: (_) => const ChildSelectorScreen());
      case createChild:
        return MaterialPageRoute(builder: (_) => const CreateChildScreen());
      case editChild:
        final child = settings.arguments as ChildModel;
        return MaterialPageRoute(
            builder: (_) => EditChildScreen(child: child));
      case childHome:
        return MaterialPageRoute(builder: (_) => const ChildHomeScreen());
      case subject:
        return MaterialPageRoute(
          builder: (_) => const SubjectScreen(),
          settings: settings,
        );
      case lessonList:
        return MaterialPageRoute(
          builder: (_) => const LessonListScreen(),
          settings: settings,
        );
      case lessonPlayer:
        return MaterialPageRoute(
          builder: (_) => const LessonPlayerScreen(),
          settings: settings,
        );
      case quiz:
        return MaterialPageRoute(
          builder: (_) => const QuizScreen(),
          settings: settings,
        );
      case quizResult:
        return MaterialPageRoute(
          builder: (_) => const QuizResultScreen(),
          settings: settings,
        );
      case gamesMenu:
        return MaterialPageRoute(builder: (_) => const GamesMenuScreen());
      case matchingPairs:
        return MaterialPageRoute(builder: (_) => const MatchingPairsScreen());
      case sortItOut:
        return MaterialPageRoute(builder: (_) => const SortItOutScreen());
      case patternBuilder:
        return MaterialPageRoute(builder: (_) => const PatternBuilderScreen());
      case countingTap:
        return MaterialPageRoute(builder: (_) => const CountingTapScreen());
      case myStars:
        return MaterialPageRoute(builder: (_) => const MyStarsScreen());
      case parentGate:
        return MaterialPageRoute(builder: (_) => const ParentGateScreen());
      case parentDashboard:
        return MaterialPageRoute(
            builder: (_) => const ParentDashboardScreen());
      case parentSettings:
        return MaterialPageRoute(
            builder: (_) => const ParentSettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
