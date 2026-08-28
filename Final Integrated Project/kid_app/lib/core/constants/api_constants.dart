class ApiConstants {
  ApiConstants._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // Auth
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String logout = '/api/auth/logout';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';

  // Children
  static const String children = '/api/children';
  static String childById(String id) => '/api/children/$id';

  // Content
  static const String subjects = '/api/content/subjects';
  static String subjectById(String id) => '/api/content/subjects/$id';
  static String lessonById(String id) => '/api/content/lessons/$id';
  static String lessonQuiz(String id) => '/api/content/lessons/$id/quiz';
  static const String games = '/api/content/games';
  static String gameById(String id) => '/api/content/games/$id';

  // Progress
  static String progressChild(String childId) => '/api/progress/$childId';
  static String progressSummary(String childId) =>
      '/api/progress/$childId/summary';
  static String progressLesson(String childId) =>
      '/api/progress/$childId/lesson';
  static String progressQuiz(String childId) =>
      '/api/progress/$childId/quiz';
  static String progressGame(String childId) =>
      '/api/progress/$childId/game';
  static String progressSync(String childId) =>
      '/api/progress/$childId/sync';

  // Rewards
  static String rewardsChild(String childId) => '/api/rewards/$childId';

  // Dashboard
  static const String dashboard = '/api/dashboard';
  static String dashboardChild(String childId) => '/api/dashboard/$childId';
}
